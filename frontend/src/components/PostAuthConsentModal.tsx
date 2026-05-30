// src/components/PostAuthConsentModal.tsx - VERSÃO CORRIGIDA
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Se não deve mostrar, não renderizar nada
  if (!showModal) return null;

  return (
    // ✅ Dialog com z-index MÁXIMO para ficar acima do overlay
    <Dialog 
      open={true} 
      onOpenChange={(open) => {
        // ✅ NÃO permitir fechar clicando fora ou ESC
        if (!open) setShowModal(true);
      }}
      modal
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto z-[10000]" // ✅ z-index maior que o overlay
        onInteractOutside={(e) => {
          e.preventDefault(); // ✅ Bloquear clique fora
          e.stopPropagation();
        }}
        onEscapeKeyDown={(e) => {
          e.preventDefault(); // ✅ Bloquear tecla ESC
          e.stopPropagation();
        }}
        style={{ zIndex: 10000 }} // ✅ Forçar z-index inline
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
            if (success) {
              setShowModal(false);
              return success;
            }
          }}
          loading={loading}
        />
      </DialogContent>
    </Dialog>
  );
}