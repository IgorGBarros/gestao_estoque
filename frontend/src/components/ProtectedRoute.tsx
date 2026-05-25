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

  // ✅ VERIFICAR AUTENTICAÇÃO COM GUARDA CONTRA NULL
  if (!isAuthenticated || !user) {
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }

  // ✅ VERIFICAR PERMISSÃO DE ADMIN (se requerido)
  if (requireAdmin && !user.is_staff) {
    return <Navigate to="/" replace />;
  }

  // ✅ GARANTIR QUE children NÃO É null/undefined
  if (!children) {
    if (import.meta.env.DEV) console.warn("⚠️ ProtectedRoute: children é null/undefined");
    return null;
  }

  return <>{children}</>;
}