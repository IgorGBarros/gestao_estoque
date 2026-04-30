# apps/payments/services/asaas_service.py
import requests
import logging
from datetime import timedelta
from django.conf import settings
from django.utils import timezone
from django.apps import apps

logger = logging.getLogger(__name__)


class AsaasAPIError(Exception):
    def __init__(self, message: str, status_code: int = None, response_data: dict = None):
        self.message = message
        self.status_code = status_code
        self.response_data = response_data or {}
        super().__init__(self.message)


def _get_store_model():
    """Helper para obter o modelo Store de forma segura, sem importação direta."""
    return apps.get_model('stores', 'Store')


class AsaasService:
    """Service para integração com API do Asaas v3"""

    def __init__(self):
        self.base_url = settings.ASAAS_BASE_URL
        self.headers = {
            'Content-Type': 'application/json',
            'access_token': settings.ASAAS_API_KEY,
        }

    def _request(self, method: str, endpoint: str, data: dict = None, params: dict = None) -> dict:
        url = f"{self.base_url}/{endpoint}"
        try:
            resp = requests.request(
                method=method, url=url, headers=self.headers,
                json=data, params=params, timeout=30
            )
            result = resp.json() if resp.content else {}

            if resp.status_code >= 400:
                errors = result.get('errors', [])
                msg = errors[0].get('description', f'HTTP {resp.status_code}') if errors else f'HTTP {resp.status_code}'
                logger.error(f"[ASAAS] {method} {endpoint} → {resp.status_code}: {result}")
                raise AsaasAPIError(msg, resp.status_code, result)

            return result
        except requests.exceptions.Timeout:
            raise AsaasAPIError("Timeout na comunicação com Asaas", 408)
        except requests.exceptions.ConnectionError:
            raise AsaasAPIError("Falha de conexão com Asaas", 503)
        except AsaasAPIError:
            raise
        except Exception as e:
            raise AsaasAPIError(f"Erro inesperado: {str(e)}", 500)

    # ─── CUSTOMERS ───────────────────────────────────────

    def get_or_create_customer(self, store) -> str:
        """Retorna customer_id do Asaas. Cria se não existir."""
        # Se já tem ID salvo, valida
        if store.payment_external_id and store.payment_provider == 'asaas':
            try:
                existing = self._request('GET', f'customers/{store.payment_external_id}')
                if existing.get('id'):
                    return existing['id']
            except AsaasAPIError:
                pass

        # Busca por email
        try:
            search = self._request('GET', 'customers', params={'email': store.owner.email})
            if search.get('data'):
                customer_id = search['data'][0]['id']
                store.payment_external_id = customer_id
                store.payment_provider = 'asaas'
                store.save(update_fields=['payment_external_id', 'payment_provider'])
                return customer_id
        except AsaasAPIError:
            pass

        # Cria novo
        cpf_cnpj = getattr(store.owner, 'cpf_cnpj', None) or getattr(store, 'cpf_cnpj', None)
        if not cpf_cnpj:
            raise AsaasAPIError("CPF/CNPJ é obrigatório para criar cliente no Asaas", 422)

        customer_data = {
            'name': store.owner.name or store.owner.email.split('@')[0],
            'email': store.owner.email,
            'cpfCnpj': cpf_cnpj,
            'mobilePhone': getattr(store, 'whatsapp', None),
            'externalReference': str(store.id),
            'notificationDisabled': False,
        }
        customer_data = {k: v for k, v in customer_data.items() if v is not None}

        result = self._request('POST', 'customers', data=customer_data)
        customer_id = result['id']

        store.payment_external_id = customer_id
        store.payment_provider = 'asaas'
        store.save(update_fields=['payment_external_id', 'payment_provider'])

        logger.info(f"[ASAAS] Customer criado: {customer_id} para store {store.id}")
        return customer_id

    # ─── SUBSCRIPTIONS ───────────────────────────────────

    def create_subscription(self, store, billing_cycle: str = 'monthly', payment_method: str = 'credit_card') -> dict:
        customer_id = self.get_or_create_customer(store)

        value = 39.90 if billing_cycle == 'monthly' else 399.00
        cycle = 'MONTHLY' if billing_cycle == 'monthly' else 'YEARLY'

        billing_type_map = {
            'credit_card': 'CREDIT_CARD',
            'pix': 'PIX',
            'boleto': 'BOLETO',
        }

        subscription_data = {
            'customer': customer_id,
            'billingType': billing_type_map.get(payment_method, 'CREDIT_CARD'),
            'value': float(value),
            'nextDueDate': (timezone.now() + timedelta(days=1)).strftime('%Y-%m-%d'),
            'cycle': cycle,
            'description': f'Minha Amora PRO - {billing_cycle.capitalize()}',
            'externalReference': str(store.id),
        }

        result = self._request('POST', 'subscriptions', data=subscription_data)

        store.payment_provider = 'asaas'
        store.subscription_started_at = timezone.now()
        store.subscription_expires_at = timezone.now() + timedelta(days=30 if billing_cycle == 'monthly' else 365)
        store.save(update_fields=['payment_provider', 'subscription_started_at', 'subscription_expires_at'])

        logger.info(f"[ASAAS] Subscription criada: {result.get('id')} para store {store.id}")
        return result

    def create_payment_link(self, store, billing_cycle: str = 'monthly') -> dict:
        """Cria link de pagamento (checkout hospedado pelo Asaas)"""
        self.get_or_create_customer(store)

        value = 39.90 if billing_cycle == 'monthly' else 399.00

        link_data = {
            'name': f'Minha Amora PRO - {"Mensal" if billing_cycle == "monthly" else "Anual"}',
            'description': f'Assinatura PRO para {store.name}',
            'endDate': (timezone.now() + timedelta(days=7)).strftime('%Y-%m-%d'),
            'value': float(value),
            'billingType': 'UNDEFINED',
            'chargeType': 'RECURRENT',
            'subscriptionCycle': 'MONTHLY' if billing_cycle == 'monthly' else 'YEARLY',
            'notificationEnabled': True,
            'externalReference': str(store.id),
        }

        result = self._request('POST', 'paymentLinks', data=link_data)
        logger.info(f"[ASAAS] Payment link: {result.get('url')}")
        return result

    # ─── WEBHOOK PROCESSING ──────────────────────────────

    def process_webhook(self, event: str, payload: dict) -> dict:
        handlers = {
            'PAYMENT_RECEIVED': self._on_payment_received,
            'PAYMENT_OVERDUE': self._on_payment_overdue,
            'SUBSCRIPTION_CANCELED': self._on_subscription_canceled,
        }

        handler = handlers.get(event)
        if not handler:
            return {'status': 'ignored', 'event': event}

        logger.info(f"[ASAAS WEBHOOK] Processando: {event}")
        return handler(payload)

    def _find_store_from_payload(self, payload: dict):
        Store = _get_store_model()

        payment = payload.get('payment', {})
        external_ref = payment.get('externalReference')

        if external_ref:
            try:
                return Store.objects.get(id=external_ref)
            except Store.DoesNotExist:
                pass

        customer_id = payment.get('customer')
        if customer_id:
            try:
                return Store.objects.get(payment_external_id=customer_id, payment_provider='asaas')
            except Store.DoesNotExist:
                pass

        return None

    def _on_payment_received(self, payload: dict) -> dict:
        store = self._find_store_from_payload(payload)
        if not store:
            return {'status': 'error', 'message': 'Store not found'}

        store.plan = 'pro'
        store.subscription_started_at = timezone.now()
        store.subscription_expires_at = timezone.now() + timedelta(days=30)
        store.save(update_fields=['plan', 'subscription_started_at', 'subscription_expires_at'])

        logger.info(f"[ASAAS WEBHOOK] Store {store.id} → PRO")
        return {'status': 'success', 'store_id': str(store.id)}

    def _on_payment_overdue(self, payload: dict) -> dict:
        store = self._find_store_from_payload(payload)
        if store:
            logger.warning(f"[ASAAS WEBHOOK] Pagamento atrasado: store {store.id}")
        return {'status': 'warning'}

    def _on_subscription_canceled(self, payload: dict) -> dict:
        Store = _get_store_model()

        subscription = payload.get('subscription', {})
        external_ref = subscription.get('externalReference')
        if not external_ref:
            return {'status': 'ignored'}

        try:
            store = Store.objects.get(id=external_ref)
            store.plan = 'free'
            store.subscription_expires_at = timezone.now()
            store.save(update_fields=['plan', 'subscription_expires_at'])
            logger.info(f"[ASAAS WEBHOOK] Store {store.id} → FREE (cancelada)")
            return {'status': 'success', 'store_id': str(store.id)}
        except Store.DoesNotExist:
            return {'status': 'error', 'message': 'Store not found'}


asaas_service = AsaasService()