// src/hooks/useAuth.tsx - VERSÃO COM RACE CONDITION FIX + TIMEOUT HANDLING
import React, { createContext, useContext, useEffect, useState, useCallback, useRef, ReactNode } from "react";
import { useNavigate, useLocation } from "react-router-dom"; // ✅ ADICIONAR useLocation
import axios from "axios";
import { api } from "../services/api";
import { auth, googleProvider, signInWithPopup } from "../firebaseConfig";
import { useToast } from "./use-toast";

// ==========================================
// ✅ CACHE DE PROFILE (FORA DO COMPONENTE)
// ==========================================
let profileCache: any | null = null;
let profileCacheTimestamp: number = 0;
const PROFILE_CACHE_DURATION = 2 * 60 * 1000; // 2 minutos

function isProfileCacheValid(): boolean {
  return profileCache !== null && (Date.now() - profileCacheTimestamp) < PROFILE_CACHE_DURATION;
}

let activeProfileRequest: Promise<any> | null = null;

const optimizedProfileApi = {
  get: async (forceRefresh = false): Promise<any> => {
    if (activeProfileRequest && !forceRefresh) return activeProfileRequest;
    if (!forceRefresh && isProfileCacheValid()) return Promise.resolve(profileCache!);
    
    activeProfileRequest = (async () => {
      try {
        const response = await api.get('/profile/', { timeout: 15000 });
        const data = response.data;
        profileCache = data;
        profileCacheTimestamp = Date.now();
        return data;
      } catch (error: any) {
        if (profileCache && !forceRefresh && error.response?.status !== 401) {
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
// ✅ INTERFACES
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
  is_staff?: boolean;
}

interface AuthContextData {
  user: User | null;
  loading: boolean;
  authLoading?: boolean; // ✅ Estado de loading para login específico
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string, name: string) => Promise<void>;
  signInWithGoogle: () => Promise<void>;
  signInDemo: () => void;
  signOut: () => Promise<void>;
  isAuthenticated: boolean;
  refreshProfile: () => Promise<void>;
}

const AuthContext = createContext<AuthContextData>({} as AuthContextData);

// ==========================================
// ✅ PROVIDER
// ==========================================
export function AuthProvider({ children }: { children: ReactNode }) {
  const navigate = useNavigate();
  const location = useLocation(); // ✅ ADICIONAR para usar em signIn
  const { toast } = useToast();
  
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [authLoading, setAuthLoading] = useState(false); // ✅ Loading específico para ações de auth
  const [isInitialized, setIsInitialized] = useState(false);
  
  // ✅ Ref para prevenir múltiplas inicializações simultâneas
  const initRef = useRef(false);

  // ==========================================
  // ✅ RENOVAR TOKEN
  // ==========================================
  const refreshToken = async (): Promise<string | null> => {
    const storedRefreshToken = localStorage.getItem("refresh_token");
    if (!storedRefreshToken) return null;

    try {
      const response = await axios.post(
        `${import.meta.env.VITE_API_BASE_URL}/api/auth/token/refresh/`,
        { refresh: storedRefreshToken },
        { timeout: 10000 }
      );
      const newAccessToken = response.data.access;
      localStorage.setItem("auth_token", newAccessToken);
      api.defaults.headers.common["Authorization"] = `Bearer ${newAccessToken}`;
      return newAccessToken;
    } catch (error) {
      console.warn("❌ Falha ao renovar token");
      return null;
    }
  };

  // ==========================================
  // ✅ LOGOUT
  // ==========================================
  const handleLogout = useCallback((shouldNavigate = true) => {
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token");
    localStorage.removeItem("auth_user");
    delete api.defaults.headers.common["Authorization"];
    optimizedProfileApi.clearCache();
    setUser(null);
    setIsInitialized(false);
    initRef.current = false;
    
    if (shouldNavigate && window.location.pathname !== '/auth') {
      navigate("/auth", { replace: true });
    }
  }, [navigate]);

  // ==========================================
  // ✅ INICIALIZAÇÃO COM PREVENÇÃO DE RACE CONDITION
  // ==========================================
  const initializeAuth = useCallback(async () => {
    // ✅ GUARD: Previne execuções concorrentes
    if (initRef.current) {
      if (import.meta.env.DEV) console.log("⏳ initializeAuth já está rodando, ignorando...");
      return;
    }
    
    // Marca como em execução
    initRef.current = true;
    
    if (import.meta.env.DEV) console.log("[DEBUG] initializeAuth iniciado");

    const storedToken = localStorage.getItem("auth_token");
    const storedUser = localStorage.getItem("auth_user");
    
    // Se não tem token, define como não logado imediatamente
    if (!storedToken) {
      setUser(null);
      setLoading(false);
      setIsInitialized(true);
      initRef.current = false; // Libera para futuras inicializações
      return;
    }

    // Define token inicial no Axios
    api.defaults.headers.common["Authorization"] = `Bearer ${storedToken}`;
    
    // Parse seguro do usuário salvo
    if (storedUser) {
      try {
        setUser(JSON.parse(storedUser));
      } catch (e) {
        localStorage.removeItem("auth_user");
      }
    }

    try {
      let profileData = null;
      
      // Tenta buscar perfil com tratamento específico para 401
      try {
        profileData = await optimizedProfileApi.get();
      } catch (err: any) {
        // Se for 401, tenta renovar UMA VEZ
        if (err.response?.status === 401) {
          if (import.meta.env.DEV) console.log("🔄 Token expirado. Tentando renovar...");
          const newToken = await refreshToken();
          
          if (newToken) {
            // Renovou com sucesso, busca perfil forçando refresh
            profileData = await optimizedProfileApi.get(true);
          } else {
            // Falha na renovação = sessão inválida
            if (import.meta.env.DEV) console.warn("🔒 Renovação falhou. Limpando sessão...");
            handleLogout(false);
            setLoading(false);
            setIsInitialized(true);
            initRef.current = false;
            return;
          }
        } else {
          // Outro erro (500, timeout, rede): mantém dados locais
          if (import.meta.env.DEV) console.warn("⚠️ Erro de rede ao carregar perfil, usando dados locais");
        }
      }

      // Se conseguiu dados do perfil, atualiza tudo
      if (profileData) {
        const userData: User = {
          ...(storedUser ? JSON.parse(storedUser) : {}),
          ...profileData,
          id: profileData.id || 0,
          email: profileData.email || '',
          name: profileData.display_name || profileData.name || '',
          is_staff: profileData.is_staff ?? false
        };
        setUser(userData);
        localStorage.setItem("auth_user", JSON.stringify(userData));
      }

    } catch (error: any) {
      if (import.meta.env.DEV) console.error("❌ Erro na inicialização:", {
        message: error?.message,
        status: error?.response?.status
      });
      handleLogout(false);
    } finally {
      // ✅ SEMPRE libera o ref e atualiza estado no finally
      setLoading(false);
      setIsInitialized(true);
      initRef.current = false;
    }
  }, [handleLogout]); // ← handleLogout é a ÚNICA dependência

  // ==========================================
  // ✅ EFEITO DE INICIALIZAÇÃO (COM GUARD EXTRA)
  // ==========================================
  useEffect(() => {
    // ✅ Verifica isInitialized E initRef para prevenir chamadas duplicadas
    if (!isInitialized && !initRef.current) {
      initializeAuth();
    }
  }, [isInitialized, initializeAuth]);

  // ==========================================
  // ✅ LOGIN (Email/Senha)
  // ==========================================
  const signIn = async (email: string, password: string) => {
    setAuthLoading(true); // ✅ Mostrar loading durante login
    
    try {
      const response = await api.post("/auth/login/", { email, password });
      const { access, refresh, consent_required } = response.data;
      
      if (!access) throw new Error("Token não recebido");
      
      // ✅ Verificar consentimento básico
      const hasBasicConsent = localStorage.getItem("cookie_consent_accepted") === "true";
      if (!hasBasicConsent) {
        // Redireciona para página de consentimento
        navigate("/consent", { state: { from: location } });
        return;
      }
      
      // ✅ Verificar se precisa de consentimento completo
      if (consent_required) {
        console.log("✅ Consentimento completo pendente");
        // O PostAuthConsentModal vai detectar e mostrar automaticamente
      }
      
      // Salvar tokens
      localStorage.setItem("auth_token", access);
      if (refresh) localStorage.setItem("refresh_token", refresh);
      api.defaults.headers.common["Authorization"] = `Bearer ${access}`;
      
      // Buscar perfil
      try {
        const profileData = await optimizedProfileApi.get(true);
        const userData: User = {
          id: profileData.id || 0,
          email: profileData.email || email,
          name: profileData.display_name || profileData.name || email.split('@')[0],
          ...profileData,
          is_staff: profileData.is_staff ?? false
        };
        localStorage.setItem("auth_user", JSON.stringify(userData));
        setUser(userData);
      } catch (e) {
        // Fallback básico se profile falhar
        setUser({ id: 0, email, name: email.split('@')[0], is_staff: false });
      }
      
    } catch (error: any) {
      console.error("❌ Erro no login:", error);
      
      // ✅ Mensagem amigável para timeout
      if (error.code === "ECONNABORTED" || error.message?.includes("timeout")) {
        toast({
          title: "⏳ Servidor respondendo lentamente",
          description: "Tente novamente em alguns instantes.",
          variant: "destructive",
        });
      } else {
        toast({
          title: "❌ Erro no login",
          description: error.message || "Credenciais inválidas",
          variant: "destructive",
        });
      }
      
      handleLogout(false);
      throw error;
    } finally {
      setAuthLoading(false); // ✅ Esconder loading
    }
  };

  const signUp = async (email: string, password: string, name: string) => {
    setAuthLoading(true);
    try {
      await api.post("/auth/register/", { email, password, name });
    } finally {
      setAuthLoading(false);
    }
  };

  // ==========================================
  // ✅ LOGIN GOOGLE
  // ==========================================
  const signInWithGoogle = async () => {
    setAuthLoading(true); // ✅ Mostrar loading durante login Google
    const startTime = Date.now();
    
    try {
      console.log("🔐 Iniciando login com Google...");
      
      // ✅ Login Firebase com popup
      const result = await signInWithPopup(auth, googleProvider);
      const idToken = await result.user.getIdToken();
      const fallbackEmail = result.user.email || "";
      const fallbackName = result.user.displayName || fallbackEmail.split("@")[0] || "Usuário";

      console.log("🔐 Enviando token para backend...", { 
        tokenLength: idToken?.length,
        timestamp: Date.now()
      });

      // ✅ Chamada ao backend com timeout explícito
      const response = await api.post("/auth/firebase/", { token: idToken });
      const { access, refresh } = response.data;

      if (!access) throw new Error("Token Django ausente");

      // Salvar tokens
      localStorage.setItem("auth_token", access);
      if (refresh) localStorage.setItem("refresh_token", refresh);
      api.defaults.headers.common["Authorization"] = `Bearer ${access}`;

      // Buscar perfil
      try {
        const profileData = await optimizedProfileApi.get(true);
        const userData: User = {
          id: profileData.id || 0,
          email: profileData.email || fallbackEmail,
          name: profileData.display_name || profileData.name || fallbackName,
          ...profileData,
          is_staff: profileData.is_staff ?? false
        };
        localStorage.setItem("auth_user", JSON.stringify(userData));
        setUser(userData);

        console.log("✅ Login Google completo:", {
          email: userData.email,
          duration: Date.now() - startTime
        });
      } catch (e) {
        console.warn("⚠️ Perfil não carregado, usando dados básicos");
        setUser({
          id: 0,
          email: fallbackEmail,
          name: fallbackName,
          is_staff: false
        });
      }
      
    } catch (error: any) {
      const duration = Date.now() - startTime;
      console.error("❌ Erro Google Sign-In:", {
        message: error.message,
        code: error.code,
        duration: `${duration}ms`
      });

      // ✅ Tratamento específico para erros comuns
      if (error.code === "ECONNABORTED" || error.message?.includes("timeout")) {
        toast({
          title: "⏳ Conexão lenta",
          description: "O servidor está respondendo lentamente. Tente novamente.",
          variant: "destructive",
        });
      } else if (error.message?.includes("popup-blocked")) {
        toast({
          title: "Popup bloqueado",
          description: "Permita popups para este site e tente novamente",
          variant: "destructive",
        });
      } else if (error.message?.includes("cancelado") || error.code === "auth/popup-closed-by-user") {
        // Não mostrar toast para cancelamento pelo usuário
        return;
      } else if (error.code === "auth/account-exists-with-different-credential") {
        toast({
          title: "Conta já existe",
          description: "Este email já está vinculado a outro método de login",
          variant: "destructive",
        });
      } else {
        toast({
          title: "Erro no login",
          description: error.message || "Tente novamente",
          variant: "destructive",
        });
      }

      throw error;
    } finally {
      setAuthLoading(false); // ✅ Esconder loading
    }
  };

  const signInDemo = () => {
    const demoUser: User = { 
      id: 999, 
      email: "demo@natura.com", 
      name: "Consultora Teste", 
      plan: "FREE",
      is_staff: false
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
      const updatedUser: User = { ...user, ...profileData, is_staff: profileData.is_staff ?? user?.is_staff ?? false };
      setUser(updatedUser);
      localStorage.setItem("auth_user", JSON.stringify(updatedUser));
    } catch (error) {
      console.error("❌ Erro ao atualizar profile:", error);
    }
  };

  return (
    <AuthContext.Provider value={{
      user, 
      loading, 
      authLoading, // ✅ Expor estado de loading para componentes
      signIn, 
      signUp, 
      signInWithGoogle, 
      signInDemo, 
      signOut,
      isAuthenticated: !!user, 
      refreshProfile
    }}>
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