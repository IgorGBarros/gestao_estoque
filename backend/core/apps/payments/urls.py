from django.urls import path
from . import views

urlpatterns = [
    # Endpoints do usuário
    path('asaas/checkout/', views.asaas_create_checkout, name='asaas-checkout'),
    path('asaas/status/', views.asaas_subscription_status, name='asaas-status'),
    path('asaas/webhook/', views.asaas_webhook, name='asaas-webhook'),
]

# Admin endpoints (adicionar no urls do admin ou aqui com prefix)
admin_urlpatterns = [
    path('payments/asaas/config/', views.asaas_admin_config, name='asaas-admin-config'),
    path('payments/asaas/test/', views.asaas_admin_test_connection, name='asaas-admin-test'),
]