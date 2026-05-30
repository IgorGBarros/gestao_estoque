// src/components/PostAuthConsentModal.tsx - VERSÃO NÃO BLOQUEANTE
import { useLocation } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";

export function PostAuthConsentModal() {
  const { isAuthenticated } = useAuth();
  const location = useLocation();
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Lista de rotas onde o modal NÃO deve aparecer
  const publicRoutes = ['/auth', '/lp', '/vitrine', '/'];
  const isPublicRoute = publicRoutes.includes(location.pathname) || 
                       location.pathname.startsWith('/vitrine/') ||
                       location.pathname.startsWith('/api/');

  // ✅ Guards: não renderizar se não deve mostrar ou está em rota pública
  if (!isAuthenticated || !showModal || isPublicRoute) {
    return null;
  }

  return (
    // ✅ Dialog com modal=false para NÃO bloquear interações com o fundo
    <Dialog 
      open={true} 
      onOpenChange={(open) => {
        // ✅ Permitir fechar clicando fora ou pressionando ESC
        if (!open) setShowModal(false);
      }}
      modal={false} // ✅ CRÍTICO: Não bloquear interações com o fundo
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto"
        // ✅ z-index alto mas não máximo (permite outros elementos por cima se necessário)
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
              💡 Você pode fechar esta janela e usar o sistema. O consentimento pode ser registrado depois.
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