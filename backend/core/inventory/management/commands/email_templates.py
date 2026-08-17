# inventory/management/commands/email_templates.py
#
# Textos dos e-mails de contato — separado num módulo próprio pra ficar
# fácil adicionar mais roteiros depois (upgrade pago, aviso de trial
# acabando, etc.) sem bagunçar o comando de envio.

TEMPLATES = {
    "checkin": {
        "assunto": "Como está sendo usar o Minha Amora?",
        "corpo_texto": (
            "Oi {nome}!\n\n"
            "Aqui é o Igor, do Minha Amora.\n\n"
            "Quis passar pra saber como está sendo usar o sistema até agora. "
            "Teve alguma dificuldade, alguma coisa que travou ou que não "
            "ficou clara?\n\n"
            "Se precisar de qualquer ajuda — desde uma dúvida boba até algo "
            "mais chato — é só responder este e-mail que eu te ajudo.\n\n"
            "Um abraço,\nIgor"
        ),
        "corpo_html": (
            "<p>Oi {nome}!</p>"
            "<p>Aqui é o Igor, do Minha Amora.</p>"
            "<p>Quis passar pra saber como está sendo usar o sistema até agora. "
            "Teve alguma dificuldade, alguma coisa que travou ou que não "
            "ficou clara?</p>"
            "<p>Se precisar de qualquer ajuda — desde uma dúvida boba até algo "
            "mais chato — é só responder este e-mail que eu te ajudo.</p>"
            "<p>Um abraço,<br>Igor</p>"
        ),
    },
    # ⚠️ NOVO: mesmos dois campos que o ProfileCompletionBanner.tsx já
    # verifica dentro do sistema (Nome e WhatsApp) — texto e lista de
    # campos faltando são personalizados por pessoa, {campos} muda
    # conforme o que cada uma especificamente ainda não preencheu.
    "completar_perfil": {
        "assunto": "Falta só um passo rápido no seu Minha Amora",
        "corpo_texto": (
            "Oi {nome}!\n\n"
            "Reparei que seu cadastro no Minha Amora ainda está com uma "
            "informação faltando: {campos}.\n\n"
            "É rapidinho — entra em Perfil (dentro do sistema) e preenche "
            "isso, leva menos de 1 minuto.\n\n"
            "Sem essa informação, algumas coisas do sistema não funcionam "
            "direito pra você — por isso quis avisar.\n\n"
            "Qualquer dúvida, é só responder este e-mail.\n\n"
            "Um abraço,\nIgor"
        ),
        "corpo_html": (
            "<p>Oi {nome}!</p>"
            "<p>Reparei que seu cadastro no Minha Amora ainda está com uma "
            "informação faltando: <b>{campos}</b>.</p>"
            "<p>É rapidinho — entra em <b>Perfil</b> (dentro do sistema) e "
            "preenche isso, leva menos de 1 minuto.</p>"
            "<p>Sem essa informação, algumas coisas do sistema não funcionam "
            "direito pra você — por isso quis avisar.</p>"
            "<p>Qualquer dúvida, é só responder este e-mail.</p>"
            "<p>Um abraço,<br>Igor</p>"
        ),
    },
}
