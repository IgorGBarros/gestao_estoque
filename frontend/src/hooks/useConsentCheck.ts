// src/hooks/useConsentCheck.ts - VERSÃO COM SEQUÊNCIA CORRETA
import { useState, useEffect, useCallback, useRef } from "react";
import { useAuth } from "./useAuth";
import { useConsent, LGPD_VERSION, PURPOSES, type Purpose, ESSENTIAL_PURPOSES } from "./useConsent";

export interface ConsentCheckData {
  showModal: boolean;
  setShowModal: (show: boolean) => void;
  loading: boolean;
  hasChecked: boolean;
  handleConsentComplete: (purposes: Purpose[]) => Promise<boolean>;
  hasValidConsent: () => boolean;
  shouldBlockAccess: boolean;
}

export function useConsentCheck(): ConsentCheckData {
  const { user, isAuthenticated, loading: authLoading } = useAuth();
  const { 
    consents, 
    essentialPurposes: contextEssentials,
    recordConsent, 
    loading: consentLoading,
    refresh 
  } = useConsent();
  
  const [showModal, setShowModal] = useState(false);
  const [hasChecked, setHasChecked] = useState(false);
  
  const hasCheckedRef = useRef(false);
  const consentRegisteredRef = useRef(false);

  const hasValidConsent = useCallback((): boolean => {
    if (!isAuthenticated || !user?.id) return false;
    
    const essentials = contextEssentials.length > 0 
      ? contextEssentials 
      : ESSENTIAL_PURPOSES;
    
    return consents.some(c => 
      c.is_active && 
      c.version === LGPD_VERSION &&
      essentials.every(p => c.purposes.includes(p))
    );
  }, [isAuthenticated, user?.id, consents, contextEssentials]);

  // ✅ Efeito: Verificar consentimento APENAS após login COMPLETO
  useEffect(() => {
    // Guard 1: Já verificou?
    if (hasCheckedRef.current) return;
    
    // Guard 2: Auth ainda carregando?
    if (authLoading) return;
    
    // Guard 3: Não autenticado?
    if (!isAuthenticated || !user?.id) return;
    
    // Guard 4: Consentimentos ainda carregando?
    if (consentLoading) return;
    
    // ✅ Tudo OK: pode verificar
    hasCheckedRef.current = true;
    setHasChecked(true);
    
    setTimeout(() => {
      const valid = hasValidConsent();
      console.log("🔍 LGPD Check:", { valid, consentsCount: consents.length });
      
      if (!valid && !consentRegisteredRef.current) {
        console.log("🔐 Showing consent modal");
        setShowModal(true);
      }
    }, 50);
    
    return () => {
      if (!isAuthenticated) {
        setShowModal(false);
        setHasChecked(false);
        hasCheckedRef.current = false;
        consentRegisteredRef.current = false;
      }
    };
  }, [isAuthenticated, user?.id, authLoading, consentLoading]); // ✅ SEM hasValidConsent nas deps!

  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    const purposesToRecord = [...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      consentRegisteredRef.current = true;
      await refresh();
      setShowModal(false);
      console.log("✅ Consent recorded");
      return true;
    }
    
    return false;
  }, [recordConsent, refresh]);

  const shouldBlockAccess = showModal && !consentRegisteredRef.current;

  return {
    showModal,
    setShowModal,
    loading: consentLoading,
    hasChecked,
    handleConsentComplete,
    hasValidConsent,
    shouldBlockAccess,
  };
}