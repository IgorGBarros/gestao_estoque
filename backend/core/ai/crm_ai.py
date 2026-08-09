# backend/core/ai/crm_ai.py
"""
Amorinha sugerindo conteúdo de mensagem no CRM — baseada no comportamento
REAL de cada cliente (histórico de compras), não em texto genérico. Reusa
o mesmo cliente Groq de ai/services.py.

Cobre os 5 tipos de template que já existem em lib/whatsapp.ts (frontend):
welcome, abandoned_cart, birthday, promotion, custom — a IA sugere as
variáveis {product}/{discount} e, pro "custom", o corpo da mensagem
inteiro.
"""
import json
import logging
from collections import Counter

from .services import _get_client, _strip_llm_noise, GROQ_MODEL

logger = logging.getLogger(__name__)

PROMPT_SISTEMA = """Você é a Amorinha, ajudando uma consultora de venda direta (Natura,
Boticário, Avon, Mary Kay) a personalizar uma mensagem de WhatsApp pra uma
cliente específica, com base no que essa cliente já comprou.

Regras:
- Sugira algo ESPECÍFICO baseado no comportamento real informado — nunca
  genérico tipo "produtos incríveis".
- Pra promoção: sugira o produto que ela mais compra (já informado) e um
  desconto razoável (10-20%, nunca invente um valor absurdo).
- Pro corpo da mensagem (quando pedido): tom acolhedor, direto, no máximo
  3 frases, sempre em português. Nunca prometa prazo de entrega nem fale
  em nome de terceiros.
- Se não houver dado de compra suficiente (cliente nova, sem histórico),
  diga isso explicitamente no campo "observacao" e sugira algo mais
  genérico de boas-vindas, sem inventar comportamento que não existe.

Responda APENAS com um JSON, sem markdown, neste formato exato:
{"product": "nome do produto ou null", "discount": "ex: 15%OFF ou null", "message": "corpo sugerido ou null", "observacao": "nota curta pra consultora, ou null"}
"""


def _comportamento_lead(historico_compras: list) -> dict:
    """
    Resume o comportamento de compra de um lead a partir do
    purchase_history já calculado em crm_lead_detail — sem refazer a
    consulta ao banco, só reaproveitando o que a view já montou.
    """
    if not historico_compras:
        return {"tem_historico": False}

    contagem_produtos = Counter()
    total_gasto = 0
    for pedido in historico_compras:
        for item in pedido.get("items", []):
            contagem_produtos[item["product_name"]] += item["quantity"]
        total_gasto += pedido.get("total", 0)

    produto_mais_comprado = contagem_produtos.most_common(1)
    return {
        "tem_historico": True,
        "produto_mais_comprado": produto_mais_comprado[0][0] if produto_mais_comprado else None,
        "quantidade_desse_produto": produto_mais_comprado[0][1] if produto_mais_comprado else 0,
        "total_pedidos": len(historico_compras),
        "total_gasto": round(total_gasto, 2),
    }


def sugerir_mensagem(nome_lead: str, template_key: str, historico_compras: list) -> dict:
    """
    Retorna {"product", "discount", "message", "observacao"} — cada campo
    pode vir None se não fizer sentido pro tipo de template pedido.
    """
    comportamento = _comportamento_lead(historico_compras)

    contexto = f"Cliente: {nome_lead}\nTipo de mensagem pedida: {template_key}\n"
    if comportamento["tem_historico"]:
        contexto += (
            f"Produto que mais compra: {comportamento['produto_mais_comprado']} "
            f"({comportamento['quantidade_desse_produto']} unidades no total)\n"
            f"Total de pedidos: {comportamento['total_pedidos']}\n"
            f"Total gasto: R$ {comportamento['total_gasto']}\n"
        )
    else:
        contexto += "Sem histórico de compras ainda (cliente nova ou só visitou a vitrine).\n"

    try:
        resposta = _get_client().chat.completions.create(
            model=GROQ_MODEL,
            messages=[
                {"role": "system", "content": PROMPT_SISTEMA},
                {"role": "user", "content": contexto},
            ],
            temperature=0.6,
            max_tokens=300,
        )
        texto = _strip_llm_noise(resposta.choices[0].message.content or "")
        dados = json.loads(texto)
        return {
            "product": dados.get("product"),
            "discount": dados.get("discount"),
            "message": dados.get("message"),
            "observacao": dados.get("observacao"),
        }
    except Exception as e:
        logger.warning(f"[CRM AI] Falha ao sugerir mensagem: {type(e).__name__}: {e}")
        # Fallback sem IA: pelo menos o produto mais comprado, calculado
        # localmente — não deixa a consultora sem nada só porque o Groq
        # falhou nesse momento.
        return {
            "product": comportamento.get("produto_mais_comprado"),
            "discount": None,
            "message": None,
            "observacao": "Não consegui gerar uma sugestão completa agora — tente de novo em instantes.",
        }
