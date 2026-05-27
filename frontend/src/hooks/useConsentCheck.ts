// src/hooks/useConsentCheck.ts
import { useState, useEffect } from "react";
import { consentApi } from "../lib/api";
import { useAuth } from "./useAuth";

export function useConsentCheck() {
  const { user, isAuthenticated } = useAuth();
  const [showConsentModal, setShowConsentModal] = useState(false);
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
      const { consents, current_version } = await consentApi.getMyConsents();
      const hasActive = consents.some(c => c.is_active && c.version === current_version);
      
      if (!hasActive) {
        setShowConsentModal(true); // Mostra modal completo
      }
    } catch {
      setShowConsentModal(true); // Em caso de erro, assume que precisa de consentimento
    } finally {
      setLoading(false);
    }
  };

  const handleConsentComplete = () => {
    setShowConsentModal(false);
  };

  return { showConsentModal, handleConsentComplete, loading };
}