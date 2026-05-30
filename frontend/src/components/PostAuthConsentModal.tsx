// src/components/PostAuthConsentModal.tsx - VERSÃO QUE BLOQUEIA
import { useConsentCheck } from "../hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";
// src/components/PostAuthConsentModal.tsx - Trecho crítico
export function PostAuthConsentModal() {
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  if (!showModal) return null;

  return (
    <Dialog 
      open={true} // ✅ Sempre aberto quando showModal=true
      onOpenChange={(open) => {
        // ✅ NÃO permitir fechar clicando fora ou ESC
        if (!open) setShowModal(true); // Reabrir se tentar fechar
      }}
      modal
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto"
        onInteractOutside={(e) => e.preventDefault()} // ✅ Bloquear clique fora
        onEscapeKeyDown={(e) => e.preventDefault()}    // ✅ Bloquear ESC
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
            // ✅ Modal só fecha se handleConsentComplete retornar true
            return success;
          }}
          loading={loading}
        />
      </DialogContent>
    </Dialog>
  );
}