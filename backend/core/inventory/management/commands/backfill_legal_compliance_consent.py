from django.core.management.base import BaseCommand
from inventory.models import ConsentRecord


class Command(BaseCommand):
    help = (
        'Corrige consentimentos ativos que ficaram sem "legal_compliance" por causa '
        'de um bug no frontend (ESSENTIAL_PURPOSES estava incompleto lá, faltando '
        'essa finalidade) — sem isso, o modal de consentimento reaparecia pra quem '
        'já tinha aceitado, porque o aceite registrado nunca incluía essa finalidade.'
    )

    def add_arguments(self, parser):
        parser.add_argument(
            '--apply', action='store_true',
            help='Grava de verdade no banco. Sem esta flag, só mostra o que faria (modo seguro, padrão).',
        )

    def handle(self, *args, **options):
        aplicar = options['apply']

        afetados = ConsentRecord.objects.filter(revoked_at__isnull=True)
        corrigidos = 0

        for consent in afetados:
            purposes = consent.purpose_flags or []
            if 'legal_compliance' not in purposes:
                corrigidos += 1
                acao = "corrigido" if aplicar else "seria corrigido (dry-run)"
                self.stdout.write(f"  ✅ [{acao}] Consentimento #{consent.id} (usuário {consent.user_id})")
                if aplicar:
                    consent.purpose_flags = [*purposes, 'legal_compliance']
                    consent.save(update_fields=['purpose_flags'])

        self.stdout.write("")
        self.stdout.write(self.style.SUCCESS(f"Consentimentos ativos verificados: {afetados.count()}"))
        self.stdout.write(self.style.SUCCESS(f"Corrigidos (já tinham tudo, menos legal_compliance): {corrigidos}"))

        if not aplicar and corrigidos > 0:
            self.stdout.write("")
            self.stdout.write(self.style.WARNING(
                "⚠️ Modo dry-run — nada foi gravado. Rode de novo com --apply pra aplicar de verdade."
            ))
