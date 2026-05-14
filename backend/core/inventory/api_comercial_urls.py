# inventory/api_comercial_urls.py
from django.urls import path
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView

# Tenta importar as views da API comercial (se existirem)
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
    # Aviso opcional no console do Render
    print("⚠️ api_comercial_views.py não encontrado. Endpoints da API comercial desativados temporariamente.")

urlpatterns = [
    # Documentação Swagger/OpenAPI
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
]

# Adiciona endpoints apenas se as views existirem
if HAS_COMMERCIAL_VIEWS:
    urlpatterns += [
        path('products/', api_products_list, name='api-products-list'),
        path('products/lookup/', api_product_lookup, name='api-product-lookup'),
        path('public/storefront/<str:slug>/', api_public_storefront, name='api-public-storefront'),
        path('analytics/products/', api_analytics_products, name='api-analytics-products'),
    ]