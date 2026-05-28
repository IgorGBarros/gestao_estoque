import hashlib
import re
from django.utils import timezone
from datetime import timedelta
from rest_framework import serializers
from django.contrib.auth import get_user_model, authenticate
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework.exceptions import AuthenticationFailed, ValidationError
from decimal import Decimal
from django.utils.crypto import get_random_string
from django.conf import settings

# Importa seus modelos de negócio
from .models import (
    ConsentRecord, CustomUser, Product, InventoryItem, InventoryBatch, Store, 
    Sale, SaleItem, StockTransaction, PlanConfig, Promotion, ThemeConfig
)

User = get_user_model()



import logging

logger = logging.getLogger(__name__)


# ==========================================
# 1. SERIALIZER DE LOGIN COM DADOS DA STORE
# ==========================================
class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """Token JWT com dados da Store e perfil do usuário"""
    username_field = User.USERNAME_FIELD
    
    def validate(self, attrs):
        credentials = {
            "email": attrs.get("email"),
            "password": attrs.get("password"),
        }
        # Autentica usando email e senha
        user = authenticate(**credentials)
        
        if not user:
            raise serializers.ValidationError("Credenciais inválidas.")
        
        # Validação padrão do JWT (gera access e refresh tokens)
        data = super().validate(attrs)
        
        # ✅ Adicionar dados da Store e perfil na resposta do login
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
        # Claims padrão
        token["email"] = user.email
        token["name"] = getattr(user, 'name', user.email)
        
        # ✅ Dados da Store no payload do JWT (acessível via decode_token)
        store = getattr(user, 'store', None)
        if store:
            token["store_slug"] = store.slug
            token["plan"] = store.plan
        
        return token


# ==========================================
# 2. SERIALIZER DE CADASTRO COM CRIAÇÃO DE LOJA
# ==========================================
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
        try:
            from .utils import ensure_user_has_store
            ensure_user_has_store(user)
        except Exception as e:
            # Fallback: loga o erro mas não falha o cadastro (melhor UX)
            logger.error(f"Erro ao criar loja para usuário {user.id}: {e}")
            
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
    
    def validate(self, attrs):
        """✅ VALIDAÇÃO AUTOMÁTICA DE LIMITES POR TENANT"""
        # ✅ 1. Obter Store do contexto ou request
        store = self._get_store_from_context()
        
        if not store:
            raise ValidationError("Store não encontrada. Usuário deve ter uma loja associada.")
        
        # ✅ 2. Verificar se é produto novo para esta loja (tenant)
        is_new_product = self._is_new_product_for_store(store, attrs)
        
        # ✅ 3. Validação automática de limite (só para produtos novos)
        if is_new_product:
            self._validate_tenant_limits(store)
        
        return attrs
    
    def _get_store_from_context(self):
        """✅ AUTOMÁTICO: Obter store do contexto ou request"""
        store = self.context.get('store')
        if store:
            return store
        
        request = self.context.get('request')
        if request and hasattr(request, 'user') and request.user.is_authenticated:
            try:
                return request.user.store
            except AttributeError:
                from .utils import ensure_user_has_store
                return ensure_user_has_store(request.user)
        
        return None
    
    def _is_new_product_for_store(self, store, attrs):
        """✅ AUTOMÁTICO: Verifica se é produto novo para este tenant"""
        bar_code = attrs.get('bar_code')
        natura_sku = attrs.get('natura_sku')
        
        if not bar_code and not natura_sku:
            return True
        
        existing_item = None
        
        if bar_code:
            existing_item = InventoryItem.objects.filter(
                store=store,
                product__bar_code=bar_code
            ).first()
        
        if not existing_item and natura_sku:
            existing_item = InventoryItem.objects.filter(
                store=store,
                product__natura_sku=natura_sku
            ).first()
        
        return existing_item is None
    
    def _validate_tenant_limits(self, store):
        """✅ AUTOMÁTICO: Validação de limites por tenant"""
        if hasattr(store, 'can_add_products'):
            can_add = store.can_add_products
        else:
            can_add = self._manual_limit_check(store)
        
        if not can_add:
            limit_info = self._get_limit_info(store)
            
            raise ValidationError({
                'error': 'PLAN_LIMIT_REACHED',
                'message': f'Você atingiu o limite de {limit_info["limit"]} produtos do plano {store.plan.upper()}.',
                'current_plan': store.plan,
                'current_count': limit_info['current_count'],
                'limit': limit_info['limit'],
                'upgrade_required': True,
                'upgrade_url': '/upgrade'
            })
    
    def _manual_limit_check(self, store):
        """✅ FALLBACK: Verificação manual se propriedade não existir"""
        current_count = InventoryItem.objects.filter(store=store).values('product').distinct().count()
        
        try:
            plan_config = getattr(store, 'plan_config', None)
            max_products = plan_config.max_products if plan_config else None
        except:
            max_products = None
        
        if max_products is None:
            max_products = 20 if store.plan == 'free' else None
        
        return max_products is None or current_count < max_products
    
    def _get_limit_info(self, store):
        """✅ HELPER: Obter informações de limite para erro"""
        current_count = InventoryItem.objects.filter(store=store).values('product').distinct().count()
        
        try:
            plan_config = getattr(store, 'plan_config', None)
            limit = plan_config.max_products if plan_config else None
        except:
            limit = None
        
        if limit is None:
            limit = 20 if store.plan == 'free' else 999999
        
        return {
            'current_count': current_count,
            'limit': limit
        }


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
        
        expired_count = 0
        near_expiry_count = 0
        low_stock_count = 0
        
        for item in items:
            if item.total_quantity <= item.min_quantity:
                low_stock_count += 1
            
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


class ThemeConfigSerializer(serializers.ModelSerializer):
    class Meta:
        model = ThemeConfig
        fields = [
            'color_primary', 'color_primary_light', 'color_success',
            'color_text', 'color_accent', 'color_destructive',
            'color_warning', 'color_background', 'color_card',
            'color_border', 'app_name', 'logo_url', 'updated_at',
        ]
        read_only_fields = ['updated_at']





# ==========================================
# CONSENTIMENTO LGPD - SERIALIZERS
# ==========================================

class ConsentRecordSerializer(serializers.Serializer):
    """
    Serializer para registro de consentimento LGPD (Art. 8º)
    Suporta usuários autenticados e anônimos (pré-cadastro)
    """
    
    # === Campos de identificação do usuário ===
    user_id = serializers.IntegerField(required=False, allow_null=True)
    email = serializers.EmailField(required=False, allow_blank=True)
    session_id = serializers.CharField(
        required=False, 
        allow_blank=True,
        max_length=100,
        help_text="ID da sessão para usuários não autenticados"
    )
    
    # === Dados do consentimento (obrigatórios) ===
    version = serializers.CharField(
        required=True,
        max_length=20,
        help_text="Versão do termo aceito (ex: 'v1.0_2026-05')"
    )
    
    purposes = serializers.ListField(
        child=serializers.ChoiceField(choices=[
            'essential',
            'authentication',
            'service_delivery',
            'legal_compliance',
            'analytics',
            'marketing',
            'behavior_tracking',
            'ai_features',
        ]),
        required=True,
        allow_empty=False,
        help_text="Finalidades para as quais o consentimento é dado"
    )
    
    accepted_at = serializers.DateTimeField(required=True)
    
    # === Metadados técnicos (write-only) ===
    ip_address = serializers.CharField(required=False, write_only=True)
    user_agent = serializers.CharField(required=False, allow_blank=True, write_only=True)
    
    # === Campos de leitura (output) ===
    id = serializers.IntegerField(read_only=True)
    ip_hash = serializers.CharField(read_only=True)
    created_at = serializers.DateTimeField(read_only=True)
    revoked_at = serializers.DateTimeField(read_only=True, allow_null=True)
    
    # === VALIDAÇÕES ===
    
    def validate_version(self, value):
        """Valida formato da versão do termo"""
        if not re.match(r'^v\d+\.\d+_\d{4}-\d{2}$', value):
            raise serializers.ValidationError(
                "Versão deve seguir formato: vMAJOR.MINOR_YYYY-MM (ex: v1.0_2026-05)"
            )
        return value
    
    def validate_purposes(self, purposes):
        """Valida finalidades de consentimento"""
        request = self.context.get("request")
        
        # ✅ VERIFICAÇÃO SEGURA: Só acessa .action se for ViewSet
        view = request.parser_context.get("view") if request else None
        is_register_action = (
            view 
            and hasattr(view, "action")  # ← VERIFICA SE TEM O ATRIBUTO
            and view.action == "register"
        )
        
        # Permite todas as finalidades no cadastro inicial
        if is_register_action:
            return purposes
        
        # Em outros contextos, valida contra finalidades permitidas
        valid_purposes = [choice[0] for choice in ConsentRecord.PURPOSE_CHOICES]
        invalid = set(purposes) - set(valid_purposes)
        
        if invalid:
            raise serializers.ValidationError(
                f"Finalidades inválidas: {', '.join(invalid)}"
            )
        
        return purposes
    
    def validate(self, attrs):
        """Validação geral do consentimento"""
        user_id = attrs.get('user_id')
        email = attrs.get('email')
        session_id = attrs.get('session_id')
        
        # ✅ Validação: Usuário autenticado deve corresponder ao user_id
        if user_id:
            try:
                user = User.objects.get(id=user_id)
                request = self.context.get('request')
                if request and request.user.is_authenticated:
                    if request.user.id != user_id:
                        raise serializers.ValidationError(
                            "user_id não corresponde ao usuário autenticado"
                        )
            except User.DoesNotExist:
                raise serializers.ValidationError("Usuário não encontrado")
        
        # ✅ Validação: Anônimos precisam de email OU session_id
        elif not email and not session_id:
            raise serializers.ValidationError(
                "Para usuários não autenticados, email ou session_id são obrigatórios"
            )
        
        # ✅ Validação: Evitar duplicidade de consentimento para mesma versão
        if email and not user_id:
            existing = ConsentRecord.objects.filter(
                email__iexact=email,  # Case-insensitive
                revoked_at__isnull=True,
                term_version=attrs['version']
            ).exists()
            if existing:
                raise serializers.ValidationError(
                    "Consentimento para esta versão já registrado para este email"
                )
        
        # ✅ Validação: accepted_at não pode ser futuro
        from django.utils import timezone
        if attrs.get('accepted_at') and attrs['accepted_at'] > timezone.now():
            raise serializers.ValidationError(
                "accepted_at não pode ser uma data futura"
            )
        
        return attrs

    # === MÉTODOS AUXILIARES ===
    
    def _hash_ip(self, ip_address: str) -> str:
        """Gera hash SHA-256 do IP + salt para anonimização (Art. 12, LGPD)"""
        if not ip_address:
            return ''
        salt = getattr(settings, 'LGPD_IP_SALT', get_random_string(32))
        return hashlib.sha256(f"{ip_address}{salt}".encode('utf-8')).hexdigest()
    
    def create(self, validated_data):
        """Cria novo registro de consentimento"""
        # Extrair metadados técnicos (não salvos diretamente)
        ip_address = validated_data.pop('ip_address', None)
        user_agent = validated_data.pop('user_agent', '')[:500]  # Truncar para segurança
        
        # Gerar hash do IP para anonimização
        ip_hash = self._hash_ip(ip_address) if ip_address else ''
        
        # Determinar usuário e email
        user = None
        request = self.context.get('request')
        
        if request and request.user.is_authenticated:
            # Usuário logado: usar dados da sessão
            user = request.user
            validated_data['user'] = user
            validated_data['email'] = user.email.lower()
        elif validated_data.get('email'):
            # Anônimo com email: normalizar para lowercase
            validated_data['email'] = validated_data['email'].lower()
        
        # Converter purposes para JSONField (lista de strings)
        purpose_flags = validated_data.pop('purposes', [])
        
        # Criar registro no banco
        consent = ConsentRecord.objects.create(
            ip_hash=ip_hash,
            user_agent=user_agent,
            purpose_flags=purpose_flags,  # JSONField
            **validated_data
        )
        
        return consent
    
    def update(self, instance, validated_data):
        """Atualização direta não é permitida - usar endpoint de revogação"""
        raise serializers.ValidationError(
            "Atualização direta não permitida. Use o endpoint de revogação para modificar consentimentos."
        )
    
    def to_representation(self, instance):
        """Personaliza a saída para esconder dados sensíveis"""
        representation = super().to_representation(instance)
        
        # Remover campos sensíveis da resposta
        representation.pop('ip_hash', None)
        representation.pop('user_agent', None)
        representation.pop('session_id', None)
        
        # Adicionar campos úteis para o frontend
        representation['purposes_granted'] = instance.purpose_flags
        representation['can_revoke'] = [
            p for p in instance.purpose_flags 
            if p not in getattr(settings, 'LGPD_ESSENTIAL_PURPOSES', ['essential', 'authentication', 'legal_compliance'])
        ]
        
        return representation


class ConsentRevocationSerializer(serializers.Serializer):
    """
    Serializer para revogação de consentimento (Art. 8º, §5º)
    Permite revogar finalidades não-essenciais
    """
    purpose = serializers.ChoiceField(
        choices=[
            'analytics',
            'marketing', 
            'behavior_tracking',
            'ai_features',
        ],
        required=True,
        help_text="Finalidade para a qual o consentimento está sendo revogado"
    )
    reason = serializers.CharField(
        required=False,
        allow_blank=True,
        max_length=500,
        help_text="Motivo opcional para a revogação (para analytics interno)"
    )
    
    def validate(self, attrs):
        """Valida que o usuário está autenticado para revogar"""
        request = self.context.get('request')
        if not request or not request.user.is_authenticated:
            raise serializers.ValidationError("Autenticação necessária para revogar consentimento")
        return attrs


class ConsentSummarySerializer(serializers.Serializer):
    """
    Serializer para listar consentimentos do usuário (Art. 18, II - Direito de acesso)
    Retorna apenas campos seguros para o titular dos dados
    """
    id = serializers.IntegerField(read_only=True)
    version = serializers.CharField(read_only=True)
    purposes = serializers.ListField(child=serializers.CharField(), read_only=True)
    accepted_at = serializers.DateTimeField(read_only=True)
    revoked_at = serializers.DateTimeField(read_only=True, allow_null=True)
    is_active = serializers.SerializerMethodField()
    
    def get_is_active(self, obj) -> bool:
        """Verifica se o consentimento ainda está ativo (não revogado)"""
        return obj.revoked_at is None
    
    class Meta:
        ref_name = "ConsentSummary"  # Nome único para documentação OpenAPI


class ConsentExportSerializer(serializers.Serializer):
    """
    Serializer para exportação de dados pessoais (Art. 18, III - Portabilidade)
    Retorna todos os dados do titular em formato estruturado
    """
    email = serializers.EmailField(read_only=True)
    consents = ConsentSummarySerializer(many=True, read_only=True)
    export_generated_at = serializers.DateTimeField(read_only=True)
    
    def to_representation(self, instance):
        """Gera exportação completa dos dados do usuário"""
        from django.utils import timezone
        
        user = instance.get('user')
        consents = instance.get('consents', [])
        
        return {
            'email': user.email if user else instance.get('email'),
            'consents': ConsentSummarySerializer(consents, many=True).data,
            'export_generated_at': timezone.now().isoformat(),
            'data_retention_days': getattr(settings, 'LGPD_CONSENT_RETENTION_DAYS', 730),
            'contact_dpo': 'privacidade@minhaamora.com.br',  # Configurar em settings
        }