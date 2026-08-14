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
    else:
        # ⚠️ Sem isto, a lista (usada pela tela "Minhas Conversas" e pela
        # notificação no sino) não tinha como saber se a ÚLTIMA mensagem é
        # da equipe (resposta esperando ser vista) ou da própria
        # consultora (nada novo pra ela ver) — teria que abrir cada
        # conversa uma por uma só pra descobrir isso.
        # ⚠️ list(conv.messages.all()) usa o cache do prefetch_related (a
        # ordenação padrão do model já é ascendente por created_at) — um
        # .order_by('-created_at') aqui pareceria mais direto, mas IGNORA
        # o cache do prefetch por ter ordenação diferente da que foi
        # carregada, disparando uma query nova por conversa (o N+1 que o
        # prefetch_related existia pra evitar).
        mensagens = list(conv.messages.all())
        ultima = mensagens[-1] if mensagens else None
        if ultima:
            dados['last_message_sender'] = ultima.sender
            dados['last_message_preview'] = ultima.content[:120]
    return dados


@api_view(['GET', 'POST'])
@permission_classes([IsAuthenticated])
def conversations_list_create(request):
    store = get_current_store(request.user)
    if not store:
        return Response({'error': 'Nenhuma loja associada a este usuário.'}, status=status.HTTP_400_BAD_REQUEST)

    if request.method == 'GET':
        # prefetch_related evita 1 query por conversa só pra descobrir a
        # última mensagem (N+1) — busca todas de uma vez, e o Python
        # (dentro de _serialize_conversation) escolhe a mais recente sem
        # bater no banco de novo.
        conversas = SupportConversation.objects.filter(store=store).prefetch_related('messages')
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

_FRASES_PEDE_HUMANO = [
    'falar com atendente', 'falar com um atendente', 'falar com uma pessoa',
    'falar com humano', 'falar com um humano', 'falar com alguém',
    'atendimento humano', 'suporte humano', 'atendente humano',
    'quero um humano', 'quero uma pessoa', 'quero falar com gente',
    'pessoa de verdade', 'atendente de verdade', 'ser humano',
    'não quero falar com robô', 'não quero falar com a ia',
    'não quero falar com bot', 'não é a amorinha', 'chama o suporte',
    'chamar o suporte', 'preciso de um atendente',
]


def _pede_humano_explicitamente(mensagem: str) -> bool:
    """
    Detecção rápida e determinística — de propósito NÃO usa IA aqui (seria
    gastar uma chamada de LLM só pra reconhecer uma frase comum). Lista
    fechada de expressões que só fazem sentido com essa intenção; evita
    ficar genérico demais (ex: não reage a "atendente" sozinho, que
    poderia aparecer numa pergunta sobre outra coisa).
    """
    texto = mensagem.lower()
    return any(frase in texto for frase in _FRASES_PEDE_HUMANO)


def _buscar_ou_escalar(query, store):
    """
    Núcleo compartilhado entre help_search (mantido por compatibilidade) e
    chat_unified — busca na Central de Ajuda, senão escala pra humano.
    Sempre loga em HelpSearchLog, ache ou não.

    ⚠️ EVOLUÇÃO: antes era busca por PALAVRA-CHAVE (icontains) — não
    entendia sinônimo nem reformulação ("removo um produto" não batia com
    "baixa", por exemplo). Agora usa a IA pra entender de verdade a
    pergunta, mas com uma trava rígida: ela só pode responder com base no
    que está escrito na Central de Ajuda (ver responder_com_central_de_ajuda
    em services.py — mesmo princípio do roteador de consulta de dados,
    nunca texto livre da IA sozinha). A busca por palavra-chave antiga
    fica como respaldo, só se a chamada à IA falhar por completo (Groq
    fora do ar, por exemplo) — assim a consultora nunca fica sem resposta
    nenhuma só porque um serviço externo caiu.
    """
    import re
    from django.db.models import Q
    from .models import HelpContent, HelpSearchLog
    from .services import responder_com_central_de_ajuda

    resultado_ia = responder_com_central_de_ajuda(query, store)

    if resultado_ia.get('encontrou'):
        primeira_fonte_id = resultado_ia['fontes'][0]['id']
        HelpSearchLog.objects.create(
            query=query[:300], matched_content_id=primeira_fonte_id, store=store,
        )
        return {
            'encontrou': True,
            'resposta': resultado_ia['resposta'],
            'fontes': resultado_ia['fontes'],
        }

    # Respaldo — só entra aqui se a IA genuinamente não achou nada (ou
    # falhou). Busca por palavra-chave, sem síntese, mostra os itens como
    # cards em vez de resposta pronta.
    PALAVRAS_COMUNS = {
        'como', 'que', 'para', 'com', 'uma', 'um', 'de', 'da', 'do', 'das', 'dos',
        'no', 'na', 'nos', 'nas', 'os', 'as', 'meu', 'minha', 'meus', 'minhas',
        'eu', 'se', 'por', 'não', 'sim', 'mais', 'muito', 'aqui', 'ali', 'isso',
        'esse', 'essa', 'este', 'esta', 'qual', 'quais', 'quando', 'onde',
    }
    palavras = [p for p in re.findall(r'\w+', query.lower(), flags=re.UNICODE) if len(p) >= 3 and p not in PALAVRAS_COMUNS]

    resultados = []
    if palavras:
        filtro = Q()
        for palavra in palavras[:8]:
            filtro |= Q(titulo__icontains=palavra) | Q(corpo__icontains=palavra)
        resultados = list(HelpContent.objects.filter(status='visivel').filter(filtro).distinct()[:3])

    if resultados:
        HelpSearchLog.objects.create(query=query[:300], matched_content=resultados[0], store=store)
        return {
            'encontrou': True,
            'resultados': [
                {
                    'id': r.id, 'tipo': r.tipo, 'titulo': r.titulo,
                    'resumo': (r.corpo[:140] + '…') if len(r.corpo) > 140 else r.corpo,
                    'video_url': r.video_url,
                }
                for r in resultados
            ],
        }

    HelpSearchLog.objects.create(query=query[:300], matched_content=None, store=store)
    conv = SupportConversation.objects.create(
        store=store, category='question', subject=query[:200], status='escalated',
    )
    SupportMessage.objects.create(conversation=conv, sender='user', content=query)
    mensagem_escalada = 'Não encontrei nada sobre isso na Central de Ajuda — já encaminhei pra nossa equipe, elas te respondem por aqui 💜'
    SupportMessage.objects.create(conversation=conv, sender='ai', content=mensagem_escalada)
    return {'encontrou': False, 'resultados': [], 'conversation_id': str(conv.id), 'mensagem': mensagem_escalada}


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def help_search(request):
    """
    POST /api/chat/help-search/ — MANTIDO por compatibilidade (nada mais
    chama, desde que o chat virou único/sem menu — ver chat_unified
    abaixo), mas não removido: não custa nada deixar funcionando.
    """
    store = get_current_store(request.user)
    if not store:
        return Response({'error': 'Nenhuma loja associada a este usuário.'}, status=status.HTTP_400_BAD_REQUEST)

    query = (request.data.get('query') or '').strip()
    if not query:
        return Response({'error': 'query não pode ser vazia.'}, status=status.HTTP_400_BAD_REQUEST)

    resultado = _buscar_ou_escalar(query, store)
    resultado.pop('mensagem', None)
    return Response(resultado)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def chat_unified(request):
    """
    POST /api/chat/unified/
    Body: {"message": "...", "history": [...], "conversation_id": null | "uuid"}

    O ÚNICO endpoint que o ChatAssistant.tsx chama agora — sem menu, sem a
    consultora escolher "consultar" ou "ajuda" antes. A ordem de decisão:

    0. Se a mensagem pede humano EXPLICITAMENTE ("falar com atendente",
       etc.), escala direto — sem tentar mais nada antes. Só a exceção
       genuína (a IA não sabe responder) ou o pedido explícito escalam;
       tudo o mais, a IA tenta responder de verdade.
    1. Se já existe conversation_id (a conversa já foi escalada nesta
       sessão), a mensagem vai direto pra ela — nunca tenta mais nada, a
       consultora já está falando com gente.
    2. Senão, tenta responder como CONSULTA de dados da própria loja
       (query_database_with_llm, o roteador de sempre da Amorinha).
    3. Se a resposta for EXATAMENTE FORA_DO_ESCOPO_MSG (o sinal de "isso
       não é sobre estoque/vendas"), cai pro modo AJUDA: a IA tenta
       responder com base na Central de Ajuda, e só escala pra humano se
       genuinamente não achar nada (a exceção, não a regra).
    """
    from inventory.views import has_consent_for_purpose
    from .services import query_database_with_llm, FORA_DO_ESCOPO_MSG

    store = get_current_store(request.user)
    if not store:
        return Response({'error': 'Nenhuma loja associada a este usuário.'}, status=status.HTTP_400_BAD_REQUEST)

    mensagem = (request.data.get('message') or '').strip()[:500]
    if not mensagem:
        return Response({'error': 'message não pode ser vazia.'}, status=status.HTTP_400_BAD_REQUEST)

    conversation_id = request.data.get('conversation_id')

    # ⚠️ NOVO: pedido EXPLÍCITO de humano — checado antes de qualquer outra
    # coisa (não gasta chamada de IA pra reconhecer isso, é rápido e
    # determinístico). Só entra aqui numa conversa NOVA (sem
    # conversation_id ainda) — se já está escalada, a mensagem já vai
    # direto pra lá de qualquer jeito, não precisa checar de novo.
    if not conversation_id and _pede_humano_explicitamente(mensagem):
        store = get_current_store(request.user)
        if not store:
            return Response({'error': 'Nenhuma loja associada a este usuário.'}, status=status.HTTP_400_BAD_REQUEST)
        conv = SupportConversation.objects.create(
            store=store, category='question', subject=mensagem[:200], status='escalated',
        )
        SupportMessage.objects.create(conversation=conv, sender='user', content=mensagem)
        mensagem_escalada = 'Claro, já te encaminhei pra nossa equipe — elas te respondem por aqui 💜'
        SupportMessage.objects.create(conversation=conv, sender='ai', content=mensagem_escalada)
        return Response({'tipo': 'escalado', 'conversation_id': str(conv.id), 'resposta': mensagem_escalada})

    if conversation_id:
        conv = SupportConversation.objects.filter(id=conversation_id, store=store).first()
        if not conv:
            return Response({'error': 'Conversa não encontrada.'}, status=status.HTTP_404_NOT_FOUND)
        SupportMessage.objects.create(conversation=conv, sender='user', content=mensagem)
        # Se ainda estiver com a Amorinha (raro chegar aqui assim, mas
        # possível), tenta responder; senão só registra pra equipe ver.
        if conv.status == 'ai_handling':
            resultado_busca = _buscar_ou_escalar(mensagem, store)
            if resultado_busca['encontrou']:
                # ⚠️ _buscar_ou_escalar agora pode devolver dois formatos:
                # {'resposta', 'fontes'} quando a IA entendeu e sintetizou
                # (caminho novo), ou {'resultados'} quando caiu no respaldo
                # por palavra-chave (Groq fora do ar, por exemplo). Repassa
                # só as chaves que existirem.
                payload = {'tipo': 'ajuda_encontrada', 'conversation_id': str(conv.id)}
                payload.update({k: v for k, v in resultado_busca.items() if k in ('resposta', 'fontes', 'resultados')})
                return Response(payload)
        return Response({
            'tipo': 'escalado', 'conversation_id': str(conv.id),
            'resposta': 'Recebido — a equipe te responde por aqui assim que possível 💜',
        })

    history = request.data.get('history')
    history = history[-6:] if isinstance(history, list) else []

    if not has_consent_for_purpose(request.user, 'ai_features'):
        return Response(
            {'error': 'É necessário consentir com o uso de recursos de IA (Amorinha) para usar o assistente.'},
            status=status.HTTP_403_FORBIDDEN,
        )

    resposta_consulta = query_database_with_llm(mensagem, store, history=history)

    if resposta_consulta != FORA_DO_ESCOPO_MSG:
        return Response({'tipo': 'consulta', 'resposta': resposta_consulta})

    # Não era sobre estoque/vendas da loja — tenta a Central de Ajuda.
    resultado = _buscar_ou_escalar(mensagem, store)
    if resultado['encontrou']:
        payload = {'tipo': 'ajuda_encontrada'}
        payload.update({k: v for k, v in resultado.items() if k in ('resposta', 'fontes', 'resultados')})
        return Response(payload)

    return Response({
        'tipo': 'escalado', 'conversation_id': resultado['conversation_id'],
        'resposta': resultado['mensagem'],
    })