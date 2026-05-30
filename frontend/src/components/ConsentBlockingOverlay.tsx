// src/components/ConsentBlockingOverlay.tsx - VERSÃO CORRIGIDA
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { useEffect } from "react";

export function ConsentBlockingOverlay() {
  const { shouldBlockAccess, hasChecked } = useConsentCheck();
  
  useEffect(() => {
    if (shouldBlockAccess && hasChecked) {
      // ✅ Bloquear scroll
      const originalOverflow = document.body.style.overflow;
      document.body.style.overflow = "hidden";
      
      // ✅ Prevenir teclas
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
  }, [shouldBlockAccess, hasChecked]);
  
  // ✅ Só renderizar se deve bloquear E já verificou
  if (!shouldBlockAccess || !hasChecked) return null;
  
  // ✅ Overlay com z-index ALTO mas MENOR que o modal
  return (
    <div 
      className="fixed inset-0 bg-black/20 backdrop-blur-[1px] pointer-events-auto"
      style={{ zIndex: 9999 }} // ✅ z-index menor que o modal (10000)
      onClick={(e) => {
        e.preventDefault();
        e.stopPropagation();
      }}
      onContextMenu={(e) => {
        e.preventDefault();
        e.stopPropagation();
      }}
      aria-hidden="true"
    />
  );
}