// src/services/api.ts - CONFIGURAÇÃO BASE OTIMIZADA
import axios, { AxiosError, InternalAxiosRequestConfig } from "axios";

// ✅ Base URL com fallback seguro
const rawBaseUrl = (import.meta as any).env?.VITE_API_BASE_URL || "https://dev-brih.onrender.com";
const finalBaseUrl = rawBaseUrl.replace(/\/$/, "") + "/api"; // ✅ Adicionar /api/ aqui

// 🔐 Helpers de Token
export function getToken(): string | null {
  return localStorage.getItem("auth_token");
}

export function setToken(token: string) {
  localStorage.setItem("auth_token", token);
  // Configurar header automaticamente na instância global
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
  timeout: 30000, // ✅ 300 segundos para evitar timeout em cold starts do Render
});

// ✅ Lista de rotas públicas que NÃO devem receber token JWT
const PUBLIC_ROUTES = [
  '/auth/login/',
  '/auth/register/',
  '/auth/firebase/',
  '/auth/refresh/',
  '/consent/',
  '/public/',
  '/vitrine/',
  '/theme/',
  '/health/',
  '/products/lookup/',
];

// 🔁 Interceptador REQUEST
api.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = getToken();
    
    // ✅ Verificar se é rota pública
    const url = config.url || '';
    const isPublicRoute = PUBLIC_ROUTES.some(route => url.includes(route));
    
    // ✅ Só injetar token JWT se NÃO for rota pública
    if (token && !isPublicRoute && !config.headers["Authorization"]) {
      config.headers["Authorization"] = `Bearer ${token}`;
      if (import.meta.env.DEV) {
        console.log(`✅ Token JWT injetado em ${config.method?.toUpperCase()} ${url}`);
      }
    } else if (import.meta.env.DEV) {
      console.log(`🔍 ${isPublicRoute ? 'Rota pública' : 'Sem token'}: ${config.method?.toUpperCase()} ${url}`);
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
      // ✅ NÃO limpar token em rotas públicas (pode ser erro de validação de dados, não de auth)
      const isAuthRoute = url.includes('/auth/');
      
      if (!isAuthRoute && getToken()) {
        console.warn("🔒 Sessão expirada ou inválida. Limpando dados locais.");
        clearToken();
        
        // ✅ Redirecionar para login apenas se não estiver já na página de auth
        if (!window.location.pathname.includes('/auth')) {
          // Usar setTimeout para evitar loop de renderização
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
        // Opcional: redirecionar para página de consentimento
        if (!window.location.pathname.includes('/consent')) {
          console.log("🔐 Consentimento necessário, redirecionando...");
          // window.location.href = '/consent';
        }
      }
    }
    
    // ✅ Tratamento de erro 404 (endpoint não encontrado)
    if (status === 404 && import.meta.env.DEV) {
      console.warn(`⚠️ Endpoint não encontrado: ${url}`);
    }
    
    // ✅ Tratamento de erro de rede/timeout
    if (error.code === 'ECONNABORTED' || error.message?.includes('timeout')) {
      console.warn(`⏳ Timeout na requisição para ${url}`);
    }
    
    return Promise.reject(error);
  }
);

// ✅ Inicialização: Carrega token salvo ao iniciar a aplicação
const initializeApi = () => {
  const token = getToken();
  if (token) {
    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    if (import.meta.env.DEV) {
      console.log("🔐 Token carregado do localStorage");
    }
  }
};

// Executar inicialização apenas no lado do cliente
if (typeof window !== 'undefined') {
  initializeApi();
}

export default api;