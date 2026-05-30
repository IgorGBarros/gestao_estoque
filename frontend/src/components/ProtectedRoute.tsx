// src/components/ProtectedRoute.tsx
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
  const { shouldBlockAccess, hasChecked } = useConsentCheck();
  const location = useLocation();
  
  // ✅ Permitir acesso à página /auth sempre (não é rota protegida)
  if (location.pathname === '/auth') {
    return <>{children}</>;
  }
  
  // ✅ Loading de autenticação
  if (authLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
      </div>
    );
  }
  
  // ✅ Não autenticado → redirect para login
  if (!user) {
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }
  
  // ✅ Requer admin mas usuário não é staff
  if (requireAdmin && !user.is_staff) {
    return <Navigate to="/" replace />;
  }
  
  // ✅ LGPD: Bloquear se consentimento não registrado E já verificou
  if (shouldBlockAccess && hasChecked) {
    return null; // Overlay já cobre a tela
  }
  
  // ✅ Tudo OK → renderizar conteúdo protegido
  return <>{children}</>;
}