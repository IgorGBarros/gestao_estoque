from django.urls import path, include
from rest_framework.routers import DefaultRouter

from backend.core.ai import views

from .admin_views import get_store_behavior_analytics, get_system_stats, list_plan_configs, list_promotions, list_users, update_plan, update_subscription,get_product_analytics,monitor_api_usage 
from .views import (
    CustomUserCreateView,
    FirebaseLoginView,
    ProductViewSet, 
    InventoryViewSet,
    SessionControlView,
    SessionSummaryView,
    apply_fifo_withdrawal,
    associate_user_store,
    cash_flow_detailed,
    cash_flow_summary,
    check_plan_limits_complete,
    debug_user_store,
    export_my_data,
    feature_gates_view,
    get_my_consents,
    inventory_item_batches_view, 
    lookup_product, 
    StockEntryView, 
    SaleCheckoutView,
    CustomTokenObtainPairView,
    StockTransactionViewSet,
    profile_view,
    ThemeConfigAdminView,
    ThemeConfigPublicView,
    public_storefront,
    public_storefront_view,
    dashboard_overview,
    dashboard_financial_summary,       
    dashboard_inventory_analysis,
    dashboard_stats,
    record_consent,
    revoke_consent
    # FirebaseLoginView e CustomUserCreateView foram removidos daqui pois estão comentados na view
)
from rest_framework_simplejwt.views import TokenRefreshView
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView
from .api_comercial_views import (
    api_products_list,
    api_product_lookup,
    api_public_storefront,
    api_analytics_products,
)

router = DefaultRouter()
router.register(r'products', ProductViewSet)
router.register(r'inventory', InventoryViewSet, basename='inventory')
router.register(r'transactions', StockTransactionViewSet, basename='stock-transaction')

# Rotas da API comercial
api_comercial_urls = [
    # Documentação Swagger/OpenAPI
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
    
    # Endpoints da API
    path('products/', api_products_list, name='api-products-list'),
    path('products/lookup/', api_product_lookup, name='api-product-lookup'),
    path('public/storefront/<str:slug>/', api_public_storefront, name='api-public-storefront'),
    path('analytics/products/', api_analytics_products, name='api-analytics-products'),
    
    # Webhooks (exemplo)
    # path('webhooks/', include('inventory.webhook_urls')),
]

urlpatterns = [
    # --- Rotas de Negócio ---
    path('admin/feature-gates/', feature_gates_view),
    path("profile/", profile_view, name="profile"),
    path('products/lookup/', lookup_product, name='product-lookup'),
    path('stock/entry/', StockEntryView.as_view(), name='stock-entry'),
    path('sales/checkout/', SaleCheckoutView.as_view(), name='sale-checkout'),
    
    # --- Rotas de Autenticação (JWT) ---
    path('auth/login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('auth/register/', CustomUserCreateView.as_view(), name='register'), 
    path('auth/firebase/', FirebaseLoginView.as_view(), name='firebase_login'),



    path('session-control/', SessionControlView.as_view(), name='session-control'),
    path('session-summary/', SessionSummaryView.as_view(), name='session-summary'),

    path('public/storefront/<str:slug>/', public_storefront, name='public_storefront'),
    path('public/storefront/', public_storefront, name='public_storefront_by_id'),
    path('public/storefront/<str:slug>/marca/<str:brand>/', public_storefront_view, name='public_storefront_brand'),

    path('inventory/<int:item_id>/batches/', inventory_item_batches_view, name='inventory-item-batches'),
    path('fifo-withdrawal/', apply_fifo_withdrawal, name='fifo-withdrawal'),

    path('debug/user-store/', debug_user_store, name='debug-user-store'),
    path('debug/associate-store/', associate_user_store, name='associate-store'),

    path('dashboard/overview/', dashboard_overview, name='dashboard-overview'),
    path('dashboard/financial/', dashboard_financial_summary, name='dashboard-financial'),
    path('dashboard/inventory/', dashboard_inventory_analysis, name='dashboard-inventory'),
    path('cash-flow/summary/', cash_flow_summary, name='cash-flow-summary'),
    path('cash-flow/detailed/', cash_flow_detailed, name='cash-flow-detailed'),
    path('stats/dashboard/', dashboard_stats, name='dashboard_stats'),


    path('admin/plan-configs/', list_plan_configs, name='admin_plan_configs'),
    path('admin/promotions/', list_promotions, name='admin_promotions'),
    path('admin/stats/', get_system_stats, name='admin_stats'),
    path('admin/users/', list_users, name='admin_users'),
    path('admin/users/<int:user_id>/plan/', update_plan, name='admin_update_plan'),
    path('admin/users/<int:user_id>/subscription/', update_subscription, name='admin_update_subscription'),
    path('admin/analytics/products/', get_product_analytics, name='admin_product_analytics'),
    path('admin/analytics/behavior/', get_store_behavior_analytics, name='admin_behavior_analytics'),
    path('admin/monitoring/api-usage/', monitor_api_usage, name='admin_api_usage'),
    path('admin/api-monitor/', monitor_api_usage, name='admin_api_monitor'),
    path('check-plan-limits/', check_plan_limits_complete, name='check-plan-limits'),  

    # Endpoint público (sem auth)
    path('public/theme/', ThemeConfigPublicView.as_view(), name='theme-public'),

    # Endpoint admin (com auth)
    path('admin/theme/', ThemeConfigAdminView.as_view(), name='theme-admin'),
        
    path('consent/', record_consent, name='record_consent'),
    path('consent/revoke/<str:purpose>/',revoke_consent, name='revoke_consent'),
    path('consent/my/', get_my_consents, name='get_my_consents'),
    path('consent/export/', export_my_data, name='export_my_data'),
    # --- Rotas Automáticas (Router) ---
    path('', include(router.urls)),
]
