// src/components/ConsentManager.tsx - VERSÃO CORRIGIDA
import { useState } from "react";
import { Button } from "./ui/button";
import { Checkbox } from "./ui/checkbox";
// ✅ Importar wrapper seguro
import { useSafeToast } from "@/lib/toast-safe";
import { useConsent, PURPOSES, type Purpose, ESSENTIAL_PURPOSES } from "@/hooks/useConsent";

interface ConsentManagerProps {
  onComplete?: (purposes: Purpose[]) => Promise<boolean>;
  loading?: boolean;
}

export function ConsentManager({ onComplete, loading }: ConsentManagerProps) {
  const { recordConsent } = useConsent();
  // ✅ useSafeToast retorna { toast: fn, dismiss: fn }
  const toast = useSafeToast();
  
  const [selectedPurposes, setSelectedPurposes] = useState<Purpose[]>([...ESSENTIAL_PURPOSES]);
  const [submitting, setSubmitting] = useState(false);

  const optionalPurposes: Purpose[] = [
    PURPOSES.ANALYTICS,
    PURPOSES.MARKETING,
    PURPOSES.BEHAVIOR,
    PURPOSES.AI,
  ];

  const handleToggle = (purpose: Purpose, checked: boolean) => {
    if (checked) {
      setSelectedPurposes(prev => [...prev, purpose]);
    } else {
      if (!ESSENTIAL_PURPOSES.includes(purpose as any)) {
        setSelectedPurposes(prev => prev.filter(p => p !== purpose));
      }
    }
  };

  const handleSubmit = async () => {
    console.log("📝 handleSubmit called with:", selectedPurposes);
    setSubmitting(true);
    
    try {
      if (onComplete) {
        console.log("📝 Calling onComplete...");
        const success = await onComplete(selectedPurposes);
        console.log("✅ onComplete returned:", success);
      } else {
        console.log("📝 Calling recordConsent directly...");
        await recordConsent(selectedPurposes);
      }
      
      // ✅ CORREÇÃO: chamar toast.toast() em vez de toast()
      toast.toast({
        title: "✅ Consentimento registrado",
        description: "Suas preferências foram salvas.",
      });
    } catch (error) {
      console.error("❌ Consent error:", error);
      // ✅ CORREÇÃO: chamar toast.toast() em vez de toast()
      toast.toast({
        title: "❌ Erro ao registrar consentimento",
        description: "Tente novamente",
        variant: "destructive",
      });
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 py-4">
      {/* ... checkboxes ... */}
      
      <div className="flex justify-end pt-4 border-t">
        <Button 
          onClick={handleSubmit}
          disabled={submitting || loading}
          className="min-w-[120px]"
        >
          {submitting || loading ? (
            <div className="flex items-center gap-2">
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white" />
              Salvando...
            </div>
          ) : (
            "Salvar"
          )}
        </Button>
      </div>
    </div>
  );
}