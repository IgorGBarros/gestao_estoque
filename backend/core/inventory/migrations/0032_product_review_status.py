from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('inventory', '0031_systemconfig_video_apresentacao_url'),
    ]

    operations = [
        migrations.AddField(
            model_name='product',
            name='review_status',
            field=models.CharField(
                choices=[('aprovado', 'Aprovado'), ('aguardando', 'Aguardando revisão'), ('rejeitado', 'Rejeitado')],
                default='aprovado',
                help_text="'aprovado' = aparece no catálogo; 'aguardando' = criado por consultora, aguarda revisão do admin.",
                max_length=20,
            ),
        ),
    ]
