// src/hooks/useAuth.tsx
import React, { createContext, useContext, useEffect, useState, useCallback, useRef, ReactNode } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { api } from "../services/api";
// 1. IMPORTAÇÕES DO FIREBASE
import { auth, googleProvider, signInWithPopup } from "../firebaseConfig";
import { useToast } from "./use-toast";

// ==========================================
// ✅ SISTEMA DE CACHE DE PROFILE OTIMIZADO
// ==========================================
let profileCache: any | null = null;
let profileCacheTimestamp: number = 0;
const PROFILE_CACHE_DURATION = 2 * 60 * 1000; // 2 minutos

function isProfileCacheValid(): boolean {
  return profileCache !== null && 
         (Date.now() - profileCacheTimestamp) < PROFILE_CACHE_DURATION;
}

let activeProfileRequest: Promise<any> | null = null;

const optimizedProfileApi = {
  get: async (forceRefresh = false): Promise<any> => {
    if (activeProfileRequest && !forceRefresh) {
      return activeProfileRequest;
    }
    
    if (!forceRefresh && isProfileCacheValid()) {
      return Promise.resolve(profileCache!);
    }
    
    activeProfileRequest = (async () => {
      try {
        // ✅ TIMEOUT para evitar requisições pendentes indefinidamente
        const response = await api.get('/profile/', { timeout: 15000 });
        const data = response.data;
        profileCache = data;
        profileCacheTimestamp = Date.now();
        return data;
      } catch (error: any) {
        // ✅ FALLBACK para cache em caso de erro de rede (não 401)
        if (profileCache && !forceRefresh && error.response?.status !== 401) {
          console.log("⚡ Usando cache do profile devido a erro de rede");
          return profileCache;
        }
        throw error;
      } finally {
        activeProfileRequest = null;
      }
    })();
    
    return activeProfileRequest;
  },

  clearCache: () => {
    profileCache = null;
    profileCacheTimestamp = 0;
    activeProfileRequest = null;
  }
};

// ==========================================
// 2. INTERFACE DO USUÁRIO
// ==========================================
export interface User {
  id: number;
  email: string;
  name?: string;
  display_name?: string;
  store_name?: string;
  plan?: string;
  whatsapp_number?: string;
  store_slug?: string;
  storefront_enabled?: boolean;
  has_store?: boolean;
  can_add_products?: boolean;
}

interface AuthContextData {
  user: User | null;
  loading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string, name: string) => Promise<void>;
  signInWithGoogle: () => Promise<void>;
  signInDemo: () => void;
  signOut: () => Promise<void>;
  isAuthenticated: boolean;
  refreshProfile: () => Promise<void>;
}

const AuthContext = createContext<AuthContextData>({} as AuthContextData);

export function AuthProvider({ children }: { children: ReactNode }) {
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [isInitialized, setIsInitialized] = useState(false); 

  // Ref para evitar múltiplas inicializações simultâneas
  const initRef = useRef(false);

  // ==========================================
  // ✅ FUNÇÃO AUXILIAR: RENOVAR TOKEN
  // ==========================================
  const refreshToken = async (): Promise<string | null> => {
    const storedRefreshToken = localStorage.getItem("refresh_token");
    if (!storedRefreshToken) return null;

    try {
      // ✅ TIMEOUT na renovação para evitar pendências
      const response = await axios.post(
        `${import.meta.env.VITE_API_BASE_URL}/api/auth/token/refresh/`, 
        { refresh: storedRefreshToken },
        { timeout: 10000 }
      );
      
      const newAccessToken = response.data.access;
      
      // Atualiza tokens no storage e headers
      localStorage.setItem("auth_token", newAccessToken);
      api.defaults.headers.common["Authorization"] = `Bearer ${newAccessToken}`;
      
      console.log("🔄 Token renovado com sucesso");
      return newAccessToken;
    } catch (error: any) {
      // ✅ LOG SEGURO: Não expõe token ou email em produção
      console.warn("❌ Falha ao renovar token:", {
        status: error.response?.status,
        message: error.message
      });
      return null;
    }
  };

  // ==========================================
  // ✅ CARREGAR SESSÃO INICIAL (CORRIGIDO)
  // ==========================================
  const initializeAuth = useCallback(async () => {
    if (initRef.current) return;
    initRef.current = true;

    const storedToken = localStorage.getItem("auth_token");
    const storedUser = localStorage.getItem("auth_user");
    
    // ✅ Se não tem token, define como não logado imediatamente
    if (!storedToken) {
      setUser(null);
      setLoading(false);
      setIsInitialized(true);
      return;
    }

    // Define token inicial no Axios
    api.defaults.headers.common["Authorization"] = `Bearer ${storedToken}`;
    
    // ✅ Parse seguro do usuário salvo
    if (storedUser) {
      try {
        setUser(JSON.parse(storedUser));
      } catch (e) {
        console.warn("⚠️ Erro ao parsear usuário salvo, limpando...");
        localStorage.removeItem("auth_user");
      }
    }

    try {
      let profileData = null;
      
      // ✅ Tenta buscar perfil com tratamento específico para 401
      try {
        profileData = await optimizedProfileApi.get();
      } catch (err: any) {
        // Se for 401, tenta renovar UMA VEZ
        if (err.response?.status === 401) {
          console.log("🔄 Token expirado. Tentando renovar...");
          const newToken = await refreshToken();
          
          if (newToken) {
            // Renovou com sucesso, busca perfil forçando refresh
            profileData = await optimizedProfileApi.get(true);
          } else {
            // ❌ Falha na renovação = sessão inválida
            console.warn("🔒 Renovação falhou. Limpando sessão...");
            handleLogout(false);
            setLoading(false);
            setIsInitialized(true);
            return;
          }
        } else {
          // Outro erro (500, timeout, rede): mantém dados locais
          console.warn("⚠️ Erro de rede ao carregar perfil, usando dados locais");
        }
      }

      // ✅ Se conseguiu dados do perfil, atualiza tudo
      if (profileData) {
        const userData: User = {
          ...(storedUser ? JSON.parse(storedUser) : {}),
          ...profileData,
          id: profileData.id || 0,
          email: profileData.email || '',
          name: profileData.display_name || profileData.name || ''
        };
        setUser(userData);
        localStorage.setItem("auth_user", JSON.stringify(userData));
      }

    } catch (error: any) {
      // ✅ LOG SEGURO sem expor dados sensíveis
      console.error("❌ Erro crítico na inicialização:", {
        message: error.message,
        status: error.response?.status
      });
      handleLogout(false);
    } finally {
      setLoading(false);
      setIsInitialized(true);
      initRef.current = false;
    }
  }, []);

  useEffect(() => {
    if (!isInitialized) {
      initializeAuth();
    }
  }, [isInitialized, initializeAuth]);

  // ==========================================
  // ✅ LOGOUT HELPER (CORRIGIDO)
  // ==========================================
  const handleLogout = (shouldNavigate = true) => {
    // ✅ Limpa TUDO de forma atômica
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("auth_user");
    delete api.defaults.headers.common["Authorization"];
    optimizedProfileApi.clearCache();
    
    // ✅ Reseta estado do React
    setUser(null);
    setIsInitialized(false);
    initRef.current = false;
    
    // ✅ Navega com replace para evitar histórico de volta
    if (shouldNavigate && window.location.pathname !== '/auth') {
      navigate("/auth", { replace: true });
    }
  };

  // ==========================================
  // ✅ LOGIN NORMAL
  // ==========================================
  const signIn = async (email: string, password: string) => {
    try {
      const response = await api.post("/auth/login/", { email, password });
      const { access, refresh } = response.data;
      
      if (!access) throw new Error("Token não recebido");

      // ✅ Salva tokens com segurança
      localStorage.setItem("auth_token", access);
      if (refresh) localStorage.setItem("refresh_token", refresh);
      
      api.defaults.headers.common["Authorization"] = `Bearer ${access}`;
      
      // ✅ Busca perfil imediato com fallback
      try {
        const profileData = await optimizedProfileApi.get(true);
        const userData: User = {
          id: profileData.id || 0,
          email: profileData.email || email,
          name: profileData.display_name || profileData.name || email.split('@')[0],
          ...profileData
        };
        localStorage.setItem("auth_user", JSON.stringify(userData));
        setUser(userData);
      } catch (e) {
        // Fallback mínimo para não travar a UI
        console.warn("⚠️ Perfil não carregado no login, usando dados básicos");
        setUser({ id: 0, email, name: email.split('@')[0] });
      }
      
    } catch (error: any) {
      // ✅ Limpa estado em caso de erro crítico no login
      handleLogout(false);
      throw error;
    }
  };

  const signUp = async (email: string, password: string, name: string) => {
    await api.post("/auth/register/", { email, password, name });
  };

  // ==========================================
  // ✅ LOGIN GOOGLE
  // ==========================================
  const signInWithGoogle = async () => {
    try {
      const result = await signInWithPopup(auth, googleProvider);
      const idToken = await result.user.getIdToken(true);
      
      if (!idToken) throw new Error("Falha ao gerar credencial do Google");
      
      const response = await api.post("/auth/firebase/", { token: idToken });
      const { access, refresh } = response.data;
      
      if (!access) throw new Error("Token Django ausente");

      localStorage.setItem("auth_token", access);
      if (refresh) localStorage.setItem("refresh_token", refresh);
      
      api.defaults.headers.common["Authorization"] = `Bearer ${access}`;
      
      try {
        const profileData = await optimizedProfileApi.get(true);
        const userData: User = {
          id: profileData.id || 0,
          email: profileData.email || response.data.email,
          name: profileData.display_name || response.data.name || "Consultora",
          ...profileData
        };
        localStorage.setItem("auth_user", JSON.stringify(userData));
        setUser(userData);
      } catch (e) {
        console.warn("⚠️ Perfil não carregado no login Google, usando dados básicos");
        setUser({ id: 0, email: response.data.email, name: response.data.name || "Consultora" });
      }
      
    } catch (error: any) {
      console.error("❌ Erro Google Sign-In:", {
        message: error.message,
        status: error.response?.status
      });
      handleLogout(false); // Limpa estado em caso de erro
      if (error.response?.data?.error) {
        throw new Error(error.response.data.error);
      }
      throw error;
    }
  };

  const signInDemo = () => {
    const demoUser: User = { 
      id: 999, 
      email: "demo@natura.com", 
      name: "Consultora Teste",
      plan: "FREE"
    };
    setUser(demoUser);
    localStorage.setItem("auth_user", JSON.stringify(demoUser));
    localStorage.setItem("auth_token", "demo_token_123");
    api.defaults.headers.common["Authorization"] = `Bearer demo_token_123`;
  };

  const signOut = async () => {
    await auth.signOut().catch(() => {});
    handleLogout(true);
  };

  const refreshProfile = async () => {
    try {
      const profileData = await optimizedProfileApi.get(true);
      const updatedUser: User = { ...user, ...profileData };
      setUser(updatedUser);
      localStorage.setItem("auth_user", JSON.stringify(updatedUser));
    } catch (error) {
      console.error("❌ Erro ao atualizar profile:", error);
      throw error;
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        signIn,
        signUp,
        signInWithGoogle,
        signInDemo,
        signOut,
        isAuthenticated: !!user,
        refreshProfile
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth deve ser usado dentro de um AuthProvider");
  }
  return context;
};