# inventory/whatsapp_templates.py
#
# Roteiros de WhatsApp — texto puro (sem HTML, o app não renderiza).
# Mesmo padrão do email_templates.py, mas aqui o "envio" não é
# automático: o WhatsApp não tem uma API simples de mandar mensagem sem
# conta Business paga. O que dá pra fazer é abrir o wa.me com o texto já
# preenchido — a pessoa só confirma o envio, sem digitar nada.

TEMPLATES = {
    "checkin": (
        "Oi {nome}! Tudo bem? Aqui é o Igor, do Minha Amora.\n\n"
        "Quis passar pra saber como está sendo usar o sistema até agora. "
        "Teve alguma dificuldade, alguma coisa que travou ou que não "
        "ficou clara?\n\n"
        "Se precisar de qualquer ajuda — desde uma dúvida boba até algo "
        "mais chato — me chama aqui mesmo, sem cerimônia."
    ),
    "completar_perfil": (
        "Oi {nome}! Reparei que seu cadastro no Minha Amora ainda está "
        "com uma informação faltando: {campos}.\n\n"
        "É rapidinho — entra em Perfil (dentro do sistema) e preenche "
        "isso, leva menos de 1 minuto. Sem essa informação, algumas "
        "coisas do sistema não funcionam direito pra você."
    ),
}