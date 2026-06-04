// src/lib/toast-wrapper.ts - ÚNICO arquivo de lógica de toast
import type { ToastProps as BaseToastProps } from "@/components/ui/toast";

export type ToastProps = {
  title?: React.ReactNode;
  description?: React.ReactNode;
  variant?: "default" | "destructive";
  duration?: number;
  [key: string]: any;
};

export const safeToast = (props: ToastProps) => {
  try {
    const { title, description, variant, duration } = props;
    
    // Método 1: Evento customizado para Toaster ouvir
    const event = new CustomEvent('app-toast', { 
      detail: { title, description, variant, duration: duration || 5000 } 
    });
    window.dispatchEvent(event);
    
    // Método 2: Fallback para console em dev
    if (import.meta.env.DEV) {
      console.log("🔔", title || description);
    }
  } catch (error) {
    console.warn("⚠️ Toast fallback (silently handled):", error);
  }
};

export const useSafeToast = () => safeToast;
export { useSafeToast as useToast };
export type { BaseToastProps };