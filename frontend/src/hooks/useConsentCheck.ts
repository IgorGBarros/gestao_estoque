// src/hooks/useConsentCheck.ts - VERSÃO FINAL CORRIGIDA
import { useState, useEffect, useCallback, useRef } from "react";
import { useAuth } from "./useAuth";
import { useConsent, LGPD_VERSION, PURPOSES, type Purpose, ESSENTIAL_PURPOSES } from "./useConsent";

export interface ConsentCheckData {
  showModal: boolean;
  setShowModal: (show: boolean) => void;
  loading: boolean;
  handleConsentComplete: (purposes: Purpose[]) => Promise<boolean>;
  hasValidConsent: () => boolean;
  shouldBlockAccess: boolean; // ✅ NOVO: Para bloquear UI enquanto modal está ativo
}

export function useConsentCheck(): ConsentCheckData {
  const { user, isAuthenticated } = useAuth();
  const { 
    consents, 
    essentialPurposes: contextEssentialPurposes,
    recordConsent, 
    loading: consentLoading,
    refresh 
  } = useConsent();
  
  const [showModal, setShowModal] = useState(false);
  
  // ✅ Ref para garantir verificação única por sessão de login
  const hasCheckedRef = useRef(false);
  // ✅ Ref para rastrear se consentimento já foi registrado nesta sessão
  const consentRegisteredRef = useRef(false);

  // ✅ Verificar se usuário tem consentimento válido para a versão atual
  const hasValidConsent = useCallback((): boolean => {
    if (!isAuthenticated || !user?.id) return false;
    
    // Usar finalidades essenciais do contexto ou fallback
    const essentials = contextEssentialPurposes.length > 0 
      ? contextEssentialPurposes 
      : ESSENTIAL_PURPOSES;
    
    return consents.some(c => 
      c.is_active && 
      c.version === LGPD_VERSION &&
      essentials.every(p => c.purposes.includes(p))
    );
  }, [isAuthenticated, user?.id, consents, contextEssentialPurposes]);

  // ✅ Efeito: Verificar consentimento APENAS UMA VEZ após autenticação
  useEffect(() => {
    // ✅ Guard: Não executar se já verificou nesta sessão
    if (hasCheckedRef.current) return;
    
    // ✅ Só verificar se usuário está autenticado e tem ID
    if (isAuthenticated && user?.id) {
      hasCheckedRef.current = true;
      
      // ✅ Aguardar próximo tick para garantir que consents foi populado pela API
      setTimeout(() => {
        const valid = hasValidConsent();
        console.log("🔍 Consent check:", { 
          valid, 
          consentsCount: consents.length,
          isAuthenticated,
          userId: user?.id 
        });
        
        // ✅ Só mostrar modal se NÃO tem consentimento válido E não registrou nesta sessão
        if (!valid && !consentRegisteredRef.current) {
          console.log("🔐 Showing consent modal");
          setShowModal(true);
        }
      }, 100);
    }
    
    // ✅ Resetar estado se usuário deslogar
    if (!isAuthenticated) {
      setShowModal(false);
      hasCheckedRef.current = false;
      consentRegisteredRef.current = false;
    }
  }, [isAuthenticated, user?.id, consents.length, hasValidConsent]);

  // ✅ Handler: Quando usuário completa o consentimento
  const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
    // Garantir que finalidades essenciais estão incluídas
    const purposesToRecord = [
      ...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])
    ];
    
    const success = await recordConsent(purposesToRecord);
    
    if (success) {
      // ✅ Marcar que consentimento foi registrado nesta sessão
      consentRegisteredRef.current = true;
      
      // ✅ Atualizar lista de consentimentos
      await refresh();
      
      // ✅ Só fechar modal após confirmação de sucesso
      setShowModal(false);
      return true;
    }
    
    // ✅ NÃO fechar modal se falhar - usuário deve tentar novamente
    return false;
  }, [recordConsent, refresh]);

  // ✅ NOVO: Verificar se deve bloquear acesso à aplicação
  const shouldBlockAccess = showModal && !consentRegisteredRef.current;

  return {
    showModal,
    setShowModal,
    loading: consentLoading,
    handleConsentComplete,
    hasValidConsent,
    shouldBlockAccess, // ✅ Exportar para uso no App/Layout
  };
}