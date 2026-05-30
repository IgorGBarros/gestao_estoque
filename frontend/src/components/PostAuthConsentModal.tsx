// src/components/PostAuthConsentModal.tsx - VERSÃO CORRIGIDA
import { useLocation } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { isAuthenticated } = useAuth();
  const location = useLocation();
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Verificação EXPLÍCITA de rotas públicas
  const isAuthRoute = location.pathname === '/auth';
  const isLandingRoute = location.pathname === '/lp';
  const isVitrineRoute = location.pathname.startsWith('/vitrine');
  const isApiRoute = location.pathname.startsWith('/api');
  const isRootRoute = location.pathname === '/';

  // ✅ Guards: não renderizar se não deve mostrar
  if (!isAuthenticated || !showModal || isAuthRoute || isLandingRoute || isVitrineRoute || isApiRoute || isRootRoute) {
    return null;
  }

  return (
    // ✅ modal={false} para NÃO bloquear interações com o fundo
    <Dialog 
      open={true} 
      onOpenChange={(open) => {
        // ✅ Permitir fechar clicando fora ou pressionando ESC
        if (!open) setShowModal(false);
      }}
      modal={false} // ← CRÍTICO: Não bloquear interações
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto"
        style={{ zIndex: 1050 }}
        // ✅ Permitir clique fora do modal
        onInteractOutside={() => {}}
        // ✅ Permitir fechar com ESC
        onEscapeKeyDown={() => {}}
      >
        <DialogHeader>
          <DialogTitle>🔒 Preferências de Privacidade (LGPD)</DialogTitle>
          <DialogDescription>
            Para usar o sistema, precisamos do seu consentimento conforme a Lei Geral de Proteção de Dados.
            Você pode alterar estas preferências a qualquer momento em Configurações.
            <br /><br />
            <span className="text-sm text-muted-foreground">
              💡 Você pode fechar esta janela e usar o sistema.
            </span>
          </DialogDescription>
        </DialogHeader>
        
        <ConsentManager 
          onComplete={async (purposes) => {
            console.log("📝 Consent submitted");
            const success = await handleConsentComplete(purposes);
            if (success) {
              console.log("✅ Consent success, closing modal");
              setShowModal(false);
            }
            return success;
          }}
          loading={loading}
        />
      </DialogContent>
    </Dialog>
  );
}