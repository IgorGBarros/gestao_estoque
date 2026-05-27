// src/components/PostAuthConsentModal.tsx
import { useConsentCheck } from "../hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { showConsentModal, handleConsentComplete } = useConsentCheck();

  if (!showConsentModal) return null;

  return (
    <Dialog open={showConsentModal} onOpenChange={() => {}}>
      <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>🔒 Preferências de Privacidade</DialogTitle>
          <DialogDescription>
            Para usar o sistema, precisamos do seu consentimento conforme a LGPD. 
            Você pode alterar estas preferências a qualquer momento.
          </DialogDescription>
        </DialogHeader>
        
        <ConsentManager />
      </DialogContent>
    </Dialog>
  );
}