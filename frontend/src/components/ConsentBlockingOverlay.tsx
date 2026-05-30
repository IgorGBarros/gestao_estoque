// src/components/ConsentBlockingOverlay.tsx
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { useEffect } from "react";

export function ConsentBlockingOverlay() {
  const { shouldBlockAccess } = useConsentCheck();
  
  useEffect(() => {
    if (shouldBlockAccess) {
      // ✅ Bloquear scroll
      document.body.style.overflow = "hidden";
      // ✅ Prevenir atalhos que poderiam pular o modal
      const handleKey = (e: KeyboardEvent) => {
        if (!["Tab", "Shift", "Control", "Alt"].includes(e.key)) {
          e.preventDefault();
        }
      };
      document.addEventListener("keydown", handleKey, { capture: true });
      
      return () => {
        document.body.style.overflow = "";
        document.removeEventListener("keydown", handleKey, { capture: true });
      };
    }
  }, [shouldBlockAccess]);
  
  if (!shouldBlockAccess) return null;
  
  // ✅ Overlay que cobre TUDO com alta prioridade (z-index máximo)
  return (
    <div 
      className="fixed inset-0 z-[9999] bg-black/30 backdrop-blur-[2px]"
      onClick={(e) => e.preventDefault()}
      onContextMenu={(e) => e.preventDefault()}
    />
  );
}