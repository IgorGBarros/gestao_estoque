# inventory/middleware.py
from django.utils.deprecation import MiddlewareMixin
from django.conf import settings
import re
# inventory/middleware.py (trecho relevante)
class ApiKeyMiddleware(MiddlewareMixin):
    """
    Valida API Key em endpoints comerciais.
    Rotas em /api/v1/ exigem header: Authorization: Bearer pk_live_••••
    """
    
    # Rotas que NÃO exigem API Key (públicas ou auth JWT)
    EXCLUDED_PATHS = [
        r'^/api/auth/',
        r'^/api/consent/',
        r'^/api/public/',
        r'^/api/health/',
        r'^/api/theme/',
    ]
    
    def process_request(self, request):
        # Pula validação para rotas excluídas
        for excluded in self.EXCLUDED_PATHS:
            if re.match(excluded, request.path_info):
                return None
        
        # Valida API Key para demais rotas (incluindo /api/v1/*)
        api_key = request.headers.get('Authorization', '')
        if api_key.startswith('Bearer '):
            api_key = api_key[7:]
        else:
            return self._error_response('API Key ausente. Use: Authorization: Bearer pk_live_••••')
        
        # Valida no banco (implementar conforme sua lógica)
        from .models import ApiKey
        try:
            key_obj = ApiKey.objects.select_related('owner').get(
                key=api_key,
                is_active=True
            )
            request.api_key = key_obj
            request.api_plan = key_obj.plan
        except ApiKey.DoesNotExist:
            return self._error_response('API Key inválida ou inativa')
        
        return None
    
    def _error_response(self, message):
        from rest_framework.response import Response
        from rest_framework import status
        return Response({'error': message}, status=status.HTTP_401_UNAUTHORIZED)