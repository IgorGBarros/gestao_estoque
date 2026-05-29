# backend/core/inventory/middleware.py

from asyncio.log import logger
import re
from django.utils.deprecation import MiddlewareMixin
from rest_framework.response import Response
from rest_framework import status

class ApiKeyMiddleware(MiddlewareMixin):
    """
    Valida API Key comercial APENAS em endpoints específicos.
    Rotas de autenticação de usuário (JWT) são excluídas.
    """
    
    # ✅ Rotas que NÃO exigem API Key comercial
    EXCLUDED_PATHS = [
        # Auth de usuário (JWT)
        r'^/api/auth/',
        
        # Consentimento LGPD (pode ser anônimo)
        r'^/api/consent/',
        
        # Público
        r'^/api/public/',
        r'^/api/vitrine/',
        r'^/api/health/',
        r'^/api/theme/',
        
        # Profile (usa JWT, não API Key)
        r'^/api/profile/',
        
        # Feature gates (usa JWT)
        r'^/api/admin/feature-gates/',
    ]
    
    # backend/core/inventory/middleware.py - dentro de process_request

    def process_request(self, request):
        path = request.path_info
        logger.info(f"🔍 [CP3] ApiKeyMiddleware: {request.method} {path}")
        
        # ✅ Verificar se é rota excluída
        for excluded in self.EXCLUDED_PATHS:
            if re.match(excluded, path):
                logger.info(f"✅ [CP3] Rota excluída: {path} ~ {excluded}")
                return None  # Continua sem validar API Key
        
        logger.info(f"⚠️ [CP3] Rota NÃO excluída, validando API Key...")
        
    # ... resto da validação ...
        
        # ✅ Validar API Key comercial apenas para endpoints protegidos
        auth_header = request.headers.get('Authorization', '')
        
        # Extrair token (pode ser JWT ou API Key)
        if auth_header.startswith('Bearer '):
            token = auth_header[7:]
        else:
            return self._error_response('API Key ausente. Use: Authorization: Bearer pk_live_••••')
        
        # ✅ Diferenciar JWT de API Key comercial pelo prefixo
        if token.startswith('eyJ'):  # JWT começa com "eyJ..."
            # ✅ É um token JWT de usuário - permitir passar
            # O JWT será validado depois por SimpleJWT authentication
            return None
        
        # ✅ É uma API Key comercial - validar no banco
        if not token.startswith('pk_live_') and not token.startswith('pk_test_'):
            return self._error_response('Formato de API Key inválido')
        
        # Validar no banco de dados
        try:
            from .models import ApiKey
            key_obj = ApiKey.objects.select_related('owner', 'store').get(
                key=token,
                is_active=True
            )
            # Anexar ao request para uso nas views
            request.api_key = key_obj
            request.api_plan = key_obj.plan
            request.api_scopes = key_obj.scopes
        except ApiKey.DoesNotExist:
            return self._error_response('API Key inválida ou inativa')
        
        return None
    
    def _error_response(self, message):
        return Response({'error': message}, status=status.HTTP_401_UNAUTHORIZED)