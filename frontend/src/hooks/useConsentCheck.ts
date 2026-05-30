// src/hooks/useConsentCheck.ts - VERSÃO FINAL SEM LOOP
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
  const { user, isAuthenticated } = useAuth();
  const { 
    consents, 
    essentialPurposes: contextEssentials,
    recordConsent, 
    loading: consentLoading,
    refresh 
  } = useConsent();
  
  const [showModal, setShowModal] = useState(false);
  const [hasChecked, setHasChecked] = useState(false);
  
  // ✅ Refs para controle de estado
  const hasCheckedRef = useRef(false);
  const consentRegisteredRef = useRef(false);
  const isShowingModalRef = useRef(false); // ✅ NOVO: Prevenir re-exibição

  // ✅ Verificar consentimento válido
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

  // ✅ Efeito: Verificar consentimento APENAS UMA VEZ
  useEffect(() => {
    // ✅ Guard 1: Não executar se já verificou
    if (hasCheckedRef.current) return;
    
    // ✅ Guard 2: Só executar se auth + loading completo
    if (!isAuthenticated || !user?.id || consentLoading) return;
    
    // ✅ Marcar como verificado
    hasCheckedRef.current = true;
    setHasChecked(true);
    
    // ✅ Verificar após próximo tick
    setTimeout(() => {
      const valid = hasValidConsent();
      console.log("🔍 LGPD Consent Check:", { 
        valid, 
        consentsCount: consents.length,
        isAuthenticated,
        userId: user?.id,
      });
      
      // ✅ Só mostrar modal se:
      // 1. NÃO tem consentimento válido
      // 2. NÃO registrou nesta sessão
      // 3. NÃO está mostrando já (prevenir loop)
      if (!valid && !consentRegisteredRef.current && !isShowingModalRef.current) {
        console.log("🔐 LGPD: Showing consent modal (blocking access)");
        isShowingModalRef.current = true;
        setShowModal(true);
      } else if (valid) {
        console.log("✅ LGPD: Consent already valid, access granted");
      }
    }, 50);
    
    // ✅ Resetar se deslogar
    return () => {
      if (!isAuthenticated) {
        setShowModal(false);
        setHasChecked(false);
        hasCheckedRef.current = false;
        consentRegisteredRef.current = false;
        isShowingModalRef.current = false;
      }
    };
  }, [isAuthenticated, user?.id, consentLoading]); // ✅ SEM hasValidConsent nas deps!

  // ✅ Handler: Registrar consentimento
  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    const purposesToRecord = [
      ...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])
    ];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      // ✅ Marcar como registrado
      consentRegisteredRef.current = true;
      isShowingModalRef.current = false;
      
      // ✅ Atualizar lista
      await refresh();
      
      // ✅ Fechar modal
      setShowModal(false);
      console.log("✅ LGPD: Consent recorded, access granted");
      return true;
    }
    
    return false;
  }, [recordConsent, refresh]);

  // ✅ Verificar se deve bloquear
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