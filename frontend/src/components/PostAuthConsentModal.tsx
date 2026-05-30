// src/components/PostAuthConsentModal.tsx
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { isAuthenticated } = useAuth();
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Guard duplo: não renderizar se não autenticado OU não deve mostrar
  if (!isAuthenticated || !showModal) return null;

  return (
    <Dialog 
      open={true} 
      onOpenChange={(open) => { if (!open) setShowModal(true); }}
      modal
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto"
        style={{ zIndex: 10000 }}
        onInteractOutside={(e) => { e.preventDefault(); e.stopPropagation(); }}
        onEscapeKeyDown={(e) => { e.preventDefault(); e.stopPropagation(); }}
      >
        <DialogHeader>
          <DialogTitle>🔒 Preferências de Privacidade (LGPD)</DialogTitle>
          <DialogDescription>
            Para usar o sistema, precisamos do seu consentimento conforme a Lei Geral de Proteção de Dados.
            Você pode alterar estas preferências a qualquer momento em Configurações.
          </DialogDescription>
        </DialogHeader>
        
        <ConsentManager 
          onComplete={async (purposes) => {
            const success = await handleConsentComplete(purposes);
            if (success) setShowModal(false);
            return success;
          }}
          loading={loading}
        />
      </DialogContent>
    </Dialog>
  );
}