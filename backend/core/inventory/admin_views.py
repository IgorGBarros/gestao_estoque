# inventory/admin_views.py
import logging
from decimal import Decimal
from datetime import timedelta
from django.db.models import Count, Sum, Avg, Max, Q, F
from django.utils import timezone
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response

from .models import (
    Product, Store, InventoryItem, Sale, UserBehaviorLog, 
    PlanConfig, Promotion, CustomUser, ConsentRecord, StockTransaction,
    Lead, Cart, CartItem, SystemConfig, ApiKey, ApiUsageLog,
)

logger = logging.getLogger(__name__)

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
    return Response([_serialize_plan_config(c) for c in configs])


def _serialize_plan_config(c):
    """Forma única de serializar um PlanConfig (usada no list e no update)."""
    return {
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
        'sort_order': c.sort_order,
    }


@api_view(['PATCH'])
@permission_classes([IsAdminUser])
def update_plan_config(request, plan_type):
    """
    PATCH /api/admin/plan-configs/<plan_type>/ → Edita um plano.

    Este é o elo que conecta o painel admin ao resto do sistema: ao mudar
    aqui monthly_price/yearly_price, o preço passa a valer no checkout do
    Asaas (asaas_service._get_pro_price), no Plans.tsx e no /profile/
    (current_limits) — tudo lendo do mesmo PlanConfig. Limites e flags de
    recurso editados aqui também refletem imediatamente nos feature gates.
    """
    config = PlanConfig.objects.filter(plan_type=plan_type).first()
    if not config:
        return Response({'error': f"Plano '{plan_type}' não encontrado."}, status=404)

    # Só campos permitidos; ignora o resto do payload por segurança.
    editable_decimal = {'monthly_price', 'yearly_price'}
    editable_int = {'max_products', 'sort_order', 'yearly_discount_percent', 'max_storage_mb'}
    editable_bool = {
        'can_use_scanner', 'can_use_storefront', 'can_use_alerts',
        'can_use_ai_assistant', 'can_use_analytics', 'can_export_data',
        'can_use_api', 'is_popular', 'is_visible',
    }
    editable_str = {'display_name', 'description', 'highlight_color'}

    data = request.data or {}
    errors = {}
    for field, value in data.items():
        try:
            if field in editable_decimal:
                dec = Decimal(str(value))
                if dec < 0:
                    errors[field] = 'não pode ser negativo'
                    continue
                setattr(config, field, dec)
            elif field in editable_int:
                setattr(config, field, None if value is None else int(value))
            elif field in editable_bool:
                setattr(config, field, bool(value))
            elif field in editable_str:
                setattr(config, field, str(value))
            # campos fora da allowlist são silenciosamente ignorados
        except (ValueError, TypeError, ArithmeticError):
            errors[field] = 'valor inválido'

    if errors:
        return Response({'error': 'Campos inválidos', 'details': errors}, status=400)

    config.save()
    return Response(_serialize_plan_config(config))


def _serialize_promotion(p):
    # 📊 Métricas REAIS — antes eram Math.random() no frontend, recalculadas
    # (e diferentes!) a cada renderização da tela.
    #
    # "Visualizações" = quantas lojas DIFERENTES viram esta promoção
    # (PromotionView, uma linha por loja — repetição não infla).
    #
    # "Conversões" = dessas lojas que viram, quantas são PRO hoje E viraram
    # PRO DEPOIS de terem visto a promoção — sem o "depois", uma loja que já
    # era PRO antes da promoção existir contaria como se a promoção tivesse
    # convertido ela, o que não é verdade.
    visualizacoes = p.views.select_related('store').all()
    total_visualizacoes = visualizacoes.count()
    conversoes = 0
    for v in visualizacoes:
        loja = v.store
        if loja.plan == 'pro' and loja.subscription_started_at and loja.subscription_started_at >= v.viewed_at:
            conversoes += 1
    taxa_conversao = round((conversoes / total_visualizacoes * 100), 1) if total_visualizacoes else 0.0

    return {
        'id': str(p.id),
        'title': p.title,
        'message': p.message,
        'promotion_type': p.promotion_type,
        'target_audience': p.target_audience,
        'target_store_ids': list(p.target_stores.values_list('id', flat=True)),
        'discount_percent': p.discount_percent,
        'discount_amount': float(p.discount_amount),
        'is_active': p.is_active,
        'starts_at': p.starts_at.isoformat(),
        'ends_at': p.ends_at.isoformat() if p.ends_at else None,
        'max_views_per_store': p.max_views,
        'background_color': p.background_color,
        'text_color': p.text_color,
        'created_at': p.created_at.isoformat(),
        'views_count': total_visualizacoes,
        'conversions_count': conversoes,
        'conversion_rate': taxa_conversao,
    }


@api_view(['GET'])
@permission_classes([IsAdminUser])
def list_promotions(request):
    """GET /api/admin/promotions/ → Lista promoções"""
    promotions = Promotion.objects.all().order_by('-created_at')
    return Response([_serialize_promotion(p) for p in promotions])


# ⚠️ CORREÇÃO GRAVE: até aqui só existia LISTAR. O botão "Salvar" do
# admin-panel nunca chamava nenhuma API — só mexia em estado local do
# React, com um id falso (Date.now()). Uma promoção "criada" sumia ao
# atualizar a página; ativar/desativar tinha o mesmo problema. O recurso
# inteiro era cosmético.

_CAMPOS_PROMOCAO = [
    'title', 'message', 'promotion_type', 'target_audience',
    'discount_percent', 'discount_amount', 'is_active',
    'starts_at', 'ends_at', 'max_views', 'background_color', 'text_color',
]


@api_view(['POST'])
@permission_classes([IsAdminUser])
def create_promotion(request):
    """POST /api/admin/promotions/create/"""
    data = request.data
    if not data.get('title') or not data.get('message'):
        return Response({'error': 'title e message são obrigatórios'}, status=400)

    promo = Promotion()
    for campo in _CAMPOS_PROMOCAO:
        if campo in data and data[campo] is not None:
            setattr(promo, campo, data[campo])
    try:
        promo.save()
    except Exception as e:
        return Response({'error': f'Não foi possível salvar: {e}'}, status=400)

    # target_store_ids: lista de IDs de Store (não de usuário — ver
    # list_users, que já tem essa mesma ressalva marcada).
    ids_lojas = data.get('target_store_ids')
    if isinstance(ids_lojas, list):
        promo.target_stores.set(Store.objects.filter(id__in=ids_lojas))

    return Response(_serialize_promotion(promo), status=201)


@api_view(['PATCH', 'DELETE'])
@permission_classes([IsAdminUser])
def promotion_detail(request, promotion_id):
    """
    PATCH  /api/admin/promotions/<id>/ — edita (inclui ativar/desativar).
    DELETE /api/admin/promotions/<id>/ — exclui definitivamente.
    """
    promo = Promotion.objects.filter(id=promotion_id).first()
    if not promo:
        return Response({'error': 'Promoção não encontrada'}, status=404)

    if request.method == 'DELETE':
        promo.delete()
        return Response(status=204)

    data = request.data
    for campo in _CAMPOS_PROMOCAO:
        if campo in data and data[campo] is not None:
            setattr(promo, campo, data[campo])
    try:
        promo.save()
    except Exception as e:
        return Response({'error': f'Não foi possível salvar: {e}'}, status=400)

    if 'target_store_ids' in data and isinstance(data['target_store_ids'], list):
        promo.target_stores.set(Store.objects.filter(id__in=data['target_store_ids']))

    return Response(_serialize_promotion(promo))


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
            'store_id': store.id,  # ⚠️ ID da LOJA — necessário pra Promotion.target_stores,
                                    # que é M2M com Store, não com o usuário.
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
            'last_activity': last_activity.isoformat(),
            # ⚠️ NOVO: status de contato — reaproveita a mesma lógica já
            # usada no comando de terminal, pra mostrar direto no painel
            # expandido de cada usuária, sem precisar de endpoint separado.
            'email_enviado': list(store.emails_enviados.values_list('template', flat=True)),
            'whatsapp_marcado': list(store.whatsapp_marcados.values_list('template', flat=True)),
            'campos_faltando': _campos_faltando_lista(store),
        })
    return Response(data)


def _campos_faltando_lista(store):
    faltando = []
    if not store.name:
        faltando.append("Nome")
    if not store.whatsapp:
        faltando.append("WhatsApp")
    return faltando


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
    # ⚠️ CORREÇÃO (FieldError → 500): Avg('items__count') não é um lookup
    # válido — não existe o campo 'count'. Para a média de itens por loja é
    # preciso anotar a contagem por loja primeiro e então tirar a média.
    avg_products = Store.objects.annotate(
        _n_items=Count('items')
    ).aggregate(avg=Avg('_n_items'))['avg'] or 0
    
    # Receita: total e mensal (apenas vendas)
    # ⚠️ CORREÇÃO (tudo zerado no painel): o admin lia de Sale.total_amount,
    # mas a maioria dos fluxos de venda do sistema grava só em
    # StockTransaction (VENDA) — Sale quase nunca é populada. Todo o resto
    # (dashboards, cash-flow, cost analysis) já calcula receita a partir de
    # StockTransaction. Alinhamos o admin à mesma fonte canônica: receita =
    # soma de (unit_price * quantidade vendida). Como quantity de VENDA é
    # negativa (baixa de estoque), usamos o valor absoluto via -quantity.
    revenue_expr = Sum(F('unit_price') * (F('quantity') * -1))
    total_revenue = StockTransaction.objects.filter(
        transaction_type='VENDA'
    ).aggregate(s=revenue_expr)['s'] or Decimal('0')

    monthly_revenue = StockTransaction.objects.filter(
        transaction_type='VENDA', created_at__gte=month_start
    ).aggregate(s=revenue_expr)['s'] or Decimal('0')

    # 💰 Receita REAL da plataforma — assinaturas efetivamente pagas via
    # Asaas, vinda direto dos webhooks (ProcessedPaymentEvent.value). É
    # diferente de `total_revenue`/`monthly_revenue` acima, que são as
    # VENDAS DE PRODUTO das consultoras nas lojas delas — GMV da plataforma,
    # não receita do próprio Minha Amora. As duas métricas são legítimas,
    # mas não podem ser confundidas: o negócio (assinatura PRO) só aparece
    # nesta aqui.
    #
    # ⚠️ Fase 4: ProcessedPaymentEvent passou a registrar TAMBÉM assinatura
    # de API de desenvolvedor (mesma tabela de idempotência, ver modelo).
    # store__isnull=False garante que este widget continue mostrando só a
    # receita de assinatura das CONSULTORAS — a de API tem o próprio widget
    # em monitor_api_usage.
    from inventory.models import ProcessedPaymentEvent
    eventos_consultora = ProcessedPaymentEvent.objects.filter(store__isnull=False)
    platform_revenue_total = eventos_consultora.aggregate(
        s=Sum('value')
    )['s'] or Decimal('0')
    platform_revenue_month = eventos_consultora.filter(
        processed_at__gte=month_start
    ).aggregate(s=Sum('value'))['s'] or Decimal('0')

    # Últimos 30 dias, por dia — pra um gráfico de tendência, como qualquer
    # painel de assinatura (Stripe, Chargebee) mostra receita ao longo do
    # tempo, não só um número estático.
    from django.db.models.functions import TruncDate
    receita_por_dia = (
        eventos_consultora.filter(processed_at__gte=now - timedelta(days=30))
        .annotate(dia=TruncDate('processed_at'))
        .values('dia')
        .annotate(total=Sum('value'))
        .order_by('dia')
    )

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
        'platform_revenue_total': float(platform_revenue_total),
        'platform_revenue_month': float(platform_revenue_month),
        'platform_revenue_by_day': [
            {'date': r['dia'].isoformat(), 'value': float(r['total'] or 0)}
            for r in receita_por_dia
        ],
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
# ANALYTICS COMPORTAMENTAL (Base para ML — filtrado por consentimento LGPD)
# ─────────────────────────────────────────────────────────────

from .consent_utils import consented_user_ids as _consented_owner_ids


@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_store_behavior_analytics(request):
    """
    GET /api/admin/analytics/behavior/ → Padrões de uso agregados

    CORREÇÃO (P1): esta função contava TODAS as lojas e TODOS os
    UserBehaviorLog, sem checar consentimento algum, e retornava
    'lgpd_compliant': True fixo no código — uma afirmação de
    conformidade que o backend não garantia. Agora:
    - Toda métrica é calculada só sobre lojas cujo dono deu
      consentimento ativo para 'behavior_tracking'.
    - 'lgpd_compliant' deixa de ser um valor fixo: é verdadeiro por
      construção, porque os dados não-consentidos nunca entram na
      consulta.
    - Números que antes eram constantes fixas no código
      (avg_products, conversion_rate, data_quality_score etc.) foram
      trocados por cálculos reais onde há dado no banco para
      sustentar o cálculo. Onde não há (ex: taxa de conversão
      free→pro, que exigiria um histórico de mudança de plano que o
      sistema não guarda hoje), o campo foi removido em vez de manter
      um número inventado — ver nota em 'not_yet_available'.
    """
    now = timezone.now()

    consented_ids = _consented_owner_ids('behavior_tracking')
    total_stores_platform = Store.objects.count()

    stores_qs = Store.objects.filter(owner_id__in=consented_ids)
    logs_qs = UserBehaviorLog.objects.filter(store__owner_id__in=consented_ids)

    total_stores = stores_qs.count()
    logs_count = logs_qs.count()

    # Preferências por marca (agregado, sem PII) — só lojas consentidas
    prefs = list(
        InventoryItem.objects.filter(store__owner_id__in=consented_ids)
        .values('product__brand').annotate(
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
            'popularity_score': round(p['stores'] / max_st * 100, 1)
        }
        for p in prefs
    ]

    # Onboarding real por data de criação da loja — só lojas consentidas
    bucket_0_7 = stores_qs.filter(created_at__gte=now - timedelta(days=7))
    bucket_8_30 = stores_qs.filter(
        created_at__range=[now - timedelta(days=30), now - timedelta(days=7)]
    )
    bucket_31_90 = stores_qs.filter(
        created_at__range=[now - timedelta(days=90), now - timedelta(days=31)]
    )
    bucket_90p = stores_qs.filter(created_at__lte=now - timedelta(days=90))

    def _avg_products_per_store(bucket_qs):
        """Média real de itens de estoque por loja no bucket, calculada
        a partir do InventoryItem (substitui o valor fixo que existia antes)."""
        agg = (
            InventoryItem.objects.filter(store__in=bucket_qs)
            .values('store')
            .annotate(n=Count('id'))
            .aggregate(avg=Avg('n'))
        )
        return round(agg['avg'] or 0, 1)

    onboarding_patterns = {
        '0-7_days': {'stores_count': bucket_0_7.count(), 'avg_products': _avg_products_per_store(bucket_0_7)},
        '8-30_days': {'stores_count': bucket_8_30.count(), 'avg_products': _avg_products_per_store(bucket_8_30)},
        '31-90_days': {'stores_count': bucket_31_90.count(), 'avg_products': _avg_products_per_store(bucket_31_90)},
        '90+_days': {'stores_count': bucket_90p.count(), 'avg_products': _avg_products_per_store(bucket_90p)},
    }

    # Uso médio por plano — real, a partir do InventoryItem, só lojas consentidas
    usage_patterns = {}
    for plan_key in ('free', 'pro'):
        plan_stores = stores_qs.filter(plan=plan_key)
        usage_patterns[f'{plan_key}_plan'] = {
            'stores_count': plan_stores.count(),
            'avg_products': _avg_products_per_store(plan_stores),
        }

    # Indicador de churn: define o limiar (30 dias) e calcula quantas lojas
    # consentidas realmente se encaixam nele, a partir do último log de uso.
    churn_threshold_days = 30
    last_activity = (
        logs_qs.values('store').annotate(last_seen=Max('created_at'))
    )
    churned_count = sum(
        1 for row in last_activity
        if row['last_seen'] and row['last_seen'] < now - timedelta(days=churn_threshold_days)
    )

    consent_coverage_pct = safe_div(total_stores, total_stores_platform) if total_stores_platform else 0.0

    return Response({
        'behavior_patterns': {
            'onboarding_patterns': onboarding_patterns,
            'usage_patterns': usage_patterns,
            'product_preferences': preferences,
        },
        'ml_insights': {
            'churn_indicators': {
                'days_without_activity_threshold': churn_threshold_days,
                'stores_matching': churned_count,
            },
            'personalization_data': {
                'total_interactions': logs_count,
                'avg_logs_per_consented_store': round(logs_count / total_stores, 1) if total_stores else 0.0,
                'ready_for_ml': total_stores > 20,
            },
            'not_yet_available': [
                'conversion_rate (requer histórico de mudança de plano, hoje só existe o estado atual)',
                'avg_products_before_upgrade (mesma limitação acima)',
            ],
        },
        'data_summary': {
            'total_stores_analyzed': total_stores,
            'total_stores_platform': total_stores_platform,
            'consent_coverage_pct': consent_coverage_pct,
            'data_points_collected': logs_count,
            'analysis_date': now.isoformat(),
            'lgpd_compliant': True,
        }
    })


# ─────────────────────────────────────────────────────────────
# DATASET DE TREINO DE IA (finalidade 'ai_training' — LGPD)
# ─────────────────────────────────────────────────────────────

@api_view(['GET'])
@permission_classes([IsAdminUser])
def get_ai_training_summary(request):
    """
    GET /api/admin/ai-training/summary/ → Tamanho/cobertura do dataset
    disponível para treino de IA, sempre filtrado por consentimento
    ativo na finalidade 'ai_training' (distinta de 'ai_features').
    Ver inventory/ai_training_export.py para as regras completas.
    """
    from .ai_training_export import training_dataset_summary
    return Response(training_dataset_summary())


# ─────────────────────────────────────────────────────────────
# MONITORAMENTO INTERNO: API & WEBHOOKS (Futura Comercialização)
# ─────────────────────────────────────────────────────────────
# inventory/admin_views.py - SUBSTITUA a função monitor_api_usage por esta versão:

@api_view(['GET'])
@permission_classes([IsAdminUser])
def monitor_api_usage(request):
    """
    GET /api/admin/api-monitor/ — dado real do produto de API.

    ⚠️ REESCRITO DO ZERO: a versão anterior usava lojas com vitrine ativa
    como "proxy" de chave de API (gerando um prefixo falso a partir do
    slug — nenhuma chave real tinha sido emitida), e "revenue_api_mrr" era
    a receita de ASSINATURA DAS CONSULTORAS, só relabelada como se fosse
    receita de API. Agora usa DeveloperAccount/ApiKey/ApiUsageLog de
    verdade — os mesmos modelos que apps/developers usa.
    """
    from django.db.models import Avg, Count, Q
    from django.db.models.functions import TruncDate
    from datetime import timedelta
    from apps.developers.models import DeveloperAccount, ApiSubscription

    now = timezone.now()
    desde_30d = now - timedelta(days=30)

    total_developers = DeveloperAccount.objects.count()
    chaves = ApiKey.objects.filter(developer__isnull=False).select_related('developer')
    chaves_ativas = chaves.filter(is_active=True).count()

    logs_30d = ApiUsageLog.objects.filter(api_key__developer__isnull=False, created_at__gte=desde_30d)
    total_requests_30d = logs_30d.count()
    erros_30d = logs_30d.filter(status_code__gte=400).count()
    error_rate = round(erros_30d / total_requests_30d * 100, 1) if total_requests_30d else 0.0
    avg_response_time = round(logs_30d.aggregate(m=Avg('response_time_ms'))['m'] or 0, 0)

    # Série diária, últimos 30 dias — pra gráfico de tendência.
    requests_by_day = list(
        logs_30d.annotate(dia=TruncDate('created_at'))
        .values('dia')
        .annotate(total=Count('id'))
        .order_by('dia')
    )

    # Endpoints mais chamados — de verdade, não um catálogo hardcoded.
    top_endpoints = list(
        logs_30d.values('endpoint')
        .annotate(chamadas=Count('id'))
        .order_by('-chamadas')[:10]
    )

    # Uma linha por chave real, com quem é o desenvolvedor dono.
    keys_data = [
        {
            'id': str(k.id),
            'name': k.name,
            'key_prefix': k.key[:12] + '...',
            'developer_name': k.developer.name if k.developer else None,
            'developer_email': k.developer.email if k.developer else None,
            'plan': k.plan,
            'is_active': k.is_active,
            'rate_limit': k.rate_limit,
            'monthly_quota': k.monthly_quota,
            'requests_30d': k.usage_logs.filter(created_at__gte=desde_30d).count(),
            'last_used': k.last_used.isoformat() if k.last_used else None,
        }
        for k in chaves.order_by('-created_at')[:50]
    ]

    # 💰 Fase 4: receita REAL de assinatura de API — mesma tabela de
    # idempotência que a receita de assinatura das consultoras usa
    # (ProcessedPaymentEvent), filtrando pelo lado developer desta vez.
    from inventory.models import ProcessedPaymentEvent
    eventos_api = ProcessedPaymentEvent.objects.filter(developer__isnull=False)
    revenue_api_mrr = eventos_api.filter(
        processed_at__gte=now - timedelta(days=30)
    ).aggregate(s=Sum('value'))['s'] or 0
    assinaturas_ativas = ApiSubscription.objects.filter(expires_at__gt=now).count()

    return Response({
        'total_developers': total_developers,
        'active_keys': chaves_ativas,
        'total_requests_30d': total_requests_30d,
        'error_rate_percent': error_rate,
        'avg_response_time_ms': avg_response_time,
        'requests_by_day': [
            {'date': r['dia'].isoformat(), 'count': r['total']} for r in requests_by_day
        ],
        'top_endpoints': top_endpoints,
        'keys': keys_data,
        'revenue_api_mrr': float(revenue_api_mrr),
        'active_api_subscriptions': assinaturas_ativas,
        'generated_at': now.isoformat(),
        'data_freshness': 'real-time',
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
        # ⚠️ CORREÇÃO: só definia subscription_started_at, nunca
        # subscription_expires_at — "Virar PRO" no admin-panel concedia
        # acesso sem nenhuma data de vencimento registrada. 30 dias é o
        # mesmo ciclo do plano mensal pago (R$ 39,90/mês) — se o admin
        # quiser uma duração diferente, o endpoint mais completo
        # (update_subscription, abaixo) já aceita `expires_at` explícito.
        store.subscription_expires_at = timezone.now() + timedelta(days=30)
    else:
        store.subscription_expires_at = None
    store.save()
    
    return Response({'success': True, 'plan': new_plan, 'expires_at': store.subscription_expires_at})


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

# ==========================================
# 📊 SAÚDE DAS CONSULTORAS (visão do dono)
# ==========================================
# Os indicadores que saíram do Dashboard da consultora vivem aqui: giro de
# estoque, ROI, capital investido, saúde geral. Para ela esses números não
# geravam ação; para quem administra a plataforma, mostram quais consultoras
# estão indo bem e quais precisam de ajuda.

@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_consultants_health(request):
    """
    GET /api/admin/analytics/consultants/

    Uma linha por consultora com os indicadores de gestão, além dos totais
    da plataforma. Ordenado por receita nos últimos 30 dias.
    """
    from django.db.models import Sum, F, Q
    from django.utils import timezone
    from datetime import timedelta
    from decimal import Decimal

    from inventory.models import Store, InventoryItem, StockTransaction

    desde = timezone.now() - timedelta(days=30)
    hoje = timezone.now().date()
    linhas = []

    stores = Store.objects.select_related('owner').all()

    for store in stores:
        itens = InventoryItem.objects.filter(store=store).select_related('product')

        investido = Decimal('0')
        potencial = Decimal('0')
        unidades = 0
        estoque_baixo = 0
        for it in itens:
            qtd = it.total_quantity or 0
            unidades += qtd
            investido += (it.cost_price or 0) * qtd
            potencial += (it.sale_price or 0) * qtd
            minimo = it.min_quantity if it.min_quantity is not None else 0
            if qtd <= minimo:
                estoque_baixo += 1

        vendas = StockTransaction.objects.filter(
            store=store, transaction_type='VENDA', created_at__gte=desde
        )
        receita = vendas.aggregate(
            s=Sum(F('unit_price') * (F('quantity') * -1))
        )['s'] or Decimal('0')
        custo_vendido = vendas.aggregate(
            s=Sum(F('unit_cost') * (F('quantity') * -1))
        )['s'] or Decimal('0')
        unidades_vendidas = abs(vendas.aggregate(q=Sum('quantity'))['q'] or 0)
        num_vendas = vendas.count()

        lucro = receita - custo_vendido
        # Giro: quanto do estoque parado virou venda no período.
        giro = float(custo_vendido / investido) if investido else 0.0
        roi = float(lucro / custo_vendido * 100) if custo_vendido else 0.0
        margem = float(lucro / receita * 100) if receita else 0.0
        ticket = float(receita / num_vendas) if num_vendas else 0.0

        # Lotes vencidos e a vencer
        vencidos = 0
        vencendo = 0
        for it in itens:
            for lote in it.batches.all():
                if lote.expiration_date:
                    dias = (lote.expiration_date - hoje).days
                    if dias < 0:
                        vencidos += 1
                    elif dias <= 30:
                        vencendo += 1

        # Saúde: combina atividade de venda, giro e risco de perda.
        # Serve para ordenar quem precisa de atenção — não é nota fiscal.
        saude = 100
        if num_vendas == 0:
            saude -= 40
        if giro < 0.1:
            saude -= 20
        if estoque_baixo > 5:
            saude -= 15
        if vencidos > 0:
            saude -= 15
        if unidades == 0:
            saude -= 10
        saude = max(0, saude)

        linhas.append({
            'store_id': store.id,
            'name': store.name,
            'email': getattr(store.owner, 'email', ''),
            'plan': store.plan,
            'access_status': getattr(store, 'access_status', store.plan),
            'produtos': itens.count(),
            'unidades': unidades,
            'capital_investido': float(investido),
            'valor_potencial': float(potencial),
            'receita_30d': float(receita),
            'lucro_30d': float(lucro),
            'margem_percent': round(margem, 1),
            'roi_percent': round(roi, 1),
            'giro_estoque': round(giro, 2),
            'ticket_medio': round(ticket, 2),
            'vendas_30d': num_vendas,
            'unidades_vendidas_30d': unidades_vendidas,
            'estoque_baixo': estoque_baixo,
            'lotes_vencidos': vencidos,
            'lotes_vencendo': vencendo,
            'saude': saude,
        })

    linhas.sort(key=lambda x: x['receita_30d'], reverse=True)

    total_receita = sum(l['receita_30d'] for l in linhas)
    total_investido = sum(l['capital_investido'] for l in linhas)
    ativas = [l for l in linhas if l['vendas_30d'] > 0]

    return Response({
        'periodo': '30 dias',
        'totais': {
            'consultoras': len(linhas),
            'ativas_30d': len(ativas),
            'inativas_30d': len(linhas) - len(ativas),
            'receita_total_30d': round(total_receita, 2),
            'capital_investido_total': round(total_investido, 2),
            'receita_media_por_consultora': round(
                total_receita / len(ativas), 2) if ativas else 0,
            'em_risco': len([l for l in linhas if l['saude'] < 60]),
        },
        'consultoras': linhas,
    })


# ==========================================
# 🔐 ACESSAR COMO CONSULTORA (suporte)
# ==========================================

@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_impersonate_user(request, user_id):
    """
    POST /api/admin/users/<id>/impersonate/

    Emite um token de acesso para a conta da consultora, para o suporte
    conseguir ver a tela exatamente como ela vê.

    ⚠️ Isto dá acesso a DADOS PESSOAIS de terceiros: nomes de clientes finais,
    histórico de vendas, contatos. Por isso:
      • só quem é staff pode chamar;
      • não é possível assumir a conta de outro admin (evita escalar acesso);
      • toda utilização fica registrada no log do servidor;
      • o token dura 30 minutos, não os 60 normais.

    Use apenas para suporte solicitado pela própria consultora.
    """
    from datetime import timedelta

    from django.contrib.auth import get_user_model
    from rest_framework_simplejwt.tokens import RefreshToken

    User = get_user_model()

    try:
        alvo = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'Usuário não encontrado'}, status=404)

    # Um admin não assume a conta de outro admin.
    if alvo.is_staff or alvo.is_superuser:
        return Response(
            {'error': 'Não é possível acessar a conta de outro administrador.'},
            status=403,
        )

    if alvo.id == request.user.id:
        return Response({'error': 'Você já está na sua própria conta.'}, status=400)

    refresh = RefreshToken.for_user(alvo)
    access = refresh.access_token
    access.set_exp(lifetime=timedelta(minutes=30))

    # Marca o token para ser possível auditar depois.
    access['impersonated_by'] = request.user.email
    access['is_impersonation'] = True

    logger.warning(
        f"[IMPERSONATE] {request.user.email} acessou a conta de {alvo.email} "
        f"(user_id={alvo.id})"
    )

    return Response({
        'access': str(access),
        'user': {
            'id': alvo.id,
            'email': alvo.email,
            'display_name': getattr(getattr(alvo, 'store', None), 'name', '') or alvo.email,
        },
        'expires_in_minutes': 30,
        'aviso': 'Sessão de suporte. O acesso fica registrado.',
    })


@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_toggle_block_user(request, user_id):
    """
    POST /api/admin/users/<id>/toggle-block/

    Bloqueia ou libera o acesso de uma consultora (`is_active` do Django).
    Uma conta inativa não consegue autenticar.

    ⚠️ Antes, o botão de bloquear no painel só mudava a tela: nada era enviado
    ao servidor. O admin acreditava ter bloqueado alguém que continuava
    entrando normalmente.
    """
    from django.contrib.auth import get_user_model
    User = get_user_model()

    try:
        alvo = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return Response({'error': 'Usuário não encontrado'}, status=404)

    if alvo.is_staff or alvo.is_superuser:
        return Response(
            {'error': 'Não é possível bloquear um administrador.'}, status=403
        )

    alvo.is_active = not alvo.is_active
    alvo.save(update_fields=['is_active'])

    logger.warning(
        f"[{'DESBLOQUEIO' if alvo.is_active else 'BLOQUEIO'}] "
        f"{request.user.email} alterou o acesso de {alvo.email}"
    )

    return Response({
        'user_id': alvo.id,
        'email': alvo.email,
        'is_active': alvo.is_active,
        'status': 'liberado' if alvo.is_active else 'bloqueado',
    })

# ─────────────────────────────────────────────────────────────
# 📇 CRM — VISÃO AGREGADA (SEM DADOS DE TERCEIROS)
# ─────────────────────────────────────────────────────────────
# ⚠️ LIMITE FIRME DE LGPD: os clientes finais capturados na vitrine NUNCA
# deram nenhum aceite com o Minha Amora — o consentimento deles é com a
# CONSULTORA, não com a plataforma. Do ponto de vista da plataforma, esses
# clientes são TERCEIROS de uma relação da qual ela não faz parte.
#
# Por isso este endpoint NUNCA devolve nome, telefone, e-mail, data de
# nascimento ou qualquer histórico individual de compra — só CONTAGENS e
# MÉDIAS por loja. Se um dia sentir falta de um número aqui, o teste é
# simples: "dá pra eu identificar UMA pessoa a partir disto?" Se sim, não
# entra.

@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_crm_overview(request):
    """
    GET /api/admin/analytics/crm/ — quantos leads cada loja capturou na
    vitrine, taxa de opt-in, ticket médio e recorrência — agregado, sem
    identificar ninguém.
    """
    linhas = []
    for store in Store.objects.select_related('owner').all():
        leads = Lead.objects.filter(store=store)
        total_leads = leads.count()
        if total_leads == 0:
            continue  # loja sem nenhum lead não entra na lista

        opt_in = leads.filter(whatsapp_opt_in=True).count()
        recorrentes = leads.filter(total_orders__gte=2).count()
        ticket_medio = (leads.exclude(total_orders=0)
                         .aggregate(m=Avg('total_spent'))['m']) or 0

        linhas.append({
            'store_id': store.id,
            'store_name': store.name,  # nome da LOJA, não de cliente — ok mostrar
            'total_leads': total_leads,
            'opt_in_rate': round(opt_in / total_leads * 100, 1),
            'clientes_recorrentes': recorrentes,
            'ticket_medio': round(float(ticket_medio), 2),
        })

    linhas.sort(key=lambda x: x['total_leads'], reverse=True)

    return Response({
        'totais': {
            'lojas_com_crm_ativo': len(linhas),
            'leads_capturados': sum(l['total_leads'] for l in linhas),
        },
        'lojas': linhas,
    })

# ─────────────────────────────────────────────────────────────
# ⚙️ CONFIGURAÇÃO GLOBAL (manutenção + feature flags) — de verdade
# ─────────────────────────────────────────────────────────────
# ⚠️ CORREÇÃO GRAVE: "Modo de Manutenção" e "Feature Flags Globais"
# salvavam tudo em localStorage do navegador do PRÓPRIO ADMIN. Não existia
# nenhum endpoint pra isso — o texto "usuários veem tela de manutenção ao
# acessar" nunca foi verdade, porque nada no backend sabia que existia
# manutenção nenhuma. Igual ao que já tínhamos achado com "Salvar
# Promoção": um controle que parecia funcionar, mas não tinha efeito nenhum
# fora do próprio navegador de quem clicou.

@api_view(['PATCH'])
@permission_classes([IsAdminUser])
def update_system_config(request):
    """PATCH /api/admin/system-config/ — liga/desliga manutenção e feature flags globais."""
    cfg = SystemConfig.get_solo()
    data = request.data
    campos = ['maintenance_mode', 'maintenance_message', 'ai_enabled', 'storefront_enabled', 'ocr_enabled', 'whatsapp_suporte', 'email_suporte', 'video_apresentacao_url']
    alterados = []
    for campo in campos:
        if campo in data:
            setattr(cfg, campo, data[campo])
            alterados.append(campo)
    cfg.save()
    return Response({
        'maintenance_mode': cfg.maintenance_mode,
        'maintenance_message': cfg.maintenance_message,
        'ai_enabled': cfg.ai_enabled,
        'storefront_enabled': cfg.storefront_enabled,
        'ocr_enabled': cfg.ocr_enabled,
        'whatsapp_suporte': cfg.whatsapp_suporte,
        'email_suporte': cfg.email_suporte,
        'video_apresentacao_url': cfg.video_apresentacao_url,
        'updated_fields': alterados,
    })

# ─────────────────────────────────────────────────────────────
# 💰 PLANOS DE API (Fase 4) — mesmo padrão do plan-configs das consultoras
# ─────────────────────────────────────────────────────────────

def _serialize_api_plan_config(c):
    return {
        'plan_type': c.plan_type,
        'display_name': c.display_name,
        'monthly_price': float(c.monthly_price),
        'yearly_price': float(c.yearly_price),
        'monthly_quota': c.monthly_quota,
        'rate_limit': c.rate_limit,
        'is_visible': c.is_visible,
    }


@api_view(['GET'])
@permission_classes([IsAdminUser])
def list_api_plan_configs(request):
    """GET /api/admin/api-plan-configs/"""
    from apps.developers.models import ApiPlanConfig
    configs = ApiPlanConfig.objects.all().order_by('monthly_price')
    return Response([_serialize_api_plan_config(c) for c in configs])


@api_view(['PATCH'])
@permission_classes([IsAdminUser])
def update_api_plan_config(request, plan_type):
    """
    PATCH /api/admin/api-plan-configs/<plan_type>/

    Mesmo elo que update_plan_config já tem pras consultoras: mudar
    monthly_price/yearly_price aqui reflete direto no checkout
    (asaas_service.create_developer_payment_link) e em /api/pricing.
    """
    from apps.developers.models import ApiPlanConfig
    config = ApiPlanConfig.objects.filter(plan_type=plan_type).first()
    if not config:
        return Response({'error': f"Plano de API '{plan_type}' não encontrado."}, status=404)

    editable_decimal = {'monthly_price', 'yearly_price'}
    editable_int = {'monthly_quota', 'rate_limit'}
    editable_bool = {'is_visible'}
    editable_str = {'display_name'}

    data = request.data or {}
    errors = {}
    for field, value in data.items():
        try:
            if field in editable_decimal:
                setattr(config, field, Decimal(str(value)))
            elif field in editable_int:
                setattr(config, field, int(value))
            elif field in editable_bool:
                setattr(config, field, bool(value))
            elif field in editable_str:
                setattr(config, field, str(value)[:50])
            # campos fora dessas listas são ignorados silenciosamente —
            # mesma postura de segurança do update_plan_config.
        except (ValueError, TypeError):
            errors[field] = 'Valor inválido'

    if errors:
        return Response({'error': 'Campos inválidos', 'details': errors}, status=400)

    config.save()
    return Response(_serialize_api_plan_config(config))

# ─────────────────────────────────────────────────────────────
# 💬 SUPORTE — conversas escaladas e vídeos tutoriais
# ─────────────────────────────────────────────────────────────

def _serialize_support_conversation(conv, com_mensagens=False):
    dados = {
        'id': str(conv.id),
        'store_id': conv.store_id,
        'store_name': conv.store.name,
        'store_owner_email': conv.store.owner.email if conv.store.owner_id else None,
        'category': conv.category,
        'status': conv.status,
        'subject': conv.subject,
        'created_at': conv.created_at.isoformat(),
        'updated_at': conv.updated_at.isoformat(),
    }
    if com_mensagens:
        dados['messages'] = [
            {'id': m.id, 'sender': m.sender, 'content': m.content, 'created_at': m.created_at.isoformat()}
            for m in conv.messages.all()
        ]
    return dados


@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_support_conversations(request):
    """
    GET /api/admin/support/conversations/?status=escalated

    Sem filtro, devolve tudo — o frontend do admin decide o que mostrar
    por padrão (normalmente "escalated" primeiro).
    """
    from ai.models import SupportConversation
    conversas = SupportConversation.objects.select_related('store', 'store__owner').all()
    filtro_status = request.GET.get('status')
    if filtro_status:
        conversas = conversas.filter(status=filtro_status)
    return Response([_serialize_support_conversation(c) for c in conversas])


@api_view(['GET', 'POST', 'PATCH'])
@permission_classes([IsAdminUser])
def admin_support_conversation_detail(request, conversation_id):
    from ai.models import SupportConversation, SupportMessage
    conv = SupportConversation.objects.select_related('store', 'store__owner').filter(id=conversation_id).first()
    if not conv:
        return Response({'error': 'Conversa não encontrada.'}, status=404)

    if request.method == 'GET':
        return Response(_serialize_support_conversation(conv, com_mensagens=True))

    if request.method == 'POST':
        # Responder — a equipe assumiu a conversa.
        mensagem = (request.data.get('message') or '').strip()
        if not mensagem:
            return Response({'error': 'Mensagem não pode ser vazia.'}, status=400)
        SupportMessage.objects.create(conversation=conv, sender='admin', content=mensagem)
        # Continua "escalated" até alguém marcar como resolvida — responder
        # não fecha a conversa sozinho, a consultora pode responder de volta.
        conv.save(update_fields=['updated_at'])
        conv.refresh_from_db()
        return Response(_serialize_support_conversation(conv, com_mensagens=True))

    # PATCH — mudar status (resolver/encerrar)
    novo_status = request.data.get('status')
    if novo_status not in dict(SupportConversation.STATUS_CHOICES):
        return Response({'error': 'status inválido.'}, status=400)
    conv.status = novo_status
    conv.save(update_fields=['status', 'updated_at'])
    return Response(_serialize_support_conversation(conv))


# ─────────────────────────────────────────────────────────────
# 🎬 VÍDEOS TUTORIAIS
# ─────────────────────────────────────────────────────────────

def _serialize_video(v):
    return {
        'id': v.id, 'title': v.title, 'description': v.description,
        'video_url': v.video_url, 'category': v.category,
        'sort_order': v.sort_order, 'is_visible': v.is_visible,
        'created_at': v.created_at.isoformat(),
    }


@api_view(['GET', 'POST'])
@permission_classes([IsAdminUser])
def admin_tutorial_videos(request):
    from ai.models import TutorialVideo
    if request.method == 'GET':
        videos = TutorialVideo.objects.all()
        return Response([_serialize_video(v) for v in videos])

    title = (request.data.get('title') or '').strip()
    video_url = (request.data.get('video_url') or '').strip()
    if not title or not video_url:
        return Response({'error': 'title e video_url são obrigatórios.'}, status=400)

    video = TutorialVideo.objects.create(
        title=title[:150],
        description=(request.data.get('description') or '')[:2000],
        video_url=video_url,
        category=(request.data.get('category') or '')[:50],
        sort_order=int(request.data.get('sort_order') or 0),
        is_visible=bool(request.data.get('is_visible', True)),
    )
    return Response(_serialize_video(video), status=201)


@api_view(['PATCH', 'DELETE'])
@permission_classes([IsAdminUser])
def admin_tutorial_video_detail(request, video_id):
    from ai.models import TutorialVideo
    video = TutorialVideo.objects.filter(id=video_id).first()
    if not video:
        return Response({'error': 'Vídeo não encontrado.'}, status=404)

    if request.method == 'DELETE':
        video.delete()
        return Response(status=204)

    campos = ['title', 'description', 'video_url', 'category', 'sort_order', 'is_visible']
    for campo in campos:
        if campo in request.data:
            setattr(video, campo, request.data[campo])
    video.save()
    return Response(_serialize_video(video))

# ─────────────────────────────────────────────────────────────
# 📚 CENTRAL DE AJUDA (HelpContent) — evolução do CRUD de vídeos.
# Etapa 1: só a camada de conteúdo/admin. O endpoint de consumo
# (GET /api/ajuda/) e as telas da consultora vêm na Etapa 2.
# ─────────────────────────────────────────────────────────────

def _serialize_help_content(c):
    return {
        'id': c.id,
        'tipo': c.tipo,
        'titulo': c.titulo,
        'corpo': c.corpo,
        'video_url': c.video_url,
        'categoria': c.categoria,
        'status': c.status,
        'ordem': c.ordem,
        'created_at': c.created_at.isoformat(),
        'updated_at': c.updated_at.isoformat(),
    }


def _validar_help_content(dados, tipo):
    """
    Regra de obrigatoriedade por tipo, centralizada aqui — o model não
    força isso (blank=True em ambos) porque o Django não valida
    condicionalmente por outro campo sem custom clean(), e a view é o
    lugar mais direto pra essa regra específica.
    """
    from ai.models import HelpContent
    if tipo not in dict(HelpContent.TIPO_CHOICES):
        return f"tipo precisa ser um de: {', '.join(dict(HelpContent.TIPO_CHOICES))}."
    if tipo == 'video' and not (dados.get('video_url') or '').strip():
        return "video_url é obrigatório pra tipo='video'."
    if tipo in ('faq', 'guia', 'novidade') and not (dados.get('corpo') or '').strip():
        return f"corpo é obrigatório pra tipo='{tipo}'."
    return None


@api_view(['GET', 'POST'])
@permission_classes([IsAdminUser])
def admin_help_content_list_create(request):
    from ai.models import HelpContent

    if request.method == 'GET':
        itens = HelpContent.objects.all()
        # Mesmos três filtros do endpoint de consumo (Etapa 2) — já deixo
        # aqui porque a lista do admin também precisa filtrar por tipo/
        # categoria/status, só que sem o default status=visivel (o admin
        # PRECISA ver rascunho, é o ponto de gerenciar isso).
        tipo = request.GET.get('tipo')
        categoria = request.GET.get('categoria')
        status_filtro = request.GET.get('status')
        if tipo:
            itens = itens.filter(tipo=tipo)
        if categoria:
            itens = itens.filter(categoria=categoria)
        if status_filtro:
            itens = itens.filter(status=status_filtro)
        return Response([_serialize_help_content(c) for c in itens])

    titulo = (request.data.get('titulo') or '').strip()
    tipo = request.data.get('tipo')
    if not titulo:
        return Response({'error': 'titulo é obrigatório.'}, status=400)

    erro = _validar_help_content(request.data, tipo)
    if erro:
        return Response({'error': erro}, status=400)

    item = HelpContent.objects.create(
        tipo=tipo,
        titulo=titulo[:150],
        corpo=(request.data.get('corpo') or ''),
        video_url=(request.data.get('video_url') or None),
        categoria=(request.data.get('categoria') or '')[:50],
        status=request.data.get('status') or 'rascunho',
        ordem=int(request.data.get('ordem') or 0),
    )
    return Response(_serialize_help_content(item), status=201)


@api_view(['PATCH', 'DELETE'])
@permission_classes([IsAdminUser])
def admin_help_content_detail(request, content_id):
    from ai.models import HelpContent
    item = HelpContent.objects.filter(id=content_id).first()
    if not item:
        return Response({'error': 'Conteúdo não encontrado.'}, status=404)

    if request.method == 'DELETE':
        item.delete()
        return Response(status=204)

    # PATCH — valida com o tipo FINAL (o que já está salvo, a menos que
    # esta própria requisição esteja mudando o tipo também).
    tipo_final = request.data.get('tipo', item.tipo)
    dados_para_validar = {**_serialize_help_content(item), **request.data}
    erro = _validar_help_content(dados_para_validar, tipo_final)
    if erro:
        return Response({'error': erro}, status=400)

    campos = ['tipo', 'titulo', 'corpo', 'video_url', 'categoria', 'status', 'ordem']
    for campo in campos:
        if campo in request.data:
            setattr(item, campo, request.data[campo])
    item.save()
    return Response(_serialize_help_content(item))

# ─────────────────────────────────────────────────────────────
# 📦 REVISÃO DE CANDIDATOS DE CÓDIGO DE BARRAS (ExternalBarcodeCatalog)
#
# O cosmos_barcode_finder só grava sozinho no Product quando a confiança é
# muito alta (correção anterior). Tudo abaixo disso (high/medium/low) fica
# parado aqui, esperando alguém confirmar — é exatamente essa fila que
# esta tela existe pra esvaziar, sem precisar abrir o banco na mão.
# ─────────────────────────────────────────────────────────────

def _serialize_barcode_candidate(c):
    from inventory.models import Product
    ja_tem_barcode = Product.objects.filter(bar_code=c.gtin).exists()
    return {
        'id': c.id,
        'gtin': c.gtin,
        'brand': c.brand,
        'description': c.description,
        'confidence_level': c.confidence_level,
        'searched_product_sku': c.searched_product_sku,
        'searched_product_name': c.searched_product_name,
        'search_term_used': c.search_term_used,
        'matched': c.matched,
        'created_at': c.created_at.isoformat(),
        'ja_aplicado': ja_tem_barcode,
    }


@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_barcode_candidates(request):
    """
    GET /api/admin/barcode-candidates/?brand=&confidence=
    Lista candidatos que ainda não foram aplicados a nenhum Product — a
    fila de revisão. Por padrão exclui os de confiança muito alta (esses
    já foram aplicados automaticamente, não sobra nada pra revisar ali) e
    exclui os já descartados.
    """
    from inventory.models import ExternalBarcodeCatalog, Product

    candidatos = ExternalBarcodeCatalog.objects.filter(matched=True).exclude(
        confidence_level='very_high'
    ).exclude(
        confidence_level__startswith='alternative_'
    ).order_by('-created_at')

    brand = request.GET.get('brand')
    confidence = request.GET.get('confidence')
    if brand:
        candidatos = candidatos.filter(brand__iexact=brand)
    if confidence:
        candidatos = candidatos.filter(confidence_level=confidence)

    # Não mostra de novo o que já foi aprovado antes (já virou bar_code
    # de algum Product) — evita a mesma linha aparecer pra sempre na fila.
    gtins_ja_aplicados = set(
        Product.objects.filter(bar_code__in=candidatos.values_list('gtin', flat=True))
        .values_list('bar_code', flat=True)
    )
    candidatos = [c for c in candidatos[:200] if c.gtin not in gtins_ja_aplicados]

    return Response([_serialize_barcode_candidate(c) for c in candidatos])


@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_barcode_candidate_approve(request, candidate_id):
    """
    POST /api/admin/barcode-candidates/<id>/approve/
    Confirma manualmente: aplica o GTIN candidato ao Product correspondente
    (achado pelo SKU que o crawler já vinculou na busca), sem sobrescrever
    se o produto já tiver código de barras de outra fonte.
    """
    from inventory.models import ExternalBarcodeCatalog, Product

    candidato = ExternalBarcodeCatalog.objects.filter(id=candidate_id).first()
    if not candidato:
        return Response({'error': 'Candidato não encontrado.'}, status=404)

    produto = None
    if candidato.searched_product_sku:
        produto = Product.objects.filter(natura_sku=candidato.searched_product_sku).first()

    if not produto:
        return Response({'error': 'Não achei o produto original vinculado a este candidato — verifique manualmente.'}, status=400)

    if produto.bar_code and produto.bar_code != candidato.gtin:
        return Response({'error': f'Este produto já tem outro código de barras ({produto.bar_code}). Recuse este candidato se estiver errado, ou remova o código atual primeiro.'}, status=409)

    produto.bar_code = candidato.gtin
    produto.save(update_fields=['bar_code'])
    return Response({'aprovado': True, 'produto': produto.name, 'gtin': candidato.gtin})


@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_barcode_candidate_reject(request, candidate_id):
    """
    POST /api/admin/barcode-candidates/<id>/reject/
    Descarta o candidato — some da fila de revisão, sem tocar em nenhum
    Product. Não apaga o registro (mantém como histórico do que já foi
    olhado e recusado), só marca como não-confirmado.
    """
    from inventory.models import ExternalBarcodeCatalog

    candidato = ExternalBarcodeCatalog.objects.filter(id=candidate_id).first()
    if not candidato:
        return Response({'error': 'Candidato não encontrado.'}, status=404)

    candidato.matched = False
    candidato.save(update_fields=['matched'])
    return Response({'recusado': True})

# ─────────────────────────────────────────────────────────────
# 🎁 CÓDIGOS DE INDICAÇÃO — não é programa aberto ao público, é
# individual: cada código é gerado pra uma pessoa específica que foi
# convidada pessoalmente (ex: uma líder de grupo). Essa tela substitui
# rodar o comando `criar_codigo_indicacao` direto no terminal.
# ─────────────────────────────────────────────────────────────

def _gerar_codigo_legivel(nome: str) -> str:
    import secrets, string, unicodedata
    # ⚠️ Remove acento antes de gerar — nome como "José" ou "Simões" não
    # pode virar um código com acento, difícil de digitar certo depois.
    nome_sem_acento = unicodedata.normalize('NFKD', nome).encode('ascii', 'ignore').decode('ascii')
    base = "".join(c for c in nome_sem_acento.upper() if c.isalpha())[:6] or "AMIGA"
    sufixo = "".join(secrets.choice(string.digits) for _ in range(3))
    return f"{base}{sufixo}"


def _serialize_referral_code(ref):
    return {
        'id': ref.id,
        'code': ref.code,
        'label': ref.label,
        'referrer_store_id': ref.referrer_store_id,
        'referrer_store_name': ref.referrer_store.name if ref.referrer_store else None,
        'referrer_store_email': ref.referrer_store.owner.email if ref.referrer_store else None,
        'bonus_trial_days': ref.bonus_trial_days,
        'referrer_bonus_days': ref.referrer_bonus_days,
        'max_uses': ref.max_uses,
        'times_used': ref.times_used,
        'esgotado': ref.esgotado,
        'active': ref.active,
        'created_at': ref.created_at.isoformat(),
    }


@api_view(['GET', 'POST'])
@permission_classes([IsAdminUser])
def admin_referral_codes(request):
    """
    GET  /api/admin/referral-codes/  — lista todos os códigos, com uso.
    POST /api/admin/referral-codes/  — cria um código novo, mesma lógica
    do comando `criar_codigo_indicacao`, só que pela tela.

    Corpo esperado no POST:
        {
            "nome": "Maria Líder",
            "indicado_por_email": "esposa@exemplo.com",  (opcional)
            "dias_teste": 30,
            "dias_bonus_indicadora": 7,
            "limite_usos": 1
        }
    """
    from inventory.models import ReferralCode, Store

    if request.method == 'GET':
        codigos = ReferralCode.objects.select_related('referrer_store', 'referrer_store__owner').order_by('-created_at')
        return Response([_serialize_referral_code(r) for r in codigos])

    # POST
    nome = (request.data.get('nome') or '').strip()
    if not nome:
        return Response({'error': 'Nome é obrigatório.'}, status=400)

    email_indicadora = (request.data.get('indicado_por_email') or '').strip()
    loja_indicadora = None
    if email_indicadora:
        loja_indicadora = Store.objects.filter(owner__email__iexact=email_indicadora).first()
        if not loja_indicadora:
            return Response({'error': f'Nenhuma loja encontrada com o e-mail "{email_indicadora}".'}, status=400)

    dias_teste = int(request.data.get('dias_teste') or 30)
    dias_bonus = int(request.data.get('dias_bonus_indicadora') or 7)
    limite_usos = request.data.get('limite_usos')
    limite_usos = int(limite_usos) if limite_usos not in (None, '') else 1

    codigo = _gerar_codigo_legivel(nome)
    while ReferralCode.objects.filter(code=codigo).exists():
        codigo = _gerar_codigo_legivel(nome)

    ref = ReferralCode.objects.create(
        code=codigo,
        label=nome,
        referrer_store=loja_indicadora,
        bonus_trial_days=dias_teste,
        referrer_bonus_days=dias_bonus,
        max_uses=limite_usos,
    )
    return Response(_serialize_referral_code(ref), status=201)


@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_referral_code_toggle(request, code_id):
    """
    POST /api/admin/referral-codes/<id>/toggle/
    Ativa/desativa um código — em vez de apagar (mantém o histórico de
    uso intacto, só impede novos usos).
    """
    from inventory.models import ReferralCode

    ref = ReferralCode.objects.filter(id=code_id).first()
    if not ref:
        return Response({'error': 'Código não encontrado.'}, status=404)

    ref.active = not ref.active
    ref.save(update_fields=['active'])
    return Response(_serialize_referral_code(ref))

# ─────────────────────────────────────────────────────────────
# 📬 CONTATO — e-mail (envio real) e WhatsApp (link pronto, envio
# manual). Não é plataforma de disparo em massa automatizada — é uma
# ferramenta pra Igor contatar as usuárias atuais sem precisar caçar
# número/e-mail um por um nem digitar a mensagem toda vez.
# ─────────────────────────────────────────────────────────────

def _status_contato(store):
    from inventory.models import EmailEnviado, WhatsappContatoMarcado
    emails_enviados = set(EmailEnviado.objects.filter(store=store).values_list('template', flat=True))
    whats_marcados = set(WhatsappContatoMarcado.objects.filter(store=store).values_list('template', flat=True))
    return {'email_enviado': list(emails_enviados), 'whatsapp_marcado': list(whats_marcados)}


@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_templates_listar(request):
    """
    GET /api/admin/templates/
    Lista os modelos disponíveis (nome + rótulo), pra tela montar o
    seletor de "carregar modelo" sem precisar saber o conteúdo de cada
    um — o conteúdo só é resolvido quando a pessoa escolhe um, via
    admin_contatos_renderizar_modelo.
    """
    from inventory.email_templates import TEMPLATES as EMAIL_TEMPLATES
    from inventory.whatsapp_templates import TEMPLATES as WA_TEMPLATES

    return Response({
        'email': [{'value': k, 'label': v['assunto']} for k, v in EMAIL_TEMPLATES.items()],
        'whatsapp': [{'value': k, 'label': k.replace('_', ' ').title()} for k in WA_TEMPLATES.keys()],
    })


@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_contatos_renderizar_modelo(request):
    """
    GET /api/admin/contatos/renderizar-modelo/?tipo=email&template=checkin&store_id=N
    Resolve o modelo (nome da pessoa, campo faltando) em texto de
    verdade — a tela usa isso só pra PREENCHER o campo editável, a
    pessoa pode mudar tudo antes de mandar. Nunca manda nada sozinho.
    """
    from inventory.models import Store
    from inventory.contato_utils import campos_faltando, nome_para_saudacao

    tipo = request.query_params.get('tipo')
    template_key = request.query_params.get('template')
    store_id = request.query_params.get('store_id')

    store = Store.objects.filter(id=store_id, owner__isnull=False).select_related('owner').first()
    if not store:
        return Response({'error': 'Loja não encontrada.'}, status=404)

    nome = nome_para_saudacao(store)
    extras = {"campos": " e ".join(campos_faltando(store))} if template_key == "completar_perfil" else {}

    if tipo == 'email':
        from inventory.email_templates import TEMPLATES as EMAIL_TEMPLATES
        if template_key not in EMAIL_TEMPLATES:
            return Response({'error': f'Modelo "{template_key}" não existe.'}, status=400)
        t = EMAIL_TEMPLATES[template_key]
        return Response({
            'assunto': t['assunto'],
            'corpo_texto': t['corpo_texto'].format(nome=nome, **extras),
        })
    elif tipo == 'whatsapp':
        from inventory.whatsapp_templates import TEMPLATES as WA_TEMPLATES
        if template_key not in WA_TEMPLATES:
            return Response({'error': f'Modelo "{template_key}" não existe.'}, status=400)
        return Response({'texto': WA_TEMPLATES[template_key].format(nome=nome, **extras)})
    else:
        return Response({'error': 'tipo deve ser "email" ou "whatsapp".'}, status=400)


@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_contatos_historico(request):
    """
    GET /api/admin/contatos/historico/?store_id=N
    Histórico de tudo que já foi mandado/marcado pra essa loja — e-mail
    de verdade enviado e WhatsApp confirmado manualmente, mais recente
    primeiro.
    """
    from inventory.models import Store, EmailEnviado, WhatsappContatoMarcado

    store_id = request.query_params.get('store_id')
    store = Store.objects.filter(id=store_id, owner__isnull=False).first()
    if not store:
        return Response({'error': 'Loja não encontrada.'}, status=404)

    emails = [
        {'canal': 'email', 'assunto': e.assunto, 'texto': e.corpo, 'quando': e.enviado_em.isoformat()}
        for e in store.emails_enviados.all()
    ]
    whats = [
        {'canal': 'whatsapp', 'assunto': None, 'texto': w.texto, 'quando': w.marcado_em.isoformat()}
        for w in store.whatsapp_marcados.all()
    ]
    historico = sorted(emails + whats, key=lambda x: x['quando'], reverse=True)
    return Response(historico)


@api_view(['GET'])
@permission_classes([IsAdminUser])
def admin_pagamentos_loja(request):
    """
    GET /api/admin/pagamentos-loja/?store_id=N
    Histórico de pagamento REAL — não estimativa. Usa
    ProcessedPaymentEvent (já alimentado pelo webhook do Asaas com o
    valor de verdade pago) pra responder: quando foi o último
    pagamento, quanto já pagou no total, e se está com a assinatura
    vencida sem renovar (o jeito mais direto de responder "está devendo").
    """
    from inventory.models import Store, ProcessedPaymentEvent
    from django.utils import timezone
    from django.db.models import Sum

    store_id = request.query_params.get('store_id')
    store = Store.objects.filter(id=store_id, owner__isnull=False).first()
    if not store:
        return Response({'error': 'Loja não encontrada.'}, status=404)

    pagamentos = ProcessedPaymentEvent.objects.filter(store=store).order_by('-processed_at')
    ultimo = pagamentos.first()
    total_pago = pagamentos.aggregate(soma=Sum('value'))['soma'] or 0

    # ⚠️ "Está devendo" = tem plano PRO, mas a data de expiração já
    # passou sem renovar — sinal direto, sem tentar reconstruir mês a
    # mês (ficaria complexo demais sem ganho real de precisão).
    vencida = bool(
        store.plan == 'pro' and store.subscription_expires_at and store.subscription_expires_at < timezone.now()
    )

    return Response({
        'ultimo_pagamento': {
            'data': ultimo.processed_at.isoformat(),
            'valor': float(ultimo.value) if ultimo.value else None,
            'forma': ultimo.billing_type,
        } if ultimo else None,
        'total_pago': float(total_pago),
        'quantidade_pagamentos': pagamentos.count(),
        'assinatura_vencida': vencida,
        'subscription_expires_at': store.subscription_expires_at.isoformat() if store.subscription_expires_at else None,
    })


@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_contatos_enviar_email(request):
    """
    POST /api/admin/contatos/enviar-email/
    Manda o e-mail de verdade, com o texto que vier — carregado de um
    modelo, editado, ou escrito do zero, tanto faz. Corpo esperado:
    {"store_id": N, "assunto": "...", "corpo_texto": "...",
     "corpo_html": "..." (opcional), "template": "checkin" (opcional,
     só pra registro histórico de qual modelo serviu de base)}
    """
    from django.core.mail import send_mail
    from django.conf import settings as django_settings
    from inventory.models import Store, EmailEnviado

    store_id = request.data.get('store_id')
    assunto = (request.data.get('assunto') or '').strip()
    corpo_texto = (request.data.get('corpo_texto') or '').strip()
    corpo_html = request.data.get('corpo_html')
    template_usado = request.data.get('template', '')

    if not assunto or not corpo_texto:
        return Response({'error': 'Assunto e corpo do e-mail são obrigatórios.'}, status=400)

    store = Store.objects.filter(id=store_id, owner__isnull=False).select_related('owner').first()
    if not store:
        return Response({'error': 'Loja não encontrada.'}, status=404)

    # ⚠️ CORREÇÃO: send_mail sem captura — se EMAIL_HOST estiver mal
    # configurado (ou faltando) no Render, a exceção subia crua até
    # virar um 500 sem explicação nenhuma no frontend. Agora devolve o
    # motivo real, pra dar pra saber se é senha errada, host errado, etc.
    try:
        send_mail(
            subject=assunto,
            message=corpo_texto,
            from_email=django_settings.DEFAULT_FROM_EMAIL,
            recipient_list=[store.owner.email],
            html_message=corpo_html or None,
            fail_silently=False,
        )
    except Exception as e:
        return Response({
            'error': f'Não deu pra mandar o e-mail — {e}',
            'dica': 'Confira EMAIL_HOST, EMAIL_HOST_USER e EMAIL_HOST_PASSWORD nas variáveis de ambiente do Render.',
        }, status=502)

    EmailEnviado.objects.create(store=store, template=template_usado, assunto=assunto, corpo=corpo_texto)
    return Response({'enviado': True, 'status': _status_contato(store)})


@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_contatos_link_whatsapp(request):
    """
    POST /api/admin/contatos/whatsapp-link/
    Monta o link do wa.me com o texto que vier — carregado de modelo,
    editado ou livre, tanto faz. Só monta o link, não marca nada como
    enviado (isso é a admin_contatos_marcar_whatsapp, separado).
    Corpo esperado: {"store_id": N, "texto": "..."}
    """
    import urllib.parse
    from inventory.models import Store

    store_id = request.data.get('store_id')
    texto = (request.data.get('texto') or '').strip()

    if not texto:
        return Response({'error': 'O texto da mensagem não pode ficar vazio.'}, status=400)

    store = Store.objects.filter(id=store_id, owner__isnull=False).select_related('owner').first()
    if not store:
        return Response({'error': 'Loja não encontrada.'}, status=404)

    if not store.whatsapp:
        return Response({'error': 'Essa loja não tem WhatsApp cadastrado.'}, status=400)

    numero = "".join(c for c in store.whatsapp if c.isdigit())
    link = f"https://wa.me/{numero}?text={urllib.parse.quote(texto)}"
    return Response({'link': link})


@api_view(['POST'])
@permission_classes([IsAdminUser])
def admin_contatos_marcar_whatsapp(request):
    """
    POST /api/admin/contatos/marcar-whatsapp/
    Igor confirma manualmente que mandou de verdade (depois de clicar no
    link e apertar enviar lá no WhatsApp) — sem isso, o sistema não tem
    como saber sozinho que a mensagem foi enviada. Guarda o texto real
    usado, pra aparecer certo no histórico.
    Corpo esperado: {"store_id": N, "texto": "...", "template": "checkin" (opcional)}
    """
    from inventory.models import Store, WhatsappContatoMarcado

    store_id = request.data.get('store_id')
    texto = (request.data.get('texto') or '').strip()
    template_usado = request.data.get('template', '')

    store = Store.objects.filter(id=store_id, owner__isnull=False).first()
    if not store:
        return Response({'error': 'Loja não encontrada.'}, status=404)

    WhatsappContatoMarcado.objects.create(store=store, template=template_usado, texto=texto)
    return Response({'marcado': True, 'status': _status_contato(store)})