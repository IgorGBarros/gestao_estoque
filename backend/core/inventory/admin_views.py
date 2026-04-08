# inventory/admin_views.py - CRIAR ESTE ARQUIVO COMPLETO

from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth.decorators import user_passes_test
from .models import Store, PlanConfig, Promotion, CustomUser
from decimal import Decimal

def is_staff_user(user):
    return user.is_authenticated and user.is_staff

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_plan_configs(request):
    """Lista configurações de planos"""
    if not request.user.is_staff:
        return Response({'error': 'Sem permissão'}, status=403)
    
    try:
        configs = PlanConfig.objects.all()
        data = []
        for config in configs:
            data.append({
                'plan_type': config.plan_type,
                'display_name': config.display_name,
                'description': config.description,
                'max_products': config.max_products,
                'can_use_scanner': config.can_use_scanner,
                'can_use_storefront': config.can_use_storefront,
                'can_use_alerts': config.can_use_alerts,
                'can_use_ai_assistant': config.can_use_ai_assistant,
                'can_use_analytics': config.can_use_analytics,
                'monthly_price': float(config.monthly_price),
                'yearly_price': float(config.yearly_price),
                'highlight_color': config.highlight_color,
                'is_popular': config.is_popular,
                'is_visible': config.is_visible,
                'sort_order': config.sort_order
            })
        return Response(data)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_promotions(request):
    """Lista promoções"""
    if not request.user.is_staff:
        return Response({'error': 'Sem permissão'}, status=403)
    
    try:
        promotions = Promotion.objects.all()
        data = []
        for promo in promotions:
            data.append({
                'id': str(promo.id),
                'title': promo.title,
                'message': promo.message,
                'target_audience': promo.target_audience,
                'discount_percent': promo.discount_percent,
                'discount_amount': float(promo.discount_amount),
                'is_active': promo.is_active,
                'starts_at': promo.starts_at.isoformat(),
                'ends_at': promo.ends_at.isoformat() if promo.ends_at else None,
                'created_at': promo.created_at.isoformat()
            })
        return Response(data)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_system_stats(request):
    """Retorna estatísticas do sistema"""
    if not request.user.is_staff:
        return Response({'error': 'Sem permissão'}, status=403)
    
    try:
        stores = Store.objects.all()
        total_stores = stores.count()
        pro_stores = stores.filter(plan='pro').count()
        free_stores = total_stores - pro_stores
        
        # Calcular produtos
        total_products = 0
        for store in stores:
            total_products += store.items.count()
        
        total_revenue = pro_stores * 39.90
        
        stats = {
            'total_stores': total_stores,
            'active_stores': int(total_stores * 0.7),
            'pro_stores': pro_stores,
            'free_stores': free_stores,
            'total_products': total_products,
            'total_revenue': total_revenue,
            'monthly_revenue': total_revenue,
            'churn_rate': 5.2,
            'conversion_rate': (pro_stores / total_stores * 100) if total_stores > 0 else 0,
            'avg_products_per_store': total_products / total_stores if total_stores > 0 else 0
        }
        
        return Response(stats)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_users(request):
    """Lista usuários para admin (baseado nas Stores)"""
    if not request.user.is_staff:
        return Response({'error': 'Sem permissão'}, status=403)
    
    try:
        stores = Store.objects.select_related('owner').prefetch_related('items').all()
        
        users_data = []
        for store in stores:
            owner = store.owner
            if owner:
                users_data.append({
                    'id': owner.id,
                    'email': owner.email,
                    'display_name': owner.name,
                    'plan': store.plan,
                    'store_slug': store.slug,
                    'storefront_enabled': bool(store.slug),
                    'whatsapp_number': store.whatsapp,
                    'product_count': store.items.count(),
                    'created_at': owner.date_joined.isoformat() if hasattr(owner, 'date_joined') else store.created_at.isoformat(),
                    'last_sign_in': owner.last_login.isoformat() if hasattr(owner, 'last_login') and owner.last_login else None,
                    'subscription_started_at': store.subscription_started_at.isoformat() if store.subscription_started_at else None,
                    'subscription_expires_at': store.subscription_expires_at.isoformat() if store.subscription_expires_at else None,
                    'payment_provider': store.payment_provider,
                    'payment_external_id': store.payment_external_id,
                })
        
        return Response(users_data)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_plan(request, user_id):
    """Atualiza plano do usuário"""
    if not request.user.is_staff:
        return Response({'error': 'Sem permissão'}, status=403)
    
    try:
        new_plan = request.data.get('plan', 'free')
        
        # Buscar store pelo owner
        store = Store.objects.filter(owner_id=user_id).first()
        if not store:
            return Response({'error': 'Store não encontrada'}, status=404)
        
        store.plan = new_plan
        store.save()
        
        return Response({'success': True, 'new_plan': new_plan})
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_subscription(request, user_id):
    """Atualiza assinatura do usuário"""
    if not request.user.is_staff:
        return Response({'error': 'Sem permissão'}, status=403)
    
    try:
        data = request.data
        
        store = Store.objects.filter(owner_id=user_id).first()
        if not store:
            return Response({'error': 'Store não encontrada'}, status=404)
        
        store.plan = data.get('plan', 'pro')
        store.payment_provider = data.get('provider')
        store.payment_external_id = data.get('external_id')
        
        if data.get('started_at'):
            from django.utils.dateparse import parse_datetime
            store.subscription_started_at = parse_datetime(data['started_at'])
        
        if data.get('expires_at'):
            from django.utils.dateparse import parse_datetime
            store.subscription_expires_at = parse_datetime(data['expires_at'])
        
        store.save()
        
        return Response({'success': True})
    except Exception as e:
        return Response({'error': str(e)}, status=500)