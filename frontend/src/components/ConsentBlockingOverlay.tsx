// src/components/ConsentBlockingOverlay.tsx - Guards adicionais
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { useEffect } from "react";

export function ConsentBlockingOverlay() {
  const { isAuthenticated } = useAuth(); // ✅ Verificar auth
  const { shouldBlockAccess, hasChecked } = useConsentCheck();
  
  useEffect(() => {
    // ✅ Só bloquear se: auth + deve bloquear + já verificou
    if (isAuthenticated && shouldBlockAccess && hasChecked) {
      const originalOverflow = document.body.style.overflow;
      document.body.style.overflow = "hidden";
      
      const handleKey = (e: KeyboardEvent) => {
        if (!["Tab", "Shift", "Control", "Alt", "Meta"].includes(e.key)) {
          e.preventDefault();
          e.stopPropagation();
        }
      };
      
      document.addEventListener("keydown", handleKey, { capture: true });
      
      return () => {
        document.body.style.overflow = originalOverflow;
        document.removeEventListener("keydown", handleKey, { capture: true });
      };
    }
  }, [isAuthenticated, shouldBlockAccess, hasChecked]);
  
  // ✅ Só renderizar overlay se todas as condições forem verdadeiras
  if (!isAuthenticated || !shouldBlockAccess || !hasChecked) return null;
  
  return (
    <div 
      className="fixed inset-0 bg-black/20 backdrop-blur-[1px] pointer-events-auto"
      style={{ zIndex: 9999 }}
      onClick={(e) => { e.preventDefault(); e.stopPropagation(); }}
      onContextMenu={(e) => { e.preventDefault(); e.stopPropagation(); }}
      aria-hidden="true"
    />
  );
}