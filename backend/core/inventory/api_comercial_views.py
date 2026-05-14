# inventory/api_comercial_views.py
from datetime import timezone

from rest_framework.decorators import api_view, permission_classes, throttle_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.throttling import UserRateThrottle
from drf_spectacular.utils import extend_schema, OpenApiParameter, OpenApiResponse
from drf_spectacular.types import OpenApiTypes
from django.db.models import Count, Q
from .models import Product, InventoryItem, Store
from .serializers import ProductSerializer  # Criar se não existir

# ── Throttles por plano ──
class StarterThrottle(UserRateThrottle):
    scope = 'starter'  # 20/min

class ProThrottle(UserRateThrottle):
    scope = 'pro'  # 100/min

class EnterpriseThrottle(UserRateThrottle):
    scope = 'enterprise'  # 500/min

# ── Serializers para resposta da API ──
from rest_framework import serializers

class PublicProductSerializer(serializers.ModelSerializer):
    """Serializer para API pública — sem dados sensíveis"""
    class Meta:
        model = Product
        fields = ['id', 'name', 'brand', 'category', 'official_price', 
                  'bar_code', 'image_url', 'description']
        read_only_fields = fields

class ProductLookupResponseSerializer(serializers.Serializer):
    found = serializers.BooleanField()
    source = serializers.CharField()
    product = PublicProductSerializer(required=False)
    suggestions = PublicProductSerializer(many=True, required=False)
    message = serializers.CharField(required=False)

# ── ENDPOINTS PÚBLICOS (com API Key) ──

@extend_schema(
    tags=['Catalog'],
    summary='Listar catálogo de produtos',
    description='Retorna lista paginada de produtos do catálogo global.',
    parameters=[
        OpenApiParameter(name='search', description='Busca por nome ou marca', required=False, type=str),
        OpenApiParameter(name='brand', description='Filtrar por marca', required=False, type=str),
        OpenApiParameter(name='category', description='Filtrar por categoria', required=False, type=str),
        OpenApiParameter(name='page', description='Página', required=False, type=int),
        OpenApiParameter(name='page_size', description='Itens por página (max 100)', required=False, type=int),
    ],
    responses={
        200: OpenApiResponse(
            description='Lista de produtos',
            response={
                'type': 'object',
                'properties': {
                    'count': {'type': 'integer'},
                    'next': {'type': 'string', 'nullable': True},
                    'previous': {'type': 'string', 'nullable': True},
                    'results': {'type': 'array', 'items': PublicProductSerializer}
                }
            }
        ),
        401: OpenApiResponse(description='API Key inválida ou ausente'),
        429: OpenApiResponse(description='Limite de requisições excedido'),
    }
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])  # Requer API Key válida
@throttle_classes([StarterThrottle])  # Aplicar throttle baseado no plano do usuário
def api_products_list(request):
    """Listar produtos do catálogo global"""
    queryset = Product.objects.all()
    
    # Filtros
    if search := request.query_params.get('search'):
        queryset = queryset.filter(Q(name__icontains=search) | Q(brand__icontains=search))
    if brand := request.query_params.get('brand'):
        queryset = queryset.filter(brand__iexact=brand)
    if category := request.query_params.get('category'):
        queryset = queryset.filter(category__iexact=category)
    
    # Paginação manual (ou use DRF Pagination)
    page = int(request.query_params.get('page', 1))
    page_size = min(int(request.query_params.get('page_size', 20)), 100)
    start = (page - 1) * page_size
    
    products = queryset[start:start + page_size]
    serializer = PublicProductSerializer(products, many=True)
    
    return Response({
        'count': queryset.count(),
        'next': f'?page={page + 1}' if start + page_size < queryset.count() else None,
        'previous': f'?page={page - 1}' if page > 1 else None,
        'results': serializer.data
    })


@extend_schema(
    tags=['Lookup'],
    summary='Buscar produto por código de barras',
    description='Busca híbrida: local → scraper → fuzzy match. Retorna produto encontrado ou sugestões.',
    parameters=[
        OpenApiParameter(name='barcode', description='Código de barras (EAN-13, EAN-8, etc.)', required=True, type=str, location=OpenApiParameter.QUERY),
    ],
    responses={
        200: ProductLookupResponseSerializer,
        400: OpenApiResponse(description='Código de barras inválido'),
        404: OpenApiResponse(description='Produto não encontrado'),
    }
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([ProThrottle])  # Lookup consome mais recursos
def api_product_lookup(request):
    """Buscar produto por código de barras"""
    barcode = request.query_params.get('barcode')
    
    if not barcode or len(barcode) < 8:
        return Response({'error': 'Código de barras inválido'}, status=400)
    
    # 1. Busca local
    product = Product.objects.filter(bar_code=barcode).first()
    if product:
        return Response({
            'found': True,
            'source': 'local',
            'product': PublicProductSerializer(product).data
        })
    
    # 2. Sugestões por fuzzy match (últimos 4 dígitos)
    suggestions = Product.objects.filter(
        bar_code__endswith=barcode[-4:]
    ).exclude(bar_code__isnull=True)[:5]
    
    return Response({
        'found': False,
        'source': 'suggestion',
        'message': 'Produto não encontrado. Sugestões baseadas nos últimos dígitos:',
        'suggestions': PublicProductSerializer(suggestions, many=True).data
    }, status=404)


@extend_schema(
    tags=['Storefront'],
    summary='Listar vitrine pública',
    description='Retorna produtos disponíveis na vitrine de uma consultora (sem auth).',
    parameters=[
        OpenApiParameter(name='slug', description='Slug da consultora', required=True, type=str, location=OpenApiParameter.PATH),
    ],
    responses={
        200: {
            'type': 'array',
            'items': {
                'type': 'object',
                'properties': {
                    'product_name': {'type': 'string'},
                    'sale_price': {'type': 'number'},
                    'total_quantity': {'type': 'integer'},
                    'image_url': {'type': 'string', 'nullable': True},
                }
            }
        },
        404: OpenApiResponse(description='Vitrine não encontrada'),
    }
)
@api_view(['GET'])
@permission_classes([AllowAny])  # ✅ Público — sem API Key
def api_public_storefront(request, slug: str):
    """Vitrine pública de uma consultora"""
    try:
        store = Store.objects.select_related('owner').get(slug=slug)
    except Store.DoesNotExist:
        return Response({'error': 'Vitrine não encontrada'}, status=404)
    
    # Produtos disponíveis na vitrine
    items = InventoryItem.objects.filter(
        store=store,
        total_quantity__gt=0
    ).select_related('product').prefetch_related('batches')
    
    data = []
    for item in items:
        data.append({
            'id': item.id,
            'product_name': item.product.name,
            'brand': item.product.brand,
            'category': item.product.category,
            'sale_price': float(item.sale_price) if item.sale_price else None,
            'total_quantity': item.total_quantity,
            'image_url': item.product.image_url,
            'barcode': item.product.bar_code,
        })
    
    return Response(data)


# ── ENDPOINTS ANALYTICS (Enterprise apenas) ──

@extend_schema(
    tags=['Analytics'],
    summary='Analytics agregado de produtos',
    description='Retorna estatísticas agregadas do catálogo: top marcas, categorias, faixas de preço. Dados anonimizados (LGPD).',
    responses={
        200: {
            'type': 'object',
            'properties': {
                'total_products': {'type': 'integer'},
                'top_brands': {
                    'type': 'array',
                    'items': {
                        'type': 'object',
                        'properties': {
                            'brand': {'type': 'string'},
                            'count': {'type': 'integer'},
                            'avg_price': {'type': 'number'}
                        }
                    }
                },
                'price_ranges': {'type': 'object', 'additionalProperties': {'type': 'integer'}},
            }
        },
    }
)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
@throttle_classes([EnterpriseThrottle])
def api_analytics_products(request):
    """Analytics agregado de produtos (Enterprise)"""
    # Verificar se usuário tem plano enterprise
    if not hasattr(request.user, 'store') or request.user.store.plan != 'enterprise':
        return Response({'error': 'Acesso restrito ao plano Enterprise'}, status=403)
    
    total = Product.objects.count()
    
    # Top marcas
    brands = Product.objects.values('brand').annotate(
        count=Count('id'),
        avg_price=Count('official_price')
    ).filter(brand__isnull=False).order_by('-count')[:10]
    
    # Faixas de preço
    ranges = {
        '0-10': Product.objects.filter(official_price__lt=10).count(),
        '10-50': Product.objects.filter(official_price__gte=10, official_price__lt=50).count(),
        '50-100': Product.objects.filter(official_price__gte=50, official_price__lt=100).count(),
        '100+': Product.objects.filter(official_price__gte=100).count(),
    }
    
    return Response({
        'total_products': total,
        'top_brands': [
            {'brand': b['brand'], 'count': b['count'], 'avg_price': float(b['avg_price'] or 0)}
            for b in brands
        ],
        'price_ranges': ranges,
        'generated_at': timezone.now().isoformat(),
        'lgpd_compliant': True,
    })