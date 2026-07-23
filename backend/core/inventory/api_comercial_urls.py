# backend/core/inventory/api_comercial_urls.py
"""
URLs para API Comercial v1 (acesso via API Key)
Estes endpoints são destinados a integrações externas e parceiros comerciais.
"""
from django.urls import path
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView

# Tenta importar as views da API comercial (fallback seguro)
try:
    from .api_comercial_views import (
        api_products_list,
        api_product_lookup,
        api_public_storefront,
        api_analytics_products,
    )
    HAS_COMMERCIAL_VIEWS = True
except ImportError:
    HAS_COMMERCIAL_VIEWS = False
    # Aviso apenas em DEBUG para não poluir logs de produção
    import sys
    if 'runserver' in sys.argv or 'pytest' in sys.argv:
        print("⚠️ api_comercial_views.py não encontrado. Endpoints da API comercial desativados.")

# URLs base: documentação Swagger (sempre disponível)
urlpatterns = [
    # Documentação OpenAPI/Swagger
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
]

# Endpoints da API comercial (apenas se as views existirem)
if HAS_COMMERCIAL_VIEWS:
    urlpatterns += [
        # Catálogo de produtos (leitura)
        path('products/', api_products_list, name='api-products-list'),
        
        # Lookup inteligente por código de barras ou nome
        path('products/lookup/', api_product_lookup, name='api-product-lookup'),
        
        # Vitrine pública de consultoras (acesso por slug)
        path('public/storefront/<str:slug>/', api_public_storefront, name='api-public-storefront'),
        
        # Analytics agregados de produtos (Enterprise)
        path('analytics/products/', api_analytics_products, name='api-analytics-products'),
    ]

# ✅ Metadata para admin Django (opcional)
app_name = 'api_comercial'