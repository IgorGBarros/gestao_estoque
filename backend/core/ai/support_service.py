# backend/core/ai/support_service.py
"""
Amorinha no papel de suporte — tenta responder dúvida de "como fazer X" no
sistema, e sabe quando NÃO tentar: reporte de erro nunca é respondido por
IA (ela não conserta bug), só reconhecido e encaminhado pra equipe.

Reaproveita o mesmo cliente Groq de ai/services.py — é o mesmo modelo,
outro prompt, outro trabalho.
"""
import json
import logging

from .services import _get_client, _strip_llm_noise, GROQ_MODEL

logger = logging.getLogger(__name__)

# Conhecimento do sistema que a Amorinha usa pra responder dúvida de uso —
# não é exaustivo, é o suficiente pra cobrir as perguntas mais comuns sem
# arriscar inventar informação sobre parte que ela não conhece bem.
CONHECIMENTO_SISTEMA = """
O Minha Amora é um sistema de gestão para consultoras de venda direta
(Natura, Boticário, Avon, Mary Kay e outras). Principais áreas:

- Estoque: cadastro de produto, entrada/saída, código de barras, alerta de
  validade (recurso PRO).
- Ajustar Saldo: só serve pra corrigir a quantidade pra BAIXO, quando a
  consultora errou pra mais no cadastro. Errou pra menos? Não precisa
  ajustar — só cadastra a unidade que faltou de novo. Todo ajuste pede uma
  justificativa.
- Vendas: registro de venda, relatório de vendas por período.
- Vitrine (Storefront): link público pra cliente final ver e pedir
  produtos, com carrinho e checkout (recurso PRO).
- CRM: lista de clientes que interagiram com a vitrine, histórico de
  compra, aniversário, sugestão de mensagem pela própria Amorinha.
- Amorinha (este assistente): responde pergunta sobre estoque/vendas
  dentro do próprio sistema, e sugere mensagem no CRM.
- Planos: Free (funcionalidade básica) e PRO (vitrine, IA, relatórios
  avançados) — tem 14 dias de teste PRO grátis pra quem acabou de se
  cadastrar.
- Perfil/Configurações: dados da loja, WhatsApp de contato, tema.
"""

PROMPT_SISTEMA = f"""Você é a Amorinha, respondendo dúvidas de suporte de consultoras que usam
o Minha Amora — não dúvida sobre estoque/vendas DELAS (isso é outra
função sua), aqui é dúvida sobre COMO USAR o sistema em si.

{CONHECIMENTO_SISTEMA}

Regras:
- Se a pergunta é sobre como usar uma funcionalidade do sistema e você tem
  informação suficiente pra responder com segurança, responda de forma
  curta e direta (2-4 frases), em português, tom acolhedor.
- Se a pergunta pede algo que você não tem informação suficiente pra
  responder com segurança, ou pede uma ação que só a equipe pode fazer
  (reembolso, mudança de plano, dado de outra consultora), NÃO invente —
  marque para escalar.
- Nunca prometa prazo, nunca fale em nome da equipe, nunca peça dado
  sensível (senha, cartão).

Responda APENAS com um JSON, neste formato exato, sem markdown:
{{"pode_responder": true, "resposta": "..."}}
ou
{{"pode_responder": false, "motivo": "breve motivo pra equipe entender por que precisou escalar"}}
"""


def tentar_responder_duvida(mensagem: str, historico: list) -> dict:
    """
    Retorna {"pode_responder": bool, "resposta": str} — se pode_responder é
    False, quem chama decide escalar (não tenta de novo com outro prompt;
    uma tentativa de escalada mal-sucedida vira ruído, não valor).
    """
    mensagens = [{"role": "system", "content": PROMPT_SISTEMA}]
    # Só as últimas trocas, mesmo motivo do roteador da Amorinha principal:
    # dar contexto pra pergunta de seguimento sem deixar o prompt crescer
    # sem limite numa conversa longa.
    for troca in (historico or [])[-4:]:
        if troca.get("sender") == "user":
            mensagens.append({"role": "user", "content": str(troca.get("content", ""))[:500]})
        elif troca.get("sender") == "ai":
            mensagens.append({"role": "assistant", "content": str(troca.get("content", ""))[:500]})
    mensagens.append({"role": "user", "content": mensagem[:500]})

    try:
        resposta = _get_client().chat.completions.create(
            model=GROQ_MODEL,
            messages=mensagens,
            temperature=0.3,
            max_tokens=400,
        )
        texto = _strip_llm_noise(resposta.choices[0].message.content or "")
        dados = json.loads(texto)
        if dados.get("pode_responder") and dados.get("resposta"):
            return {"pode_responder": True, "resposta": str(dados["resposta"])[:1000]}
        return {"pode_responder": False, "motivo": dados.get("motivo", "Amorinha não conseguiu responder com segurança.")}
    except Exception as e:
        logger.warning(f"[SUPPORT AI] Falha ao tentar responder: {type(e).__name__}: {e}")
        # Erro de infraestrutura (Groq fora, JSON malformado, etc.) — sempre
        # escala, nunca deixa a consultora sem resposta nenhuma.
        return {"pode_responder": False, "motivo": "Erro técnico ao tentar responder automaticamente."}
