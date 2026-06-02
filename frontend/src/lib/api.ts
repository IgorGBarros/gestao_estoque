// src/lib/api.ts - VERSÃO FINAL CONSOLIDADA
import {
  isDemoMode, DEMO_INVENTORY, DEMO_MOVEMENTS,
  DEMO_PROFILE, DEMO_BATCHES
} from "./demoData";
// ✅ Importar instância Axios E helpers de token da configuração global
import { api, getToken, setToken, clearToken } from "../services/api";

// ✅ CORREÇÃO: Base URL limpa (services/api.ts já adiciona /api/)
const API_BASE_URL = ((import.meta as any).env?.VITE_API_BASE_URL || "https://dev-brih.onrender.com")
  .replace(/\/$/, "");

// ✅ REMOVIDO: getToken, setToken, clearToken duplicados
// Agora importados de "@/services/api" para consistência

// ✅ CORREÇÃO: Função apiRequest usando Axios (consistente com services/api.ts)
async function apiRequest<T>(endpoint: string, options: RequestInit = {}): Promise<T> {
  // ✅ CORREÇÃO: Não duplicar /api/ - services/api.ts já adiciona
  const cleanEndpoint = endpoint.startsWith('/') ? endpoint : `/${endpoint}`;
  
  console.log(`🔄 API Request: ${options.method || 'GET'} ${cleanEndpoint}`);
  
  try {
    // ✅ Usa instância Axios configurada (com interceptors, timeout, etc.)
    const response = await api({
      url: cleanEndpoint,
      method: options.method || 'GET',
      data: options.body ? JSON.parse(options.body as string) : undefined,
      headers: {
        "Content-Type": "application/json",
        ...(options.headers as Record<string, string>),
      },
    });
    
    console.log(`📊 Response Status: ${response.status} for ${cleanEndpoint}`);
    
    // ✅ Tratamento de 401: deixar services/api.ts gerenciar (já tem lógica mais robusta)
    if (response.status === 204) return null as T;
    
    console.log(`✅ API Success: ${cleanEndpoint}`, response.data);
    return response.data as T;
    
  } catch (error: any) {
    console.error(`❌ API Request Failed: ${endpoint}`, {
      message: error.message,
      status: error.response?.status,
      data: error.response?.data
    });
    
    // ✅ Propaga erro formatado para o caller
    if (error.response?.data?.error || error.response?.data?.detail) {
      throw new Error(error.response.data.error || error.response.data.detail);
    }
    throw error;
  }
}

// ── Auth (endpoints sem /api/ duplicado) ──
export interface AuthUser {
  id: number | string;
  email: string;
  name?: string;
}

export const authApi = {
  login: (email: string, password: string) =>
    apiRequest<{ access: string; refresh: string }>("/auth/login/", {
      method: "POST",
      body: JSON.stringify({ email, password }),
    }),
  register: (email: string, password: string, name: string) =>
    apiRequest<{ access: string; refresh: string; user?: AuthUser }>("/auth/register/", {
      method: "POST",
      body: JSON.stringify({ email, password, name }),
    }),
  firebaseLogin: (firebaseIdToken: string) =>
    apiRequest<{ access: string; refresh: string }>("/auth/firebase/", {
      method: "POST",
      body: JSON.stringify({ token: firebaseIdToken }),
    }),
  me: () => apiRequest<AuthUser>("/auth/me/"),
  logout: () => apiRequest<void>("/auth/logout/", { method: "POST" }).catch(() => {}),
};

// ── Product (Global Catalog) ──
export interface GlobalProduct {
  id: number;
  name: string;
  sku: string | null;
  barcode: string;
  category: string;
  official_price: number | null;
  image_url: string | null;
  brand: string | null;
  description: string | null;
}

export interface LookupResult {
  found: boolean;
  source: "local" | "remote" | "remote_learned" | "remote_partial" | "suggestion" | "fuzzy" | "none";
  product?: GlobalProduct | null; 
  suggestions?: GlobalProduct[];  
  data?: any;                     
  message?: string | null; 
}

export const productLookupApi = {
  lookup: (barcodeOrName: string | null) => {
    const query = barcodeOrName ?? "";
    return apiRequest<LookupResult>(`/products/lookup/?q=${encodeURIComponent(query)}`);
  },
  confirmMatch: (barcode: string, productId: number) =>
    apiRequest<GlobalProduct>("/products/confirm-match/", {
      method: "POST",
      body: JSON.stringify({ barcode, product_id: productId }),
    }),
};

// ✅ Sistema de cache melhorado
let inventoryCache: InventoryItem[] | null = null;
let movementsCache: Movement[] | null = null;
let cacheTimestamp: { inventory?: number; movements?: number } = {};
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutos

export const clearAppCache = () => {
  console.log("🧹 Limpando cache da aplicação");
  inventoryCache = null;
  movementsCache = null;
  cacheTimestamp = {};
};

function isCacheValid(type: 'inventory' | 'movements'): boolean {
  const timestamp = cacheTimestamp[type];
  if (!timestamp) return false;
  const isValid = Date.now() - timestamp < CACHE_DURATION;
  if (!isValid) console.log(`⏰ Cache ${type} expirado`);
  return isValid;
}

// ── Inventory ──
export interface InventoryItem {
  product_id?: string | number;
  id: string;
  total_quantity?: number;
  min_quantity?: number;
  cost_price: number;
  sale_price: number | null;
  product?: {
    id: number | string;
    name: string;
    bar_code: string;
    natura_sku: string;
    category: string;
    image_url: string;
    official_price: number;
    brand?: string;
  };
  batches?: InventoryBatch[];
  quantity?: number;
  barcode?: string;
  product_name?: string;
  custom_name?: string | null;
  category?: string;
  brand?: string | null;
  official_price?: number | null;
  sale_type?: string | null;
  expiry_date?: string | null;
  expiry_photo_url?: string | null;
  image_url?: string | null;
  sku?: string | null;
  is_available_storefront?: boolean;
  created_at?: string;
  updated_at?: string;
}

export const stockApi = {
  create: async (data: Record<string, any>) => {
    if (isDemoMode()) return { ...DEMO_INVENTORY[0], ...data } as InventoryItem;
    const res = await apiRequest<InventoryItem>("/stock/entry/", {
      method: "POST",
      body: JSON.stringify(data),
    });
    clearAppCache();
    return res;
  }
};

export const inventoryApi = {
  list: async (forceRefresh = false) => {
    console.log(`📦 Carregando inventário (forceRefresh: ${forceRefresh})`);
    if (isDemoMode()) {
      console.log("🎭 Modo demo ativo");
      return DEMO_INVENTORY;
    }
    if (!forceRefresh && isCacheValid('inventory') && inventoryCache) {
      console.log("⚡ Usando cache do inventário");
      return inventoryCache;
    }
    try {
      const data = await apiRequest<InventoryItem[]>("/inventory/");
      inventoryCache = data;
      cacheTimestamp.inventory = Date.now();
      console.log(`✅ Inventário carregado: ${data.length} itens`);
      return data;
    } catch (error) {
      console.error("❌ Erro ao carregar inventário:", error);
      if (inventoryCache && (error as any).response?.status !== 401) {
        console.log("🔄 Usando cache como fallback");
        return inventoryCache;
      }
      throw error;
    }
  },

  getByBarcode: async (barcode: string): Promise<InventoryItem | null> => {
    console.log(`🔍 Buscando produto por código: ${barcode}`);
    if (isDemoMode()) {
      const found = DEMO_INVENTORY.find(item => 
        item.product?.bar_code === barcode || item.barcode === barcode
      );
      return found || null;
    }
    try {
      const data = await apiRequest<InventoryItem>(`/inventory/by-barcode/${encodeURIComponent(barcode)}/`);
      console.log("✅ Produto encontrado:", data);
      return data;
    } catch (error: any) {
      console.error(`❌ Erro ao buscar produto ${barcode}:`, error);
      if (error.response?.status === 404 || error.message?.includes('404')) {
        console.log("📝 Produto não encontrado no estoque (404)");
        return null;
      }
      throw error;
    }
  },

  update: async (id: string, data: Partial<InventoryItem>) => {
    console.log(`📝 Atualizando item ${id}:`, data);
    if (isDemoMode()) return { ...DEMO_INVENTORY[0], ...data };
    try {
      const result = await apiRequest<InventoryItem>(`/inventory/${id}/`, {
        method: "PATCH",
        body: JSON.stringify(data),
      });
      clearAppCache();
      console.log("✅ Item atualizado:", result);
      return result;
    } catch (error) {
      console.error(`❌ Erro ao atualizar item ${id}:`, error);
      throw error;
    }
  },

  delete: async (id: string) => {
    console.log(`🗑️ Removendo item ${id}`);
    if (isDemoMode()) return;
    try {
      await apiRequest<void>(`/inventory/${id}/`, { method: "DELETE" });
      clearAppCache();
      console.log("✅ Item removido");
    } catch (error) {
      console.error(`❌ Erro ao remover item ${id}:`, error);
      throw error;
    }
  },
};

// ✅ API FIFO
export const fifoApi = {
  applyWithdrawal: async (data: {
    product_id: string;
    quantity: number;
    transaction_type: string;
    unit_price?: number;
    notes?: string;
    batch_id?: string | null;
  }) => {
    try {
      console.log('🎯 Aplicando baixa FIFO:', data);
      const response = await apiRequest<{
        message: string;
        product_name: string;
        quantity_withdrawn: number;
        new_total_quantity: number;
        batches_used: Array<{ batch_id: number; quantity_used: number; expiration_date: string }>;
      }>('/fifo-withdrawal/', {
        method: 'POST',
        body: JSON.stringify(data)
      });
      console.log('✅ FIFO aplicado com sucesso:', response);
      clearAppCache();
      return response;
    } catch (error) {
      console.error('❌ Erro ao aplicar FIFO:', error);
      throw error;
    }
  }
};

// ── Batches ──
export interface InventoryBatch {
  id: string;
  batch_code: string;
  quantity: number;
  cost_price: number;
  expiration_date: string | null;
  created_at: string;
  updated_at?: string;
}

export const batchApi = {
  listByItem: async (inventoryItemId: string): Promise<InventoryBatch[]> => {
    console.log(`📦 Carregando lotes para item ${inventoryItemId}`);
    if (isDemoMode()) return DEMO_BATCHES[inventoryItemId] || [];
    try {
      const data = await apiRequest<InventoryBatch[]>(`/inventory/${inventoryItemId}/batches/`);
      console.log(`✅ ${data.length} lotes carregados`);
      return data;
    } catch (error) {
      console.error(`❌ Erro ao carregar lotes:`, error);
      return [];
    }
  },
};

// ── Movements ──
export interface Movement {
  id: string;
  product_name: string;
  transaction_type: string;
  quantity: number;
  unit_price: number;
  created_at: string;
  description?: string;
  notes?: string;
  movement_type?: string;
}

export type TransactionType = "venda" | "presente" | "brinde" | "perda" | "uso_proprio";

export const movementsApi = {
  list: async (forceRefresh = false) => {
    console.log(`📊 Carregando movimentações (forceRefresh: ${forceRefresh})`);
    if (isDemoMode()) return DEMO_MOVEMENTS;
    if (!forceRefresh && isCacheValid('movements') && movementsCache) {
      console.log("⚡ Usando cache das movimentações");
      return movementsCache;
    }
    try {
      const data = await apiRequest<Movement[]>("/transactions/");
      movementsCache = data;
      cacheTimestamp.movements = Date.now();
      console.log(`✅ ${data.length} movimentações carregadas`);
      return data;
    } catch (error) {
      console.error("❌ Erro ao carregar movimentações:", error);
      if (movementsCache && (error as any).response?.status !== 401) {
        console.log("🔄 Usando cache como fallback");
        return movementsCache;
      }
      throw error;
    }
  },

  create: async (data: any) => {
    console.log("📝 Criando movimentação:", data);
    if (isDemoMode()) return { ...data, id: Date.now().toString() };
    try {
      const result = await apiRequest<Movement>("/transactions/", {
        method: "POST",
        body: JSON.stringify(data),
      });
      clearAppCache();
      console.log("✅ Movimentação criada:", result);
      return result;
    } catch (error) {
      console.error("❌ Erro ao criar movimentação:", error);
      throw error;
    }
  },
};

// ── Payments ──
export interface CheckoutResponse {
  checkout_url: string;
  payment_link_id: string;
  billing_cycle: string;
  status: string;
}
export interface SubscriptionStatus {
  plan: string;
  is_active: boolean;
  payment_provider: string | null;
  subscription_started_at: string | null;
  subscription_expires_at: string | null;
  days_remaining: number;
}
export interface AsaasConfig {
  environment: string;
  base_url: string;
  has_api_key: boolean;
  has_webhook_token: boolean;
  webhook_url: string;
}
export interface AsaasConnectionTest {
  status: "connected" | "error";
  balance?: number;
  environment?: string;
  message?: string;
}

export const paymentsApi = {
  createCheckout: (billingCycle: "monthly" | "yearly") =>
    apiRequest<CheckoutResponse>("/payments/asaas/checkout/", {
      method: "POST",
      body: JSON.stringify({ billing_cycle: billingCycle }),
    }),
  getSubscriptionStatus: () =>
    apiRequest<SubscriptionStatus>("/payments/asaas/status/"),
  cancelSubscription: () =>
    apiRequest<{ status: string; message: string }>("/payments/asaas/cancel/", {
      method: "POST",
    }),
};

export const adminPaymentsApi = {
  getAsaasConfig: () =>
    apiRequest<AsaasConfig>("/admin/payments/asaas/config/"),
  testAsaasConnection: () =>
    apiRequest<AsaasConnectionTest>("/admin/payments/asaas/test/", {
      method: "POST",
    }),
};

export const adminApi = {
  listUsers: () => apiRequest<any[]>("/admin/users/"),
  updatePlan: (id: string | number, plan: "free" | "pro") =>
    apiRequest<{ message: string; plan: string }>(`/admin/users/${id}/plan/`, {
      method: "PATCH",
      body: JSON.stringify({ plan }),
    }),
  updateSubscription: (id: string | number, data: any) =>
    apiRequest<{ message: string }>(`/admin/users/${id}/subscription/`, {
      method: "PATCH",
      body: JSON.stringify(data),
    }),
  getProductAnalytics: () => apiRequest<any>("/admin/analytics/products/"),
  getBehaviorAnalytics: () => apiRequest<any>("/admin/analytics/behavior/"),
  getMlInsights: () => apiRequest<any>("/admin/analytics/ml-insights/"),
  listPlanConfigs: () => apiRequest<any[]>("/admin/plan-configs/"),
  listPromotions: () => apiRequest<any[]>("/admin/promotions/"),
  getSystemStats: () => apiRequest<any>("/admin/stats/"),
  getApiMonitor: () => apiRequest<any>("/admin/api-monitor/"),
  getAsaasConfig: () => apiRequest<AsaasConfig>("/payments/asaas/config/"),
  testAsaasConnection: () =>
    apiRequest<AsaasConnectionTest>("/payments/asaas/test/", {
      method: "POST",
    }),
};

// ── Profile ──
export interface Profile {
  id: string;
  display_name: string | null;
  whatsapp_number: string | null;
  storefront_enabled: boolean;
  store_slug: string | null;
  plan: "free" | "pro";
  user?: { id: number; email: string; name?: string };
  stats?: {
    total_products: number;
    total_value: number;
    expired_products: number;
    near_expiry_products: number;
    low_stock_products: number;
  };
}

export const profileApi = {
  get: () => {
    if (isDemoMode()) return Promise.resolve(DEMO_PROFILE);
    return apiRequest<Profile>("/profile/");
  },
  update: (data: Partial<Profile>) => {
    if (isDemoMode()) return Promise.resolve({ ...DEMO_PROFILE, ...data } as Profile);
    return apiRequest<Profile>("/profile/", { 
      method: "PATCH", 
      body: JSON.stringify(data) 
    });
  },
};

// ── Storefront ──
export interface StorefrontItem {
  id: string;
  product_name?: string;
  display_name?: string;
  custom_name?: string | null;
  category?: string;
  brand?: string | null;
  sale_price?: number | null;
  total_quantity?: number;
  barcode?: string;
  expiry_date?: string | null;
  seller_name?: string | null;
  seller_whatsapp?: string | null;
  user_id?: string;
  image_url?: string | null;
  store_slug?: string | null;
  product?: {
    id: number | string;
    name: string;
    bar_code: string;
    natura_sku?: string;
    category: string;
    brand?: string | null;
    image_url?: string;
    official_price?: number;
  };
  stock_info?: {
    quantity: number;
    is_urgent: boolean;
    display_text: string;
  };
}

export const publicStorefrontApi = {
  listBySlug: async (slug: string) => {
    try {
      console.log(`🔍 Buscando vitrine por slug: ${slug}`);
      const response = await api.get(`/public/storefront/${slug}/`, {
        headers: { 'Content-Type': 'application/json' }
      });
      console.log('✅ Dados recebidos:', response.data);
      return response.data;
    } catch (error) {
      console.error('❌ Erro na API publicStorefront:', error);
      throw error;
    }
  },
  listById: async (sellerId: string) => {
    try {
      console.log(`🔍 Buscando vitrine por ID: ${sellerId}`);
      const response = await api.get('/public/storefront/', {
        params: { seller: sellerId },
        headers: { 'Content-Type': 'application/json' }
      });
      console.log('✅ Dados recebidos:', response.data);
      return response.data;
    } catch (error) {
      console.error('❌ Erro na API publicStorefront:', error);
      throw error;
    }
  }
};

export const storefrontApi = {
  list: (sellerId?: string) => {
    if (isDemoMode() || sellerId === "demo") {
      const imageMap: Record<string, string> = {
        d1: "/products/kaiak.jpg", d2: "/products/luna.jpg", d3: "/products/tododia.jpg",
        d4: "/products/chronos.jpg", d6: "/products/batom.jpg", d7: "/products/ekos.jpg",
      };
      return Promise.resolve(DEMO_INVENTORY
        .filter((i) => i.is_available_storefront && (i.quantity ?? 0) > 0)
        .map((i) => ({
          id: i.id, 
          product_name: i.product?.name || i.product_name || "Produto Demo",
          display_name: i.custom_name || i.product?.name || i.product_name || "Produto Demo",
          custom_name: i.custom_name || null, 
          category: i.product?.category || i.category || "Geral",
          brand: i.product?.brand || i.brand || null,
          sale_price: i.sale_price ?? null, 
          total_quantity: i.quantity ?? i.total_quantity ?? 0,
          barcode: i.product?.bar_code || i.barcode || "0000000000000",
          expiry_date: i.expiry_date ?? null, 
          seller_name: DEMO_PROFILE.display_name,
          seller_whatsapp: DEMO_PROFILE.whatsapp_number, 
          user_id: "demo",
          image_url: imageMap[i.id] || i.product?.image_url || i.image_url || null, 
          store_slug: DEMO_PROFILE.store_slug,
        })));
    }
    if (sellerId) return publicStorefrontApi.listById(sellerId);
    return apiRequest<StorefrontItem[]>("/storefront/");
  },
  listBySlug: (slug: string) => {
    if (slug === "demo") return storefrontApi.list("demo");
    return publicStorefrontApi.listBySlug(slug);
  },
};

// ── Outros serviços ──
export { productService } from "./productService";

export const ocrApi = {
  uploadAndExtract: async (file: File): Promise<{ expiry_date?: string; photo_url?: string }> => {
    const token = getToken();
    const formData = new FormData();
    formData.append("image", file);
    const response = await api.post("/ocr-expiry/", formData, {
      headers: {
        "Content-Type": "multipart/form-data",
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
    });
    return response.data;
  },
};

export function formatMoney(value: number | null | undefined): string {
  if (value == null || isNaN(value)) return "—";
  return `R$ ${value.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 })}`;
}

export const salesApi = {
  checkout: (payload: any) =>
    apiRequest<{ message: string; total: number }>("/sales/checkout/", {
      method: "POST",
      body: JSON.stringify(payload),
    }),
};

// ✅ FUNÇÕES HELPER
export function getProductBrand(item: any): string | null {
  return item.product?.brand || item.brand || null;
}
export function getProductDisplayName(item: any): string {
  return item.product?.name || item.display_name || item.product_name || item.custom_name || "Produto sem nome";
}
export function getProductQuantity(item: any): number {
  return item.total_quantity ?? item.quantity ?? 0;
}

export const debugApi = {
  checkHealth: async () => {
    try {
      const response = await api.get('/health/');
      return { status: response.status, ok: response.status === 200 };
    } catch (error: any) {
      return { status: error.response?.status || 0, ok: false, error: error.message };
    }
  },
  clearAllCache: () => {
    clearAppCache();
    localStorage.removeItem('demo_mode');
    console.log("🧹 Cache e configurações limpas");
  }
};

// ── Session Control ──
export interface SessionStatus {
  has_session: boolean;
  products_count?: number;
  duration_minutes?: number;
  total_estimated_cost?: number;
  session_id?: number;
}
export interface SessionSummary {
  products_count: number;
  total_estimated_cost: number;
  duration_minutes: number;
  session_id: number;
}

export const sessionApi = {
  getStatus: async (): Promise<SessionStatus> => {
    try {
      const response = await api.get('/session-control/');
      return response.data;
    } catch (error) {
      return { has_session: false };
    }
  },
  startSession: async () => {
    const response = await api.post('/session-control/', { action: 'start' });
    return response.data;
  },
  finishSession: async () => {
    const response = await api.post('/session-control/', { action: 'finish' });
    return response.data;
  },
  getSummary: async () => {
    const response = await api.get('/session-summary/');
    return response.data;
  },
  confirmInvestment: async (sessionId: number, data: any) => {
    const response = await api.post('/session-summary/', { session_id: sessionId, ...data });
    return response.data;
  }
};

// ── Theme Config ──
export interface ThemeConfig {
  color_primary: string;
  color_primary_light: string;
  color_success: string;
  color_text: string;
  color_accent: string;
  color_destructive: string;
  color_warning: string;
  color_background: string;
  color_card: string;
  color_border: string;
  app_name: string;
  logo_url: string | null;
  updated_at: string;
}

export const themeApi = {
  get: async (): Promise<ThemeConfig> => {
    const response = await api.get('/public/theme/', {
      headers: { 'Content-Type': 'application/json' }
    });
    return response.data;
  },
};

export const adminThemeApi = {
  get: () => apiRequest<ThemeConfig>('/admin/theme/'),
  update: (data: Partial<ThemeConfig>) =>
    apiRequest<ThemeConfig>('/admin/theme/', {
      method: 'PATCH',
      body: JSON.stringify(data),
    }),
};

// ── Dashboard Stats ──
export interface DashboardStats {
  investedValue: number;
  potentialValue: number;
  projectedProfit: number;
  monthSales: number;
  monthProfit: number;
}

export const statsApi = {
  getDashboard: () => apiRequest<DashboardStats>("/stats/dashboard/"),
};

// ==========================================
// CONSENTIMENTO LGPD (Art. 8º) - ✅ JÁ CORRETO
// ==========================================

export interface ConsentRecord {
  id: number;
  version: string;
  purposes: string[];  // ✅ Deve ser ARRAY
  accepted_at: string;
  revoked_at: string | null;
  is_active: boolean;
  purposes_granted?: string[];
  can_revoke?: string[];
}

export interface ConsentRequest {
  email?: string;
  session_id?: string;
  version: string;
  purposes: string[];
  accepted_at: string;
}

// ✅ FUNÇÃO AUXILIAR: Normaliza purpose_flags que pode vir como string JSON
function normalizeConsentRecord(raw: any): ConsentRecord {
  let purposes: string[] = [];
  
  if (Array.isArray(raw.purposes)) {
    purposes = raw.purposes;
  } else if (typeof raw.purposes === 'string') {
    try {
      purposes = JSON.parse(raw.purposes);
    } catch {
      purposes = raw.purposes.replace(/[\[\]"]/g, '').split(',').map((p: string) => p.trim()).filter((p: string) => p.length > 0);
    }
  } else if (Array.isArray(raw.purpose_flags)) {
    purposes = raw.purpose_flags;
  } else if (typeof raw.purpose_flags === 'string') {
    try {
      purposes = JSON.parse(raw.purpose_flags);
    } catch {
      purposes = raw.purpose_flags.replace(/[\[\]"]/g, '').split(',').map((p: string) => p.trim()).filter((p: string) => p.length > 0);
    }
  }
  
  return {
    id: raw.id,
    version: raw.version || raw.term_version || '',
    purposes,  // ✅ Sempre array
    accepted_at: raw.accepted_at,
    revoked_at: raw.revoked_at ?? null,
    is_active: raw.is_active ?? (raw.revoked_at === null),
    purposes_granted: raw.purposes_granted || purposes,
    can_revoke: raw.can_revoke,
  };
}

export const consentApi = {
  record: async (data: ConsentRequest): Promise<ConsentRecord> => {
    const response = await apiRequest<ConsentRecord>("/consent/", {
      method: "POST",
      body: JSON.stringify(data),
    });
    return normalizeConsentRecord(response);
  },

  revoke: async (purpose: string): Promise<{ status: string; purpose: string }> => {
    return apiRequest(`/consent/revoke/${purpose}/`, { method: "DELETE" });
  },

  getMyConsents: async (): Promise<{
    consents: ConsentRecord[];
    essential_purposes: string[];
    revocable_purposes: string[];
    current_version: string;
  }> => {
    const raw = await apiRequest<any>("/consent/my/");
    
    let consentsRaw: any[] = [];
    if (Array.isArray(raw)) {
      consentsRaw = raw;
    } else if (raw?.consents && Array.isArray(raw.consents)) {
      consentsRaw = raw.consents;  // ← Seu backend retorna assim
    } else if (raw?.results && Array.isArray(raw.results)) {
      consentsRaw = raw.results;
    }
    
    const consents = consentsRaw.map(normalizeConsentRecord);
    
    return {
      consents,
      essential_purposes: raw.essential_purposes || [],
      revocable_purposes: raw.revocable_purposes || [],
      current_version: raw.current_version || raw.version || "v1.0_2026-05",
    };
  },

  hasConsent: async (purpose: string): Promise<boolean> => {
    try {
      const { consents } = await consentApi.getMyConsents();
      return consents.some((c) => c.is_active && c.purposes.includes(purpose));
    } catch {
      return false;
    }
  },
  
  hasValidConsent: (
    consents: ConsentRecord[], 
    version: string = "v1.0_2026-05",
    essentialPurposes: string[] = ["essential", "authentication", "service_delivery"]
  ): boolean => {
    const active = consents.filter(c => c.is_active && c.version === version);
    if (active.length === 0) return false;
    const granted = new Set(active.flatMap(c => c.purposes));
    return essentialPurposes.every(p => granted.has(p));
  },
};