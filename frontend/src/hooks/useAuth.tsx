import React, { createContext, useContext, useEffect, useState, useCallback, useRef, ReactNode } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios"; // Importamos axios diretamente para o refresh manual
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
        const response = await api.get('/profile/');
        const data = response.data;
        profileCache = data;
        profileCacheTimestamp = Date.now();
        return data;
      } catch (error: any) {
        if (profileCache && !forceRefresh) {
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
      // Chama endpoint de refresh do Django SimpleJWT
      const response = await axios.post(`${import.meta.env.VITE_API_BASE_URL}/api/auth/token/refresh/`, {
        refresh: storedRefreshToken
      });
      
      const newAccessToken = response.data.access;
      
      // Atualiza tokens no storage e headers
      localStorage.setItem("auth_token", newAccessToken);
      api.defaults.headers.common["Authorization"] = `Bearer ${newAccessToken}`;
      
      return newAccessToken;
    } catch (error) {
      console.warn("❌ Falha ao renovar token. Sessão inválida.");
      return null;
    }
  };

  // ==========================================
  // ✅ CARREGAR SESSÃO INICIAL
  // ==========================================
  const initializeAuth = useCallback(async () => {
    if (initRef.current) return;
    initRef.current = true;

    const storedToken = localStorage.getItem("auth_token");
    const storedUser = localStorage.getItem("auth_user");
    
    if (!storedToken) {
      setLoading(false);
      setIsInitialized(true);
      return;
    }

    // Define token inicial
    api.defaults.headers.common["Authorization"] = `Bearer ${storedToken}`;
    
    if (storedUser) {
      setUser(JSON.parse(storedUser));
    }

    try {
      // Tenta buscar perfil. Se der 401, tenta renovar.
      let profileData;
      try {
        profileData = await optimizedProfileApi.get();
      } catch (err: any) {
        if (err.response?.status === 401) {
          console.log("🔄 Token expirado. Tentando renovar...");
          const newToken = await refreshToken();
          
          if (newToken) {
            // Se renovou com sucesso, busca o perfil novamente
            profileData = await optimizedProfileApi.get(true);
          } else {
            // Se falhou a renovação, força erro para cair no catch externo
            throw new Error("Renewal failed");
          }
        } else {
          throw err;
        }
      }
      
      // Atualiza estado do usuário com dados frescos
      const userData: User = {
        ...(storedUser ? JSON.parse(storedUser) : {}),
        ...profileData,
        id: profileData.id || 0,
        email: profileData.email || '',
        name: profileData.display_name || profileData.name || ''
      };
      
      setUser(userData);
      localStorage.setItem("auth_user", JSON.stringify(userData));
      
    } catch (error: any) {
      console.error("❌ Erro crítico na inicialização:", error);
      // Limpa sessão apenas se for erro de autenticação irrecoverável
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
  // ✅ LOGOUT HELPER
  // ==========================================
  const handleLogout = (shouldNavigate = true) => {
    localStorage.removeItem("auth_token");
    localStorage.removeItem("refresh_token"); // Importante remover o refresh também
    localStorage.removeItem("auth_user");
    delete api.defaults.headers.common["Authorization"];
    optimizedProfileApi.clearCache();
    setUser(null);
    setIsInitialized(false);
    initRef.current = false;
    
    if (shouldNavigate) {
      navigate("/auth");
    }
  };

  // ==========================================
  // ✅ LOGIN NORMAL
  // ==========================================
  const signIn = async (email: string, password: string) => {
    try {
      // Usa endpoint de login que retorna access E refresh
      const response = await api.post("/auth/login/", { email, password });
      const { access, refresh } = response.data;
      
      if (!access) throw new Error("Token não recebido");

      localStorage.setItem("auth_token", access);
      if (refresh) localStorage.setItem("refresh_token", refresh); // Salva refresh token
      
      api.defaults.headers.common["Authorization"] = `Bearer ${access}`;
      
      // Busca perfil imediato
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
        // Fallback básico se perfil falhar
        setUser({ id: 0, email, name: email.split('@')[0] });
      }
      
    } catch (error) {
      console.error("Erro no login:", error);
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
      
      if (!idToken) throw new Error("Falha Google Token");
      
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
        setUser({ id: 0, email: response.data.email, name: response.data.name || "Consultora" });
      }
      
    } catch (error: any) {
      console.error("Erro Google Sign-In:", error);
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
      console.error("Erro ao atualizar profile:", error);
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