// src/hooks/useConsentCheck.ts - VERSÃO CORRIGIDA
import { useState, useEffect, useCallback, useRef } from "react";
import { useAuth } from "./useAuth";
import { useConsent, LGPD_VERSION, PURPOSES, type Purpose } from "./useConsent";

export interface ConsentCheckData {
  showModal: boolean;
  setShowModal: (show: boolean) => void;
  loading: boolean;
  handleConsentComplete: (purposes: Purpose[]) => Promise<boolean>;
  hasValidConsent: () => boolean;
}

export function useConsentCheck(): ConsentCheckData {
  const { user, isAuthenticated } = useAuth();
  const { 
    consents, 
    essentialPurposes, 
    recordConsent, 
    loading: consentLoading,
    refresh 
  } = useConsent();
  
  const [showModal, setShowModal] = useState(false);
  const [checked, setChecked] = useState(false);
  
  // ✅ Ref para evitar re-renders desnecessários
  const hasCheckedRef = useRef(false);

  // ✅ Verificar se usuário tem consentimento válido
  const hasValidConsent = useCallback((): boolean => {
    if (!isAuthenticated || !user?.id) return false;
    
    return consents.some(c => 
      c.is_active && 
      c.version === LGPD_VERSION &&
      essentialPurposes.every(p => c.purposes.includes(p))
    );
  }, [isAuthenticated, user?.id, consents, essentialPurposes]);

  // ✅ Efeito: Verificar consentimento APENAS UMA VEZ após autenticação
  useEffect(() => {
    // ✅ Guard: Só executar uma vez por sessão de login
    if (hasCheckedRef.current) return;
    
    // ✅ Só verificar se usuário está autenticado e temos dados
    if (isAuthenticated && user?.id && consents.length >= 0) {
      hasCheckedRef.current = true;
      
      // ✅ Usar setTimeout para garantir que consents foi populado
      setTimeout(() => {
        const valid = hasValidConsent();
        console.log("🔍 Consent check result:", { valid, consentsCount: consents.length });
        
        // ✅ Só mostrar modal se NÃO tem consentimento válido
        if (!valid) {
          console.log("🔐 Showing consent modal");
          setShowModal(true);
        }
      }, 200); // Pequeno delay para garantir que dados carregaram
    }
    
    // ✅ Resetar se usuário deslogar
    if (!isAuthenticated) {
      setShowModal(false);
      setChecked(false);
      hasCheckedRef.current = false;
    }
  }, [isAuthenticated, user?.id, consents.length, hasValidConsent]); // ← deps corretas

  // ✅ Handler: Quando usuário completa o consentimento
  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    const purposesToRecord = [
      ...new Set<Purpose>([...purposes, ...(essentialPurposes as Purpose[])])
    ] as Purpose[];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      await refresh();
      // ✅ Só fechar modal após confirmação de sucesso
      setShowModal(false);
      return true;
    }
    
    // ✅ NÃO fechar modal se falhar - usuário deve tentar novamente
    return false;
  }, [essentialPurposes, recordConsent, refresh]);

  return {
    showModal,
    setShowModal,
    loading: consentLoading,
    handleConsentComplete,
    hasValidConsent,
  };
}