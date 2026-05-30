// src/components/PostAuthConsentModal.tsx - VERSÃO QUE BLOQUEIA
import { useConsentCheck } from "../hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Se modal deve aparecer, NÃO renderizar children da aplicação
  if (showModal) {
    return (
      <Dialog open={true} onOpenChange={() => {}}>
        <DialogContent 
          className="max-w-2xl max-h-[90vh] overflow-y-auto"
          onInteractOutside={(e) => e.preventDefault()} // ✅ Bloquear clique fora
          onEscapeKeyDown={(e) => e.preventDefault()}    // ✅ Bloquear ESC
        >
          <DialogHeader>
            <DialogTitle>🔒 Preferências de Privacidade</DialogTitle>
            <DialogDescription>
              Para usar o sistema, precisamos do seu consentimento conforme a LGPD.
            </DialogDescription>
          </DialogHeader>
          
          <ConsentManager 
            onComplete={async (purposes) => {
              const success = await handleConsentComplete(purposes);
              if (success) {
                setShowModal(false); // ✅ Só fechar se sucesso
              }
              return success;
            }}
            loading={loading}
          />
        </DialogContent>
      </Dialog>
    );
  }

  // ✅ Se não precisa de consentimento, renderizar normalmente
  return null;
}