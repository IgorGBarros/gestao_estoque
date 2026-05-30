// src/components/ConsentBlockingOverlay.tsx
import { useAuth } from "@/hooks/useAuth";
import { useConsentCheck } from "@/hooks/useConsentCheck";
import { useEffect } from "react";

export function ConsentBlockingOverlay() {
  const { isAuthenticated } = useAuth();
  const { shouldBlockAccess, hasChecked } = useConsentCheck();
  
  useEffect(() => {
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