// src/components/PostAuthConsentModal.tsx
import { useLocation } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { isAuthenticated } = useAuth();
  const location = useLocation(); // ✅ Para verificar rota
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Guard triplo: não renderizar se:
  // 1. Não autenticado
  // 2. Não deve mostrar modal
  // 3. Está na página /auth ← NOVO!
  if (!isAuthenticated || !showModal || location.pathname === '/auth') {
    return null;
  }

  return (
    <Dialog 
      open={true} 
      onOpenChange={(open) => {
        // ✅ NÃO permitir fechar clicando fora ou ESC
        if (!open) setShowModal(true);
      }}
      modal
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto"
        // ✅ z-index MAIOR que o overlay (10000 > 9999)
        style={{ zIndex: 10000, position: 'relative' }}
        onInteractOutside={(e) => { e.preventDefault(); e.stopPropagation(); }}
        onEscapeKeyDown={(e) => { e.preventDefault(); e.stopPropagation(); }}
      >
        <DialogHeader>
          <DialogTitle>🔒 Preferências de Privacidade (LGPD)</DialogTitle>
          <DialogDescription>
            Para usar o sistema, precisamos do seu consentimento conforme a Lei Geral de Proteção de Dados.
          </DialogDescription>
        </DialogHeader>
        
        <ConsentManager 
          onComplete={async (purposes) => {
            console.log("📝 Consent submitted");
            const success = await handleConsentComplete(purposes);
            if (success) {
              console.log("✅ Consent success, closing modal");
              setShowModal(false);
            } else {
              console.warn("⚠️ Consent failed, keeping modal open");
            }
            return success;
          }}
          loading={loading}
        />
      </DialogContent>
    </Dialog>
  );
}