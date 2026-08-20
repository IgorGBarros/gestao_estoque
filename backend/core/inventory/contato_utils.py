# inventory/contato_utils.py
#
# Lógica de "quem precisa de qual contato" — compartilhada entre o
# comando de terminal (enviar_email_contato) e as telas do admin-panel,
# pra nunca ter duas versões divergentes da mesma regra.
from django.db.models import Q


def quem_falta_whatsapp(qs):
    """Público do 'checkin' por e-mail — quem não tem WhatsApp cadastrado."""
    return qs.exclude(whatsapp__isnull=False, whatsapp__gt='')


def quem_tem_campo_faltando(qs):
    """
    Público do 'completar_perfil' — mesma checagem que o
    ProfileCompletionBanner.tsx já faz dentro do sistema (Nome ou
    WhatsApp vazios).
    """
    return qs.filter(
        Q(name__isnull=True) | Q(name='') |
        Q(whatsapp__isnull=True) | Q(whatsapp='')
    )


def campos_faltando(store) -> list[str]:
    faltando = []
    if not store.name:
        faltando.append("Nome")
    if not store.whatsapp:
        faltando.append("WhatsApp")
    return faltando


def nome_para_saudacao(store) -> str:
    if store.name:
        return store.name
    if store.owner and store.owner.name:
        return store.owner.name
    if store.owner:
        return store.owner.email.split('@')[0]
    return "tudo bem"