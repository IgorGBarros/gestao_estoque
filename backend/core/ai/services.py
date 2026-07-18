"""
Serviço de IA (Amorinha) — respostas sobre estoque e vendas da loja.

CORREÇÃO DE SEGURANÇA (P0):
Antes, este arquivo deixava o LLM escrever SQL livre e executava direto no
Postgres (`SQLDatabase.from_uri` + `db.run(clean_sql)`), sem filtrar por loja.
Qualquer consultora autenticada podia, em tese, levar o modelo a gerar uma
consulta que lesse dados de OUTRAS consultoras (client_name de vendas,
e-mails de outros usuários, registros de consentimento, etc.), já que a
única validação era "a query começa com SELECT".

Agora o LLM NUNCA gera nem executa SQL. Ele só escolhe, a partir de uma
lista fechada (FUNCOES_PERMITIDAS), qual consulta pré-definida usar e com
quais parâmetros. O `store` é sempre passado pelo código Python (vem de
request.user.store no view), nunca é algo que o modelo decide — portanto
não existe caminho, nem por prompt injection, para vazar dados de outra loja
por aqui.
"""
import json
import logging
import re
from datetime import timedelta

from django.db.models import F, Sum
from django.utils import timezone
from langchain_community.llms import Ollama

from inventory.models import InventoryItem, Sale

logger = logging.getLogger(__name__)

THINK_TAG_RE = re.compile(r"<think>.*?</think>", flags=re.DOTALL | re.IGNORECASE)


def _strip_llm_noise(text: str) -> str:
    """Remove blocos de raciocínio (<think>...</think>, comuns em modelos 'reasoning')
    e cercas de markdown antes de tratar a saída do modelo."""
    text = THINK_TAG_RE.sub("", text or "")
    text = text.replace("```json", "").replace("```", "")
    return text.strip()


# ─────────────────────────────────────────────────────────────────────────
# CAMADA DE DADOS — as únicas consultas que o assistente pode executar.
# Todas recebem `store` explicitamente; o LLM nunca vê nem escolhe o `store`.
# Usam o ORM (parametrizado), nunca SQL cru.
# ─────────────────────────────────────────────────────────────────────────

def _buscar_estoque(store, termo: str = "") -> dict:
    qs = InventoryItem.objects.filter(store=store).select_related("product")
    if termo:
        qs = qs.filter(product__name__icontains=termo[:100])
    itens = list(qs.values("product__name", "total_quantity", "sale_price")[:10])
    return {"itens": itens}


def _valor_total_estoque(store) -> dict:
    total = InventoryItem.objects.filter(store=store).aggregate(
        valor=Sum(F("total_quantity") * F("sale_price"))
    )["valor"] or 0
    return {"valor_total_estoque": float(total)}


def _vendas_periodo(store, dias: int = 30) -> dict:
    dias = max(1, min(int(dias or 30), 365))
    desde = timezone.now() - timedelta(days=dias)
    qs = Sale.objects.filter(store=store, created_at__gte=desde, transaction_type="VENDA")
    total = qs.aggregate(total=Sum("total_amount"))["total"] or 0
    return {"periodo_dias": dias, "quantidade_vendas": qs.count(), "valor_total_vendas": float(total)}


def _produtos_baixo_estoque(store) -> dict:
    itens = list(
        InventoryItem.objects.filter(store=store, total_quantity__lte=F("min_quantity"))
        .select_related("product")
        .values("product__name", "total_quantity", "min_quantity")[:10]
    )
    return {"produtos_baixo_estoque": itens}


# nome_da_ferramenta -> (função, {parâmetro_aceito: conversor_de_tipo})
# Só o que está aqui pode ser chamado; só esses parâmetros são repassados.
FUNCOES_PERMITIDAS = {
    "buscar_estoque": (_buscar_estoque, {"termo": str}),
    "valor_total_estoque": (_valor_total_estoque, {}),
    "vendas_periodo": (_vendas_periodo, {"dias": int}),
    "produtos_baixo_estoque": (_produtos_baixo_estoque, {}),
}

ROUTER_PROMPT = """Você escolhe qual ferramenta usar para responder a pergunta de uma consultora sobre a loja DELA.

Ferramentas disponíveis:
- buscar_estoque(termo): busca produtos no estoque pelo nome. Use termo="" para listar em geral.
- valor_total_estoque(): valor total do estoque atual.
- vendas_periodo(dias): total de vendas nos últimos N dias.
- produtos_baixo_estoque(): produtos abaixo da quantidade mínima.

Responda APENAS com um JSON, sem explicação, sem markdown, exatamente neste formato:
{{"funcao": "nome_da_ferramenta", "argumentos": {{}}}}

Se a pergunta não for sobre estoque, produtos ou vendas da própria loja, responda:
{{"funcao": null, "argumentos": {{}}}}

Pergunta: {question}
"""

EXPLAIN_PROMPT = """Você é a Amorinha, assistente de estoque.
Explique o resultado abaixo em 1-2 frases curtas, naturais, em português.
Se os dados estiverem vazios ou zerados, diga que não encontrou nada.
NÃO invente números que não estão nos dados.

Pergunta: {question}
Dados: {data}

Resposta:
"""


def query_database_with_llm(user_question: str, store) -> str:
    """
    `store`: instância de inventory.models.Store do usuário autenticado.
    Deve vir SEMPRE de request.user.store (no view) — nunca de input do
    usuário ou de algo que o LLM produza.
    """
    if store is None:
        return "Não encontrei uma loja associada à sua conta."

    user_question = (user_question or "").strip()[:500]
    if not user_question:
        return "Pode reformular sua pergunta?"

    try:
        # PASSO 1: o modelo escolhe UMA ferramenta da lista fechada (não SQL)
        llm_router = Ollama(model="deepseek-r1:14b", temperature=0.0, num_ctx=4096)
        raw_route = llm_router.invoke(ROUTER_PROMPT.format(question=user_question))
        clean_route = _strip_llm_noise(raw_route)

        try:
            route = json.loads(clean_route)
        except (json.JSONDecodeError, TypeError):
            match = re.search(r"\{.*\}", clean_route, flags=re.DOTALL)
            route = json.loads(match.group(0)) if match else {}

        funcao_nome = route.get("funcao") if isinstance(route, dict) else None
        argumentos = route.get("argumentos") if isinstance(route, dict) else {}
        argumentos = argumentos if isinstance(argumentos, dict) else {}

        if not funcao_nome or funcao_nome not in FUNCOES_PERMITIDAS:
            return "Desculpe, só posso responder sobre estoque, produtos e vendas da sua loja."

        funcao, parametros_aceitos = FUNCOES_PERMITIDAS[funcao_nome]

        # Só repassa argumentos que estão na allowlist da função, já convertidos.
        # Qualquer coisa fora disso (nome de tabela, outro store_id, etc.) é
        # simplesmente ignorada — o modelo não tem como injetar parâmetros novos.
        kwargs = {}
        for nome_param, conversor in parametros_aceitos.items():
            if nome_param in argumentos:
                try:
                    kwargs[nome_param] = conversor(argumentos[nome_param])
                except (TypeError, ValueError):
                    pass

        # PASSO 2: executa a função real, sempre com o store vindo do código
        dados = funcao(store, **kwargs)

        # PASSO 3: transforma o resultado estruturado em resposta natural
        final_prompt = EXPLAIN_PROMPT.format(question=user_question, data=json.dumps(dados, default=str))
        llm_explain = Ollama(model="deepseek-r1:14b", temperature=0.3, num_ctx=4096)
        raw_answer = llm_explain.invoke(final_prompt)
        final_answer = _strip_llm_noise(raw_answer)

        if len(final_answer) < 5:
            return f"Encontrei o seguinte resultado: {dados}"

        return final_answer

    except Exception:
        logger.exception("Erro no assistente de IA (query_database_with_llm)")
        return "Desculpe, tive um problema técnico ao processar sua pergunta."