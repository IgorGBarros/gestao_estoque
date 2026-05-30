// src/components/PostAuthConsentModal.tsx - VERSÃO FINAL
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Se não deve mostrar, retornar null imediatamente
  if (!showModal) return null;

  return (
    <Dialog 
      open={true} 
      onOpenChange={(open) => {
        // ✅ NÃO permitir fechar
        if (!open) setShowModal(true);
      }}
      modal
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto"
        style={{ zIndex: 10000 }}
        onInteractOutside={(e) => {
          e.preventDefault();
          e.stopPropagation();
        }}
        onEscapeKeyDown={(e) => {
          e.preventDefault();
          e.stopPropagation();
        }}
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