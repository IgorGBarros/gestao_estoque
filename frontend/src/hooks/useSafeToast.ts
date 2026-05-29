// src/hooks/useSafeToast.ts
import { useToast as useShadcnToast } from "./use-toast";

/**
 * Hook seguro para toast que garante retorno de função
 * Evita "TypeError: r is not a function"
 */
export function useSafeToast() {
  // cast to any to avoid TS inference issues when upstream types vary
  const toastHook: any = useShadcnToast();
  
  // ✅ Garantir que sempre retorna uma função
  const safeToast = (props: any) => {
    if (typeof toastHook === 'function') {
      return toastHook(props);
    }
    if (toastHook?.toast && typeof toastHook.toast === 'function') {
      return toastHook.toast(props);
    }
    // Fallback: log em vez de crash
    console.warn("⚠️ Toast não disponível:", props);
  };
  
  return safeToast;
}