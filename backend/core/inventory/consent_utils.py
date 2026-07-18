# backend/core/inventory/consent_utils.py
"""
Funções compartilhadas de consentimento LGPD (Art. 8º).

Centralizado aqui porque antes existiam duas implementações quase iguais
(uma em views.py, outra local em admin_views.py) — juntar num só lugar
evita que uma delas fique desatualizada enquanto a outra é corrigida.
"""
from .models import ConsentRecord


def has_consent_for_purpose(user, purpose: str) -> bool:
    """Verifica se um usuário específico consentiu com uma finalidade."""
    if not user or not getattr(user, "is_authenticated", False):
        return False

    return ConsentRecord.objects.filter(
        user=user,
        purpose_flags__contains=[purpose],
        revoked_at__isnull=True,
    ).exists()


def consented_user_ids(purpose: str):
    """
    IDs de usuários com consentimento ATIVO para a finalidade informada.
    Uso típico: filtrar qualquer queryset agregado/de treino por
    `owner_id__in=consented_user_ids('minha_finalidade')` antes de expor
    ou processar os dados.
    """
    return set(
        ConsentRecord.objects.filter(
            purpose_flags__contains=[purpose],
            revoked_at__isnull=True,
        ).values_list('user_id', flat=True)
    )