from django.core.management.base import BaseCommand
from django.core.mail import send_mail
from django.conf import settings
from inventory.models import Store, EmailEnviado
from inventory.email_templates import TEMPLATES
from inventory.contato_utils import (
    quem_falta_whatsapp, quem_tem_campo_faltando, campos_faltando, nome_para_saudacao,
)


FILTRO_POR_TEMPLATE = {
    "checkin": quem_falta_whatsapp,
    "completar_perfil": quem_tem_campo_faltando,
}


class Command(BaseCommand):
    help = 'Manda o e-mail de um dos roteiros pra quem se encaixa no público daquele roteiro.'

    def add_arguments(self, parser):
        parser.add_argument(
            '--template', default='checkin', choices=list(TEMPLATES.keys()),
            help='Qual roteiro mandar (padrão: checkin).',
        )
        parser.add_argument(
            '--apply', action='store_true',
            help='Manda de verdade. Sem esta flag, só mostra pra quem mandaria (modo seguro, padrão).',
        )

    def handle(self, *args, **options):
        template_key = options['template']
        aplicar = options['apply']
        template = TEMPLATES[template_key]

        ja_enviados = set(
            EmailEnviado.objects.filter(template=template_key).values_list('store_id', flat=True)
        )
        base = Store.objects.filter(owner__isnull=False).exclude(id__in=ja_enviados)
        candidatas = FILTRO_POR_TEMPLATE[template_key](base)

        total = candidatas.count()
        self.stdout.write(self.style.WARNING(f"📧 Roteiro: '{template_key}' | Destinatárias: {total}"))

        if total == 0:
            self.stdout.write(self.style.SUCCESS("Nada pra fazer — ninguém pendente pra esse roteiro."))
            return

        enviados = 0
        for store in candidatas:
            nome = nome_para_saudacao(store)
            email_destino = store.owner.email
            extras = {"campos": " e ".join(campos_faltando(store))} if template_key == "completar_perfil" else {}
            corpo = template['corpo_texto'].format(nome=nome, **extras)

            acao = "enviado" if aplicar else "seria enviado (dry-run)"
            detalhe = f" | faltando: {extras['campos']}" if extras.get('campos') else ""
            self.stdout.write(f"  ✅ [{acao}] {nome} <{email_destino}>{detalhe}")

            if aplicar:
                send_mail(
                    subject=template['assunto'],
                    message=corpo,
                    from_email=settings.DEFAULT_FROM_EMAIL,
                    recipient_list=[email_destino],
                    html_message=template['corpo_html'].format(nome=nome, **extras),
                    fail_silently=False,
                )
                EmailEnviado.objects.create(store=store, template=template_key)
                enviados += 1

        self.stdout.write("")
        self.stdout.write(self.style.SUCCESS(f"Total processado: {enviados if aplicar else total}"))

        if not aplicar:
            self.stdout.write(self.style.WARNING(
                "⚠️ Modo dry-run — nada foi enviado. Rode de novo com --apply pra mandar de verdade."
            ))
