# backend/core/inventory/middleware.py
"""
Middleware para validação de API Key comercial.
Rotas de autenticação de usuário (JWT) são excluídas.
"""

import re
import logging
from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin

logger = logging.getLogger(__name__)


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
    
    def process_request(self, request):
        """
        Intercepta requisição para validar API Key.
        Retorna None para continuar, ou JsonResponse para bloquear.
        """
        path = request.path_info
        
        # ✅ Log seguro (sem vazar dados sensíveis)
        logger.debug(f"🔍 ApiKeyMiddleware: {request.method} {path}")
        
        # ✅ Verificar se é rota excluída
        for excluded_pattern in self.EXCLUDED_PATHS:
            if re.match(excluded_pattern, path):
                logger.debug(f"✅ Rota excluída: {path} ~ {excluded_pattern}")
                return None  # Continua sem validar API Key
        
        # ✅ Validar API Key comercial apenas para endpoints protegidos
        auth_header = request.headers.get('Authorization', '')
        
        # Extrair token (pode ser JWT ou API Key)
        if not auth_header.startswith('Bearer '):
            return self._error_response('API Key ausente. Use: Authorization: Bearer pk_live_••••')
        
        token = auth_header[7:]  # Remove "Bearer "
        
        # ✅ Diferenciar JWT de API Key comercial pelo prefixo
        if token.startswith('eyJ'):  # JWT começa com "eyJ..."
            # ✅ É um token JWT de usuário - permitir passar
            # O JWT será validado depois por SimpleJWT authentication
            logger.debug("✅ Token JWT detectado, permitindo passagem para SimpleJWT")
            return None
        
        # ✅ É uma API Key comercial - validar formato
        if not token.startswith('pk_live_') and not token.startswith('pk_test_'):
            return self._error_response('Formato de API Key inválido. Use pk_live_••• ou pk_test_•••')
        
        # ✅ Validar no banco de dados
        try:
            from .models import ApiKey
            key_obj = ApiKey.objects.select_related('owner', 'store').get(
                key=token,
                is_active=True
            )
            # Anexar ao request para uso nas views
            request.api_key = key_obj
            request.api_plan = key_obj.plan
            request.api_scopes = key_obj.scopes or []
            logger.debug(f"✅ API Key válida: {key_obj.name or key_obj.key[:10]}...")
        except ApiKey.DoesNotExist:
            logger.warning(f"⚠️ API Key inválida: {token[:10]}...")
            return self._error_response('API Key inválida ou inativa')
        except Exception as e:
            logger.error(f"❌ Erro ao validar API Key: {e}")
            return self._error_response('Erro interno ao validar API Key')
        
        return None
    
    def _error_response(self, message: str, status_code: int = 401):
        """
        Retorna resposta de erro compatível com middleware Django.
        Usa JsonResponse em vez de DRF Response para evitar conflitos.
        """
        logger.warning(f"⚠️ ApiKeyMiddleware error: {message}")
        return JsonResponse(
            {'error': message}, 
            status=status_code,
            json_dumps_params={'ensure_ascii': False}
        )