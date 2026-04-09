# services/asaas_service.py

from backend.core.inventory.models import PlanConfig, Store


class AsaasService:
    """Serviço Asaas tenant-aware"""
    
    @staticmethod
    def create_subscription_for_store(store, billing_cycle='monthly'):
        """Cria assinatura para uma loja específica"""
        
        # 1. Buscar configuração do plano
        plan_config = PlanConfig.objects.get(plan_type='pro')
        
        # 2. Definir preço baseado no ciclo
        amount = plan_config.yearly_price if billing_cycle == 'yearly' else plan_config.monthly_price
        
        # 3. Criar customer no Asaas (usando dados da Store)
        customer_data = {
            'name': store.owner.name if store.owner else store.name,
            'email': store.owner.email if store.owner else f'{store.slug}@temp.com',
            'cpfCnpj': '00000000000',  # Implementar CPF real depois
        }
        
        # 4. Criar assinatura
        subscription_data = {
            'customer': 'customer_id_from_asaas',
            'billingType': 'CREDIT_CARD',
            'value': float(amount),
            'cycle': 'MONTHLY' if billing_cycle == 'monthly' else 'YEARLY',
            'description': f'Plano PRO - {store.name}'
        }
        
        # 5. Salvar referência na Store
        store.payment_provider = 'asaas'
        store.payment_external_id = 'subscription_id_from_asaas'
        store.upgrade_to_pro(billing_cycle)
        
        return store

    @staticmethod
    def process_webhook(webhook_data):
        """Processa webhook do Asaas (tenant-aware)"""
        
        if webhook_data.get('event') == 'PAYMENT_RECEIVED':
            external_id = webhook_data['payment']['customer']
            
            # Buscar Store pelo external_id
            try:
                store = Store.objects.get(payment_external_id=external_id)
                store.upgrade_to_pro()
                
                return {'status': 'success', 'store_id': store.id}
            
            except Store.DoesNotExist:
                return {'status': 'error', 'message': 'Store não encontrada'}
        
        return {'status': 'ignored'}