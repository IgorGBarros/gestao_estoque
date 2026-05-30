// src/components/ProtectedRoute.tsx - ADICIONAR verificação de consentimento
import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";

interface ProtectedRouteProps {
  children: React.ReactNode;
  requireAdmin?: boolean;
}

export default function ProtectedRoute({ 
  children, 
  requireAdmin = false 
}: ProtectedRouteProps) {
  const { user, loading: authLoading } = useAuth();
  const { shouldBlockAccess } = useConsentCheck(); // ✅ NOVO
  const location = useLocation();
  
  // ✅ Se ainda carregando autenticação, mostrar loading
  if (authLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
      </div>
    );
  }
  
  // ✅ Se não autenticado, redirecionar para login
  if (!user) {
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }
  
  // ✅ Se requer admin e usuário não é staff, negar acesso
  if (requireAdmin && !user.is_staff) {
    return <Navigate to="/" replace />;
  }
  
  // ✅ NOVO: Se deve bloquear por consentimento, não renderizar conteúdo
  // O ConsentBlockingOverlay já cobre a UI, mas isso previne fetch de dados sensíveis
  if (shouldBlockAccess) {
    return null; // Overlay já está cobrindo a tela
  }
  
  // ✅ Tudo OK, renderizar conteúdo protegido
  return <>{children}</>;
}