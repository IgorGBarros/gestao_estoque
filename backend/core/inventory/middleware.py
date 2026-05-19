# inventory/middleware.py
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin
from django.utils import timezone
from .models import ApiKey
import re

class ApiKeyMiddleware(MiddlewareMixin):
    """
    Valida API Key no header Authorization: Bearer pk_••••
    ✅ IGNORA rotas públicas e de autenticação
    """
    
    # Rotas que NÃO precisam de API Key
    EXEMPT_PATHS = [
        '/api/auth/',       # Login, Register, Firebase
        '/api/admin/',      # Admin Panel (usa JWT de staff)
        '/api/public/',     # Vitrine pública
        '/api/webhooks/',   # Webhooks Asaas/Stripe
        '/api/docs',        # Swagger
        '/api/schema',      # OpenAPI Schema
        '/health/',         # Health Check
    ]

    def process_request(self, request):
        path = request.path_info
        
        # 1. Verifica se a rota é isenta
        if any(path.startswith(exempt) for exempt in self.EXEMPT_PATHS):
            return None
        
        # 2. Extrai API Key do header
        auth_header = request.META.get('HTTP_AUTHORIZATION', '')
        
        # Regex para validar formato pk_live_••• ou pk_test_•••
        match = re.match(r'^Bearer\s+(pk_(?:live|test)_[\w\-]+)$', auth_header)
        
        if not match:
            return JsonResponse({
                'error': 'API Key ausente ou inválida. Use: Authorization: Bearer pk_live_••••'
            }, status=401)
        
        key_value = match.group(1)
        
        try:
            api_key = ApiKey.objects.select_related('store', 'owner').get(
                key=key_value,
                is_active=True
            )
        except ApiKey.DoesNotExist:
            return JsonResponse({'error': 'API Key inválida'}, status=401)
        
        # Verificar expiração
        if api_key.expires_at and timezone.now() > api_key.expires_at:
            return JsonResponse({'error': 'API Key expirada'}, status=401)
        
        # Anexar API Key ao request
        request.api_key = api_key
        
        # Atualizar last_used (async para não bloquear)
        ApiKey.objects.filter(id=api_key.id).update(last_used=timezone.now())
        
        return None