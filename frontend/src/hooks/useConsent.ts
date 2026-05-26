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
  refresh: () => Promise<void>;
}

// ==========================================
// ✅ HOOK PRINCIPAL
// ==========================================
export function useConsent(): ConsentContextData {
  const { user } = useAuth();
  const { toast } = useToast();
  
  const [consents, setConsents] = useState<ConsentRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [essentialPurposes, setEssentialPurposes] = useState<string[]>([]);
  const [revocablePurposes, setRevocablePurposes] = useState<string[]>([]);

  // ✅ Carregar consentimentos apenas se usuário estiver autenticado
  useEffect(() => {
    if (user?.id) {
      loadConsents();
    } else {
      // Se não tem user, limpa estados
      setConsents([]);
      setEssentialPurposes([]);
      setRevocablePurposes([]);
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
      setEssentialPurposes(data.essential_purposes || []);
      setRevocablePurposes(data.revocable_purposes || []);
    } catch (error: any) {
      // ✅ Não loga erro 401 (já tratado pelo interceptor)
      if (error.response?.status !== 401) {
        console.error("Erro ao carregar consentimentos:", error);
      }
    } finally {
      setLoading(false);
    }
  }, [user?.id]);
 // ✅ ATUALIZAR: Suportar usuários não autenticados
  const recordConsent = useCallback(async (
    purposes: Purpose[],
    email?: string,
    sessionId?: string
  ): Promise<boolean> => {
    try {
      const data = await consentApi.record({
        // Usa email do usuário logado OU email fornecido
        email: email || user?.email,
        // Session ID para rastrear usuários não logados (opcional)
        session_id: sessionId,
        version: LGPD_VERSION,
        purposes,
        accepted_at: new Date().toISOString(),
      });
      
      // Atualizar estado local
      setConsents(prev => [data, ...prev.filter(c => c.id !== data.id)]);
      
      // Feedback visual
      if (typeof toast === 'function') {
        toast({
          title: "✅ Preferências salvas",
          description: "Seus dados serão tratados conforme a LGPD.",
        });
      }
      
      return true;
    } catch (error: any) {
      // ✅ Não mostra toast se erro for 401 (usuário não autenticado ainda)
      if (error.response?.status !== 401 && typeof toast === 'function') {
        toast({
          title: "⚠️ Não foi possível salvar",
          description: "Tente novamente ou recarregue a página.",
          variant: "destructive",
        });
      }
      return false;
    }
  }, [user?.email, toast]);

  // ✅ Revogar consentimento para finalidade específica
  const revokeConsent = useCallback(async (purpose: Purpose): Promise<boolean> => {
    // ✅ Não permite revogar finalidades essenciais
    if (essentialPurposes.includes(purpose)) {
      toast?.({
        title: "⚠️ Não é possível revogar",
        description: `A finalidade "${purpose}" é essencial para o funcionamento do sistema.`,
        variant: "destructive",
      });
      return false;
    }
    
    try {
      await api.delete(`/consent/revoke/${purpose}/`);
      
      // Atualizar lista local
      setConsents(prev => 
        prev.map(c => 
          c.purposes.includes(purpose) && c.is_active
            ? { ...c, is_active: false, revoked_at: new Date().toISOString() }
            : c
        )
      );
      
      toast?.({
        title: "✅ Consentimento revogado",
        description: `Você não receberá mais tratamentos para "${purpose}".`,
      });
      
      return true;
    } catch (error: any) {
      console.error("Erro ao revogar consentimento:", error);
      
      toast?.({
        title: "❌ Erro ao revogar consentimento",
        description: error.message || "Tente novamente",
        variant: "destructive",
      });
      
      return false;
    }
  }, [essentialPurposes, toast]);

  // ✅ Verificar se usuário tem consentimento ativo para finalidade
  const hasConsent = useCallback((purpose: Purpose): boolean => {
    return consents.some(c => c.is_active && c.purposes.includes(purpose));
  }, [consents]);

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
    refresh,
  };
}