// src/hooks/useConsentCheck.ts - VERSÃO FINAL NÃO BLOQUEANTE
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
  // ✅ REMOVIDO: shouldBlockAccess (não bloqueamos mais)
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

  // ✅ hasValidConsent com useCallback para referência estável
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

  // ✅ Efeito: Verificar consentimento APENAS UMA VEZ (sem loop)
  useEffect(() => {
    // ✅ Guard 1: Já verificou?
    if (hasCheckedRef.current) return;
    
    // ✅ Guard 2-4: Aguardar auth e dados
    if (authLoading || !isAuthenticated || !user?.id || consentLoading) return;
    
    // ✅ Marcar como verificado
    hasCheckedRef.current = true;
    setHasChecked(true);
    
    // ✅ Verificar uma única vez
    setTimeout(() => {
      const valid = hasValidConsent();
      console.log("🔍 LGPD Check:", { valid, consentsCount: consents.length });
      
      // ✅ Só mostrar modal discreto se NÃO tem consentimento válido
      if (!valid && !consentRegisteredRef.current) {
        console.log("🔐 Showing discrete consent modal (non-blocking)");
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
      }
    };
  }, [
    isAuthenticated, 
    user?.id, 
    authLoading, 
    consentLoading
    // ✅ CRÍTICO: REMOVER hasValidConsent das deps para evitar loop!
  ]);

  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    const purposesToRecord = [...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      consentRegisteredRef.current = true;
      await refresh();
      // ✅ Fechar modal após sucesso
      setShowModal(false);
      console.log("✅ Consent recorded, modal closed");
      return true;
    }
    
    return false;
  }, [recordConsent, refresh]);

  // ✅ REMOVIDO: shouldBlockAccess (não bloqueamos mais)

  return {
    showModal,
    setShowModal,
    loading: consentLoading,
    hasChecked,
    handleConsentComplete,
    hasValidConsent,
    // ✅ REMOVIDO: shouldBlockAccess
  };
}