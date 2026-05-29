// src/components/ConsentManager.tsx
import { useState } from "react";
import { Button } from "./ui/button";
import { Checkbox } from "./ui/checkbox";
import { useConsent, PURPOSES, type Purpose, ESSENTIAL_PURPOSES } from "../hooks/useConsent";

interface ConsentManagerProps {
  onComplete?: (purposes: Purpose[]) => Promise<boolean>;
  loading?: boolean;
}

export function ConsentManager({ onComplete, loading }: ConsentManagerProps) {
  const { recordConsent } = useConsent();
  
  const [selectedPurposes, setSelectedPurposes] = useState<Purpose[]>([...ESSENTIAL_PURPOSES]);
  const [submitting, setSubmitting] = useState(false);

  // ✅ Finalidades que o usuário pode escolher (não-essenciais)
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
      // Não permitir desmarcar finalidades essenciais
      if (!ESSENTIAL_PURPOSES.includes(purpose as any)) {
        setSelectedPurposes(prev => prev.filter(p => p !== purpose));
      }
    }
  };

  const handleSubmit = async () => {
    setSubmitting(true);
    
    try {
      // Se tiver onComplete prop, usar ela (do hook useConsentCheck)
      if (onComplete) {
        await onComplete(selectedPurposes);
      } else {
        // Fallback: chamar recordConsent diretamente
        await recordConsent(selectedPurposes);
      }
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="space-y-6 py-4">
      {/* ✅ Finalidades Essenciais (sempre marcadas, não desmarcáveis) */}
      <div className="space-y-3">
        <h4 className="font-medium text-sm">Obrigatório</h4>
        <div className="space-y-2 pl-4 border-l-2 border-muted">
          {ESSENTIAL_PURPOSES.map((purpose) => (
            <div key={purpose} className="flex items-center space-x-2">
              <Checkbox 
                id={`essential-${purpose}`} 
                checked={true} 
                disabled={true}
                className="opacity-50"
              />
              <label 
                htmlFor={`essential-${purpose}`}
                className="text-sm text-muted-foreground cursor-not-allowed"
              >
                {getPurposeLabel(purpose)} - Essencial para o funcionamento do sistema
              </label>
            </div>
          ))}
        </div>
      </div>

      {/* ✅ Finalidades Opcionais (usuário pode escolher) */}
      <div className="space-y-3">
        <h4 className="font-medium text-sm">Opcional</h4>
        <div className="space-y-2 pl-4">
          {optionalPurposes.map((purpose) => (
            <div key={purpose} className="flex items-center space-x-2">
              <Checkbox 
                id={`optional-${purpose}`}
                checked={selectedPurposes.includes(purpose)}
                onCheckedChange={(checked) => handleToggle(purpose, checked as boolean)}
                disabled={submitting || loading}
              />
              <label 
                htmlFor={`optional-${purpose}`}
                className="text-sm"
              >
                {getPurposeLabel(purpose)}
              </label>
            </div>
          ))}
        </div>
      </div>

      {/* ✅ Botão de Ação */}
      <div className="flex justify-end pt-4 border-t">
        <Button 
          onClick={handleSubmit}
          disabled={submitting || loading || selectedPurposes.length === 0}
          className="min-w-[120px]"
        >
          {submitting || loading ? (
            <div className="flex items-center gap-2">
              <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white" />
              Salvando...
            </div>
          ) : (
            "Aceitar e Continuar"
          )}
        </Button>
      </div>
    </div>
  );
}

// ✅ Helper para labels amigáveis
function getPurposeLabel(purpose: Purpose): string {
  const labels: Record<Purpose, string> = {
    [PURPOSES.ESSENTIAL]: "Funcionamento básico",
    [PURPOSES.AUTH]: "Autenticação e segurança",
    [PURPOSES.SERVICE]: "Entrega do serviço",
    [PURPOSES.ANALYTICS]: "Análise de uso e melhorias",
    [PURPOSES.MARKETING]: "Comunicações e ofertas",
    [PURPOSES.BEHAVIOR]: "Personalização de experiência",
    [PURPOSES.AI]: "Recursos de inteligência artificial",
  };
  return labels[purpose] || purpose;
}