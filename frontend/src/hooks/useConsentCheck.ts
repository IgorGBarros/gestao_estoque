// src/hooks/useConsentCheck.ts
import { useState, useEffect } from "react";
import { consentApi } from "../lib/api";
import { useAuth } from "./useAuth";
// src/hooks/useConsentCheck.ts - Lógica CORRIGIDA

export function useConsentCheck() {
  const { user, isAuthenticated } = useAuth();
  const [showModal, setShowModal] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!isAuthenticated || !user?.id) {
      setLoading(false);
      return;
    }
    checkConsentStatus();
  }, [user?.id, isAuthenticated]);

  const checkConsentStatus = async () => {
    try {
      const { consents, current_version, essential_purposes } = await consentApi.getMyConsents();
      
      // ✅ Verificar se já existe consentimento ATIVO para a versão atual
      const hasActiveConsent = consents.some((c: any) => 
        c.is_active && 
        c.version === current_version &&
        // ✅ Verificar se tem pelo menos os propósitos essenciais
        essential_purposes?.every((p: string) => c.purposes?.includes(p))
      );
      
      // ✅ Só mostrar modal se NÃO tiver consentimento válido
      setShowModal(!hasActiveConsent);
      
    } catch (error) {
      // Em caso de erro, mostrar modal por segurança
      console.warn("⚠️ Erro ao verificar consentimento, mostrando modal por segurança");
      setShowModal(true);
    } finally {
      setLoading(false);
    }
  };

  return { showModal, setShowModal, loading };
}