// src/hooks/useAuth.tsx
import React, { createContext, useContext, useEffect, useState, useCallback, useRef, ReactNode } from "react";
import { useNavigate } from "react-router-dom";
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

// ✅ CONTROLE DE REQUISIÇÕES EM ANDAMENTO (evita duplicação/race conditions)
let activeProfileRequest: Promise<any> | null = null;

const optimizedProfileApi = {
  get: async (forceRefresh = false): Promise<any> => {
    console.log(`👤 Carregando profile (forceRefresh: ${forceRefresh})`);
    
    // Se há uma requisição em andamento, aguardar ela terminar
    if (activeProfileRequest && !forceRefresh) {
      console.log("⏳ Aguardando requisição de profile em andamento...");
      return activeProfileRequest;
    }
    
    // Usar cache se válido e não forçar refresh
    if (!forceRefresh && isProfileCacheValid()) {
      console.log("⚡ Usando cache do profile");
      return Promise.resolve(profileCache!);
    }
    
    // Criar nova requisição
    activeProfileRequest = (async () => {
      try {
        console.log("🔄 Buscando profile da API...");
        
        // ✅ AUMENTAR TIMEOUT PARA EVITAR ERROS NO RENDER (Cold Start)
        const response = await api.get('/profile/', { timeout: 60000 }); 
        const data = response.data;
        
        // Validação básica de integridade
        if (!data || typeof data !== 'object') {
          throw new Error("Resposta inválida do perfil");
        }

        // Atualizar cache
        profileCache = data;
        profileCacheTimestamp = Date.now();
        
        console.log("✅ Profile carregado e cacheado:", data);
        return data;
        
      } catch (error: any) {
        console.error("❌ Erro ao carregar profile:", error);
        
        // Se for erro de rede/timeout, não limpamos o cache antigo imediatamente
        // para permitir fallback suave
        if (profileCache && !forceRefresh) {
          console.log("🔄 Usando cache antigo do profile como fallback devido a erro de rede");
          return profileCache;
        }
        
        throw error;
      } finally {
        // Limpar promise após completar
        activeProfileRequest = null;
      }
    })();
    
    return activeProfileRequest;
  },

  clearCache: () => {
    console.log("🧹 Limpando cache do profile");
    profileCache = null;
    profileCacheTimestamp = 0;
    activeProfileRequest = null;
  }
};

// ==========================================
// 2. INTERFACE DO USUÁRIO EXPANDIDA
// ==========================================
export interface User {
  id: number;
  email: string;
  name?: string;
  first_name?: string;
  // ✅ Campos do profile completo vindos do backend
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

  // ==========================================
  // ✅ CARREGAR SESSÃO INICIAL OTIMIZADA
  // ==========================================
  useEffect(() => {
    if (!isInitialized) {
      initializeAuth();
    }
  }, [isInitialized]);

  const initializeAuth = async () => {
    const storedToken = localStorage.getItem("auth_token");
    const storedUser = localStorage.getItem("auth_user");
    
    if (!storedToken) {
      setLoading(false);
      setIsInitialized(true);
      return;
    }

    // Configurar token primeiro para futuras chamadas
    api.defaults.headers.common["Authorization"] = `Bearer ${storedToken}`;
    
    // Usar dados do localStorage temporariamente para evitar tela branca
    if (storedUser) {
      try {
        const tempUser = JSON.parse(storedUser);
        setUser(tempUser);
        console.log("📦 Dados temporários do localStorage carregados");
      } catch (e) {
        console.error("Erro ao parsear usuário salvo", e);
        localStorage.removeItem("auth_user");
      }
    }

    try {
      console.log("🔐 Token encontrado, validando sessão e carregando profile...");
      
      // UMA ÚNICA CHAMADA DE PROFILE COM CACHE
      const profileData = await optimizedProfileApi.get();
      
      // Mesclar dados do profile com dados básicos do usuário
      const userData: User = {
        ...(storedUser ? JSON.parse(storedUser) : {}),
        ...profileData,
        id: profileData.id || (storedUser ? JSON.parse(storedUser).id : 0),
        email: profileData.email || (storedUser ? JSON.parse(storedUser).email : ''),
        name: profileData.display_name || profileData.name || (storedUser ? JSON.parse(storedUser).name : '')
      };
      
      setUser(userData);
      
      // Atualizar localStorage com dados completos e frescos
      localStorage.setItem("auth_user", JSON.stringify(userData));
      
      console.log("✅ Profile carregado na inicialização:", userData);
      
    } catch (error: any) {
      console.error("❌ Erro ao carregar profile inicial:", error);
      
      // Se for 401, o token é inválido. Limpamos tudo.
      if (error.response?.status === 401) {
        console.warn("🔒 Token inválido/expirado. Fazendo logout...");
        handleLogoutCleanup();
      } else {
        // Para outros erros (500, timeout), mantemos o usuário logado com dados locais
        // mas avisamos que pode haver dessincronização
        console.warn("⚠️ Erro de servidor ao carregar perfil. Usando dados locais.");
      }
    } finally {
      setLoading(false);
      setIsInitialized(true);
    }
  };

  // Helper para limpeza segura
  const handleLogoutCleanup = () => {
    localStorage.removeItem("auth_token");
    localStorage.removeItem("auth_user");
    delete api.defaults.headers.common["Authorization"];
    optimizedProfileApi.clearCache();
    setUser(null);
  };

  // ==========================================
  // ✅ LOGIN NORMAL OTIMIZADO
  // ==========================================
  const signIn = async (email: string, password: string) => {
    try {
      const response = await api.post("/auth/login/", { email, password });
      const { access } = response.data;
      
      if (!access) throw new Error("Token não recebido");

      // Configurar token
      localStorage.setItem("auth_token", access);
      api.defaults.headers.common["Authorization"] = `Bearer ${access}`;
      
      try {
        // Carregar profile completo após login
        const profileData = await optimizedProfileApi.get(true); // Forçar refresh
        
        const userData: User = {
          id: profileData.id || 0,
          email: profileData.email || email,
          name: profileData.display_name || profileData.name || email.split('@')[0],
          ...profileData
        };
        
        localStorage.setItem("auth_user", JSON.stringify(userData));
        setUser(userData);
        
        console.log("✅ Login realizado com profile completo:", userData);
      } catch (profileError) {
        console.warn("⚠️ Erro ao carregar profile após login, usando dados básicos");
        // Fallback seguro: cria usuário básico para não travar a UI
        const basicUserData: User = {
          id: 0,
          email: email,
          name: email.split('@')[0],
          plan: 'free' // Assume free por segurança
        };
        localStorage.setItem("auth_user", JSON.stringify(basicUserData));
        setUser(basicUserData);
      }
      
    } catch (error: any) {
      console.error("Erro no login padrão:", error);
      // Garante que não fique lixo no state se falhar
      handleLogoutCleanup();
      throw error;
    }
  };

  // --- CADASTRO MANUAL ---
  const signUp = async (email: string, password: string, name: string) => {
    // O registro apenas cria a conta. O login deve ser feito em seguida ou redirecionar para login.
    await api.post("/auth/register/", { email, password, name });
  };

  // ==========================================
  // ✅ LOGIN GOOGLE OTIMIZADO
  // ==========================================
  const signInWithGoogle = async () => {
    try {
      const result = await signInWithPopup(auth, googleProvider);
      const idToken = await result.user.getIdToken(true);
      
      if (!idToken) {
        throw new Error("Falha ao gerar credencial do Google.");
      }
      
      const response = await api.post("/auth/firebase/", { token: idToken });
      const token = response.data.access;
      
      if (!token) {
        throw new Error("Token de acesso não retornado pelo servidor Django.");
      }
      
      // Configurar token
      localStorage.setItem("auth_token", token);
      api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
      
      try {
        // Carregar profile completo
        const profileData = await optimizedProfileApi.get(true); // Forçar refresh
        
        const userData: User = {
          id: profileData.id || response.data.id || 0,
          email: profileData.email || response.data.email,
          name: profileData.display_name || profileData.name || response.data.name || "Consultora",
          ...profileData
        };
        
        localStorage.setItem("auth_user", JSON.stringify(userData));
        setUser(userData);
        
        console.log("✅ Login Google realizado com profile completo:", userData);
      } catch (profileError) {
        console.warn("⚠️ Erro ao carregar profile após login Google, usando dados básicos");
        const basicUserData: User = {
          id: response.data.id || 0,
          email: response.data.email,
          name: response.data.name || "Consultora",
          plan: 'free'
        };
        localStorage.setItem("auth_user", JSON.stringify(basicUserData));
        setUser(basicUserData);
      }
      
    } catch (error: any) {
      console.error("Erro completo Google Sign-In:", error);
      handleLogoutCleanup(); // Limpa estado em caso de erro crítico
      
      if (error.response?.data?.error) {
        throw new Error(error.response.data.error);
      }
      throw error;
    }
  };

  // --- LOGIN DE DEMONSTRAÇÃO ---
  const signInDemo = () => {
    const demoUser: User = { 
      id: 999, 
      email: "demo@natura.com", 
      name: "Consultora Teste",
      display_name: "Consultora Teste",
      store_name: "Loja Demo",
      plan: "FREE"
    };
    
    setUser(demoUser);
    localStorage.setItem("auth_user", JSON.stringify(demoUser));
    localStorage.setItem("auth_token", "demo_token_123");
    api.defaults.headers.common["Authorization"] = `Bearer demo_token_123`;
  };

  // ==========================================
  // ✅ LOGOUT OTIMIZADO
  // ==========================================
  const signOut = async () => {
    handleLogoutCleanup();
    
    try {
      await auth.signOut().catch(() => {});
    } catch (e) {
      console.warn("Erro ao fazer logout do Firebase:", e);
    }
    
    // Redireciona para home ou login
    navigate("/"); 
  };

  // ✅ FUNÇÃO PÚBLICA: Atualizar profile manualmente
  const refreshProfile = async () => {
    try {
      console.log("🔄 Atualizando profile manualmente...");
      const profileData = await optimizedProfileApi.get(true); // Forçar refresh
      
      const updatedUser: User = {
        ...user,
        ...profileData
      };
      
      setUser(updatedUser);
      localStorage.setItem("auth_user", JSON.stringify(updatedUser));
      
      console.log("✅ Profile atualizado:", updatedUser);
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