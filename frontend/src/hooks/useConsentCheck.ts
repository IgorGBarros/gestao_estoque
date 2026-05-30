// src/hooks/useConsentCheck.ts - VERSÃO FINAL LGPD
import { useState, useEffect, useCallback, useRef } from "react";
import { useAuth } from "./useAuth";
import { useConsent, LGPD_VERSION, PURPOSES, type Purpose, ESSENTIAL_PURPOSES } from "./useConsent";

export interface ConsentCheckData {
  showModal: boolean;
  setShowModal: (show: boolean) => void;
  loading: boolean;
  hasChecked: boolean; // ✅ NOVO: Saber se já verificou consentimento
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
  const [hasChecked, setHasChecked] = useState(false); // ✅ Rastrear se já verificou
  
  const hasCheckedRef = useRef(false);
  const consentRegisteredRef = useRef(false);

  // ✅ Verificar consentimento válido para versão atual + essenciais
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

  // ✅ Efeito: Verificar consentimento APENAS após login + dados carregados
  useEffect(() => {
    // ✅ Não executar se já verificou nesta sessão
    if (hasCheckedRef.current) return;
    
    // ✅ Só verificar se:
    // 1. Usuário está autenticado
    // 2. Temos ID do usuário  
    // 3. Consentimentos já foram carregados da API (loading = false)
    if (isAuthenticated && user?.id && consentLoading === false) {
      hasCheckedRef.current = true;
      setHasChecked(true);
      
      // ✅ Pequeno delay para garantir estado consistente
      setTimeout(() => {
        const valid = hasValidConsent();
        console.log("🔍 LGPD Consent Check:", { 
          valid, 
          consentsCount: consents.length,
          isAuthenticated,
          userId: user?.id,
          version: LGPD_VERSION
        });
        
        // ✅ Só mostrar modal se:
        // - NÃO tem consentimento válido
        // - E não registrou nesta sessão (evita loop)
        if (!valid && !consentRegisteredRef.current) {
          console.log("🔐 LGPD: Showing consent modal (blocking access)");
          setShowModal(true);
        } else if (valid) {
          console.log("✅ LGPD: Consent already valid, access granted");
        }
      }, 50);
    }
    
    // ✅ Resetar se usuário deslogar
    if (!isAuthenticated) {
      setShowModal(false);
      setHasChecked(false);
      hasCheckedRef.current = false;
      consentRegisteredRef.current = false;
    }
  }, [isAuthenticated, user?.id, consentLoading, consents.length, hasValidConsent]);

  // ✅ Handler: Registrar consentimento e liberar acesso
  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    const purposesToRecord = [
      ...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])
    ];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      // ✅ Marcar como registrado nesta sessão
      consentRegisteredRef.current = true;
      
      // ✅ Atualizar lista do backend
      await refresh();
      
      // ✅ Fechar modal e liberar acesso
      setShowModal(false);
      console.log("✅ LGPD: Consent recorded, access granted");
      return true;
    }
    
    // ✅ NÃO fechar se falhar - usuário deve tentar novamente
    console.warn("⚠️ LGPD: Consent record failed, modal remains open");
    return false;
  }, [recordConsent, refresh]);

  // ✅ Bloquear acesso se: modal ativo E consentimento não registrado
  const shouldBlockAccess = showModal && !consentRegisteredRef.current;

  return {
    showModal,
    setShowModal,
    loading: consentLoading,
    hasChecked, // ✅ Exportar para debug/controle
    handleConsentComplete,
    hasValidConsent,
    shouldBlockAccess,
  };
}