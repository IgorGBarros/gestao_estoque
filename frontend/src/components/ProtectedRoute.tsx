// src/components/ProtectedRoute.tsx
import { useAuth } from "../hooks/useAuth";
import { Navigate, useLocation } from "react-router-dom";

export default function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, loading } = useAuth();
  const location = useLocation();

  console.log("🔍 [DEBUG] ProtectedRoute renderizado", { 
    isAuthenticated, 
    loading,
    pathname: location.pathname 
  });

  if (loading) {
    console.log("⏳ [DEBUG] ProtectedRoute: loading=true, mostrando spinner");
    return (
      <div className="flex h-screen w-full items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (!isAuthenticated) {
    console.log("🔒 [DEBUG] ProtectedRoute: não autenticado, redirecionando para /auth");
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }

  console.log("✅ [DEBUG] ProtectedRoute: renderizando conteúdo protegido");
  return <>{children}</>;
}