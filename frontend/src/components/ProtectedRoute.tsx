// src/components/ProtectedRoute.tsx
import { useAuth } from "../hooks/useAuth";
import { Navigate, useLocation } from "react-router-dom";

interface ProtectedRouteProps {
  children: React.ReactNode;
  requireAdmin?: boolean;
}

export default function ProtectedRoute({ 
  children, 
  requireAdmin = false 
}: ProtectedRouteProps) {
  const { user, loading, isAuthenticated } = useAuth();
  const location = useLocation();

  // ✅ MOSTRAR LOADING enquanto autentica
  if (loading) {
    return (
      <div className="flex h-screen w-full items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary" />
      </div>
    );
  }

  // ✅ VERIFICAR AUTENTICAÇÃO
  if (!isAuthenticated || !user) {
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }

  // ✅ VERIFICAR PERMISSÃO DE ADMIN (se requerido)
  if (requireAdmin && !user.is_staff) {
    // Redireciona para página inicial se não for admin
    return <Navigate to="/" replace />;
  }

  // ✅ RENDERIZAR CONTEÚDO PROTEGIDO
  return <>{children}</>;
}