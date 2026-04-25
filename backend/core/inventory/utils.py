# inventory/utils.py - VERSÃO ROBUSTA E TENANT-AWARE

import logging
from django.utils.text import slugify
from django.core.exceptions import ValidationError
from .models import Store

# Configurar logger
logger = logging.getLogger(__name__)

def get_current_store(user):
    """
    Obtém ou cria a loja do usuário atual de forma robusta.
    
    Esta função implementa o padrão tenant-aware onde cada usuário
    tem exatamente uma Store associada.
    
    Args:
        user: Instância do modelo User (CustomUser ou User padrão)
        
    Returns:
        Store: Instância da loja do usuário
        
    Raises:
        ValidationError: Se houver erro na criação da loja
        Exception: Para outros erros inesperados
    """
    if not user or not user.is_authenticated:
        logger.warning("Tentativa de obter loja para usuário não autenticado")
        raise ValidationError("Usuário deve estar autenticado")
    
    try:
        # ✅ PRIMEIRO: Tentar buscar loja existente
        logger.debug(f"Buscando loja para usuário {user.id} ({user.email})")
        
        # Usar relacionamento OneToOne definido no modelo
        if hasattr(user, 'store') and user.store:
            logger.debug(f"✅ Loja encontrada: {user.store.slug}")
            return user.store
        
        # ✅ FALLBACK: Buscar por query direta (caso relacionamento não funcione)
        store = Store.objects.filter(owner=user).first()
        if store:
            logger.debug(f"✅ Loja encontrada via query: {store.slug}")
            return store
            
    except Exception as e:
        logger.warning(f"Erro ao buscar loja existente: {e}")
        # Continuar para criação automática
    
    # ✅ SEGUNDO: Criar nova loja automaticamente
    try:
        logger.info(f"Criando nova loja para usuário {user.id}")
        
        # Gerar nome da loja baseado no usuário
        user_name = getattr(user, 'name', None) or getattr(user, 'first_name', None)
        if user_name:
            store_name = f'Loja {user_name.title()}'
        else:
            # Usar parte do email como fallback
            email_prefix = user.email.split('@')[0]
            store_name = f'Loja {email_prefix.title()}'
        
        # Gerar slug único
        base_slug = slugify(user.email.split('@')[0])
        unique_slug = base_slug
        
        # ✅ GARANTIR SLUG ÚNICO
        counter = 1
        while Store.objects.filter(slug=unique_slug).exists():
            unique_slug = f"{base_slug}-{counter}"
            counter += 1
            
            # Evitar loop infinito
            if counter > 1000:
                unique_slug = f"{base_slug}-{user.id}"
                break
        
        # ✅ CRIAR LOJA COM CONFIGURAÇÕES PADRÃO
        store = Store.objects.create(
            owner=user,  # ✅ Usar 'owner' conforme seu modelo
            name=store_name,
            slug=unique_slug,
            plan='free',  # ✅ Plano padrão
            # Campos opcionais com valores padrão
            whatsapp=getattr(user, 'phone', None),  # Se existir campo phone
        )
        
        logger.info(f"✅ Loja criada com sucesso: {store.slug} para usuário {user.email}")
        return store
        
    except ValidationError as e:
        logger.error(f"❌ Erro de validação ao criar loja: {e}")
        raise
    except Exception as e:
        logger.error(f"❌ Erro inesperado ao criar loja para usuário {user.id}: {e}")
        raise ValidationError(f"Não foi possível criar loja: {str(e)}")

def ensure_user_has_store(user):
    """
    Alias para get_current_store para compatibilidade com código existente.
    
    Args:
        user: Instância do modelo User
        
    Returns:
        Store: Instância da loja do usuário
    """
    return get_current_store(user)

def validate_store_ownership(user, store):
    """
    Valida se o usuário é dono da loja (segurança tenant).
    
    Args:
        user: Instância do modelo User
        store: Instância do modelo Store
        
    Returns:
        bool: True se o usuário é dono da loja
        
    Raises:
        ValidationError: Se o usuário não é dono da loja
    """
    if not store or not user:
        raise ValidationError("Usuário e loja são obrigatórios")
    
    if store.owner_id != user.id:
        logger.warning(f"Tentativa de acesso não autorizado: usuário {user.id} tentou acessar loja {store.id}")
        raise ValidationError("Acesso negado: você não é dono desta loja")
    
    return True

def get_store_stats(store):
    """
    Retorna estatísticas básicas da loja.
    
    Args:
        store: Instância do modelo Store
        
    Returns:
        dict: Estatísticas da loja
    """
    try:
        from .models import InventoryItem  # Import local para evitar circular
        
        total_products = store.items.count()
        total_value = sum(
            (item.cost_price or 0) * item.total_quantity 
            for item in store.items.all()
        )
        
        return {
            'total_products': total_products,
            'total_value': total_value,
            'plan': store.plan,
            'can_add_products': getattr(store, 'can_add_products', True),
            'created_at': store.created_at,
        }
        
    except Exception as e:
        logger.error(f"Erro ao calcular estatísticas da loja {store.id}: {e}")
        return {
            'total_products': 0,
            'total_value': 0,
            'plan': store.plan,
            'can_add_products': True,
            'created_at': store.created_at,
        }