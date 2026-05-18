// src/hooks/useConsent.ts
import { useState, useEffect, useCallback } from "react";
import { consentApi, ConsentRecord } from "../lib/api";
import { useAuth } from "./useAuth";
import { useToast } from "./use-toast";

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

export function useConsent() {
  const { user } = useAuth();
  const { toast } = useToast();
  
  const [consents, setConsents] = useState<ConsentRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [essentialPurposes, setEssentialPurposes] = useState<string[]>([]);
  const [revocablePurposes, setRevocablePurposes] = useState<string[]>([]);

  // Carregar consentimentos ao montar ou mudar usuário
  useEffect(() => {
    if (user?.id) {
      loadConsents();
    }
  }, [user?.id]);

  const loadConsents = useCallback(async () => {
    if (!user?.id) return;
    
    setLoading(true);
    try {
      const data = await consentApi.getMyConsents();
      setConsents(data.consents);
      setEssentialPurposes(data.essential_purposes);
      setRevocablePurposes(data.revocable_purposes);
    } catch (error) {
      console.error("Erro ao carregar consentimentos:", error);
    } finally {
      setLoading(false);
    }
  }, [user?.id]);

  // Registrar consentimento (para cadastro ou atualização)
  const recordConsent = useCallback(async (
    purposes: Purpose[],
    email?: string,
    sessionId?: string
  ) => {
    try {
      const data = await consentApi.record({
        email: email || user?.email,
        session_id: sessionId,
        version: LGPD_VERSION,
        purposes,
        accepted_at: new Date().toISOString(),
      });
      
      // Atualizar lista local
      setConsents(prev => [data, ...prev.filter(c => c.id !== data.id)]);
      
      toast({
        title: "✅ Consentimento registrado",
        description: "Seus dados serão tratados conforme a LGPD.",
      });
      
      return true;
    } catch (error: any) {
      toast({
        title: "❌ Erro ao registrar consentimento",
        description: error.message || "Tente novamente",
        variant: "destructive",
      });
      return false;
    }
  }, [user?.email, toast]);

  // Revogar consentimento para finalidade específica
  const revokeConsent = useCallback(async (purpose: Purpose) => {
    if (essentialPurposes.includes(purpose)) {
      toast({
        title: "⚠️ Não é possível revogar",
        description: `A finalidade "${purpose}" é essencial para o funcionamento do sistema.`,
        variant: "destructive",
      });
      return false;
    }

    try {
      await consentApi.revoke(purpose);
      
      // Atualizar lista local
      setConsents(prev => 
        prev.map(c => 
          c.purposes.includes(purpose) && c.is_active
            ? { ...c, is_active: false, revoked_at: new Date().toISOString() }
            : c
        )
      );
      
      toast({
        title: "✅ Consentimento revogado",
        description: `Você não receberá mais tratamentos para "${purpose}".`,
      });
      
      return true;
    } catch (error: any) {
      toast({
        title: "❌ Erro ao revogar consentimento",
        description: error.message || "Tente novamente",
        variant: "destructive",
      });
      return false;
    }
  }, [essentialPurposes, toast]);

  // Verificar se tem consentimento ativo para finalidade
  const hasConsent = useCallback((purpose: Purpose): boolean => {
    return consents.some(
      c => c.is_active && c.purposes.includes(purpose)
    );
  }, [consents]);

  // Finalidades que o usuário PODE revogar
  const getRevocablePurposes = useCallback((): Purpose[] => {
    return revocablePurposes as Purpose[];
  }, [revocablePurposes]);

  return {
    consents,
    loading,
    essentialPurposes,
    revocablePurposes,
    recordConsent,
    revokeConsent,
    hasConsent,
    getRevocablePurposes,
    refresh: loadConsents,
  };
}