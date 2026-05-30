// src/lib/toast-safe.ts - Wrapper global que NUNCA falha
import type { ToastProps as BaseToastProps } from "@/components/ui/toast";

// ✅ Tipo simplificado para evitar conflitos com Radix UI
export type ToastProps = {
  title?: React.ReactNode;
  description?: React.ReactNode;
  variant?: "default" | "destructive";
  duration?: number;
  [key: string]: any; // ✅ Permite props extras sem erro
};

/**
 * Função toast global que NUNCA lança erro
 * Usa evento customizado + fallback seguro
 */
export const safeToast = (props: ToastProps) => {
  try {
    // Extrair apenas campos que vamos usar
    const { title, description, variant, duration } = props;
    
    // Dispatch evento global que o Toaster vai ouvir
    const event = new CustomEvent('app-toast', { 
      detail: { 
        title, 
        description,
        variant,
        duration: duration || 5000,
      } 
    });
    window.dispatchEvent(event);
    
    // Fallback dev (não aparece em produção)
    if (import.meta.env.DEV) {
      console.log("🔔", title || description);
    }
  } catch (error) {
    console.warn("⚠️ Toast fallback:", error);
  }
};

/**
 * Hook que retorna a função safeToast
 * Compatível com API do shadcn/ui
 */
export const useToast = () => ({
  toast: safeToast,
  dismiss: () => {}, // no-op para compatibilidade
});

export type { BaseToastProps };