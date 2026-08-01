import logging
from datetime import timedelta

from django.db import transaction
from django.db.models import Count, Q, Avg
from django.db.models.functions import TruncDate
from django.utils import timezone
from rest_framework import status
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response

from inventory.models import ApiKey, ApiUsageLog

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


@api_view(['GET'])
@authentication_classes([DeveloperJWTAuthentication])
@permission_classes([IsAuthenticated])
def dashboard(request):
    """
    GET /api/developers/dashboard/ — dados reais de uso, pro
    ApiDashboard.tsx (que hoje mostra tudo simulado, com uma chamada real
    comentada e um setTimeout(500ms) fingindo carregar).

    Tudo aqui vem de ApiUsageLog de verdade — nada é calculado, estimado
    ou aleatório.
    """
    dev = request.user
    chaves = list(dev.api_keys.all().order_by('-created_at'))
    logs = ApiUsageLog.objects.filter(api_key__developer=dev)

    agora = timezone.now()
    inicio_mes = agora.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
    logs_mes = logs.filter(created_at__gte=inicio_mes)

    total_mes = logs_mes.count()
    erros_mes = logs_mes.filter(status_code__gte=400).count()
    taxa_erro = round(erros_mes / total_mes * 100, 1) if total_mes else 0.0
    latencia_media = logs_mes.aggregate(m=Avg('response_time_ms'))['m'] or 0

    desde = agora - timedelta(days=30)
    por_dia = (
        logs.filter(created_at__gte=desde)
        .annotate(dia=TruncDate('created_at'))
        .values('dia')
        .annotate(total=Count('id'))
        .order_by('dia')
    )

    quota_total = sum(k.monthly_quota for k in chaves) or 0

    return Response({
        'keys': [
            {
                'id': str(k.id),
                'name': k.name,
                'key_prefix': k.key[:12] + '...',
                'plan': k.plan,
                'is_active': k.is_active,
                'rate_limit': k.rate_limit,
                'monthly_quota': k.monthly_quota,
                'last_used': k.last_used.isoformat() if k.last_used else None,
            }
            for k in chaves
        ],
        'requests_this_month': total_mes,
        'error_rate_percent': taxa_erro,
        'success_rate_percent': round(100 - taxa_erro, 1),
        'avg_latency_ms': round(latencia_media, 0),
        'quota_used': total_mes,
        'quota_limit': quota_total,
        'requests_by_day': [
            {'date': r['dia'].isoformat(), 'count': r['total']} for r in por_dia
        ],
    })