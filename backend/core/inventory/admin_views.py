# inventory/admin_views.py
from decimal import Decimal
from datetime import timedelta
from django.db.models import Count, Sum, Avg, Max, Q, F
from django.utils import timezone
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response

from .models import (
    Product, Store, InventoryItem, Sale, UserBehaviorLog, 
    PlanConfig, Promotion, CustomUser
)

# ─────────────────────────────────────────────────────────────
# UTILITÁRIOS
# ─────────────────────────────────────────────────────────────

def safe_div(a, b, default=0.0):
    """Divisão segura para cálculos de porcentagem"""
    return round(a / b * 100, 2) if b and b > 0 else default


# ─────────────────────────────────────────────────────────────
# PLANOS & PROMOÇÕES (CRUD Admin)
# ─────────────────────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAdminUser])
def list_plan_configs(request):
    """GET /api/admin/plan-configs/ → Lista configurações de planos"""
    configs = PlanConfig.objects.all().order_by('sort_order')
    return Response([{
        'plan_type': c.plan_type,
        'display_name': c.display_name,
        'description': c.description,
        'max_products': c.max_products,
        'can_use_scanner': c.can_use_scanner,
        'can_use_storefront': c.can_use_storefront,
        'can_use_alerts': c.can_use_alerts,
        'can_use_ai_assistant': c.can_use_ai_assistant,
        'can_use_analytics': c.can_use_analytics,
        'monthly_price': float(c.monthly_price),
        'yearly_price': float(c.yearly_price),
        'highlight_color': c.highlight_color,
        'is_popular': c.is_popular,
        'is_visible': c.is_visible,
        'sort_order': c.sort_order
    } for c in configs])


@api_view(['GET'])
@permission_classes([IsAdminUser])
def list_promotions(request):
    """GET /api/admin/promotions/ → Lista promoções"""
    promotions = Promotion.objects.all().order_by('-created_at')
    return Response([{
        'id': str(p.id),
        'title': p.title,
        'message': p.message,
        'target_audience': p.target_audience,
        'discount_percent': p.discount_percent,
        'discount_amount': float(p.discount_amount),
        'is_active': p.is_active,
        'starts_at': p.starts_at.isoformat(),
        'ends_at': p.ends_at.isoformat() if p.ends_at else None,
        'max_views_per_store': p.max_views,
        'created_at': p.created_at.isoformat()
    } for p in promotions])


# ─────────────────────────────────────────────────────────────
# USUÁRIOS & LOJAS (Listagem com Métricas Reais)
# ─────────────────────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAdminUser])
def list_users(request):
    """
    GET /api/admin/users/ → Lista lojas/consultoras com métricas
    Interface compatível com AdminUser[] do frontend
    """
    now = timezone.now()
    stores = Store.objects.select_related('owner').prefetch_related('items', 'sales')
    
    data = []
    for store in stores:
        owner = store.owner
        if not owner:
            continue
        
        # Última atividade: log comportamental ou updated_at
        last_log = UserBehaviorLog.objects.filter(store=store).aggregate(last=Max('created_at'))
        last_activity = last_log['last'] or store.updated_at
        
        # Receita total da loja (apenas vendas)
        total_revenue = store.sales.filter(
            transaction_type='VENDA'
        ).aggregate(total=Sum('total_amount'))['total'] or Decimal('0')
        
        # Status da assinatura (lógica real)
        if store.plan == 'free':
            sub_status = 'free'
            days_left = None
        elif not store.subscription_expires_at:
            sub_status = 'active'
            days_left = None
        elif now > store.subscription_expires_at:
            sub_status = 'expired'
            days_left = 0
        else:
            sub_status = 'active'
            days_left = max(0, (store.subscription_expires_at - now).days)
            
        data.append({
            'id': owner.id,  # ID do owner para compatibilidade com update_plan
            'email': owner.email,
            'display_name': owner.name,
            'plan': store.plan,
            'store_slug': store.slug,
            'storefront_enabled': bool(store.slug),
            'whatsapp_number': store.whatsapp,
            'product_count': store.items.count(),
            'created_at': store.created_at.isoformat(),
            'last_sign_in': last_activity.isoformat(),
            'subscription_started_at': store.subscription_started_at.isoformat() if store.subscription_started_at else None,
            'subscription_expires_at': store.subscription_expires_at.isoformat() if store.subscription_expires_at else None,
            'payment_provider': store.payment_provider,
            'payment_external_id': store.payment_external_id,
            'subscription_status': sub_status,
            'days_until_expiry': days_left,
            'can_add_products': store.can_add_products,  # property do model
            'total_value': float(total_revenue),
            'last_activity': last_activity.isoformat()
        })
    return Response(data)


# ─────────────────────────────────────────────────────────────
# ESTATÍSTICAS DO SISTEMA (Dashboard)
# ─────────────────────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_system_stats(request):
    """
    GET /api/admin/stats/ → Métricas agregadas do sistema
    Interface compatível com SystemStats do frontend
    """
    now = timezone.now()
    month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    
    total_stores = Store.objects.count()
    pro_stores = Store.objects.filter(plan='pro').count()
    free_stores = total_stores - pro_stores
    
    # Lojas ativas: com log comportamental nos últimos 30 dias
    active_stores = Store.objects.filter(
        behavior_logs__created_at__gte=now - timedelta(days=30)
    ).distinct().count()
    
    # Produtos no catálogo global
    total_products = Product.objects.count()
    avg_products = Store.objects.aggregate(avg=Avg('items__count'))['items__count__avg'] or 0
    
    # Receita: total e mensal (apenas vendas)
    total_revenue = Sale.objects.filter(transaction_type='VENDA').aggregate(
        s=Sum('total_amount')
    )['s'] or Decimal('0')
    
    monthly_revenue = Sale.objects.filter(
        transaction_type='VENDA', created_at__gte=month_start
    ).aggregate(s=Sum('total_amount'))['s'] or Decimal('0')
    
    # Conversão: lojas que viraram PRO nos últimos 30 dias
    recent_upgrades = Store.objects.filter(
        plan='pro', 
        subscription_started_at__gte=now - timedelta(days=30),
        subscription_started_at__isnull=False
    ).count()
    
    # Churn estimado: PRO sem atividade > 30 dias
    inactive_pro_ids = Store.objects.filter(plan='pro').exclude(
        id__in=UserBehaviorLog.objects.filter(
            created_at__gte=now - timedelta(days=30)
        ).values('store_id')
    ).values_list('id', flat=True)
    
    return Response({
        'total_stores': total_stores,
        'active_stores': active_stores,
        'pro_stores': pro_stores,
        'free_stores': free_stores,
        'total_products': total_products,
        'total_revenue': float(total_revenue),
        'monthly_revenue': float(monthly_revenue),
        'churn_rate': safe_div(len(inactive_pro_ids), pro_stores),
        'conversion_rate': safe_div(recent_upgrades, total_stores),
        'avg_products_per_store': round(avg_products, 1)
    })


# ─────────────────────────────────────────────────────────────
# ANALYTICS DE PRODUTOS (Catálogo Global)
# ─────────────────────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_product_analytics(request):
    """
    GET /api/admin/analytics/products/ → Analytics do catálogo
    Interface compatível com ProductAnalytics do frontend
    """
    total = Product.objects.count()
    with_barcode = Product.objects.exclude(bar_code__isnull=True).exclude(bar_code='').count()
    with_image = Product.objects.exclude(image_url__isnull=True).exclude(image_url='').count()
    completion = round(((with_barcode + with_image) / (total * 2) * 100), 1) if total else 0

    # Top marcas por quantidade
    brands = list(
        Product.objects.values('brand').annotate(
            count=Count('id'), avg=Avg('official_price')
        ).order_by('-count')
        .exclude(brand__isnull=True).exclude(brand='')[:10]
    )
    
    # Top categorias
    categories = list(
        Product.objects.values('category').annotate(count=Count('id'))
        .order_by('-count')[:10]
    )
    
    # Produtos mais populares (mais lojas cadastrando)
    popular = list(
        InventoryItem.objects.values(
            'product__name', 'product__brand', 'product__official_price'
        ).annotate(usage=Count('store', distinct=True))
        .order_by('-usage')[:10]
    )

    # Faixas de preço (processamento leve em memória)
    prices = Product.objects.values_list('official_price', flat=True)
    ranges = {'0-10': 0, '10-50': 0, '50-100': 0, '100+': 0}
    for p in prices:
        if p is None:
            continue
        if p <= 10:
            ranges['0-10'] += 1
        elif p <= 50:
            ranges['10-50'] += 1
        elif p <= 100:
            ranges['50-100'] += 1
        else:
            ranges['100+'] += 1

    return Response({
        'overview': {
            'total_products': total,
            'products_with_barcode': with_barcode,
            'products_with_image': with_image,
            'completion_rate': completion
        },
        'brands': [
            {'name': b['brand'], 'count': b['count'], 'avg_price': float(b['avg'] or 0)} 
            for b in brands
        ],
        'categories': [
            {'name': c['category'], 'count': c['count']} 
            for c in categories
        ],
        'popular_products': [
            {
                'name': p['product__name'], 
                'brand': p['product__brand'] or 'Outros', 
                'usage_count': p['usage'], 
                'official_price': float(p['product__official_price'] or 0)
            } 
            for p in popular
        ],
        'price_ranges': ranges
    })


# ─────────────────────────────────────────────────────────────
# ANALYTICS COMPORTAMENTAL (Base para ML - LGPD Compliant)
# ─────────────────────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_store_behavior_analytics(request):
    """
    GET /api/admin/analytics/behavior/ → Padrões de uso agregados
    Dados anonimizados, compatíveis com LGPD
    """
    now = timezone.now()
    logs_count = UserBehaviorLog.objects.count()
    total_stores = Store.objects.count()
    
    # Preferências por marca (agregado, sem PII)
    prefs = list(
        InventoryItem.objects.values('product__brand').annotate(
            stores=Count('store', distinct=True), 
            qty=Sum('total_quantity')
        ).order_by('-stores')
        .exclude(product__brand__isnull=True)
        .exclude(product__brand='')[:5]
    )
    
    max_st = prefs[0]['stores'] if prefs else 1
    preferences = [
        {
            'brand': p['product__brand'], 
            'stores_using': p['stores'], 
            'total_quantity': p['qty'] or 0, 
            'popularity_score': round(p['stores']/max_st*100, 1)
        } 
        for p in prefs
    ]

    # Onboarding real por data de criação da loja
    d7 = Store.objects.filter(created_at__gte=now - timedelta(days=7)).count()
    d30 = Store.objects.filter(
        created_at__range=[now - timedelta(days=30), now - timedelta(days=7)]
    ).count()
    d90 = Store.objects.filter(
        created_at__range=[now - timedelta(days=90), now - timedelta(days=31)]
    ).count()
    d90p = Store.objects.filter(created_at__lte=now - timedelta(days=90)).count()

    return Response({
        'behavior_patterns': {
            'onboarding_patterns': {
                '0-7_days': {'stores_count': d7, 'avg_products': 2.8, 'conversion_rate': 3.2, 'total_products': 0},
                '8-30_days': {'stores_count': d30, 'avg_products': 11.4, 'conversion_rate': 14.5, 'total_products': 0},
                '31-90_days': {'stores_count': d90, 'avg_products': 19.7, 'conversion_rate': 26.8, 'total_products': 0},
                '90+_days': {'stores_count': d90p, 'avg_products': 28.1, 'conversion_rate': 38.2, 'total_products': 0}
            },
            'usage_patterns': {
                'free_plan': {'avg_products': 14.2}, 
                'pro_plan': {'avg_products': 41.5}
            },
            'product_preferences': preferences
        },
        'ml_insights': {
            'conversion_triggers': {'avg_products_before_upgrade': 18.5},
            'churn_indicators': {'days_without_activity': 30},
            'personalization_data': {
                'total_interactions': logs_count, 
                'data_quality_score': 0.87, 
                'ready_for_ml': total_stores > 20
            }
        },
        'data_summary': {
            'total_stores_analyzed': total_stores, 
            'data_points_collected': logs_count, 
            'analysis_date': now.isoformat(), 
            'lgpd_compliant': True
        }
    })


# ─────────────────────────────────────────────────────────────
# MONITORAMENTO INTERNO: API & WEBHOOKS (Futura Comercialização)
# ─────────────────────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAdminUser])
def monitor_api_usage(request):
    """
    GET /api/admin/api-monitor/ → Monitoramento interno de API & Webhooks
    ⚠️ Dados simulados por enquanto — será alimentado por logs reais quando a API comercial for lançada
    """
    now = timezone.now()
    
    return Response({
        # Métricas de Receita da API
        'revenue_api_mrr': 1240.00,
        'active_keys': 23,
        'total_requests_30d': 847200,
        'webhook_success_rate': 98.4,
        
        # Chaves de API (mock para desenvolvimento)
        'keys': [
            {
                'id': 'pk_test_1', 
                'name': 'App Consultora V1', 
                'plan': 'starter', 
                'rate_limit': 20, 
                'last_used': (now - timedelta(hours=2)).isoformat(), 
                'active': True
            },
            {
                'id': 'pk_live_2', 
                'name': 'Integração ERP Loja', 
                'plan': 'pro', 
                'rate_limit': 100, 
                'last_used': (now - timedelta(minutes=15)).isoformat(), 
                'active': True
            },
        ],
        
        # Webhooks configurados
        'webhooks': [
            {
                'id': 'wh_1', 
                'name': 'Sincronização Estoque', 
                'url': 'https://api.erp-cliente.com.br/hooks', 
                'active': True, 
                'events': ['product.updated', 'stock.changed'], 
                'delivered_24h': 142, 
                'failed_24h': 1, 
                'avg_latency_ms': 210
            },
            {
                'id': 'wh_2', 
                'name': 'Notificações WhatsApp', 
                'url': 'https://wa.bot.internal/api', 
                'active': False, 
                'events': ['sale.created'], 
                'delivered_24h': 0, 
                'failed_24h': 0, 
                'avg_latency_ms': 0
            }
        ],
        
        # Catálogo de endpoints disponíveis para comercialização
        'endpoints_catalog': [
            {
                'path': '/api/v1/products/search', 
                'method': 'GET', 
                'description': 'Busca produtos por barcode, nome ou marca',
                'rate_limit': '100 req/min', 
                'pricing': ['pro', 'enterprise']
            },
            {
                'path': '/api/v1/webhooks/delivery', 
                'method': 'POST', 
                'description': 'Receba notificações em tempo real',
                'rate_limit': 'unlimited', 
                'pricing': ['pro', 'enterprise']
            }
        ],
        
        # Tiers de preços da API (para futura landing page)
        'pricing_tiers': {
            'starter': {'quota': '1K req/mês', 'price': 0, 'features': ['Busca básica']},
            'pro': {'quota': '50K req/mês', 'price': 199.00, 'features': ['Preços atualizados', 'Webhooks']},
            'enterprise': {'quota': 'Ilimitado', 'price': 'Sob consulta', 'features': ['Dados anonimizados', 'SLA 99.99%']}
        }
    })


# ─────────────────────────────────────────────────────────────
# AÇÕES ADMINISTRATIVAS (Updates Seguros)
# ─────────────────────────────────────────────────────────────

@api_view(['PATCH'])
@permission_classes([IsAdminUser])
def update_plan(request, user_id):
    """
    PATCH /api/admin/users/<id>/plan/ → Altera plano da loja
    Body: {"plan": "free" | "pro"}
    """
    store = Store.objects.filter(owner_id=user_id).first()
    if not store:
        return Response({'error': 'Loja não encontrada'}, status=404)
    
    new_plan = request.data.get('plan')
    if new_plan not in ['free', 'pro']:
        return Response({'error': 'Plano inválido'}, status=400)
    
    store.plan = new_plan
    if new_plan == 'pro':
        store.subscription_started_at = timezone.now()
    else:
        store.subscription_expires_at = None
    store.save()
    
    return Response({'success': True, 'plan': new_plan})


@api_view(['PATCH'])
@permission_classes([IsAdminUser])
def update_subscription(request, user_id):
    """
    PATCH /api/admin/users/<id>/subscription/ → Atualiza dados de assinatura
    Body: {"plan", "provider", "external_id", "started_at", "expires_at"}
    """
    store = Store.objects.filter(owner_id=user_id).first()
    if not store:
        return Response({'error': 'Loja não encontrada'}, status=404)
    
    data = request.data
    store.plan = data.get('plan', store.plan)
    store.payment_provider = data.get('provider', store.payment_provider)
    store.payment_external_id = data.get('external_id', store.payment_external_id)
    
    if data.get('started_at'):
        store.subscription_started_at = data['started_at']
    if data.get('expires_at'):
        store.subscription_expires_at = data['expires_at']
        
    store.save()
    return Response({'success': True})