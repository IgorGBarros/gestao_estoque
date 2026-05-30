// src/components/ProtectedRoute.tsx - Atualizar guards
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
  
  // ✅ Rotas que NÃO requerem autenticação
  const publicRoutes = ['/auth', '/lp', '/', '/admin-panel'];
  const isPublicRoute = publicRoutes.includes(location.pathname);
  
  // ✅ Permitir rotas públicas SEMPRE
  if (isPublicRoute) {
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
  
  // ✅ LGPD: NÃO bloquear - modal é discreto
  return <>{children}</>;
}