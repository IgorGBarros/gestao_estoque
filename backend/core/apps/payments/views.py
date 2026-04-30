import logging
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.conf import settings

from .services.asaas_service import asaas_service, AsaasAPIError

logger = logging.getLogger(__name__)


def _get_store(request):
    """Helper para buscar store do usuário autenticado"""
    store = getattr(request.user, 'store', None)
    if not store:
        from apps.stores.models import Store
        try:
            store = Store.objects.get(owner=request.user)
        except Store.DoesNotExist:
            return None
    return store


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def asaas_create_checkout(request):
    """
    POST /api/payments/asaas/checkout/
    Body: { "billing_cycle": "monthly"|"yearly" }
    """
    store = _get_store(request)
    if not store:
        return Response({'error': 'Loja não encontrada'}, status=status.HTTP_404_NOT_FOUND)

    if store.plan == 'pro':
        return Response({'error': 'Loja já possui plano PRO'}, status=status.HTTP_400_BAD_REQUEST)

    billing_cycle = request.data.get('billing_cycle', 'monthly')

    try:
        result = asaas_service.create_payment_link(store=store, billing_cycle=billing_cycle)
        return Response({
            'checkout_url': result.get('url'),
            'payment_link_id': result.get('id'),
            'billing_cycle': billing_cycle,
            'status': 'pending',
        }, status=status.HTTP_201_CREATED)
    except AsaasAPIError as e:
        return Response({'error': e.message}, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def asaas_subscription_status(request):
    """GET /api/payments/asaas/status/"""
    store = _get_store(request)
    if not store:
        return Response({'error': 'Loja não encontrada'}, status=status.HTTP_404_NOT_FOUND)

    from django.utils import timezone
    now = timezone.now()
    is_active = store.plan == 'pro' and store.subscription_expires_at and store.subscription_expires_at > now
    days_remaining = (store.subscription_expires_at - now).days if store.subscription_expires_at and store.subscription_expires_at > now else 0

    return Response({
        'plan': store.plan,
        'is_active': is_active,
        'payment_provider': store.payment_provider,
        'subscription_started_at': store.subscription_started_at,
        'subscription_expires_at': store.subscription_expires_at,
        'days_remaining': days_remaining,
    })


@api_view(['POST'])
@permission_classes([AllowAny])
def asaas_webhook(request):
    """
    POST /api/payments/asaas/webhook/
    Endpoint público para receber notificações do Asaas.
    """
    # Validar token
    webhook_token = settings.ASAAS_WEBHOOK_TOKEN
    if webhook_token:
        received_token = request.headers.get('asaas-access-token', '')
        if received_token != webhook_token:
            logger.warning("[ASAAS WEBHOOK] Token inválido")
            return Response({'error': 'Unauthorized'}, status=status.HTTP_401_UNAUTHORIZED)

    event = request.data.get('event')
    if not event:
        return Response({'error': 'Event required'}, status=status.HTTP_400_BAD_REQUEST)

    supported = ['PAYMENT_RECEIVED', 'PAYMENT_OVERDUE', 'SUBSCRIPTION_CANCELED']
    if event not in supported:
        return Response({'status': 'ignored', 'event': event})

    result = asaas_service.process_webhook(event=event, payload=request.data)
    return Response(result)


# ─── ADMIN ENDPOINTS ─────────────────────────────────────
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def asaas_admin_config(request):
    """GET /api/admin/payments/asaas/config/ - Retorna config atual do Asaas"""
    if not request.user.is_staff:
        return Response({'error': 'Forbidden'}, status=status.HTTP_403_FORBIDDEN)

    return Response({
        'environment': settings.ASAAS_ENVIRONMENT,
        'base_url': settings.ASAAS_BASE_URL,
        'has_api_key': bool(settings.ASAAS_API_KEY),
        'has_webhook_token': bool(settings.ASAAS_WEBHOOK_TOKEN),
        'webhook_url': request.build_absolute_uri('/api/payments/asaas/webhook/'),
    })


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def asaas_admin_test_connection(request):
    """POST /api/admin/payments/asaas/test/ - Testa conexão com Asaas"""
    if not request.user.is_staff:
        return Response({'error': 'Forbidden'}, status=status.HTTP_403_FORBIDDEN)

    try:
        result = asaas_service._request('GET', 'finance/balance')
        return Response({
            'status': 'connected',
            'balance': result.get('balance'),
            'environment': settings.ASAAS_ENVIRONMENT,
        })
    except AsaasAPIError as e:
        return Response({
            'status': 'error',
            'message': e.message,
        }, status=status.HTTP_400_BAD_REQUEST)