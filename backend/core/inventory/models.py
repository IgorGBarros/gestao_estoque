import uuid

from django.db import models
from django.utils import timezone
from django.utils.text import slugify
from django.db import models
from django.contrib.auth.models import (
    AbstractBaseUser, BaseUserManager, PermissionsMixin, Permission
)
from django.utils import timezone
from django.conf import settings

from firebase_admin import auth
import firebase_admin

# ==========================================
# 1. CAMADA PÚBLICA (CATÁLOGO GLOBAL)
# ==========================================
# Alimentada pelos Robôs. Todas as consultoras "leem" daqui.

class Product(models.Model):
    name = models.CharField(max_length=255, verbose_name="Nome do Produto")
        # 🚀 ADICIONE ESTA LINHA:
    brand = models.CharField(max_length=100, null=True, blank=True, verbose_name="Marca")
    # Identificadores
    bar_code = models.CharField(max_length=50, unique=True, null=True, blank=True, verbose_name="Código de Barras")
    natura_sku = models.CharField(max_length=50, unique=True, null=True, blank=True, verbose_name="SKU Natura")
    
    # Detalhes
    category = models.CharField(max_length=100, default="Geral")
    description = models.TextField(null=True, blank=True)
    image_url = models.URLField(max_length=500, null=True, blank=True)
    min_quantity = models.PositiveIntegerField(default=5)
    # Preço Oficial (Referência)
    official_price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, verbose_name="Preço Site")
    
    # Controle do Robô
    last_checked_price = models.DecimalField(max_digits=10, decimal_places=2, null=True) # Preço na última checagem
    last_checked_at = models.DateTimeField(null=True, blank=True, verbose_name="Última Checagem de Preço")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class PriceHistory(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name="price_history")
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Preço Coletado")
    captured_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.product.name}: R$ {self.price} em {self.captured_at.strftime('%d/%m/%Y')}"

class CrawlerLog(models.Model):
    sku = models.CharField(max_length=50, db_index=True)
    status_code = models.IntegerField(null=True, blank=True)
    error_message = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    retry_count = models.IntegerField(default=0)

    def __str__(self):
        return f"Erro SKU {self.sku}: {self.error_message}"


# ==========================================
# 2. CAMADA PRIVADA (DADOS DA CONSULTORA)
# ==========================================

class Store(models.Model):
    """Loja da consultora"""
    name = models.CharField(max_length=255, default='Minha Loja Natura')
    slug = models.SlugField(unique=True, blank=True, max_length=120)
    whatsapp = models.CharField(max_length=20, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    # ✅ RELACIONAMENTO CORRETO
    owner = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='store',
        null=True,  # Permitir null temporariamente
        blank=True
    )

    PLAN_CHOICES = [
        ('free', 'Free'),
        ('pro', 'Pro'),
    ]
    plan = models.CharField(
        max_length=20,
        choices=PLAN_CHOICES,
        default='pro',
        help_text="Plano de assinatura da loja"
    )

    payment_provider = models.CharField(max_length=50, blank=True, null=True, help_text="Ex: stripe, mercadopago")
    payment_external_id = models.CharField(max_length=100, blank=True, null=True, help_text="ID da transação/assinatura")
    subscription_started_at = models.DateTimeField(blank=True, null=True)
    subscription_expires_at = models.DateTimeField(blank=True, null=True)
    def save(self, *args, **kwargs):
        if not self.slug:
            base_slug = slugify(self.name)
            slug = base_slug
            counter = 1
            while Store.objects.filter(slug=slug).exists():
                slug = f"{base_slug}-{counter}"
                counter += 1
            self.slug = slug
        super().save(*args, **kwargs)

    # inventory/models.py - ATUALIZAR Store    
    @property
    def product_count(self):
        """Conta produtos da loja"""
        return self.items.count()
    
    @property
    def plan_config(self):
        """Retorna configuração do plano atual"""
        return PlanConfig.objects.filter(plan_type=self.plan).first()
    
    @property
    def can_add_products(self):
        """Verifica se pode adicionar mais produtos"""
        config = self.plan_config
        if not config or config.max_products is None:
            return True
        return self.product_count < config.max_products
    
    @property
    def products_limit_reached(self):
        """Verifica se atingiu limite de produtos"""
        return not self.can_add_products
    
    @property
    def can_use_feature(self):
        """Retorna dict com recursos disponíveis"""
        config = self.plan_config
        if not config:
            return {
                'scanner': True,
                'storefront': False,
                'alerts': False,
                'ai_assistant': False,
                'analytics': False
            }
        
        return {
            'scanner': config.can_use_scanner,
            'storefront': config.can_use_storefront,
            'alerts': config.can_use_alerts,
            'ai_assistant': config.can_use_ai_assistant,
            'analytics': config.can_use_analytics
        }
    
    @property
    def subscription_status(self):
        """Status da assinatura"""
        if not self.subscription_expires_at:
            return 'active' if self.plan == 'pro' else 'free'
        
        if timezone.now() > self.subscription_expires_at:
            return 'expired'
        
        return 'active'
    
    @property
    def days_until_expiry(self):
        """Dias até expirar"""
        if not self.subscription_expires_at:
            return None
        
        delta = self.subscription_expires_at - timezone.now()
        return max(0, delta.days)
    
    def upgrade_to_pro(self, billing_cycle='monthly'):
        """Upgrade para PRO"""
        self.plan = 'pro'
        self.subscription_started_at = timezone.now()
        
        if billing_cycle == 'yearly':
            self.subscription_expires_at = timezone.now() + timezone.timedelta(days=365)
        else:
            # Para assinatura mensal, não definir expiração (renovação automática)
            self.subscription_expires_at = None
            
        self.save()
    
    def downgrade_to_free(self):
        """Downgrade para Free"""
        self.plan = 'free'
        self.subscription_expires_at = None
        self.payment_provider = None
        self.payment_external_id = None
        self.save()
    
    def get_active_promotions(self):
        """Retorna promoções ativas para esta loja"""
        return [
            promo for promo in Promotion.objects.filter(is_active=True)
            if promo.is_valid_for_store(self)
        ]
    
    def __str__(self):
        return f"{self.name} ({self.owner.email if self.owner else 'Sem dono'})"
    
    class Meta:
        verbose_name = 'Loja'
        verbose_name_plural = 'Lojas'

class InventoryItem(models.Model):
    """
    O vínculo entre a Loja e o Produto Global.
    Define o preço que ELA cobra e o resumo do estoque DELA.
    """
    store = models.ForeignKey(Store, on_delete=models.CASCADE, related_name="items")
    product = models.ForeignKey(Product, on_delete=models.PROTECT) # Se deletar prod global, não quebra estoque
    
    # Preços personalizados da consultora
    cost_price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, verbose_name="Custo Médio")
    sale_price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, verbose_name="Preço Venda")
    
    # Estoque consolidado (Soma dos lotes)
    total_quantity = models.IntegerField(default=0)
    min_quantity = models.IntegerField(default=5)
    
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('store', 'product') # Evita duplicidade do mesmo produto na loja

    def __str__(self):
        return f"{self.product.name} ({self.total_quantity})"

class InventoryBatch(models.Model):
    """
    Lotes físicos (Validade e Quantidade específica).
    """
    item = models.ForeignKey(InventoryItem, on_delete=models.CASCADE, related_name="batches")
    quantity = models.IntegerField()
    batch_code = models.CharField(max_length=50, blank=True, null=True, verbose_name="Lote")
    expiration_date = models.DateField(null=True, blank=True, verbose_name="Validade")
    entry_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Lote {self.batch_code} - Val: {self.expiration_date}"


# ==========================================
# 3. CAMADA DE SAÍDA (VENDAS E BAIXAS)
# ==========================================

class Sale(models.Model):
    SALE_TYPES = [
        ('VENDA', 'Venda'),
        ('PRESENTE', 'Presente Pessoal'),
        ('BRINDE', 'Brinde Cliente'),
        ('PERDA', 'Perda/Avaria'),
        ('USO_PROPRIO', 'Uso Próprio')
    ]

    store = models.ForeignKey(Store, on_delete=models.CASCADE, related_name="sales")
    transaction_type = models.CharField(max_length=20, choices=SALE_TYPES, default='VENDA')
    
    total_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    client_name = models.CharField(max_length=100, blank=True, null=True)
    payment_method = models.CharField(max_length=50, default="DINHEIRO", blank=True)
    
    notes = models.TextField(blank=True, null=True, verbose_name="Observações")
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"#{self.id} - {self.transaction_type} - R$ {self.total_amount}"

class SaleItem(models.Model):
    sale = models.ForeignKey(Sale, on_delete=models.CASCADE, related_name="items")
    product = models.ForeignKey(Product, on_delete=models.PROTECT)
    batch = models.ForeignKey(InventoryBatch, on_delete=models.SET_NULL, null=True, blank=True)
    
    quantity = models.IntegerField()
    unit_price_sold = models.DecimalField(max_digits=10, decimal_places=2) # Preço no momento da venda
    unit_cost_at_time = models.DecimalField(max_digits=10, decimal_places=2, default=0) # Para relatório de lucro


from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.utils import timezone
from firebase_admin import auth

# ==========================================
# 0. USUÁRIO CUSTOMIZADO (AUTH)
# ==========================================
class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError("O usuário deve ter um email")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        if password:
            user.set_password(password)
        else:
            user.set_unusable_password()
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, password, **extra_fields)
    
    def create_user_with_firebase(self, firebase_token, **extra_fields):
        try:
            decoded_token = auth.verify_id_token(firebase_token)
            email = decoded_token.get('email')
            name = decoded_token.get('name') or decoded_token.get('uid')
            
            user, created = self.get_or_create(
                email=email, 
                defaults={'name': name, **extra_fields}
            )
            if created:
                user.set_unusable_password()
                user.save(using=self._db)
            return user
        except Exception as e:
            raise ValueError(f"Erro ao verificar o token do Firebase: {e}")

class CustomUser(AbstractBaseUser, PermissionsMixin):
    email = models.EmailField(unique=True)
    name = models.CharField(max_length=255)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    is_superuser = models.BooleanField(default=False)
    
    objects = CustomUserManager()
    
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name']
    
    def __str__(self):
        return self.email

# ... Resto do seu models.py (Product, Store, InventoryItem, etc)
# ... (outros models: Product, Store, InventoryItem, etc)

class StockTransaction(models.Model):
    TRANSACTION_TYPES = [
        ('ENTRADA', 'Entrada de Estoque'),
        ('VENDA', 'Saída por Venda'),
        ('PRESENTE', 'Saída para Presente'),
        ('BRINDE', 'Saída para Brinde'),
        ('USO_PROPRIO', 'Uso Próprio'),
        ('PERDA', 'Perda / Avaria'),
        ('AJUSTE', 'Ajuste Manual'),
    ]

    store = models.ForeignKey(Store, on_delete=models.CASCADE, related_name="transactions")
    product = models.ForeignKey(Product, on_delete=models.PROTECT)
    batch = models.ForeignKey(InventoryBatch, on_delete=models.SET_NULL, null=True, blank=True)
    
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    quantity = models.IntegerField() # Positivo = Entrada, Negativo = Saída
    
    # Snapshot dos valores no momento da operação
    unit_cost = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    
    description = models.CharField(max_length=255, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.get_transaction_type_display()} - {self.product.name} ({self.quantity})"
    


# inventory/models.py - ADICIONAR apenas isso
# inventory/models.py - ADICIONAR este modelo
class RegistrationSession(models.Model):
    """Sessão de cadastro de produtos"""
    store = models.ForeignKey(Store, on_delete=models.CASCADE)
    started_at = models.DateTimeField(auto_now_add=True)
    finished_at = models.DateTimeField(null=True, blank=True)
    is_active = models.BooleanField(default=True)
    
    # Contadores
    products_count = models.PositiveIntegerField(default=0)
    total_estimated_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    
    # Dados de pagamento (opcionais)
    payment_method = models.CharField(max_length=50, null=True, blank=True)
    total_paid = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    installments = models.PositiveIntegerField(default=1)
    
    class Meta:
        verbose_name = "Sessão de Cadastro"
        verbose_name_plural = "Sessões de Cadastro"
    
    @property
    def duration_minutes(self):
        if self.finished_at:
            return (self.finished_at - self.started_at).total_seconds() / 60
        return (timezone.now() - self.started_at).total_seconds() / 60
    
    
    def add_product(self, inventory_item, quantity=1):
        """Adiciona produto à sessão"""
        self.products_count += quantity
        # Calcula custo estimado baseado no custo do item
        cost_per_unit = inventory_item.cost_price or inventory_item.product.official_price or 0
        self.total_estimated_cost += cost_per_unit * quantity
        self.save()
    
    def finish_session(self):
        """Finaliza sessão"""
        self.is_active = False
        self.finished_at = timezone.now()
        self.save()
        return self
    
    def __str__(self):
        return f"Sessão {self.id} - {self.store.name} ({self.products_count} produtos)"
    
# inventory/models.py - ADICIONAR no final do arquivo

from django.core.validators import MinValueValidator, MaxValueValidator
from decimal import Decimal

class PlanConfig(models.Model):
    """Configuração dinâmica de planos"""
    
    PLAN_CHOICES = [
        ('free', 'Free'),
        ('pro', 'Pro'),
        ('premium', 'Premium'),
    ]
    
    plan_type = models.CharField(max_length=20, choices=PLAN_CHOICES, unique=True)
    display_name = models.CharField(max_length=50)
    description = models.TextField(blank=True)
    
    # Limites configuráveis
    max_products = models.IntegerField(
        null=True, 
        blank=True,
        help_text="NULL = ilimitado"
    )
    max_storage_mb = models.IntegerField(default=100)
    
    # Recursos habilitados
    can_use_scanner = models.BooleanField(default=True)
    can_use_storefront = models.BooleanField(default=False)
    can_use_alerts = models.BooleanField(default=False)
    can_use_ai_assistant = models.BooleanField(default=False)
    can_use_analytics = models.BooleanField(default=False)
    can_export_data = models.BooleanField(default=False)
    can_use_api = models.BooleanField(default=False)
    
    # Configurações de pagamento
    monthly_price = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=Decimal('0.00')
    )
    yearly_price = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=Decimal('0.00')
    )
    yearly_discount_percent = models.IntegerField(
        default=0,
        validators=[MinValueValidator(0), MaxValueValidator(100)]
    )
    
    # Configurações de UI
    highlight_color = models.CharField(max_length=7, default='#3B82F6')  # hex color
    is_popular = models.BooleanField(default=False)
    is_visible = models.BooleanField(default=True)
    sort_order = models.IntegerField(default=0)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'plan_configs'
        ordering = ['sort_order', 'plan_type']
        verbose_name = 'Configuração de Plano'
        verbose_name_plural = 'Configurações de Planos'
        
    def __str__(self):
        return f"{self.display_name} (R$ {self.monthly_price}/mês)"
    
    @property
    def yearly_price_monthly(self):
        """Preço anual dividido por 12"""
        if self.yearly_price > 0:
            return self.yearly_price / 12
        return self.monthly_price
    
    @property
    def yearly_savings(self):
        """Economia anual em reais"""
        if self.yearly_price > 0 and self.monthly_price > 0:
            return (self.monthly_price * 12) - self.yearly_price
        return Decimal('0.00')

class Promotion(models.Model):
    """Promoções e banners configuráveis"""
    
    TARGET_CHOICES = [
        ('all', 'Todos os usuários'),
        ('free', 'Apenas plano Free'),
        ('pro', 'Apenas plano Pro'),
        ('new_users', 'Usuários novos (< 7 dias)'),
        ('inactive', 'Usuários inativos (> 30 dias)'),
    ]
    
    TYPE_CHOICES = [
        ('banner', 'Banner'),
        ('modal', 'Modal'),
        ('notification', 'Notificação'),
        ('email', 'Email'),
    ]
    
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    title = models.CharField(max_length=100)
    message = models.TextField()
    
    # Configuração de exibição
    promotion_type = models.CharField(max_length=20, choices=TYPE_CHOICES, default='banner')
    target_audience = models.CharField(max_length=20, choices=TARGET_CHOICES, default='free')
    
    # Configuração de desconto
    discount_percent = models.IntegerField(
        default=0,
        validators=[MinValueValidator(0), MaxValueValidator(100)]
    )
    discount_amount = models.DecimalField(
        max_digits=10, 
        decimal_places=2, 
        default=Decimal('0.00')
    )
    
    # Controle de tempo
    starts_at = models.DateTimeField(default=timezone.now)
    ends_at = models.DateTimeField(null=True, blank=True)
    
    # Controle de exibição
    is_active = models.BooleanField(default=True)
    max_views = models.IntegerField(null=True, blank=True)
    current_views = models.IntegerField(default=0)
    
    # Estilo
    background_color = models.CharField(max_length=7, default='#3B82F6')
    text_color = models.CharField(max_length=7, default='#FFFFFF')
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'promotions'
        ordering = ['-created_at']
        verbose_name = 'Promoção'
        verbose_name_plural = 'Promoções'
        
    def __str__(self):
        return self.title
    
    def is_valid_for_store(self, store):
        """Verifica se promoção é válida para uma loja específica"""
        from django.utils import timezone
        
        now = timezone.now()
        
        # Verificações básicas
        if not self.is_active:
            return False
        if now < self.starts_at:
            return False
        if self.ends_at and now > self.ends_at:
            return False
            
        # Verificação por target_audience
        if self.target_audience == 'free' and store.plan != 'free':
            return False
        if self.target_audience == 'pro' and store.plan != 'pro':
            return False
        if self.target_audience == 'new_stores':
            days_since_creation = (now - store.created_at).days
            if days_since_creation > 7:
                return False
        if self.target_audience == 'inactive':
            # Verificar se loja está inativa (sem atividade recente)
            # Implementar lógica de inatividade se necessário
            pass
                
        return True
    
    @property
    def is_valid(self):
        """Verifica se a promoção está válida (sem contexto de loja)"""
        from django.utils import timezone
        
        now = timezone.now()
        if not self.is_active:
            return False
        if now < self.starts_at:
            return False
        if self.ends_at and now > self.ends_at:
            return False
        if self.max_views and self.current_views >= self.max_views:
            return False
        return True
    @property
    def is_valid(self):
        """Verifica se a promoção está válida"""
        now = timezone.now()
        if not self.is_active:
            return False
        if now < self.starts_at:
            return False
        if self.ends_at and now > self.ends_at:
            return False
        if self.max_views and self.current_views >= self.max_views:
            return False
        return True

# inventory/models.py - CORRIGIR o modelo UserPlanCache

class UserPlanCache(models.Model):
    """Cache de limites por usuário (performance)"""
    
    # ✅ CORREÇÃO: Usar settings.AUTH_USER_MODEL em vez de string
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,  # Em vez de 'CustomUser'
        on_delete=models.CASCADE, 
        related_name='plan_cache'
    )
    
    # Cache dos limites atuais
    current_plan = models.CharField(max_length=20, default='free')
    max_products = models.IntegerField(null=True, blank=True)
    products_used = models.IntegerField(default=0)
    
    # Recursos
    can_use_scanner = models.BooleanField(default=True)
    can_use_storefront = models.BooleanField(default=False)
    can_use_alerts = models.BooleanField(default=False)
    can_use_ai_assistant = models.BooleanField(default=False)
    can_use_analytics = models.BooleanField(default=False)
    
    last_updated = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'user_plan_cache'
        verbose_name = 'Cache de Plano'
        verbose_name_plural = 'Cache de Planos'
        
    def __str__(self):
        return f"{self.user.email} - {self.current_plan}"
    
    def refresh_from_store(self):
        """Atualiza cache baseado na Store do usuário"""
        try:
            store = self.user.store
            self.current_plan = store.plan
            
            # Busca configuração do plano
            plan_config = PlanConfig.objects.filter(plan_type=store.plan).first()
            if plan_config:
                self.max_products = plan_config.max_products
                self.can_use_scanner = plan_config.can_use_scanner
                self.can_use_storefront = plan_config.can_use_storefront
                self.can_use_alerts = plan_config.can_use_alerts
                self.can_use_ai_assistant = plan_config.can_use_ai_assistant
                self.can_use_analytics = plan_config.can_use_analytics
            
            # Conta produtos atuais
            if hasattr(store, 'items'):
                self.products_used = store.items.count()
            
            self.save()
        except:
            pass  # Se não tem store, mantém defaults


# inventory/models.py - ADICIONAR

class UserBehaviorLog(models.Model):
    """Log comportamental agregado (LGPD-compliant)"""
    
    ACTION_TYPES = [
        ('product_scan', 'Produto Escaneado'),
        ('product_add', 'Produto Adicionado'),
        ('product_edit', 'Produto Editado'),
        ('stock_update', 'Estoque Atualizado'),
        ('sale_record', 'Venda Registrada'),
        ('report_view', 'Relatório Visualizado'),
        ('storefront_access', 'Vitrine Acessada'),
        ('plan_view', 'Página de Planos Visualizada'),
    ]
    
    # ✅ LGPD: Não armazena dados pessoais, apenas padrões
    store = models.ForeignKey(Store, on_delete=models.CASCADE, related_name='behavior_logs')
    action_type = models.CharField(max_length=20, choices=ACTION_TYPES)
    
    # Dados contextuais (não pessoais)
    plan_at_time = models.CharField(max_length=10)  # free/pro no momento da ação
    products_count_at_time = models.IntegerField()
    day_of_week = models.IntegerField()  # 0-6 (segunda a domingo)
    hour_of_day = models.IntegerField()  # 0-23
    
    # Metadados para ML
    session_duration_minutes = models.IntegerField(null=True, blank=True)
    feature_used = models.CharField(max_length=50, blank=True)  # scanner, vitrine, etc
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        db_table = 'user_behavior_logs'
        indexes = [
            models.Index(fields=['action_type', 'plan_at_time']),
            models.Index(fields=['created_at']),
            models.Index(fields=['store', 'action_type']),
        ]
        # ✅ LGPD: Retenção automática de dados
        # Implementar job para deletar logs > 2 anos
        
    def __str__(self):
        return f"{self.action_type} - {self.plan_at_time} - {self.created_at.date()}"

class MLInsight(models.Model):
    """Insights gerados por Machine Learning (agregados)"""
    
    INSIGHT_TYPES = [
        ('conversion_prediction', 'Predição de Conversão'),
        ('churn_risk', 'Risco de Churn'),
        ('product_recommendation', 'Recomendação de Produto'),
        ('optimal_pricing', 'Precificação Otimizada'),
        ('seasonal_trend', 'Tendência Sazonal'),
    ]
    
    insight_type = models.CharField(max_length=30, choices=INSIGHT_TYPES)
    
    # ✅ LGPD: Dados agregados, não individuais
    target_segment = models.CharField(max_length=50)  # 'free_users_week_1', 'pro_users_cosmetics'
    
    # Dados do insight
    confidence_score = models.FloatField()  # 0.0 - 1.0
    insight_data = models.JSONField()  # Dados estruturados do insight
    
    # Metadados
    model_version = models.CharField(max_length=20, default='v1.0')
    training_data_size = models.IntegerField()
    generated_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()  # Insights têm validade
    
    is_active = models.BooleanField(default=True)
    
    class Meta:
        db_table = 'ml_insights'
        indexes = [
            models.Index(fields=['insight_type', 'target_segment']),
            models.Index(fields=['generated_at']),
        ]
        
    def __str__(self):
        return f"{self.get_insight_type_display()} - {self.target_segment} ({self.confidence_score:.2f})"

class DataPrivacyConsent(models.Model):
    """Controle de consentimento LGPD"""
    
    CONSENT_TYPES = [
        ('analytics', 'Analytics e Métricas'),
        ('ml_training', 'Treinamento de IA'),
        ('personalization', 'Personalização'),
        ('marketing', 'Marketing Direcionado'),
    ]
    
    store = models.ForeignKey(Store, on_delete=models.CASCADE, related_name='privacy_consents')
    consent_type = models.CharField(max_length=20, choices=CONSENT_TYPES)
    
    # Controle de consentimento
    granted = models.BooleanField(default=False)
    granted_at = models.DateTimeField(null=True, blank=True)
    revoked_at = models.DateTimeField(null=True, blank=True)
    
    # Auditoria LGPD
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    consent_version = models.CharField(max_length=10, default='1.0')
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = 'data_privacy_consents'
        unique_together = ['store', 'consent_type']
        
    def __str__(self):
        status = "Concedido" if self.granted else "Negado"
        return f"{self.store.name} - {self.get_consent_type_display()} ({status})"