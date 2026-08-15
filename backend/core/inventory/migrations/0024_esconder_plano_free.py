from django.db import migrations


def esconder_plano_free_da_listagem_publica(apps, schema_editor):
    """
    'free' agora representa um ESTADO ("teste de 14 dias acabou, sem
    assinar"), não uma oferta que alguém escolhe ativamente — não faz
    sentido continuar aparecendo em /api/plans/ como se fosse uma opção
    ao lado do PRO. A pessoa nunca "assina" o free; ela cai nele.
    """
    PlanConfig = apps.get_model('inventory', 'PlanConfig')
    PlanConfig.objects.filter(plan_type='free').update(is_visible=False)


def reverter(apps, schema_editor):
    PlanConfig = apps.get_model('inventory', 'PlanConfig')
    PlanConfig.objects.filter(plan_type='free').update(is_visible=True)


class Migration(migrations.Migration):

    dependencies = [
        ('inventory', '0023_plano_free_sem_produto_novo'),
    ]

    operations = [
        migrations.RunPython(esconder_plano_free_da_listagem_publica, reverter),
    ]
