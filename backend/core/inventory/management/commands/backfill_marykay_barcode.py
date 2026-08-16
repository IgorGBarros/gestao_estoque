from django.core.management.base import BaseCommand
from django.db.models import Q
from inventory.models import Product


class Command(BaseCommand):
    help = (
        'Preenche bar_code com o SKU pra produto Mary Kay já cadastrado antes '
        'da correção — essa marca não tem código de barras físico, o SKU já '
        'descoberto no site é o único identificador que existe.'
    )

    def add_arguments(self, parser):
        parser.add_argument(
            '--apply', action='store_true',
            help='Grava de verdade no banco. Sem esta flag, só mostra o que faria (modo seguro, padrão).',
        )

    def handle(self, *args, **options):
        aplicar = options['apply']

        candidatos = Product.objects.filter(
            brand='Mary Kay', natura_sku__isnull=False
        ).filter(Q(bar_code__isnull=True) | Q(bar_code=''))

        total = candidatos.count()
        self.stdout.write(self.style.WARNING(f"📊 Produtos Mary Kay sem bar_code: {total}"))

        if total == 0:
            self.stdout.write(self.style.SUCCESS("Nada pra fazer — já está tudo preenchido."))
            return

        preenchidos = 0
        pulados_colisao = 0

        for produto in candidatos:
            sku = produto.natura_sku
            # ⚠️ Mesma proteção do crawler — bar_code é único no banco;
            # não sobrescreve nem quebra se, por coincidência rara, já
            # existir outro produto (de outra marca) com esse valor.
            colide = Product.objects.filter(bar_code=sku).exclude(id=produto.id).exists()
            if colide:
                pulados_colisao += 1
                self.stdout.write(f"  ⚠️  Pulado (colisão): {produto.name[:50]!r} (SKU {sku})")
                continue

            preenchidos += 1
            acao = "preenchido" if aplicar else "seria preenchido (dry-run)"
            self.stdout.write(f"  ✅ [{acao}] {produto.name[:50]!r} → bar_code={sku}")
            if aplicar:
                produto.bar_code = sku
                produto.save(update_fields=['bar_code'])

        self.stdout.write("")
        self.stdout.write(self.style.SUCCESS(f"Preenchidos: {preenchidos} | Pulados por colisão: {pulados_colisao}"))

        if not aplicar and preenchidos > 0:
            self.stdout.write("")
            self.stdout.write(self.style.WARNING(
                "⚠️ Modo dry-run — nada foi gravado. Rode de novo com --apply pra aplicar de verdade."
            ))
