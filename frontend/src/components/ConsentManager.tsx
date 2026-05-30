// src/components/ConsentManager.tsx - Garantir uso do toast seguro
import { useState } from "react";
import { Button } from "./ui/button";
import { Checkbox } from "./ui/checkbox";
// ✅ Importar wrapper seguro
import { useToast } from "@/lib/toast-safe";
import { useConsent, PURPOSES, type Purpose, ESSENTIAL_PURPOSES } from "@/hooks/useConsent";

interface ConsentManagerProps {
  onComplete?: (purposes: Purpose[]) => Promise<boolean>;
  loading?: boolean;
}

export function ConsentManager({ onComplete, loading }: ConsentManagerProps) {
  const { recordConsent } = useConsent();
  // ✅ Usar toast seguro
  const { toast } = useToast();
  
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
    setSubmitting(true);
    
    try {
      if (onComplete) {
        await onComplete(selectedPurposes);
      } else {
        await recordConsent(selectedPurposes);
      }
      
      // ✅ Toast seguro - nunca falha
      toast({
        title: "✅ Consentimento registrado",
        description: "Suas preferências foram salvas.",
      });
    } catch (error) {
      console.error("❌ Consent error:", error);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 py-4">
      {/* ... resto do componente ... */}
      <Button onClick={handleSubmit} disabled={submitting || loading}>
        {submitting || loading ? "Salvando..." : "Aceitar e Continuar"}
      </Button>
    </div>
  );
}