# backend/core/ai/support_views.py
import logging

from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from inventory.utils import get_current_store
from .models import SupportConversation, SupportMessage, TutorialVideo
from .support_service import tentar_responder_duvida

logger = logging.getLogger(__name__)


def _serialize_conversation(conv, com_mensagens=False):
    dados = {
        'id': str(conv.id),
        'category': conv.category,
        'status': conv.status,
        'subject': conv.subject,
        'created_at': conv.created_at.isoformat(),
        'updated_at': conv.updated_at.isoformat(),
    }
    if com_mensagens:
        dados['messages'] = [
            {'id': m.id, 'sender': m.sender, 'content': m.content, 'created_at': m.created_at.isoformat()}
            for m in conv.messages.all()
        ]
    return dados


@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def conversations_list_create(request):
    store = get_current_store(request.user)
    if not store:
        return Response({'error': 'Nenhuma loja associada a este usuário.'}, status=status.HTTP_400_BAD_REQUEST)

    if request.method == 'GET':
        conversas = SupportConversation.objects.filter(store=store)
        return Response([_serialize_conversation(c) for c in conversas])

    # POST — abre uma conversa nova
    category = request.data.get('category')
    subject = (request.data.get('subject') or '')[:200]
    mensagem = (request.data.get('message') or '').strip()

    if category not in ('question', 'bug'):
        return Response({'error': "category precisa ser 'question' ou 'bug'."}, status=status.HTTP_400_BAD_REQUEST)
    if not mensagem:
        return Response({'error': 'Mensagem não pode ser vazia.'}, status=status.HTTP_400_BAD_REQUEST)

    conv = SupportConversation.objects.create(
        store=store, category=category, subject=subject,
        # ⚠️ Reporte de erro nunca é respondido por IA — ela não conserta
        # bug, só a dúvida de "como fazer X" passa pela Amorinha primeiro.
        status='ai_handling' if category == 'question' else 'escalated',
    )
    SupportMessage.objects.create(conversation=conv, sender='user', content=mensagem)

    if category == 'bug':
        SupportMessage.objects.create(
            conversation=conv, sender='ai',
            content='Recebemos seu reporte! Nossa equipe vai analisar e responder por aqui assim que possível. Obrigada por avisar 💜',
        )
    else:
        resultado = tentar_responder_duvida(mensagem, [])
        if resultado['pode_responder']:
            SupportMessage.objects.create(conversation=conv, sender='ai', content=resultado['resposta'])
        else:
            conv.status = 'escalated'
            conv.save(update_fields=['status'])
            SupportMessage.objects.create(
                conversation=conv, sender='ai',
                content='Essa eu não sei responder com segurança — já encaminhei pra nossa equipe, elas te respondem por aqui 💜',
            )

    conv.refresh_from_db()
    return Response(_serialize_conversation(conv, com_mensagens=True), status=status.HTTP_201_CREATED)


@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def conversation_detail(request, conversation_id):
    store = get_current_store(request.user)
    if not store:
        return Response({'error': 'Nenhuma loja associada a este usuário.'}, status=status.HTTP_400_BAD_REQUEST)

    # ⚠️ Sempre filtra por store — nunca busca só por id. Uma consultora
    # nunca pode ver a conversa de outra, mesmo sabendo o UUID.
    conv = SupportConversation.objects.filter(id=conversation_id, store=store).first()
    if not conv:
        return Response({'error': 'Conversa não encontrada.'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        return Response(_serialize_conversation(conv, com_mensagens=True))

    # POST — mensagem de seguimento
    mensagem = (request.data.get('message') or '').strip()
    if not mensagem:
        return Response({'error': 'Mensagem não pode ser vazia.'}, status=status.HTTP_400_BAD_REQUEST)
    if conv.status in ('resolved', 'closed'):
        return Response({'error': 'Esta conversa já foi encerrada.'}, status=status.HTTP_400_BAD_REQUEST)

    SupportMessage.objects.create(conversation=conv, sender='user', content=mensagem)

    # Só tenta a Amorinha de novo se a conversa ainda está com ela — depois
    # de escalar, é a equipe que responde, não faz sentido a IA continuar
    # tentando por cima.
    if conv.status == 'ai_handling':
        historico = [
            {'sender': m.sender, 'content': m.content}
            for m in conv.messages.order_by('-created_at')[:6]
        ][::-1]
        resultado = tentar_responder_duvida(mensagem, historico)
        if resultado['pode_responder']:
            SupportMessage.objects.create(conversation=conv, sender='ai', content=resultado['resposta'])
        else:
            conv.status = 'escalated'
            conv.save(update_fields=['status'])
            SupportMessage.objects.create(
                conversation=conv, sender='ai',
                content='Vou encaminhar pra nossa equipe olhar com mais calma — já te respondem por aqui 💜',
            )

    conv.refresh_from_db()
    return Response(_serialize_conversation(conv, com_mensagens=True))


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def tutorial_videos(request):
    """GET /api/chat/videos/ — vídeos visíveis pra consultora logada, dentro do sistema."""
    videos = TutorialVideo.objects.filter(is_visible=True)
    return Response([
        {
            'id': v.id, 'title': v.title, 'description': v.description,
            'video_url': v.video_url, 'category': v.category,
        }
        for v in videos
    ])


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ajuda_list(request):
    """
    GET /api/ajuda/?tipo=&categoria=&status=

    Endpoint ÚNICO de consumo da Central de Ajuda — a página de suporte e
    a seção "Aprenda a usar" do profile usam exatamente este endpoint,
    só com filtros diferentes (Etapa 2: "zero conteúdo duplicado"). A
    busca do chat (Etapa 4) também reaproveita este mesmo dado, não bate
    noutro lugar.

    ⚠️ status é sempre 'visivel' aqui, e NÃO é sobrescrito por query string
    — rascunho nunca deve aparecer pra consultora, mesmo que ela tente
    forçar via URL. O parâmetro "status" existe só pra manter a mesma
    assinatura do endpoint de admin; do lado da consultora ele é ignorado
    de propósito, não é um "default" que dá pra trocar.
    """
    from .models import HelpContent
    itens = HelpContent.objects.filter(status='visivel')

    tipo = request.GET.get('tipo')
    categoria = request.GET.get('categoria')

    if tipo:
        itens = itens.filter(tipo=tipo)
    if categoria:
        itens = itens.filter(categoria=categoria)

    return Response([
        {
            'id': c.id, 'tipo': c.tipo, 'titulo': c.titulo, 'corpo': c.corpo,
            'video_url': c.video_url, 'categoria': c.categoria, 'ordem': c.ordem,
        }
        for c in itens
    ])

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def help_search(request):
    """
    POST /api/chat/help-search/
    Body: {"query": "..."}

    Modo "🆘 Preciso de ajuda" do chat unificado — busca em HelpContent
    (título+corpo, ILIKE), até 3 resultados. Sem resultado nenhum, escala
    automaticamente pra humano (reaproveita o MESMO fluxo de escalada de
    SupportConversation que já existe, não inventa um novo caminho). Toda
    busca é logada em HelpSearchLog — vira backlog de conteúdo pro admin
    (pergunta que ninguém respondeu = candidato a FAQ nova).
    """
    from django.db.models import Q
    from .models import HelpContent, HelpSearchLog

    store = get_current_store(request.user)
    if not store:
        return Response({'error': 'Nenhuma loja associada a este usuário.'}, status=status.HTTP_400_BAD_REQUEST)

    query = (request.data.get('query') or '').strip()
    if not query:
        return Response({'error': 'query não pode ser vazia.'}, status=status.HTTP_400_BAD_REQUEST)

    resultados = list(
        HelpContent.objects.filter(status='visivel')
        .filter(Q(titulo__icontains=query) | Q(corpo__icontains=query))[:3]
    )

    if resultados:
        HelpSearchLog.objects.create(query=query[:300], matched_content=resultados[0], store=store)
        return Response({
            'encontrou': True,
            'resultados': [
                {
                    'id': r.id, 'tipo': r.tipo, 'titulo': r.titulo,
                    'resumo': (r.corpo[:140] + '…') if len(r.corpo) > 140 else r.corpo,
                    'video_url': r.video_url,
                }
                for r in resultados
            ],
        })

    # Nenhum resultado — loga sem match (isso É o backlog: pergunta real
    # sem conteúdo pra responder) e escala pra humano automaticamente,
    # reaproveitando o mesmo model/fluxo que a escalada manual já usa.
    HelpSearchLog.objects.create(query=query[:300], matched_content=None, store=store)

    conv = SupportConversation.objects.create(
        store=store, category='question', subject=query[:200], status='escalated',
    )
    SupportMessage.objects.create(conversation=conv, sender='user', content=query)
    SupportMessage.objects.create(
        conversation=conv, sender='ai',
        content='Não encontrei nada sobre isso na Central de Ajuda — já encaminhei pra nossa equipe, elas te respondem por aqui 💜',
    )

    return Response({'encontrou': False, 'resultados': [], 'conversation_id': str(conv.id)})