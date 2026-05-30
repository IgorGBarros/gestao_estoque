// src/components/ui/toaster.tsx - Versão corrigida (sem passar id)
import { useToast as useShadcnToast } from "@/hooks/use-toast-original";
import { Toast, ToastProvider, ToastViewport } from "./toast";
import { useEffect } from "react";

export function Toaster() {
  // ✅ Usar o hook original do shadcn para gerenciar toasts internos
  const { toast: internalToast, toasts } = useShadcnToast();
  
  // ✅ Ouvir evento global de toast
  useEffect(() => {
    const handleGlobalToast = (event: Event) => {
      const customEvent = event as CustomEvent;
      
      // ✅ NÃO passar id - o shadcn gera internamente
      // ✅ Usar apenas propriedades válidas do tipo Toast
      internalToast({
        title: customEvent.detail?.title,
        description: customEvent.detail?.description,
        variant: customEvent.detail?.variant,
        duration: customEvent.detail?.duration,
        // ✅ Se precisar de ação:
        // action: customEvent.detail?.action,
      });
    };
    
    window.addEventListener('app-toast', handleGlobalToast);
    return () => {
      window.removeEventListener('app-toast', handleGlobalToast);
    };
  }, [internalToast]);
  
  return (
    <ToastProvider>
      {toasts.map(({ id, title, description, action, ...props }) => (
        <Toast key={id} {...props}>
          <div className="grid gap-1">
            {title && <div className="font-semibold">{title}</div>}
            {description && <div className="text-sm opacity-90">{description}</div>}
          </div>
          {action}
        </Toast>
      ))}
      <ToastViewport />
    </ToastProvider>
  );
}