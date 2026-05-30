// src/hooks/useConsentCheck.ts - VERSÃO FINAL COM CORREÇÃO DE PURPOSE_FLAGS
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
  const profileLoadedRef = useRef(false);
// src/hooks/useConsentCheck.ts - Correção do parse de purpose_flags

const hasValidConsent = useCallback((): boolean => {
  if (!isAuthenticated || !user?.id) return false;
  
  const essentials = contextEssentials.length > 0 
    ? contextEssentials 
    : ESSENTIAL_PURPOSES;
  
  // ✅ LOG DE DEBUG
  if (consents.length > 0 && import.meta.env.DEV) {
    console.log("🔍 hasValidConsent debug:", {
      consentsCount: consents.length,
      firstConsent: {
        purposes: consents[0].purposes,
        purposesType: typeof consents[0].purposes,
        isArray: Array.isArray(consents[0].purposes),
      },
    });
  }
  
  const valid = consents.some(c => {
    // ✅ CORREÇÃO: Parse de purpose_flags com cast para evitar erro TypeScript
    let purposes: string[] = [];
    
    if (Array.isArray(c.purposes)) {
      // Já é array ✅
      purposes = c.purposes;
    } else {
      // ✅ Cast para any para permitir operação em string
      const purposesValue = c.purposes as any;
      
      if (typeof purposesValue === 'string') {
        // ✅ Parse da string JSON para array
        try {
          purposes = JSON.parse(purposesValue);
        } catch (e) {
          // Fallback: split simples se não for JSON válido
          purposes = purposesValue
            .replace(/[\[\]"]/g, '') // Remove [, ], "
            .split(',')
            .map((p: string) => p.trim())
            .filter((p: string) => p.length > 0);
        }
      } else {
        // Fallback para qualquer outro tipo
        purposes = Array.isArray(purposesValue) ? purposesValue : [];
      }
    }
    
    // ✅ Verificar consentimento válido
    return c.is_active && 
           c.version === LGPD_VERSION &&
           essentials.every(p => purposes.includes(p));
  });
  
  if (import.meta.env.DEV) {
    console.log("✅ hasValidConsent result:", valid);
  }
  
  return valid;
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
    
    // ✅ Guard 5: Profile ainda não carregou?
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
    user?.email,
    authLoading, 
    consentLoading
    // ✅ CRÍTICO: SEM hasValidConsent nas deps para evitar loop!
  ]);
// src/hooks/useConsentCheck.ts - handleConsentComplete corrigido

const handleConsentComplete = useCallback(async (purposes: Purpose[]): Promise<boolean> => {
  console.log("📝 handleConsentComplete started with:", purposes);
  const purposesToRecord = [...new Set<Purpose>([...purposes, ...ESSENTIAL_PURPOSES])];
  
  try {
    const success = await recordConsent(purposesToRecord);
    console.log("✅ recordConsent returned:", success);
    
    if (success) {
      consentRegisteredRef.current = true;
      
      // ✅ AGUARDAR refresh completar ANTES de fechar modal
      console.log("🔄 Calling refresh()...");
      await refresh();
      console.log("✅ refresh() completed, consents updated");
      
      // ✅ Pequeno delay para garantir estado atualizado
      await new Promise(resolve => setTimeout(resolve, 200));
      
      // ✅ Fechar modal APÓS refresh completar
      setShowModal(false);
      console.log("✅ Modal closed");
      return true;
    }
    
    return false;
  } catch (error) {
    console.error("❌ handleConsentComplete error:", error);
    return false;
  }
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