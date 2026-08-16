import secrets
import string
import unicodedata
from django.core.management.base import BaseCommand
from inventory.models import ReferralCode, Store


def gerar_codigo_legivel(nome: str) -> str:
    """
    Código curto e memorável baseado no nome — mais fácil de passar por
    mensagem de voz/WhatsApp do que uma string aleatória (ex: "MARIA7X2").
    Sem acento de propósito — nome como "José" não pode virar código
    difícil de digitar certo depois.
    """
    nome_sem_acento = unicodedata.normalize('NFKD', nome).encode('ascii', 'ignore').decode('ascii')
    base = "".join(c for c in nome_sem_acento.upper() if c.isalpha())[:6] or "AMIGA"
    sufixo = "".join(secrets.choice(string.digits) for _ in range(3))
    return f"{base}{sufixo}"


class Command(BaseCommand):
    help = (
        'Cria um código de indicação pra uma pessoa específica que você escolheu '
        'convidar — não é um programa aberto, é individual, um código por convidada.'
    )

    def add_arguments(self, parser):
        parser.add_argument('--nome', required=True, help='Nome da pessoa (ex: "Maria Líder")')
        parser.add_argument(
            '--indicado-por-email', required=False,
            help='E-mail da loja de quem está indicando (ex: sua esposa) — recebe o bônus quando o código for usado.',
        )
        parser.add_argument('--dias-teste', type=int, default=30, help='Dias de teste pra quem usar o código (padrão: 30)')
        parser.add_argument('--dias-bonus-indicadora', type=int, default=7, help='Dias extras pra quem indicou (padrão: 7)')
        parser.add_argument('--limite-usos', type=int, default=1, help='Quantas vezes esse código pode ser usado (padrão: 1)')

    def handle(self, *args, **options):
        nome = options['nome']
        email_indicadora = options.get('indicado_por_email')
        dias_teste = options['dias_teste']
        dias_bonus = options['dias_bonus_indicadora']
        limite = options['limite_usos']

        loja_indicadora = None
        if email_indicadora:
            loja_indicadora = Store.objects.filter(owner__email=email_indicadora).first()
            if not loja_indicadora:
                self.stdout.write(self.style.ERROR(f"❌ Não achei nenhuma loja com o e-mail '{email_indicadora}'."))
                return

        codigo = gerar_codigo_legivel(nome)
        # Garante que não colidiu com um código já existente (raro, mas possível).
        while ReferralCode.objects.filter(code=codigo).exists():
            codigo = gerar_codigo_legivel(nome)

        ref = ReferralCode.objects.create(
            code=codigo,
            label=nome,
            referrer_store=loja_indicadora,
            bonus_trial_days=dias_teste,
            referrer_bonus_days=dias_bonus,
            max_uses=limite,
        )

        self.stdout.write(self.style.SUCCESS(f"✅ Código criado: {ref.code}"))
        self.stdout.write(f"   Pra: {nome}")
        self.stdout.write(f"   Teste de {dias_teste} dias (em vez do padrão)")
        if loja_indicadora:
            self.stdout.write(f"   Indicada por: {loja_indicadora.name} (ganha +{dias_bonus} dias quando o código for usado)")
        self.stdout.write(f"   Pode ser usado {limite}x")
        self.stdout.write("")
        self.stdout.write(self.style.WARNING(f"   Passe pra {nome}: \"{ref.code}\""))
