// src/services/api.ts - CONFIGURAÇÃO BASE OTIMIZADA + LGPD FIX
import axios, { AxiosError, InternalAxiosRequestConfig } from "axios";

// ✅ Base URL com fallback seguro
const rawBaseUrl = (import.meta as any).env?.VITE_API_BASE_URL || "https://dev-brih.onrender.com";
const finalBaseUrl = rawBaseUrl.replace(/\/$/, "") + "/api";

// 🔐 Helpers de Token
export function getToken(): string | null {
  return localStorage.getItem("auth_token");
}

export function setToken(token: string) {
  localStorage.setItem("auth_token", token);
  api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
}

export function clearToken() {
  localStorage.removeItem("auth_token");
  localStorage.removeItem("refresh_token");
  localStorage.removeItem("auth_user");
  delete api.defaults.headers.common["Authorization"];
}

// 🚀 Instância principal do Axios
export const api = axios.create({
  baseURL: finalBaseUrl,
  headers: { 
    "Content-Type": "application/json",
    "Accept": "application/json"
  },
  timeout: 30000, // ✅ 30 segundos para cold starts do Render
});

// ==========================================
// ✅ LISTAS DE ROTAS - CRÍTICO PARA LGPD
// ==========================================

// 🔓 Rotas VERDADEIRAMENTE públicas (NÃO recebem JWT)
const PUBLIC_ROUTES = [
  '/auth/login/',
  '/auth/register/',
  '/auth/firebase/',      // ← Firebase auth usa token próprio
  '/auth/refresh/',
  '/public/',
  '/vitrine/',
  '/theme/',
  '/health/',
  '/products/lookup/',
  '/schema/',
  '/docs/',
  '/redoc/',
  // ✅ REMOVIDO: '/consent/' - rotas de consentimento usam JWT!
];

// 🔐 Rotas de consentimento que DEVEM receber JWT (usuário autenticado)
// Estas NÃO estão em PUBLIC_ROUTES, então recebem token automaticamente
const CONSENT_PROTECTED_ROUTES = [
  '/consent/my/',         // ← Lista consentimentos do usuário (REQUER JWT)
  '/consent/revoke/',     // ← Revoga consentimento (REQUER JWT)
  '/consent/export/',     // ← Exporta dados (REQUER JWT)
];

// 🔁 Interceptador REQUEST - LÓGICA CORRIGIDA
api.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = getToken();
    const url = config.url || '';
    const method = config.method?.toLowerCase();
    
    // ✅ Verificar tipo de rota
    const isPublicRoute = PUBLIC_ROUTES.some(route => url.includes(route));
    
    // ✅ Caso especial: POST /consent/ pode ser público, mas GET/DELETE requerem JWT
    const isConsentPublicPost = url.includes('/consent/') && method === 'post' && !url.includes('/my/') && !url.includes('/revoke/');
    
    // ✅ Só injetar token JWT se:
    // 1. Token existe
    // 2. NÃO é rota pública
    // 3. NÃO é POST público de consentimento
    // 4. Header ainda não foi definido
    if (token && !isPublicRoute && !isConsentPublicPost && !config.headers["Authorization"]) {
      config.headers["Authorization"] = `Bearer ${token}`;
      if (import.meta.env.DEV) {
        console.log(`✅ JWT injetado em ${method?.toUpperCase()} ${url}`);
      }
    } else if (import.meta.env.DEV) {
      const reason = isPublicRoute ? 'rota pública' : isConsentPublicPost ? 'POST consent público' : 'sem token';
      console.log(`🔍 ${reason}: ${method?.toUpperCase()} ${url}`);
    }
    
    return config;
  },
  (error: AxiosError) => {
    if (import.meta.env.DEV) {
      console.error("❌ Request Error:", error);
    }
    return Promise.reject(error);
  }
);

// 🚨 Interceptador RESPONSE
api.interceptors.response.use(
  (response) => {
    if (import.meta.env.DEV) {
      console.log(`✅ ${response.status} ${response.config.url}`);
    }
    return response;
  },
  async (error: AxiosError) => {
    const status = error.response?.status;
    const url = error.config?.url || '';
    
    // ✅ Log de erro apenas em desenvolvimento
    if (import.meta.env.DEV) {
      console.error(`❌ ${status} ${url}`, {
        message: error.message,
        data: error.response?.data,
      });
    }
    
    // ✅ Tratamento de erro 401 (token expirado/inválido)
    if (status === 401) {
      const isAuthRoute = url.includes('/auth/');
      const isConsentRoute = url.includes('/consent/');
      
      // ✅ NÃO limpar token em rotas de auth ou consentimento (pode ser validação de dados)
      if (!isAuthRoute && !isConsentRoute && getToken()) {
        console.warn("🔒 Sessão expirada ou inválida. Limpando dados locais.");
        clearToken();
        
        if (!window.location.pathname.includes('/auth')) {
          setTimeout(() => {
            window.location.href = '/auth';
          }, 100);
        }
      }
    }
    
    // ✅ Tratamento de erro 403 (proibido - pode ser consentimento pendente)
    if (status === 403) {
      const data = error.response?.data as any;
      if (data?.action_required === 'accept_consent') {
        console.log("🔐 Consentimento necessário");
        // Emitir evento para frontend mostrar modal
        window.dispatchEvent(new CustomEvent('consent-required'));
      }
    }
    
    // ✅ Tratamento de erro 404
    if (status === 404 && import.meta.env.DEV) {
      console.warn(`⚠️ Endpoint não encontrado: ${url}`);
    }
    
    // ✅ Tratamento de timeout
    if (error.code === 'ECONNABORTED' || error.message?.includes('timeout')) {
      console.warn(`⏳ Timeout na requisição para ${url}`);
    }
    
    return Promise.reject(error);
  }
);

// ✅ Inicialização: Carrega token salvo ao iniciar
const initializeApi = () => {
  const token = getToken();
  if (token) {
    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    if (import.meta.env.DEV) {
      console.log("🔐 Token JWT carregado do localStorage");
    }
  }
};

if (typeof window !== 'undefined') {
  initializeApi();
}

export default api;