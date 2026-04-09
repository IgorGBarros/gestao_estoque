# inventory/management/commands/setup_plan_configs.py
from django.core.management.base import BaseCommand
from inventory.models import PlanConfig
from decimal import Decimal

class Command(BaseCommand):
    help = 'Cria configurações iniciais de planos'

    def handle(self, *args, **options):
        # Plano Free
        free_plan, created = PlanConfig.objects.get_or_create(
            plan_type='free',
            defaults={
                'display_name': 'Free',
                'description': 'Para começar a organizar seu estoque',
                'max_products': 20,
                'can_use_scanner': True,
                'can_use_storefront': False,
                'can_use_alerts': False,
                'can_use_ai_assistant': False,
                'can_use_analytics': False,
                'monthly_price': Decimal('0.00'),
                'yearly_price': Decimal('0.00'),
                'highlight_color': '#6B7280',
                'is_popular': False,
                'is_visible': True,
                'sort_order': 1
            }
        )
        
        if created:
            self.stdout.write(
                self.style.SUCCESS(f'✅ Plano Free criado')
            )
        else:
            self.stdout.write(f'⚠️ Plano Free já existe')

        # Plano Pro
        pro_plan, created = PlanConfig.objects.get_or_create(
            plan_type='pro',
            defaults={
                'display_name': 'PRO',
                'description': 'Recursos completos para crescer suas vendas',
                'max_products': None,  # Ilimitado
                'can_use_scanner': True,
                'can_use_storefront': True,
                'can_use_alerts': True,
                'can_use_ai_assistant': True,
                'can_use_analytics': True,
                'monthly_price': Decimal('39.90'),
                'yearly_price': Decimal('399.00'),
                'highlight_color': '#3B82F6',
                'is_popular': True,
                'is_visible': True,
                'sort_order': 2
            }
        )
        
        if created:
            self.stdout.write(
                self.style.SUCCESS(f'✅ Plano PRO criado')
            )
        else:
            self.stdout.write(f'⚠️ Plano PRO já existe')

        self.stdout.write(
            self.style.SUCCESS(f'\n🎉 Configuração de planos concluída!')
        )