// src/hooks/useConsent.ts
import { useState, useEffect, useCallback } from "react";
import { api } from "../services/api";
import { useAuth } from "./useAuth";
import { useToast } from "./use-toast";
import { consentApi } from "@/lib/api";

// ==========================================
// ✅ CONSTANTES LGPD
// ==========================================
export const LGPD_VERSION = "v1.0_2026-05";

export const PURPOSES = {
  ESSENTIAL: "essential",
  AUTH: "authentication",
  SERVICE: "service_delivery",
  ANALYTICS: "analytics",
  MARKETING: "marketing",
  BEHAVIOR: "behavior_tracking",
  AI: "ai_features",
} as const;

export type Purpose = (typeof PURPOSES)[keyof typeof PURPOSES];

// Finalidades que NÃO podem ser revogadas (essenciais para o serviço)
export const ESSENTIAL_PURPOSES = [
  PURPOSES.ESSENTIAL,
  PURPOSES.AUTH,
  PURPOSES.SERVICE,
] as const;

// ==========================================
// ✅ INTERFACES
// ==========================================
export interface ConsentRecord {
  id: number;
  version: string;
  purposes: string[];
  accepted_at: string;
  revoked_at: string | null;
  is_active: boolean;
  purposes_granted?: string[];
  can_revoke?: string[];
}

export interface ConsentContextData {
  consents: ConsentRecord[];
  loading: boolean;
  essentialPurposes: string[];
  revocablePurposes: string[];
  recordConsent: (purposes: Purpose[], email?: string, sessionId?: string) => Promise<boolean>;
  revokeConsent: (purpose: Purpose) => Promise<boolean>;
  hasConsent: (purpose: Purpose) => boolean;
  hasValidConsent: (version?: string) => boolean; // ✅ NOVO: Verifica consentimento válido para versão
  refresh: () => Promise<void>;
}

// ==========================================
// ✅ HOOK PRINCIPAL
// ==========================================
export function useConsent(): ConsentContextData {
  const { user } = useAuth();
  const toastHook = useToast();
  
  // ✅ Garantir que toast é uma função (evita "r is not a function")
  const toast = typeof toastHook === 'function' 
    ? toastHook 
    : toastHook?.toast;
  
  const [consents, setConsents] = useState<ConsentRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [essentialPurposes, setEssentialPurposes] = useState<string[]>([...ESSENTIAL_PURPOSES]);
  const [revocablePurposes, setRevocablePurposes] = useState<string[]>([
    PURPOSES.ANALYTICS,
    PURPOSES.MARKETING,
    PURPOSES.BEHAVIOR,
    PURPOSES.AI,
  ]);

  // ✅ Carregar consentimentos apenas se usuário estiver autenticado
  useEffect(() => {
    if (user?.id) {
      loadConsents();
    } else {
      // Se não tem user, limpa estados
      setConsents([]);
      setEssentialPurposes([...ESSENTIAL_PURPOSES]);
      setRevocablePurposes([PURPOSES.ANALYTICS, PURPOSES.MARKETING, PURPOSES.BEHAVIOR, PURPOSES.AI]);
      setLoading(false);
    }
  }, [user?.id]);

  // ✅ Carregar consentimentos da API
  const loadConsents = useCallback(async () => {
    if (!user?.id) return;
    
    setLoading(true);
    try {
      const resp = await api.get("/consent/my/");
      const data = resp.data;
      
      setConsents(data.consents || []);
      if (data.essential_purposes?.length) {
        setEssentialPurposes(data.essential_purposes);
      }
      if (data.revocable_purposes?.length) {
        setRevocablePurposes(data.revocable_purposes);
      }
    } catch (error: any) {
      // ✅ Não loga erro 401 (já tratado pelo interceptor)
      if (error.response?.status !== 401) {
        console.error("Erro ao carregar consentimentos:", error);
      }
    } finally {
      setLoading(false);
    }
  }, [user?.id]);

  // ✅ Registrar consentimento - Suporta usuários autenticados e anônimos
  const recordConsent = useCallback(async (
    purposes: Purpose[],
    email?: string,
    sessionId?: string
  ): Promise<boolean> => {
    try {
      const data = await consentApi.record({
        email: email || user?.email,
        session_id: sessionId,
        version: LGPD_VERSION,
        purposes,
        accepted_at: new Date().toISOString(),
      });
      
      // Atualizar estado local
      setConsents(prev => {
        // Remover registro antigo com mesmo ID (se existir)
        const filtered = prev.filter(c => c.id !== data.id);
        return [data, ...filtered];
      });
      
      // ✅ Mostrar toast apenas se for função
      if (typeof toast === 'function') {
        toast({
          title: "✅ Consentimento registrado",
          description: "Suas preferências de privacidade foram salvas.",
        });
      }
      
      return true;
    } catch (error: any) {
      // ✅ Tratamento específico por status code
      const status = error.response?.status;
      
      // Não mostrar toast para erros esperados (400 = validação, 404 = endpoint não encontrado)
      if (status !== 400 && status !== 404 && typeof toast === 'function') {
        toast({
          title: "❌ Erro ao registrar consentimento",
          description: error.message || "Tente novamente em alguns instantes",
          variant: "destructive",
        });
      }
      
      // Log para debug em desenvolvimento
      if (import.meta.env.DEV) {
        console.error("❌ Consent record error:", {
          status,
          message: error.message,
          data: error.response?.data,
        });
      }
      
      return false;
    }
  }, [user?.email, toast]);

  // ✅ Revogar consentimento para finalidade específica
  const revokeConsent = useCallback(async (purpose: Purpose): Promise<boolean> => {
    // ✅ Não permite revogar finalidades essenciais
    if (essentialPurposes.includes(purpose)) {
      if (typeof toast === 'function') {
        toast({
          title: "⚠️ Não é possível revogar",
          description: `A finalidade "${purpose}" é essencial para o funcionamento do sistema.`,
          variant: "destructive",
        });
      }
      return false;
    }
    
    try {
      await api.delete(`/consent/revoke/${purpose}/`);
      
      // Atualizar lista local: marcar como revogado
      setConsents(prev => 
        prev.map(c => 
          c.purposes.includes(purpose) && c.is_active
            ? { ...c, is_active: false, revoked_at: new Date().toISOString() }
            : c
        )
      );
      
      if (typeof toast === 'function') {
        toast({
          title: "✅ Consentimento revogado",
          description: `Você não receberá mais tratamentos para "${purpose}".`,
        });
      }
      
      return true;
    } catch (error: any) {
      console.error("Erro ao revogar consentimento:", error);
      
      if (typeof toast === 'function') {
        toast({
          title: "❌ Erro ao revogar consentimento",
          description: error.message || "Tente novamente",
          variant: "destructive",
        });
      }
      
      return false;
    }
  }, [essentialPurposes, toast]);

  // ✅ Verificar se usuário tem consentimento ativo para finalidade
  const hasConsent = useCallback((purpose: Purpose): boolean => {
    return consents.some(c => c.is_active && c.purposes.includes(purpose));
  }, [consents]);

  // ✅ NOVO: Verificar se usuário tem consentimento VÁLIDO para a versão atual
  const hasValidConsent = useCallback((version: string = LGPD_VERSION): boolean => {
    // Verificar se existe consentimento ativo para a versão especificada
    // E se contém pelo menos as finalidades essenciais
    return consents.some(c => 
      c.is_active && 
      c.version === version &&
      essentialPurposes.every(p => c.purposes.includes(p))
    );
  }, [consents, essentialPurposes]);

  // ✅ Refresh manual dos consentimentos
  const refresh = useCallback(async () => {
    await loadConsents();
  }, [loadConsents]);

  return {
    consents,
    loading,
    essentialPurposes,
    revocablePurposes,
    recordConsent,
    revokeConsent,
    hasConsent,
    hasValidConsent, // ✅ Exportar nova função
    refresh,
  };
}