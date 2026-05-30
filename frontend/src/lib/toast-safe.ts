// src/lib/toast-safe.ts - Wrapper global que NUNCA falha
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
    
    const event = new CustomEvent('app-toast', { 
      detail: { 
        title, 
        description,
        variant,
        duration: duration || 5000,
      } 
    });
    window.dispatchEvent(event);
    
    if (import.meta.env.DEV) {
      console.log("🔔", title || description);
    }
  } catch (error) {
    console.warn("⚠️ Toast fallback:", error);
  }
};

export const useToast = () => ({
  toast: safeToast,
  dismiss: () => {},
});

export { useToast as useSafeToast };
export type { BaseToastProps };