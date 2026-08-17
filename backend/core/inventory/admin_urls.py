# backend/core/inventory/admin_urls.py
"""
Rotas do painel admin (inventory/admin_views.py), montadas sob /api/admin/
pelo core/urls.py.

CORREÇÃO (Auditoria P0.1, fechamento): antes só 2 dos 11 endpoints tinham
rota — o AdminPanel chamava /admin/users/, /admin/stats/, /admin/plan-configs/
etc. e recebia 404. Este arquivo agora cobre TODAS as funções de
admin_views.py que o frontend consome. Todas exigem IsAdminUser (decorado
nas próprias views).
"""
from django.urls import path

from .admin_views import (
    admin_consultants_health,
    admin_crm_overview,
    admin_impersonate_user,
    admin_toggle_block_user,
    list_plan_configs,
    list_api_plan_configs,
    update_api_plan_config,
    update_plan_config,
    list_promotions,
    admin_support_conversations,
    admin_support_conversation_detail,
    admin_tutorial_videos,
    admin_tutorial_video_detail,
    admin_help_content_list_create,
    admin_help_content_detail,
    admin_barcode_candidates,
    admin_referral_codes,
    admin_referral_code_toggle,
    admin_contatos_enviar_email,
    admin_contatos_link_whatsapp,
    admin_contatos_marcar_whatsapp,
    admin_barcode_candidate_approve,
    admin_barcode_candidate_reject,
    update_system_config,
    create_promotion,
    promotion_detail,
    list_users,
    get_system_stats,
    get_product_analytics,
    get_store_behavior_analytics,
    get_ai_training_summary,
    monitor_api_usage,
    update_plan,
    update_subscription,
)

urlpatterns = [
    # Gestão de usuários
    path('users/', list_users, name='admin_list_users'),
    path('users/<int:user_id>/plan/', update_plan, name='admin_update_plan'),
    path('users/<int:user_id>/subscription/', update_subscription, name='admin_update_subscription'),

    # Visão geral / configuração
    path('stats/', get_system_stats, name='admin_system_stats'),
    path('plan-configs/', list_plan_configs, name='admin_plan_configs'),
    path('api-plan-configs/', list_api_plan_configs, name='admin_api_plan_configs'),
    path('api-plan-configs/<str:plan_type>/', update_api_plan_config, name='admin_update_api_plan_config'),
    path('plan-configs/<str:plan_type>/', update_plan_config, name='admin_update_plan_config'),
    path('promotions/', list_promotions, name='admin_promotions'),
    path('support/conversations/', admin_support_conversations, name='admin_support_conversations'),
    path('support/conversations/<uuid:conversation_id>/', admin_support_conversation_detail, name='admin_support_conversation_detail'),
    path('tutorial-videos/', admin_tutorial_videos, name='admin_tutorial_videos'),
    path('tutorial-videos/<int:video_id>/', admin_tutorial_video_detail, name='admin_tutorial_video_detail'),
    path('help-content/', admin_help_content_list_create, name='admin_help_content_list_create'),
    path('help-content/<int:content_id>/', admin_help_content_detail, name='admin_help_content_detail'),
    path('barcode-candidates/', admin_barcode_candidates, name='admin_barcode_candidates'),
    path('referral-codes/', admin_referral_codes, name='admin_referral_codes'),
    path('referral-codes/<int:code_id>/toggle/', admin_referral_code_toggle, name='admin_referral_code_toggle'),
    path('contatos/enviar-email/', admin_contatos_enviar_email, name='admin_contatos_enviar_email'),
    path('contatos/whatsapp-link/', admin_contatos_link_whatsapp, name='admin_contatos_link_whatsapp'),
    path('contatos/marcar-whatsapp/', admin_contatos_marcar_whatsapp, name='admin_contatos_marcar_whatsapp'),
    path('barcode-candidates/<int:candidate_id>/approve/', admin_barcode_candidate_approve, name='admin_barcode_candidate_approve'),
    path('barcode-candidates/<int:candidate_id>/reject/', admin_barcode_candidate_reject, name='admin_barcode_candidate_reject'),
    path('system-config/', update_system_config, name='admin_system_config'),
    path('promotions/create/', create_promotion, name='admin_promotion_create'),
    path('promotions/<uuid:promotion_id>/', promotion_detail, name='admin_promotion_detail'),
    path('api-monitor/', monitor_api_usage, name='admin_api_monitor'),

    # Analytics (filtrado por consentimento LGPD — ver admin_views.py)
    # 📊 Saúde de todas as consultoras (indicadores de gestão)
    path('analytics/consultants/', admin_consultants_health, name='admin_consultants_health'),
    path('analytics/crm/', admin_crm_overview, name='admin_crm_overview'),
    # 🔐 Suporte: acessar como consultora / bloquear acesso
    path('users/<int:user_id>/impersonate/', admin_impersonate_user, name='admin_impersonate'),
    path('users/<int:user_id>/toggle-block/', admin_toggle_block_user, name='admin_toggle_block'),
    path('analytics/products/', get_product_analytics, name='admin_product_analytics'),
    path('analytics/behavior/', get_store_behavior_analytics, name='admin_behavior_analytics'),
    path('ai-training/summary/', get_ai_training_summary, name='admin_ai_training_summary'),
]