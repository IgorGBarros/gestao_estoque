// src/components/ProtectedRoute.tsx - COM BLOQUEIO LGPD
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
  const { shouldBlockAccess, hasChecked } = useConsentCheck(); // ✅ Usar hasChecked
  const location = useLocation();
  
  // ✅ 1. Loading de autenticação
  if (authLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
      </div>
    );
  }
  
  // ✅ 2. Não autenticado → redirect para login
  if (!user) {
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }
  
  // ✅ 3. Requer admin mas usuário não é staff
  if (requireAdmin && !user.is_staff) {
    return <Navigate to="/" replace />;
  }
  
  // ✅ 4. LGPD: Bloquear se consentimento não registrado E já verificou
  // (hasChecked evita bloquear durante o loading inicial dos consentimentos)
  if (shouldBlockAccess && hasChecked) {
    // ✅ Não renderizar conteúdo sensível
    // ✅ Overlay já cobre a tela via ConsentBlockingOverlay
    return null;
  }
  
  // ✅ 5. Tudo OK → renderizar conteúdo protegido
  return <>{children}</>;
}