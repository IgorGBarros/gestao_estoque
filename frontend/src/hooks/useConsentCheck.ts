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
  
  // ✅ Refs para controle de estado
  const hasCheckedRef = useRef(false);
  const consentRegisteredRef = useRef(false);

  // ✅ Verificar consentimento válido
  const hasValidConsent = useCallback((): boolean => {
    // ✅ Só verificar se usuário está autenticado E temos dados
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
    // ✅ Guard 1: Não executar se já verificou
    if (hasCheckedRef.current) return;
    
    // ✅ Guard 2: NÃO executar se auth ainda está carregando
    if (authLoading) return;
    
    // ✅ Guard 3: NÃO executar se usuário não está autenticado
    if (!isAuthenticated || !user?.id) return;
    
    // ✅ Guard 4: NÃO executar se consentimentos ainda estão carregando
    if (consentLoading) return;
    
    // ✅ Todas as condições atendidas: pode verificar
    hasCheckedRef.current = true;
    setHasChecked(true);
    
    // ✅ Verificar após próximo tick (garante estado consistente)
    setTimeout(() => {
      const valid = hasValidConsent();
      console.log("🔍 LGPD Consent Check (post-auth):", { 
        valid, 
        consentsCount: consents.length,
        isAuthenticated,
        userId: user?.id,
      });
      
      // ✅ Só mostrar modal se NÃO tem consentimento válido
      if (!valid && !consentRegisteredRef.current) {
        console.log("🔐 LGPD: Showing consent modal (blocking access)");
        setShowModal(true);
      } else if (valid) {
        console.log("✅ LGPD: Consent already valid, access granted");
      }
    }, 100);
    
    // ✅ Cleanup: resetar se deslogar
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
    authLoading,      // ✅ ADICIONADO: esperar auth terminar
    consentLoading,   // ✅ ADICIONADO: esperar consentimentos carregarem
    hasValidConsent
  ]);

  // ✅ Handler: Registrar consentimento
  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    const purposesToRecord = [
      ...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])
    ];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      consentRegisteredRef.current = true;
      await refresh();
      setShowModal(false);
      console.log("✅ LGPD: Consent recorded, access granted");
      return true;
    }
    
    return false;
  }, [recordConsent, refresh]);

  // ✅ Bloquear acesso se modal ativo e consentimento não registrado
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