# backend/core/inventory/admin_urls.py
"""
Rotas do painel admin (inventory/admin_views.py).

NOTA: admin_views.py define bem mais funções do que as roteadas aqui
(list_plan_configs, list_promotions, monitor_api_usage, product analytics
etc.) — nenhuma delas tinha rota registrada em lugar nenhum do projeto até
agora. Este arquivo, por ora, só liga os dois endpoints tocados na
correção de consentimento LGPD (P1: analytics comportamental; P2: resumo
do dataset de treino de IA). O restante de admin_views.py continua sem
rota — se for pra usar, precisa ser registrado aqui também.
"""
from django.urls import path

from .admin_views import (
    get_store_behavior_analytics,
    get_ai_training_summary,
)

urlpatterns = [
    path('analytics/behavior/', get_store_behavior_analytics, name='admin_behavior_analytics'),
    path('ai-training/summary/', get_ai_training_summary, name='admin_ai_training_summary'),
]