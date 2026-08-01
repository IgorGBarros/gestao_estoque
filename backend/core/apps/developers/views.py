import logging

from django.db import transaction
from django.utils import timezone
from rest_framework import status
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response

from inventory.models import ApiKey

from .authentication import DeveloperJWTAuthentication, issue_tokens_for_developer
from .models import DeveloperAccount
from .serializers import DeveloperAccountSerializer, DeveloperLoginSerializer, DeveloperRegisterSerializer

logger = logging.getLogger(__name__)


@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    """
    POST /api/developers/register/ — cadastro de desenvolvedor.

    Nada de LGPD/termos aplicado aqui ainda de propósito — ver o comentário
    em DeveloperAccount.terms_accepted_at. Quando o termo do produto de
    dados existir de verdade, é aqui que a aceitação passa a ser exigida.
    """
    serializer = DeveloperRegisterSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    dados = serializer.validated_data

    with transaction.atomic():
        dev = DeveloperAccount(
            email=dados['email'],
            name=dados['name'],
            company_name=dados.get('company_name', ''),
        )
        dev.set_password(dados['password'])
        dev.save()

        # Chave gratuita automática — ninguém precisa pedir manualmente.
        # Escopos batem com os dois produtos planejados (catálogo e
        # analytics agregada) mesmo que os endpoints ainda não existam —
        # a chave já nasce pronta pra quando existirem.
        chave = ApiKey.objects.create(
            name=f"Chave padrão — {dev.name}",
            developer=dev,
            plan='starter',
            scopes=['read:catalogo', 'read:analytics'],
        )

    tokens = issue_tokens_for_developer(dev)
    logger.info(f"[DEVELOPERS] Nova conta registrada: {dev.email}")
    return Response({
        'developer': DeveloperAccountSerializer(dev).data,
        # ⚠️ Única vez que a chave completa é devolvida — dali em diante,
        # só o prefixo (ver `me`, abaixo). Mesmo padrão de qualquer provedor
        # sério: se perder, gera outra, nunca reexibe a antiga por inteiro.
        'api_key': chave.key,
        'api_key_warning': 'Guarde esta chave agora — ela não será mostrada por completo novamente.',
        **tokens,
    }, status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    """POST /api/developers/login/"""
    serializer = DeveloperLoginSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    email = serializer.validated_data['email'].strip().lower()
    senha = serializer.validated_data['password']

    dev = DeveloperAccount.objects.filter(email=email).first()
    # Mensagem genérica nos dois casos (e-mail não existe / senha errada) —
    # não dá pra um atacante descobrir por tentativa quais e-mails têm conta.
    if not dev or not dev.check_password(senha):
        return Response({'error': 'E-mail ou senha inválidos.'}, status=status.HTTP_401_UNAUTHORIZED)

    if not dev.is_active:
        return Response({'error': 'Conta desativada.'}, status=status.HTTP_403_FORBIDDEN)

    dev.last_login_at = timezone.now()
    dev.save(update_fields=['last_login_at'])

    tokens = issue_tokens_for_developer(dev)
    return Response({
        'developer': DeveloperAccountSerializer(dev).data,
        **tokens,
    })


@api_view(['GET'])
@authentication_classes([DeveloperJWTAuthentication])
@permission_classes([IsAuthenticated])
def me(request):
    """GET /api/developers/me/ — perfil do desenvolvedor logado + chaves dele."""
    dev = request.user
    chaves = dev.api_keys.all().order_by('-created_at')
    return Response({
        'developer': DeveloperAccountSerializer(dev).data,
        'api_keys': [
            {
                'id': str(k.id),
                'name': k.name,
                'key_prefix': k.key[:12] + '...',  # nunca devolve a chave inteira depois da criação
                'plan': k.plan,
                'scopes': k.scopes,
                'rate_limit': k.rate_limit,
                'monthly_quota': k.monthly_quota,
                'is_active': k.is_active,
                'last_used': k.last_used.isoformat() if k.last_used else None,
                'created_at': k.created_at.isoformat(),
            }
            for k in chaves
        ],
    })
