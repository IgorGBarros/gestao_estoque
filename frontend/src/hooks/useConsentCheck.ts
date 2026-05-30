// src/hooks/useConsentCheck.ts - VERSÃO FINAL COM GATILHO CORRETO
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
  const profileLoadedRef = useRef(false); // ✅ NOVO: Rastrear se profile foi carregado

  // ✅ hasValidConsent com useCallback
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

  // ✅ Efeito: Verificar consentimento APENAS após profile carregado
  useEffect(() => {
    // ✅ Guard 1: Já verificou?
    if (hasCheckedRef.current) return;
    
    // ✅ Guard 2: Auth ainda carregando?
    if (authLoading) return;
    
    // ✅ Guard 3: Usuário não autenticado?
    if (!isAuthenticated || !user?.id) return;
    
    // ✅ Guard 4: Consentimentos ainda carregando?
    if (consentLoading) return;
    
    // ✅ Guard 5: Profile ainda não carregou? (verificar se temos dados do perfil)
    if (!profileLoadedRef.current && user?.email) {
      profileLoadedRef.current = true;
    }
    
    // ✅ Marcar como verificado
    hasCheckedRef.current = true;
    setHasChecked(true);
    
    // ✅ Verificar UMA ÚNICA VEZ após profile carregado
    setTimeout(() => {
      const valid = hasValidConsent();
      console.log("🔍 LGPD Check (post-profile):", { 
        valid, 
        consentsCount: consents.length,
        profileLoaded: profileLoadedRef.current 
      });
      
      // ✅ Só mostrar modal se NÃO tem consentimento válido
      if (!valid && !consentRegisteredRef.current) {
        console.log("🔐 Showing consent modal (post-login trigger)");
        setShowModal(true);
      }
    }, 100);
    
    // ✅ Cleanup
    return () => {
      if (!isAuthenticated) {
        setShowModal(false);
        setHasChecked(false);
        hasCheckedRef.current = false;
        consentRegisteredRef.current = false;
        profileLoadedRef.current = false;
      }
    };
  }, [
    isAuthenticated, 
    user?.id, 
    user?.email,      // ✅ Gatilho: quando email do profile chega
    authLoading, 
    consentLoading
    // ✅ SEM hasValidConsent nas deps!
  ]);

  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    const purposesToRecord = [...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      consentRegisteredRef.current = true;
      await refresh();
      setShowModal(false);
      console.log("✅ Consent recorded, modal closed");
      return true;
    }
    
    return false;
  }, [recordConsent, refresh]);

  return {
    showModal,
    setShowModal,
    loading: consentLoading,
    hasChecked,
    handleConsentComplete,
    hasValidConsent,
  };
}