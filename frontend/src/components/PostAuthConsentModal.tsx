// src/components/PostAuthConsentModal.tsx - VERSÃO FINAL CORRIGIDA
import { useLocation } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { ConsentManager } from "./ConsentManager";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "./ui/dialog";
import type { Purpose } from "@/hooks/useConsent";

export function PostAuthConsentModal() {
  const { isAuthenticated } = useAuth();
  const location = useLocation();
  const { showModal, setShowModal, loading, handleConsentComplete } = useConsentCheck();

  // ✅ Rotas ONDE O MODAL NUNCA APARECE
  const neverShowModalRoutes = [
    '/auth',
    '/lp',
    '/',
    '/admin-panel',
  ];
  
  const isNeverShowRoute = neverShowModalRoutes.includes(location.pathname) || 
                          location.pathname.startsWith('/vitrine') ||
                          location.pathname.startsWith('/api');

  // ✅ Guards: não renderizar NUNCA se:
  if (
    !isAuthenticated ||           // 1. Não autenticado
    !showModal ||                 // 2. Modal não deve mostrar
    isNeverShowRoute              // 3. Rota proibida (/lp, /auth, /, etc.)
  ) {
    return null;
  }

  console.log("🔐 PostAuthConsentModal: Rendering for", location.pathname);
  
  return (
    <Dialog 
      open={true} 
      onOpenChange={(open) => {
        if (!open) setShowModal(false);
      }}
      modal={false}
    >
      <DialogContent 
        className="max-w-2xl max-h-[90vh] overflow-y-auto"
        style={{ zIndex: 1050 }}
        onInteractOutside={() => {}}
        onEscapeKeyDown={() => {}}
      >
        <DialogHeader>
          <DialogTitle>🔒 Preferências de Privacidade (LGPD)</DialogTitle>
          <DialogDescription>
            Para usar o sistema, precisamos do seu consentimento conforme a Lei Geral de Proteção de Dados.
            <br /><br />
            <span className="text-sm text-muted-foreground">
              💡 Você pode fechar esta janela e usar o sistema.
            </span>
          </DialogDescription>
        </DialogHeader>
        
        <ConsentManager 
          // ✅ CORREÇÃO: Função deve retornar Promise<boolean>
          onComplete={async (purposes: Purpose[]): Promise<boolean> => {
            console.log("📝 onComplete called with:", purposes);
            const success = await handleConsentComplete(purposes);
            console.log("✅ handleConsentComplete returned:", success);
            
            if (success) {
              setShowModal(false);
            }
            
            // ✅ CRÍTICO: Retornar o boolean para satisfazer o tipo
            return success;
          }}
          loading={loading}
        />
      </DialogContent>
    </Dialog>
  );
}