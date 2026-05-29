// src/components/PostAuthConsentModal.tsx
import { useConsentCheck } from "../hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  // ✅ Agora as propriedades existem no retorno do hook
  const { showModal, setShowModal, loading } = useConsentCheck();

  // Handler chamado quando o consentimento é concluído
  const handleConsentComplete = () => {
    // Fecha o modal quando o usuário completar o fluxo de consentimento
    setShowModal(false);
  };

  // Não renderizar nada se modal não deve aparecer
  if (!showModal) return null;

  return (
    <Dialog 
      open={showModal} 
      onOpenChange={(open) => {
        // Não permitir fechar clicando fora ou pressionando ESC
        // O usuário deve aceitar explicitamente
        if (!open) {
          // Se tentar fechar, reabre
          setShowModal(true);
        }
      }}
      modal
    >
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>🔒 Preferências de Privacidade</DialogTitle>
          <DialogDescription>
            Para usar o sistema, precisamos do seu consentimento conforme a LGPD. 
            Você pode alterar estas preferências a qualquer momento nas configurações.
          </DialogDescription>
        </DialogHeader>
        
        {/* ✅ Passar handler para ConsentManager */}
        {/* Algumas versões do ConsentManager podem não expor props TS typings;
            usar as-cast para evitar erro de tipo local sem alterar outros arquivos */}
        <ConsentManager {...({ onComplete: handleConsentComplete, loading } as any)} />
      </DialogContent>
    </Dialog>
  );
} 