// src/services/api.ts - CONFIGURAÇÃO BASE OTIMIZADA
import axios, { AxiosError } from "axios";

const rawBaseUrl = (import.meta as any).env?.VITE_API_BASE_URL || "https://gestao-estoque-k5vy.onrender.com";
const finalBaseUrl = rawBaseUrl.replace(/\/$/, "") + "/api"; // ✅ Adicionar /api/ aqui

// 🔐 Token helpers
export function getToken(): string | null {
  return localStorage.getItem("auth_token");
}

export function setToken(token: string) {
  localStorage.setItem("auth_token", token);
  // ✅ Configurar header automaticamente
  api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
}

export function clearToken() {
  localStorage.removeItem("auth_token");
  localStorage.removeItem("auth_user");
  // ✅ Remover header automaticamente
  delete api.defaults.headers.common["Authorization"];
}

// 🚀 Instância principal do Axios
export const api = axios.create({
  baseURL: finalBaseUrl,
  headers: { 
    "Content-Type": "application/json",
    "Accept": "application/json"
  },
  timeout:60000,
});

// 🔁 Interceptador REQUEST
api.interceptors.request.use(
  (config) => {
    const token = getToken();
    if (token && !config.headers["Authorization"]) {
      config.headers["Authorization"] = `Bearer ${token}`;
    }
    
    console.log(`🚀 API Request: ${config.method?.toUpperCase()} ${config.url}`);
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
    console.log(`✅ API Response: ${response.status} ${response.config.url}`);
    return response;
  },
  async (error: AxiosError) => {
    const status = error.response?.status;
    const url = error.config?.url;
    
    console.error(`❌ API Error: ${status} ${url}`, error.response?.data);
    
    if (status === 401) {
      console.warn("🔒 Sessão expirada, limpando dados");
      clearToken();
      // Não redirecionar automaticamente, deixar componente decidir
    }
    
    return Promise.reject(error);
  }
);

// ✅ Inicializar token se existir
const initializeApi = () => {
  const token = getToken();
  if (token) {
    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    console.log("🔐 Token carregado do localStorage");
  }
};

initializeApi();

export default api;