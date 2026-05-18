// src/components/ConsentManager.tsx
import { useState } from "react";
import { useConsent, PURPOSES, Purpose } from "../hooks/useConsent";
import { useToast } from "../hooks/use-toast";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Switch } from "./ui/switch";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./ui/card";
import { Shield, ToggleLeft, ToggleRight, Info } from "lucide-react";

const PURPOSE_LABELS: Record<Purpose, { label: string; desc: string }> = {
  [PURPOSES.ESSENTIAL]: {
    label: "Funcionamento Essencial",
    desc: "Necessário para autenticação, segurança e entrega do serviço contratado.",
  },
  [PURPOSES.AUTH]: {
    label: "Autenticação e Conta",
    desc: "Gerenciamento da sua conta, login e recuperação de acesso.",
  },
  [PURPOSES.SERVICE]: {
    label: "Entrega do Serviço",
    desc: "Processamento de pedidos, estoque e funcionalidades principais do app.",
  },
  [PURPOSES.ANALYTICS]: {
    label: "Analytics e Melhorias",
    desc: "Coleta de dados de uso anônimos para melhorar a experiência do aplicativo.",
  },
  [PURPOSES.MARKETING]: {
    label: "Comunicações Promocionais",
    desc: "Receber ofertas, novidades e conteúdos relevantes sobre nossos produtos.",
  },
  [PURPOSES.BEHAVIOR]: {
    label: "Comportamento para IA",
    desc: "Padrões de uso anonimizados para treinar recursos de inteligência artificial.",
  },
  [PURPOSES.AI]: {
    label: "Recursos de IA",
    desc: "Habilitar assistente virtual, recomendações personalizadas e automações inteligentes.",
  },
};

export function ConsentManager() {
  const { 
    consents, 
    loading, 
    essentialPurposes, 
    revocablePurposes,
    hasConsent, 
    revokeConsent,
    refresh 
  } = useConsent();
  
  const { toast } = useToast();
  const [revoking, setRevoking] = useState<Purpose | null>(null);

  const handleToggle = async (purpose: Purpose) => {
    if (essentialPurposes.includes(purpose)) return;
    
    setRevoking(purpose);
    const success = await revokeConsent(purpose);
    if (success) {
      refresh();
    }
    setRevoking(null);
  };

  if (loading) {
    return (
      <Card>
        <CardContent className="p-6 text-center text-muted-foreground">
          Carregando preferências de privacidade...
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Shield className="h-5 w-5 text-primary" />
          Privacidade e Consentimento
        </CardTitle>
        <CardDescription>
          Gerencie como seus dados são tratados, conforme a LGPD.
          <br />
          <span className="text-xs text-muted-foreground">
            Versão do termo: v1.0_2026-05
          </span>
        </CardDescription>
      </CardHeader>
      
      <CardContent className="space-y-4">
        {(Object.values(PURPOSES) as Purpose[]).map((purpose) => {
          const isActive = hasConsent(purpose);
          const isEssential = essentialPurposes.includes(purpose);
          const isRevocable = revocablePurposes.includes(purpose);
          const { label, desc } = PURPOSE_LABELS[purpose];
          
          return (
            <div 
              key={purpose}
              className="flex items-start justify-between gap-4 p-4 border rounded-lg"
            >
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  <span className="font-medium text-sm">{label}</span>
                  {isEssential && (
                    <Badge variant="secondary" className="text-[10px]">
                      Essencial
                    </Badge>
                  )}
                  {isActive && !isEssential && (
                    <Badge variant="default" className="text-[10px] bg-green-500">
                      Ativo
                    </Badge>
                  )}
                </div>
                <p className="text-xs text-muted-foreground">{desc}</p>
              </div>
              
              <div className="flex items-center gap-2">
                {isEssential ? (
                  <span className="text-xs text-muted-foreground flex items-center gap-1">
                    <Info className="h-3 w-3" />
                    Obrigatório
                  </span>
                ) : (
                  <Switch
                    checked={isActive}
                    onCheckedChange={() => handleToggle(purpose)}
                    disabled={revoking === purpose}
                    aria-label={`Toggle ${label}`}
                  />
                )}
              </div>
            </div>
          );
        })}
        
        <div className="pt-4 border-t text-xs text-muted-foreground">
          <p>
            <strong>Seus direitos LGPD:</strong> Você pode solicitar acesso, 
            correção, portabilidade ou exclusão dos seus dados a qualquer momento.
            <br />
            Contato: <a href="mailto:privacidade@minhaamora.com.br" className="text-brand hover:underline">
              privacidade@minhaamora.com.br
            </a>
          </p>
        </div>
      </CardContent>
    </Card>
  );
}