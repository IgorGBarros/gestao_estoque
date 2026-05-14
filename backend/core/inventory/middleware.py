# inventory/middleware.py
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin
from django.utils import timezone  # ✅ IMPORT NECESSÁRIO
from .models import ApiKey
import re

class ApiKeyMiddleware(MiddlewareMixin):
    """Valida API Key no header Authorization: Bearer pk_••••"""
    
    def process_request(self, request):
        # Ignorar rotas públicas e de documentação
        if request.path.startswith('/api/v1/docs') or \
           request.path.startswith('/api/v1/redoc') or \
           request.path.startswith('/api/v1/schema') or \
           request.path.startswith('/api/v1/public'):
            return None
        
        # Extrair API Key do header
        auth_header = request.META.get('HTTP_AUTHORIZATION', '')
        match = re.match(r'^Bearer\s+(pk_(?:live|test)_[\w\-]+)$', auth_header)
        
        if not match:
            return JsonResponse({'error': 'API Key ausente ou inválida. Use: Authorization: Bearer pk_live_••••'}, status=401)
        
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