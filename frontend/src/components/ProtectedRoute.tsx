// src/components/ProtectedRoute.tsx
import { useAuth } from "../hooks/useAuth";
import { Navigate, useLocation } from "react-router-dom";

export default function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, loading } = useAuth();
  const location = useLocation();

  // ✅ MOSTRAR LOADING ENQUANTO AUTENTICA
  if (loading) {
    return (
      <div className="flex h-screen w-full items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  // ✅ REDIRECIONAR SE NÃO AUTENTICADO
  if (!isAuthenticated) {
    return <Navigate to="/auth" state={{ from: location }} replace />;
  }

  // ✅ RENDERIZAR CONTEÚDO PROTEGIDO
  return <>{children}</>;
}