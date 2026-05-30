// src/components/ProtectedRoute.tsx - Sem bloqueio por LGPD
import { Navigate, useLocation } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";

interface ProtectedRouteProps {
  children: React.ReactNode;
  requireAdmin?: boolean;
}

export default function ProtectedRoute({ 
  children, 
  requireAdmin = false 
}: ProtectedRouteProps) {
  const { user, loading: authLoading } = useAuth();
  const location = useLocation();
  
  // ✅ Permitir acesso à página /auth sempre
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
  
  // ✅ LGPD: NÃO bloquear acesso - modal é discreto e não impede uso do sistema
  // O consentimento é registrado em background enquanto usuário usa o sistema
  
  // ✅ Renderizar conteúdo protegido normalmente
  return <>{children}</>;
}