"""
backend/core/core/urls.py
URL configuration for core project.
"""
from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenRefreshView

# Views de autenticação e perfil
from inventory.views import (
    CustomTokenObtainPairView,
    CustomUserCreateView,
    FirebaseLoginView,
    profile_view,
)

# Views de consentimento LGPD
from inventory.views import (
    record_consent,
    revoke_consent,
    get_my_consents,
    export_my_data,
)

# Views de tema (público e admin)
from inventory.views import ThemeConfigPublicView, ThemeConfigAdminView

# Views de dashboard e analytics
from inventory.views import (
    dashboard_overview,
    dashboard_stats,
    dashboard_financial_summary,
    dashboard_inventory_analysis,
    cash_flow_summary,
    cash_flow_detailed,
)

# Views de feature gates e planos
from inventory.views import feature_gates_view, check_plan_limits_complete

# Views de sessão
from inventory.views import SessionControlView, SessionSummaryView

# Views públicas
from inventory.views import public_storefront, public_storefront_view, lookup_product

# Swagger/Documentação
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView, SpectacularRedocView

urlpatterns = [
    # Admin Django
    path('admin/', admin.site.urls),
    
    # ==========================================
    # 🔐 AUTHENTICATION (Rotas principais)
    # ==========================================
    path('api/auth/login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/auth/register/', CustomUserCreateView.as_view(), name='register'),
    path('api/auth/firebase/', FirebaseLoginView.as_view(), name='firebase_login'),
    
    # ==========================================
    # 👤 PROFILE & CONFIGURAÇÕES
    # ==========================================
    path('profile/', profile_view, name='profile'),
    path('admin/feature-gates/', feature_gates_view, name='feature_gates'),
    path('check-plan-limits/', check_plan_limits_complete, name='check_plan_limits'),
    
    # ==========================================
    # 📊 DASHBOARD & ANALYTICS
    # ==========================================
    path('dashboard/overview/', dashboard_overview, name='dashboard_overview'),
    path('stats/dashboard/', dashboard_stats, name='dashboard_stats'),
    path('dashboard/financial/', dashboard_financial_summary, name='dashboard_financial'),
    path('dashboard/inventory/', dashboard_inventory_analysis, name='dashboard_inventory'),
    path('cash-flow/summary/', cash_flow_summary, name='cash_flow_summary'),
    path('cash-flow/detailed/', cash_flow_detailed, name='cash_flow_detailed'),
    
    # ==========================================
    # 🔐 LGPD - CONSENTIMENTO (Rotas principais)
    # ==========================================
    path('consent/', record_consent, name='record_consent'),
    path('consent/revoke/<str:purpose>/', revoke_consent, name='revoke_consent'),
    path('consent/my/', get_my_consents, name='get_my_consents'),
    path('consent/export/', export_my_data, name='export_my_data'),
    
    # ==========================================
    # 🎨 TEMA (Público e Admin)
    # ==========================================
    path('public/theme/', ThemeConfigPublicView.as_view(), name='theme_public'),
    path('admin/theme/', ThemeConfigAdminView.as_view(), name='theme_admin'),
    
    # ==========================================
    # 📦 SESSÃO DE CADASTRO
    # ==========================================
    path('session-control/', SessionControlView.as_view(), name='session_control'),
    path('session-summary/', SessionSummaryView.as_view(), name='session_summary'),
    
    # ==========================================
    # 🌐 ROTAS PÚBLICAS
    # ==========================================
    path('products/lookup/', lookup_product, name='lookup_product'),
    path('public/storefront/<slug:slug>/', public_storefront, name='public_storefront_slug'),
    path('public/storefront/', public_storefront, name='public_storefront_list'),
    
    # ==========================================
    # 📚 DOCUMENTAÇÃO API (Swagger)
    # ==========================================
    path('schema/', SpectacularAPIView.as_view(), name='schema'),
    path('docs/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger-ui'),
    path('redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),
    
    # ==========================================
    # 📦 INVENTORY (Inclusão do app inventory)
    # ==========================================
    path('', include('inventory.urls')),
    
    # ==========================================
    # 🤖 AI & PAYMENTS (Outros apps)
    # ==========================================
    path('api/chat/', include('ai.urls')),
    path('api/payments/', include('apps.payments.urls')),
    
    # ==========================================
    # 🛍️ API COMERCIAL (v1)
    # ==========================================
    path('api/v1/', include('inventory.api_comercial_urls')),
]