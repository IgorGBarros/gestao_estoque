// src/lib/toast-simple.ts - Wrapper global minimalista (tipos corrigidos)

/**
 * Tipo simplificado para toast - evita conflitos com tipos complexos do Radix UI
 */
export type SimpleToastProps = {
  title?: React.ReactNode;
  description?: React.ReactNode;
  variant?: "default" | "destructive";
  duration?: number;
  [key: string]: any; // ✅ Permite props extras sem erro
};

/**
 * Toast global seguro que NUNCA lança erro
 * Usa evento customizado para comunicação com <Toaster />
 */
export const safeToast = (props: SimpleToastProps) => {
  try {
    // ✅ Extrair apenas os campos que vamos usar (evita erro de tipo)
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
    
    // Fallback visual no console (apenas dev)
    if (import.meta.env.DEV) {
      console.log("🔔", title || description);
    }
  } catch (error) {
    console.warn("⚠️ Toast fallback:", error);
  }
};

/**
 * Hook mínimo que retorna a função safeToast
 * Compatível com a API do shadcn/ui
 */
export const useToast = () => ({
  toast: safeToast,
  dismiss: (_id?: string) => {}, // no-op para compatibilidade
});

// ✅ Exportar tipo simplificado
export type { SimpleToastProps as ToastProps };