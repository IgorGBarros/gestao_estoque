// src/components/ui/toaster.tsx
import { useToast as useOriginalToast } from "@/hooks/use-toast-original";
import { Toast, ToastProvider, ToastViewport } from "./toast";
import { useEffect } from "react";

export function Toaster() {
  const { toast: internalToast, toasts } = useOriginalToast();
  
  // ✅ Ouvir evento global do wrapper seguro
  useEffect(() => {
    const handleGlobalToast = (event: Event) => {
      const custom = event as CustomEvent;
      internalToast({
        title: custom.detail?.title,
        description: custom.detail?.description,
        variant: custom.detail?.variant,
        duration: custom.detail?.duration,
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