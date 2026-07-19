# backend/core/inventory/signals.py
import uuid
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.contrib.auth import get_user_model
from .models import Store

User = get_user_model()

@receiver(post_save, sender=User)
def create_store_for_new_user(sender, instance, created, **kwargs):
    """
    Toda vez que um User é criado no banco, esta função é disparada.
    Garante que todo usuário tenha uma loja (Store) pronta para uso.
    """
    if created:
        # Pega o primeiro nome ou parte do email para montar o link da vitrine
        base_name = getattr(instance, 'first_name', '')
        if not base_name:
            base_name = instance.email.split('@')[0] if getattr(instance, 'email', None) else 'loja'
        
        # Garante que o slug (URL da vitrine) seja único usando um UUID curto
        unique_slug = f"{base_name.lower().replace(' ', '-')}-{str(uuid.uuid4())[:6]}"
        
        # Cria a Loja vinculada ao novo Usuário
        Store.objects.create(
            owner=instance,
            name=f"Espaço de {base_name.capitalize()}",
            slug=unique_slug,
            whatsapp="", # A consultora preenche depois
            # storefront_enabled=False (Se você tiver esse campo no model, inicie desativado)
        )