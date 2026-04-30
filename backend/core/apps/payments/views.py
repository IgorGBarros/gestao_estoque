# apps/payments/views.py - CORREÇÃO DAS IMPORTAÇÕES

import logging
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from django.conf import settings

from .services.asaas_service import asaas_service, AsaasAPIError

logger = logging.getLogger(__name__)


def _get_store(request):
    """Helper para buscar store do usuário autenticado"""
    # Tenta relação direta primeiro
    store = getattr(request.user, 'store', None)
    if store:
        return store

    # Fallback: busca pelo owner
    try:
        # ✅ CORREÇÃO: Importação dinâmica para evitar erro de path
        from django.apps import apps
        Store = apps.get_model('stores', 'Store')
        return Store.objects.get(owner=request.user)
    except Exception:
        return None