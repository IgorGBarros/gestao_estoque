// src/components/ConsentManager.tsx - CORREÇÃO DO TOAST
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
  // ✅ Usar wrapper seguro
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
    console.log("📝 handleSubmit called");
    setSubmitting(true);
    
    try {
      if (onComplete) {
        console.log("📝 Calling onComplete...");
        const success = await onComplete(selectedPurposes);
        console.log("✅ onComplete returned:", success);
      } else {
        await recordConsent(selectedPurposes);
      }
      
      // ✅ CORREÇÃO: chamar toast.toast() (não toast())
      toast.toast({
        title: "✅ Consentimento registrado",
        description: "Suas preferências foram salvas.",
      });
    } catch (error) {
      console.error("❌ Consent error:", error);
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
        >
          {submitting || loading ? "Salvando..." : "Salvar"}
        </Button>
      </div>
    </div>
  );
}