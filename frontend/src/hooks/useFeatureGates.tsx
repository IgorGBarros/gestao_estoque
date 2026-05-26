// src/hooks/useFeatureGates.ts
import { useState, useEffect, useCallback } from "react";
import { api } from "../services/api";
import { useAuth } from "./useAuth";

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

export function useConsent() {
  const { user } = useAuth();
  const [consents, setConsents] = useState<ConsentRecord[]>([]);
  const [loading, setLoading] = useState(false);
  const [essentialPurposes, setEssentialPurposes] = useState<string[]>([]);
  const [revocablePurposes, setRevocablePurposes] = useState<string[]>([]);

  // ✅ SÓ carregar se usuário estiver autenticado
  useEffect(() => {
    if (user?.id) {
      loadConsents();
    } else {
      // Se não tem user, limpa consents
      setConsents([]);
      setLoading(false);
    }
  }, [user?.id]);

  const loadConsents = useCallback(async () => {
    if (!user?.id) return;
    
    setLoading(true);
    try {
      const resp = await api.get("/consent/my/");
      const data = resp.data;
      setConsents(data.consents);
      setEssentialPurposes(data.essential_purposes);
      setRevocablePurposes(data.revocable_purposes);
    } catch (error) {
      console.error("Erro ao carregar consentimentos:", error);
    } finally {
      setLoading(false);
    }
  }, [user?.id]);

  const recordConsent = useCallback(async (
    purposes: Purpose[],
    email?: string,
    sessionId?: string
  ) => {
    try {
      const resp = await api.post('/consent/', {
        email: email || user?.email,
        session_id: sessionId,
        version: LGPD_VERSION,
        purposes,
        accepted_at: new Date().toISOString(),
      });
      const data = resp.data as ConsentRecord;

      setConsents(prev => [data, ...prev.filter(c => c.id !== data.id)]);
      return true;
    } catch (error: any) {
      console.error("Erro ao registrar consentimento:", error);
      return false;
    }
  }, [user?.email]);

  const revokeConsent = useCallback(async (purpose: Purpose) => {
    if (essentialPurposes.includes(purpose)) {
      return false;
    }
    
    try {
      await api.delete(`/consent/revoke/${purpose}/`);
      setConsents(prev => 
        prev.map(c => 
          c.purposes.includes(purpose) && c.is_active
            ? { ...c, is_active: false, revoked_at: new Date().toISOString() }
            : c
        )
      );
      return true;
    } catch (error) {
      console.error("Erro ao revogar consentimento:", error);
      return false;
    }
  }, [essentialPurposes]);

  const hasConsent = useCallback((purpose: Purpose): boolean => {
    return consents.some(c => c.is_active && c.purposes.includes(purpose));
  }, [consents]);

  return {
    consents,
    loading,
    essentialPurposes,
    revocablePurposes,
    recordConsent,
    revokeConsent,
    hasConsent,
    refresh: loadConsents,
  };
}