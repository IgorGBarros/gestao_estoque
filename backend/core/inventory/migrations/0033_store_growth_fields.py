from django.db import migrations, models


class Migration(migrations.Migration):
    dependencies = [('inventory', '0032_product_review_status')]
    operations = [
        migrations.AddField(model_name='store', name='utm_source',   field=models.CharField(blank=True, default='', max_length=100)),
        migrations.AddField(model_name='store', name='utm_medium',   field=models.CharField(blank=True, default='', max_length=100)),
        migrations.AddField(model_name='store', name='utm_campaign', field=models.CharField(blank=True, default='', max_length=100)),
        migrations.AddField(model_name='store', name='utm_content',  field=models.CharField(blank=True, default='', max_length=100)),
        migrations.AddField(model_name='store', name='activated_at', field=models.DateTimeField(blank=True, null=True)),
    ]
