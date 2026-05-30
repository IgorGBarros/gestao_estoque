// src/lib/toast.ts - Wrapper 100% seguro
import { useToast as useOriginal } from "@/hooks/use-toast";
import type { ToastProps } from "@/hooks/use-toast";

export function useToast() {
  const original = useOriginal();
  
  return (props: ToastProps) => {
    try {
      if (original?.toast && typeof original.toast === 'function') {
        return original.toast(props);
      }
    } catch (e) {
      console.warn("⚠️ Toast fallback:", props?.title);
    }
  };
}

export type { ToastProps };