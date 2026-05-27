# backend/core/inventory/urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter

from .views import (
    ProductViewSet,
    InventoryViewSet,
    StockTransactionViewSet,
    StockEntryView,
    SaleCheckoutView,
    inventory_item_batches_view,
    apply_fifo_withdrawal,
    debug_user_store,
    associate_user_store,
    fix_user_store,
)

# Router para ViewSets (CRUD automático)
router = DefaultRouter()
router.register(r'products', ProductViewSet, basename='product')
router.register(r'inventory', InventoryViewSet, basename='inventory')
router.register(r'transactions', StockTransactionViewSet, basename='stock-transaction')

urlpatterns = [
    # Rotas do Router (CRUD automático)
    path('', include(router.urls)),
    
    # ==========================================
    # 📦 OPERAÇÕES DE ESTOQUE
    # ==========================================
    path('stock/entry/', StockEntryView.as_view(), name='stock_entry'),
    path('sales/checkout/', SaleCheckoutView.as_view(), name='sale_checkout'),
    
    # ==========================================
    # 🔄 FIFO & LOTES
    # ==========================================
    path('inventory/<int:item_id>/batches/', inventory_item_batches_view, name='inventory_batches'),
    path('fifo-withdrawal/', apply_fifo_withdrawal, name='fifo_withdrawal'),
    
    # ==========================================
    # 🐛 DEBUG (apenas desenvolvimento)
    # ==========================================
    path('debug/user-store/', debug_user_store, name='debug_user_store'),
    path('debug/associate-store/', associate_user_store, name='associate_user_store'),
    path('debug/fix-store/', fix_user_store, name='fix_user_store'),
]