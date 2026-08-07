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
    ⚠️ MANTIDO por segurança (rollback), mas em desuso a partir da Central
    de Ajuda (HelpContent, abaixo). O admin-panel e a consultora agora
    usam HelpContent com tipo='video' — os registros existentes aqui foram
    copiados pra lá numa migração de dados, não movidos. Não é mais
    escrito por nenhuma tela nova.

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


class HelpContent(models.Model):
    """
    Central de Ajuda — evolução do TutorialVideo pra cobrir mais tipos de
    conteúdo além de vídeo (FAQ, guia passo-a-passo, novidade da
    plataforma). Um único model, um único endpoint de consumo
    (GET /api/ajuda/), consumido tanto pela página de suporte quanto pela
    seção "Aprenda a usar" do profile — e pelas sugestões da Amorinha no
    chat (busca textual em titulo+corpo).
    """
    TIPO_CHOICES = [
        ('video', 'Vídeo'),
        ('faq', 'Pergunta frequente'),
        ('guia', 'Guia'),
        ('novidade', 'Novidade'),
    ]
    STATUS_CHOICES = [
        ('rascunho', 'Rascunho'),
        ('visivel', 'Visível'),
    ]

    tipo = models.CharField(max_length=20, choices=TIPO_CHOICES)
    titulo = models.CharField(max_length=150)
    # Texto do conteúdo em si — obrigatório em faq/guia/novidade (validado
    # na view, não aqui, pra manter a regra num lugar só). Vídeo pode
    # deixar em branco, ou usar como resumo/descrição do vídeo.
    corpo = models.TextField(blank=True)
    # Só faz sentido pra tipo='video' — nullable pros outros tipos.
    video_url = models.URLField(blank=True, null=True)
    categoria = models.CharField(max_length=50, blank=True)
    # ⚠️ default='rascunho' de propósito — um conteúdo novo não fica
    # visível pra consultora até o admin revisar e publicar deliberadamente.
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='rascunho')
    ordem = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['ordem', '-created_at']
        indexes = [
            models.Index(fields=['status', 'tipo']),
            models.Index(fields=['status', 'categoria']),
        ]

    def __str__(self):
        return f"[{self.get_tipo_display()}] {self.titulo}"


class HelpSearchLog(models.Model):
    """
    Toda busca feita no modo "🆘 Preciso de ajuda" do chat — vira backlog
    de conteúdo pro admin (pergunta que ninguém respondeu = candidato a
    FAQ nova). matched_content nulo = a busca não encontrou nada, e a
    conversa foi escalada pra humano automaticamente.
    """
    query = models.CharField(max_length=300)
    matched_content = models.ForeignKey(
        HelpContent, on_delete=models.SET_NULL, null=True, blank=True, related_name='search_hits'
    )
    store = models.ForeignKey('inventory.Store', on_delete=models.CASCADE, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        alvo = self.matched_content.titulo if self.matched_content else "(sem resultado)"
        return f"{self.query!r} → {alvo}"