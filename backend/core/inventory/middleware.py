# inventory/middleware.py
from django.utils.deprecation import MiddlewareMixin
from django.conf import settings
import re

class ApiKeyMiddleware(MiddlewareMixin):
    """
    Middleware para validar API Key em endpoints comerciais.
    ✅ EXCLUI endpoints de autenticação e LGPD da validação.
    """
    
    # ✅ Rotas que NÃO exigem API Key (autenticação de usuário ou públicas)
    EXCLUDED_PATHS = [
        # Auth
        r'^/api/auth/',
        r'^/api/token/',
        
        # LGPD / Consentimento
        r'^/api/consent/',
        
        # Público
        r'^/api/public/',
        r'^/api/vitrine/',
        r'^/api/health/',
        
        # Theme (público)
        r'^/api/theme/',
    ]
    
    def process_request(self, request):
        # ✅ Verificar se a rota está excluída
        path = request.path_info
        for excluded in self.EXCLUDED_PATHS:
            if re.match(excluded, path):
                return None  # Pula validação de API Key
        
        # ✅ Validar API Key apenas para rotas comerciais
        api_key = request.headers.get('Authorization', '')
        
        if api_key.startswith('Bearer '):
            api_key = api_key[7:]  # Remove 'Bearer '
        else:
            return self._error_response('API Key ausente. Use: Authorization: Bearer pk_live_••••')
        
        # ✅ Validar API Key no banco (implementar conforme sua lógica)
        from .models import ApiKey
        try:
            key_obj = ApiKey.objects.select_related('owner', 'store').get(
                key=api_key,
                is_active=True
            )
            # Anexar informações da chave ao request para uso nas views
            request.api_key = key_obj
            request.api_plan = key_obj.plan
            request.api_scopes = key_obj.scopes
        except ApiKey.DoesNotExist:
            return self._error_response('API Key inválida ou inativa')
        
        return None
    
    def _error_response(self, message):
        from rest_framework.response import Response
        from rest_framework import status
        # Retorna resposta JSON para APIs
        return Response({'error': message}, status=status.HTTP_401_UNAUTHORIZED)