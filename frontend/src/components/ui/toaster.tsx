// src/components/ui/toaster.tsx
import { useToast as useOriginalToast } from "@/hooks/use-toast-original";
import { Toast, ToastProvider, ToastViewport } from "./toast";
import { useEffect } from "react";

export function Toaster() {
  const { toast: internalToast, toasts } = useOriginalToast();
  
  useEffect(() => {
    const handleGlobalToast = (event: Event) => {
      const customEvent = event as CustomEvent;
      // ✅ Chamar toast interno SEM passar id (shadcn gera internamente)
      internalToast({
        title: customEvent.detail?.title,
        description: customEvent.detail?.description,
        variant: customEvent.detail?.variant,
        duration: customEvent.detail?.duration,
      });
    };
    
    window.addEventListener('app-toast', handleGlobalToast);
    return () => window.removeEventListener('app-toast', handleGlobalToast);
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