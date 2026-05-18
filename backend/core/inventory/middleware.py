# inventory/middleware.py
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin
from django.utils import timezone
from django.conf import settings
from .models import ApiKey
import re

class ApiKeyMiddleware(MiddlewareMixin):
    """
    Valida API Key no header Authorization: Bearer pk_••••
    ✅ AGORA: Ignora rotas de auth, admin, webhooks e públicas
    """
    
    # ✅ LISTA DE ROTAS QUE NÃO PRECISAM DE API KEY
    EXEMPT_PATHS = [
        # Documentação
        '/api/v1/docs',
        '/api/v1/redoc', 
        '/api/v1/schema',
        '/api/v1/public',
        
        # 🔐 Autenticação (públicas - NÃO exigir API Key)
        '/api/auth/',
        '/api/login/',
        '/api/register/',
        '/api/firebase/',
        
        # 👨‍💼 Admin panel (usa JWT, não API Key)
        '/api/admin/',
        
        # 🔔 Webhooks (públicos por natureza)
        '/api/webhooks/',
        '/api/asaas/webhook/',
        '/api/stripe/webhook/',
        
        # 🛡️ LGPD endpoints (públicos para consentimento)
        '/api/consent/',
        
        # 🏪 Storefront pública
        '/api/public/',
        '/api/storefront/',
        
        # 🏥 Health check
        '/api/health/',
    ]
    
    def process_request(self, request):
        # ✅ 1. Verificar se a rota está na lista de exceções
        path = request.path_info
        if any(path.startswith(exempt) for exempt in self.EXEMPT_PATHS):
            return None  # Ignora middleware para esta rota
        
        # ✅ 2. Extrair API Key do header Authorization
        auth_header = request.META.get('HTTP_AUTHORIZATION', '')
        
        # Regex para validar formato pk_live_••• ou pk_test_•••
        match = re.match(r'^Bearer\s+(pk_(?:live|test)_[\w\-]+)$', auth_header)
        
        if not match:
            return JsonResponse({
                'error': 'API Key ausente ou inválida. Use: Authorization: Bearer pk_live_••••'
            }, status=401)
        
        key_value = match.group(1)
        
        # ✅ 3. Buscar API Key no banco de dados
        try:
            api_key = ApiKey.objects.select_related('store', 'owner').get(
                key=key_value,
                is_active=True
            )
        except ApiKey.DoesNotExist:
            return JsonResponse({'error': 'API Key inválida'}, status=401)
        
        # ✅ 4. Verificar expiração da chave
        if api_key.expires_at and timezone.now() > api_key.expires_at:
            return JsonResponse({'error': 'API Key expirada'}, status=401)
        
        # ✅ 5. Anexar API Key ao request para uso nas views
        request.api_key = api_key
        
        # ✅ 6. Atualizar last_used (async para não bloquear a resposta)
        ApiKey.objects.filter(id=api_key.id).update(last_used=timezone.now())
        
        return None