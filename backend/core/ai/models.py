import uuid

from django.db import models


class SupportConversation(models.Model):
    """
    Uma conversa de suporte — dúvida ou reporte de erro. A Amorinha tenta
    responder primeiro nas dúvidas; reportes de erro já nascem escalados,
    porque IA não conserta bug, só pode reconhecer e encaminhar.
    """
    CATEGORY_CHOICES = [
        ('question', 'Dúvida'),
        ('bug', 'Reporte de erro'),
    ]
    STATUS_CHOICES = [
        ('ai_handling', 'Amorinha respondendo'),
        ('escalated', 'Aguardando equipe'),
        ('resolved', 'Resolvida'),
        ('closed', 'Encerrada'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    store = models.ForeignKey('inventory.Store', on_delete=models.CASCADE, related_name='support_conversations')
    category = models.CharField(max_length=20, choices=CATEGORY_CHOICES, default='question')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='ai_handling')
    # Preenchido pela consultora ao abrir a conversa — dá contexto pro
    # admin sem precisar abrir e ler a conversa inteira pra saber do que se
    # trata.
    subject = models.CharField(max_length=200, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-updated_at']

    def __str__(self):
        return f"{self.get_category_display()} — {self.store.name} ({self.get_status_display()})"


class SupportMessage(models.Model):
    SENDER_CHOICES = [
        ('user', 'Consultora'),
        ('ai', 'Amorinha'),
        ('admin', 'Equipe'),
    ]

    conversation = models.ForeignKey(SupportConversation, on_delete=models.CASCADE, related_name='messages')
    sender = models.CharField(max_length=10, choices=SENDER_CHOICES)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']

    def __str__(self):
        return f"[{self.sender}] {self.content[:50]}"


class TutorialVideo(models.Model):
    """
    Vídeo tutorial gerenciado pelo admin — o vídeo em si fica hospedado
    fora (YouTube, provavelmente), aqui só guarda o link e os metadados de
    exibição pra consultora.
    """
    title = models.CharField(max_length=150)
    description = models.TextField(blank=True)
    video_url = models.URLField()
    # Livre, não um enum fechado — o admin organiza como fizer sentido pro
    # próprio catálogo de vídeos (ex: "Estoque", "Vendas", "Vitrine").
    category = models.CharField(max_length=50, blank=True)
    sort_order = models.IntegerField(default=0)
    is_visible = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['sort_order', '-created_at']

    def __str__(self):
        return self.title