// src/services/api.ts - CONFIGURAÇÃO BASE OTIMIZADA
import axios, { AxiosError, InternalAxiosRequestConfig } from "axios";

const rawBaseUrl = (import.meta as any).env?.VITE_API_BASE_URL || "https://gestao-estoque-k5vy.onrender.com";
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
  timeout: 60000, // ✅ 60 segundos para evitar timeout em cold starts do Render
});

// 🔁 Interceptador REQUEST
api.interceptors.request.use(
  (config) => {
    const token = getToken();
    console.log("🔑 Token encontrado:", token ? "Sim" : "Não"); // Debug
    
    if (token && !config.headers["Authorization"]) {
      config.headers["Authorization"] = `Bearer ${token}`;
      console.log("✅ Header Authorization injetado");
    }
    
    return config;
  },
  (error) => {
    console.error("❌ Request Error:", error);
    return Promise.reject(error);
  }
);

// 🚨 Interceptador RESPONSE
api.interceptors.response.use(
  (response) => {
    if (import.meta.env.DEV) {
      console.log(`✅ API Response: ${response.status} ${response.config.url}`);
    }
    return response;
  },
  async (error: AxiosError) => {
    const status = error.response?.status;
    const url = error.config?.url;
    
    if (import.meta.env.DEV) {
      console.error(`❌ API Error: ${status} ${url}`, error.response?.data);
    }
    
    // Se for erro 401 (Não Autorizado), limpa o token localmente
    if (status === 401) {
      console.warn("🔒 Sessão expirada ou inválida (401). Limpando dados locais.");
      clearToken();
      
      // Opcional: Redirecionar para login se não estiver já lá
      // if (window.location.pathname !== '/auth') {
      //   window.location.href = '/auth';
      // }
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

initializeApi();

export default api;