// src/components/ConsentManager.tsx - VERSÃO FINAL CORRIGIDA
import { useState } from "react";
import { Button } from "./ui/button";
import { Checkbox } from "./ui/checkbox";
// ✅ Importar do use-toast padrão do shadcn
import { useToast } from "@/components/ui/use-toast";
import { useConsent, type Purpose, ESSENTIAL_PURPOSES, OPTIONAL_PURPOSES } from "@/hooks/useConsent";

interface ConsentManagerProps {
  onComplete?: (purposes: Purpose[]) => Promise<boolean>;
  loading?: boolean;
}

// ✅ Labels centralizados para evitar repetição
const LABELS: Record<Purpose, { title: string; desc: string }> = {
  essential: {
    title: "Funcionamento básico do sistema",
    desc: "Cookies e dados necessários para o sistema operar.",
  },
  authentication: {
    title: "Autenticação e segurança",
    desc: "Manter sua sessão segura e proteger sua conta.",
  },
  service_delivery: {
    title: "Entrega do serviço",
    desc: "Processar seus dados de estoque, vendas e operação.",
  },
  analytics: {
    title: "Análise de uso e melhorias",
    desc: "Métricas anônimas para evoluirmos o produto.",
  },
  marketing: {
    title: "Comunicações e ofertas",
    desc: "Receber novidades, dicas e promoções por email.",
  },
  behavior_tracking: {
    title: "Rastreamento de comportamento",
    desc: "Entender como você usa o sistema para personalizar.",
  },
  ai_features: {
    title: "Recursos de inteligência artificial",
    desc: "Análises e sugestões geradas por IA sobre seu estoque.",
  },
  ai_training: {
    title: "Treinamento de modelos de IA",
    desc: "Usar dados de entrada e saída de estoque (produto, quantidade, preço, data) para treinar e melhorar os modelos de IA da plataforma. Não inclui nome de cliente, CPF, RG, endereço ou qualquer outro dado pessoal — só padrões de estoque e vendas.",
  },
};

export function ConsentManager({ onComplete, loading }: ConsentManagerProps) {
  const { recordConsent } = useConsent();
  
  const toast = useToast();
  
  const [selectedPurposes, setSelectedPurposes] = useState<Purpose[]>([...ESSENTIAL_PURPOSES]);
  const [submitting, setSubmitting] = useState(false);

  const handleToggle = (purpose: Purpose, checked: boolean) => {
    if (checked) {
      setSelectedPurposes(prev => [...prev, purpose]);
    } else {
      // ✅ CORREÇÃO #2: Usar 'as any' para evitar erro de tipo estrito no includes
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
        const success = await onComplete(selectedPurposes);
        console.log("✅ onComplete returned:", success);
      } else {
        await recordConsent(selectedPurposes);
      }
      
      // ✅ CORREÇÃO #3: Chamar toast.toast() (propriedade do objeto retornado pelo hook)
      toast.toast({
        title: "✅ Consentimento registrado",
        description: "Suas preferências de privacidade foram salvas.",
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
      {/* Finalidades essenciais */}
      <section>
        <h4 className="mb-2 text-sm font-semibold text-foreground">
          Finalidades essenciais
        </h4>
        <div className="space-y-3 rounded-lg border border-border bg-muted/30 p-3">
          {ESSENTIAL_PURPOSES.map((key) => (
            <label key={key} className="flex items-start gap-3 cursor-not-allowed">
              <Checkbox checked disabled className="mt-0.5" />
              <div className="text-sm">
                <div className="font-medium text-foreground">{LABELS[key].title}</div>
                <div className="text-muted-foreground">{LABELS[key].desc}</div>
              </div>
            </label>
          ))}
        </div>
      </section>

      {/* Finalidades opcionais */}
      <section>
        <h4 className="mb-2 text-sm font-semibold text-foreground">
          Finalidades opcionais
        </h4>
        <div className="space-y-3 rounded-lg border border-border p-3">
          {OPTIONAL_PURPOSES.map((key) => (
            <label key={key} className="flex items-start gap-3 cursor-pointer">
              <Checkbox
                checked={selectedPurposes.includes(key)}
                onCheckedChange={(checked) => handleToggle(key, checked === true)}
                className="mt-0.5"
              />
              <div className="text-sm">
                <div className="font-medium text-foreground">{LABELS[key].title}</div>
                <div className="text-muted-foreground">{LABELS[key].desc}</div>
              </div>
            </label>
          ))}
        </div>
      </section>

      {/* Info */}
      <p className="rounded-md bg-muted/40 p-2 text-xs text-muted-foreground">
        💡 Você pode fechar esta janela e usar o sistema. O consentimento
        pode ser registrado depois em Configurações.
      </p>

      {/* Botões */}
      <div className="flex flex-col-reverse gap-2 sm:flex-row sm:justify-end">
        <Button 
          variant="ghost" 
          onClick={() => {
            if (onComplete) onComplete([]);
          }} 
          disabled={submitting || loading}
        >
          Fechar
        </Button>
        <Button onClick={handleSubmit} disabled={submitting || loading}>
          {submitting || loading ? "Salvando..." : "Salvar e continuar"}
        </Button>
      </div>
    </div>
  );
}