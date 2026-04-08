from django.utils import timezone
from datetime import timedelta
from rest_framework import serializers
from django.contrib.auth import get_user_model, authenticate
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from decimal import Decimal

# Importa seus modelos de negócio
from .models import (
    CustomUser, Product, InventoryItem, InventoryBatch, Store, 
    Sale, SaleItem, StockTransaction, PlanConfig, Promotion
)

User = get_user_model()

# ==========================================
# 1. SERIALIZERS DE AUTENTICAÇÃO (melhorados)
# ==========================================

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """Token JWT com dados da Store"""
    username_field = User.USERNAME_FIELD
    
    def validate(self, attrs):
        credentials = {
            "email": attrs.get("email"),
            "password": attrs.get("password"),
        }
        user = authenticate(email=credentials["email"], password=credentials["password"])
        if not user:
            raise serializers.ValidationError("Credenciais inválidas.")
        
        # Validação padrão do JWT
        data = super().validate(attrs)
        
        # ✅ NOVO: Adicionar dados da Store no token
        store = getattr(user, 'store', None)
        data.update({
            "email": user.email,
            "name": getattr(user, 'name', user.email),
            "has_store": store is not None,
            "store_slug": store.slug if store else None,
            "plan": store.plan if store else 'free',
            "can_add_products": store.can_add_products if store else True,
        })
        
        return data
        
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token["email"] = user.email
        token["name"] = getattr(user, 'name', user.email)
        
        # ✅ NOVO: Dados da Store no token
        store = getattr(user, 'store', None)
        if store:
            token["store_slug"] = store.slug
            token["plan"] = store.plan
        
        return token

class CustomUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)
    
    class Meta:
        model = User
        fields = ['id', 'email', 'name', 'password']
        
    def validate_email(self, value):
        """Validação de email único"""
        if User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Este email já está em uso.")
        return value
        
    def create(self, validated_data):
        """Cria usuário e Store automaticamente"""
        user = User.objects.create_user(
            email=validated_data.get('email', ''),
            password=validated_data['password'],
            name=validated_data.get('name', '')
        )
        
        # ✅ NOVO: Criar Store automaticamente
        from .utils import ensure_user_has_store
        ensure_user_has_store(user)
        
        return user

# ==========================================
# 2. SERIALIZERS DE CONFIGURAÇÃO (NOVOS)
# ==========================================

class PlanConfigSerializer(serializers.ModelSerializer):
    """Serializer para configuração de planos"""
    yearly_price_monthly = serializers.SerializerMethodField()
    yearly_savings = serializers.SerializerMethodField()
    
    class Meta:
        model = PlanConfig
        fields = [
            'plan_type', 'display_name', 'description',
            'max_products', 'can_use_scanner', 'can_use_storefront', 
            'can_use_alerts', 'can_use_ai_assistant', 'can_use_analytics',
            'monthly_price', 'yearly_price', 'yearly_price_monthly', 'yearly_savings',
            'highlight_color', 'is_popular', 'is_visible', 'sort_order'
        ]
    
    def get_yearly_price_monthly(self, obj):
        """Preço anual dividido por 12"""
        if obj.yearly_price > 0:
            return round(obj.yearly_price / 12, 2)
        return obj.monthly_price
    
    def get_yearly_savings(self, obj):
        """Economia anual"""
        if obj.yearly_price > 0 and obj.monthly_price > 0:
            return round((obj.monthly_price * 12) - obj.yearly_price, 2)
        return 0

# inventory/serializers.py - CORRIGIR PromotionSerializer

class PromotionSerializer(serializers.ModelSerializer):
    is_valid = serializers.SerializerMethodField()
    
    class Meta:
        model = Promotion
        fields = [
            'id', 'title', 'message', 'target_audience',
            'discount_percent', 'discount_amount', 'is_active',
            'starts_at', 'ends_at', 'is_valid', 'created_at'
        ]
    
    def get_is_valid(self, obj):
        """Método corrigido para verificar validade"""
        # Usar a property is_valid em vez do método is_valid_for_store
        return obj.is_valid

# ==========================================
# 3. SERIALIZERS DE PRODUTO E ESTOQUE (melhorados)
# ==========================================

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = [
            'id', 'name', 'bar_code', 'natura_sku', 'image_url', 
            'category', 'brand', 'description', 'official_price', 'min_quantity'
        ]

class InventoryBatchSerializer(serializers.ModelSerializer):
    formatted_date = serializers.SerializerMethodField()
    is_expired = serializers.SerializerMethodField()
    is_near_expiry = serializers.SerializerMethodField()
    days_to_expire = serializers.SerializerMethodField()
    status = serializers.SerializerMethodField()
    
    class Meta:
        model = InventoryBatch
        fields = [
            'id', 'batch_code', 'expiration_date', 'quantity', 
            'formatted_date', 'is_expired', 'is_near_expiry', 
            'days_to_expire', 'status'
        ]
    
    def get_formatted_date(self, obj):
        if obj.expiration_date:
            return obj.expiration_date.strftime('%d/%m/%Y')
        return 'Sem validade'
    
    def get_is_expired(self, obj):
        if obj.expiration_date:
            return obj.expiration_date < timezone.now().date()
        return False
    
    def get_is_near_expiry(self, obj):
        if obj.expiration_date and not self.get_is_expired(obj):
            days_diff = (obj.expiration_date - timezone.now().date()).days
            return days_diff <= 30
        return False
    
    def get_days_to_expire(self, obj):
        if obj.expiration_date and not self.get_is_expired(obj):
            return (obj.expiration_date - timezone.now().date()).days
        return None
    
    def get_status(self, obj):
        if self.get_is_expired(obj):
            return 'expired'
        elif self.get_is_near_expiry(obj):
            return 'near_expiry'
        else:
            return 'valid'

class InventoryItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    batches = InventoryBatchSerializer(many=True, read_only=True)
    display_price = serializers.SerializerMethodField()
    
    # ✅ NOVO: Campos calculados
    total_cost = serializers.SerializerMethodField()
    potential_profit = serializers.SerializerMethodField()
    
    class Meta:
        model = InventoryItem
        fields = [
            'id', 'product', 'sale_price', 'cost_price', 
            'total_quantity', 'min_quantity', 'batches', 'display_price',
            'total_cost', 'potential_profit'
        ]
    
    def get_display_price(self, obj):
        return obj.sale_price if obj.sale_price and obj.sale_price > 0 else obj.product.official_price
    
    def get_total_cost(self, obj):
        """Custo total do estoque"""
        if obj.cost_price and obj.total_quantity:
            return obj.cost_price * obj.total_quantity
        return 0
    
    def get_potential_profit(self, obj):
        """Lucro potencial se vender tudo"""
        cost = self.get_total_cost(obj)
        revenue = self.get_display_price(obj) * obj.total_quantity
        return revenue - cost

# ==========================================
# 4. SERIALIZER DE ENTRADA COM VALIDAÇÃO DE LIMITE (melhorado)
# ==========================================

class StockEntrySerializer(serializers.Serializer):
    bar_code = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    quantity = serializers.IntegerField(min_value=1)
    cost_price = serializers.DecimalField(max_digits=10, decimal_places=2, required=False, allow_null=True)
    sale_price = serializers.DecimalField(max_digits=10, decimal_places=2, required=False, allow_null=True)
    batch_code = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    expiration_date = serializers.DateField(required=False, allow_null=True)
    
    # Campos de criação de produto
    name = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    category = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    natura_sku = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    image_url = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    
    # ✅ APENAS validações básicas de formato
    def validate_quantity(self, value):
        if value <= 0:
            raise ValidationError("Quantidade deve ser maior que zero")
        return value
    
    def validate_bar_code(self, value):
        # Validar formato se necessário
        if value and len(value) > 50:
            raise ValidationError("Código de barras muito longo")
        return value

# ==========================================
# 5. SERIALIZERS DE VENDA (mantidos)
# ==========================================

class SaleItemInputSerializer(serializers.Serializer):
    bar_code = serializers.CharField()
    quantity = serializers.IntegerField(min_value=1)
    batch_id = serializers.IntegerField(required=False, allow_null=True) 
    price_sold = serializers.DecimalField(max_digits=10, decimal_places=2, required=False, allow_null=True)

class SaleSerializer(serializers.Serializer):
    items = SaleItemInputSerializer(many=True)
    client_name = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    payment_method = serializers.CharField(default="DINHEIRO")
    transaction_type = serializers.CharField(default="VENDA") 
    notes = serializers.CharField(required=False, allow_blank=True, allow_null=True)

class StockTransactionSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.name', read_only=True)
    batch_code = serializers.CharField(source='batch.batch_code', read_only=True)
    formatted_date = serializers.SerializerMethodField()
    
    class Meta:
        model = StockTransaction
        fields = [
            'id', 'product', 'product_name', 'batch', 'batch_code',
            'transaction_type', 'quantity', 'unit_cost', 'unit_price',
            'description', 'created_at', 'formatted_date'
        ]
        read_only_fields = ['id', 'created_at', 'product_name', 'batch_code']
    
    def get_formatted_date(self, obj):
        return obj.created_at.strftime('%d/%m/%Y %H:%M')

# ==========================================
# 6. SERIALIZERS DE PERFIL / LOJA (melhorados)
# ==========================================

class UserNestedSerializer(serializers.ModelSerializer):
    """Dados básicos do usuário"""
    class Meta:
        model = CustomUser
        fields = ["id", "email", "name"]

class StoreStatsSerializer(serializers.Serializer):
    """Estatísticas da loja"""
    total_products = serializers.IntegerField()
    total_value = serializers.DecimalField(max_digits=15, decimal_places=2)
    expired_products = serializers.IntegerField()
    near_expiry_products = serializers.IntegerField()
    low_stock_products = serializers.IntegerField()

class ProfileSerializer(serializers.ModelSerializer):
    """✅ MELHORADO: Serializer de perfil baseado na Store"""
    user = UserNestedSerializer(source='owner', read_only=True)
    
    # Aliases para compatibilidade
    display_name = serializers.CharField(source='name', required=False, allow_blank=True)
    whatsapp_number = serializers.CharField(source='whatsapp', required=False, allow_blank=True)
    store_slug = serializers.CharField(source='slug', read_only=True)
    
    # ✅ NOVO: Dados do plano atual
    plan_config = PlanConfigSerializer(read_only=True)
    current_limits = serializers.SerializerMethodField()
    active_promotions = serializers.SerializerMethodField()
    subscription_status = serializers.SerializerMethodField()
    
    # ✅ NOVO: Estatísticas
    stats = serializers.SerializerMethodField()
    
    class Meta:
        model = Store
        fields = [
            "id", "user", "display_name", "store_slug", "whatsapp_number", 
            "created_at", "updated_at", "plan", "plan_config", "current_limits",
            "active_promotions", "subscription_status", "stats",
            "payment_provider", "subscription_started_at", "subscription_expires_at"
        ]
        read_only_fields = [
            "id", "user", "created_at", "updated_at", "store_slug", 
            "plan_config", "subscription_status", "stats"
        ]
    
    def get_current_limits(self, obj):
        """Limites atuais da loja"""
        return {
            'max_products': obj.plan_config.max_products if obj.plan_config else 20,
            'current_products': obj.product_count,
            'can_add_products': obj.can_add_products,
            'features': obj.can_use_feature
        }
    
    def get_active_promotions(self, obj):
        """Promoções ativas para esta loja"""
        promotions = obj.get_active_promotions()
        return PromotionSerializer(promotions, many=True, context={'store': obj}).data
    
    def get_subscription_status(self, obj):
        """Status da assinatura"""
        return {
            'status': obj.subscription_status,
            'days_until_expiry': obj.days_until_expiry,
            'is_active': obj.plan == 'pro' and obj.subscription_status == 'active'
        }
    
    def get_stats(self, obj):
        """Estatísticas da loja"""
        items = obj.items.select_related('product').prefetch_related('batches')
        
        total_products = items.count()
        total_value = sum(
            (item.cost_price or 0) * item.total_quantity 
            for item in items
        )
        
        # Contar produtos com problemas
        expired_count = 0
        near_expiry_count = 0
        low_stock_count = 0
        
        for item in items:
            # Verificar estoque baixo
            if item.total_quantity <= item.min_quantity:
                low_stock_count += 1
            
            # Verificar validade nos lotes
            for batch in item.batches.all():
                if batch.expiration_date:
                    if batch.expiration_date < timezone.now().date():
                        expired_count += 1
                    elif (batch.expiration_date - timezone.now().date()).days <= 30:
                        near_expiry_count += 1
        
        return {
            'total_products': total_products,
            'total_value': total_value,
            'expired_products': expired_count,
            'near_expiry_products': near_expiry_count,
            'low_stock_products': low_stock_count
        }
    
    def validate_display_name(self, value):
        return value if value else ""
    
    def validate_whatsapp_number(self, value):
        return value if value else ""

# ==========================================
# 7. SERIALIZERS PARA ASAAS (NOVOS)
# ==========================================

class AsaasCheckoutSerializer(serializers.Serializer):
    """Serializer para criar checkout no Asaas"""
    billing_cycle = serializers.ChoiceField(choices=['monthly', 'yearly'], default='monthly')
    payment_method = serializers.ChoiceField(
        choices=['credit_card', 'pix', 'boleto'], 
        default='credit_card'
    )
    
    def validate(self, attrs):
        """Validação do checkout"""
        # Verificar se store pode fazer upgrade
        store = self.context.get('store')
        if not store:
            raise ValidationError("Store não encontrada")
        
        if store.plan == 'pro':
            raise ValidationError("Loja já possui plano PRO ativo")
        
        return attrs

class AsaasWebhookSerializer(serializers.Serializer):
    """Serializer para processar webhooks do Asaas"""
    event = serializers.CharField()
    payment = serializers.DictField(required=False)
    subscription = serializers.DictField(required=False)
    
    def validate_event(self, value):
        """Validar eventos suportados"""
        supported_events = [
            'PAYMENT_RECEIVED', 'PAYMENT_OVERDUE', 
            'SUBSCRIPTION_ACTIVATED', 'SUBSCRIPTION_CANCELED'
        ]
        
        if value not in supported_events:
            raise ValidationError(f"Evento {value} não suportado")
        
        return value

# ==========================================
# 8. SERIALIZERS DE ADMIN (NOVOS)
# ==========================================

class AdminStoreSerializer(serializers.ModelSerializer):
    """Serializer para admin panel"""
    owner_email = serializers.CharField(source='owner.email', read_only=True)
    owner_name = serializers.CharField(source='owner.name', read_only=True)
    product_count = serializers.IntegerField(read_only=True)
    subscription_status = serializers.CharField(read_only=True)
    days_until_expiry = serializers.IntegerField(read_only=True)
    can_add_products = serializers.BooleanField(read_only=True)
    
    class Meta:
        model = Store
        fields = [
            'id', 'name', 'slug', 'owner_email', 'owner_name',
            'plan', 'product_count', 'whatsapp', 'created_at', 'updated_at',
            'payment_provider', 'payment_external_id',
            'subscription_started_at', 'subscription_expires_at',
            'subscription_status', 'days_until_expiry', 'can_add_products'
        ]