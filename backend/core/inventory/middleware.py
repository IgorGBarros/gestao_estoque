# inventory/middleware.py
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin
from django.utils import timezone
from .models import ApiKey
import re

class ApiKeyMiddleware(MiddlewareMixin):
    """
    Valida API Key no header Authorization: Bearer pk_••••
    ✅ IGNORA rotas de Auth, Admin, Webhooks e Públicas
    """
    
    # Rotas que NÃO precisam de API Key
    EXEMPT_PATHS = [
        '/admin/',          # Painel Admin Django
        '/auth/',           # Autenticação (Login, Register, Firebase)
        '/api/auth/',       # Autenticação DRF
        '/api/admin/',      # Endpoints Admin da API
        '/api/webhooks/',   # Webhooks Asaas/Stripe
        '/api/public/',     # Vitrine Pública
        '/api/docs',        # Swagger
        '/api/schema',      # OpenAPI Schema
        '/health/',         # Health Check
    ]

    def process_request(self, request):
        path = request.path_info
        
        # 1. Verifica se a rota é isenta
        if any(path.startswith(exempt) for exempt in self.EXEMPT_PATHS):
            return None
        
        # 2. Extrai API Key do Header
        auth_header = request.META.get('HTTP_AUTHORIZATION', '')
        match = re.match(r'^Bearer\s+(pk_(?:live|test)_[\w\-]+)$', auth_header)
        
        if not match:
            # Se não tem API Key válida, retorna erro 401
            return JsonResponse({
                'error': 'API Key ausente ou inválida. Use: Authorization: Bearer pk_live_••••'
            }, status=401)
        
        key_value = match.group(1)
        
        # 3. Busca a Chave no Banco
        try:
            api_key = ApiKey.objects.select_related('store', 'owner').get(
                key=key_value,
                is_active=True
            )
        except ApiKey.DoesNotExist:
            return JsonResponse({'error': 'API Key inválida'}, status=401)
        
        # 4. Verifica Expiração
        if api_key.expires_at and timezone.now() > api_key.expires_at:
            return JsonResponse({'error': 'API Key expirada'}, status=401)
        
        # 5. Anexa ao Request e atualiza last_used
        request.api_key = api_key
        # Atualização assíncrona leve para não bloquear a resposta
        ApiKey.objects.filter(id=api_key.id).update(last_used=timezone.now())
        
        return None