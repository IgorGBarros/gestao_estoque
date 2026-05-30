// src/lib/toast.ts
import { useToast as useShadcnToast, type ToastProps } from "@/hooks/use-toast";

/**
 * Wrapper global seguro para toast
 * Previne "TypeError: r is not a function" em qualquer componente
 */
export function useSafeToast() {
  const toastHook = useShadcnToast() as unknown;
  
  // ✅ Função segura que nunca lança erro
  const safeToast = (props: ToastProps) => {
    try {
      // Caso 1: hook retorna função direta
      if (typeof toastHook === 'function') {
        return (toastHook as (props: ToastProps) => void)(props);
      }
      // Caso 2: hook retorna objeto com método toast()
      if (toastHook && typeof (toastHook as { toast?: unknown }).toast === 'function') {
        return (toastHook as { toast: (props: ToastProps) => void }).toast(props);
      }
      // Fallback: log seguro em vez de crash
      console.warn("⚠️ Toast fallback:", props);
    } catch (error) {
      console.error("❌ Toast error (silently handled):", error);
    }
  };
  
  return safeToast;
}

// ✅ Exportar tipo para compatibilidade com TypeScript
export type { ToastProps };