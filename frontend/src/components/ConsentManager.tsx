// src/components/ConsentManager.tsx
import { useState } from "react";
import { useConsent, PURPOSES, Purpose, LGPD_VERSION } from "../hooks/useConsent";
import { useToast } from "../hooks/use-toast";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Switch } from "./ui/switch";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "./ui/card";
import { Shield, Info, AlertCircle } from "lucide-react";

// ✅ CONSTANTE: Lista explícita de finalidades (mais seguro que Object.values)
const ALL_PURPOSES: Purpose[] = [
  PURPOSES.ESSENTIAL,
  PURPOSES.AUTH,
  PURPOSES.SERVICE,
  PURPOSES.ANALYTICS,
  PURPOSES.MARKETING,
  PURPOSES.BEHAVIOR,
  PURPOSES.AI,
] as const;

// ✅ LABELS: Mapeamento completo com tipagem segura
const PURPOSE_LABELS: Record<Purpose, { label: string; desc: string; icon?: string }> = {
  [PURPOSES.ESSENTIAL]: {
    label: "Funcionamento Essencial",
    desc: "Necessário para autenticação, segurança e entrega do serviço contratado.",
    icon: "🔒",
  },
  [PURPOSES.AUTH]: {
    label: "Autenticação e Conta",
    desc: "Gerenciamento da sua conta, login e recuperação de acesso.",
    icon: "👤",
  },
  [PURPOSES.SERVICE]: {
    label: "Entrega do Serviço",
    desc: "Processamento de pedidos, estoque e funcionalidades principais do app.",
    icon: "📦",
  },
  [PURPOSES.ANALYTICS]: {
    label: "Analytics e Melhorias",
    desc: "Coleta de dados de uso anônimos para melhorar a experiência do aplicativo.",
    icon: "📊",
  },
  [PURPOSES.MARKETING]: {
    label: "Comunicações Promocionais",
    desc: "Receber ofertas, novidades e conteúdos relevantes sobre nossos produtos.",
    icon: "📢",
  },
  [PURPOSES.BEHAVIOR]: {
    label: "Comportamento para IA",
    desc: "Padrões de uso anonimizados para treinar recursos de inteligência artificial.",
    icon: "🤖",
  },
  [PURPOSES.AI]: {
    label: "Recursos de IA",
    desc: "Habilitar assistente virtual, recomendações personalizadas e automações inteligentes.",
    icon: "✨",
  },
};

// ✅ CONFIG: Dados institucionais centralizados
const LGPD_CONFIG = {
  version: LGPD_VERSION,
  dpoEmail: "privacidade@minhaamora.com.br",
  rights: [
    "Confirmação da existência de tratamento",
    "Acesso aos dados armazenados",
    "Correção de dados incompletos",
    "Anonimização ou eliminação de dados",
    "Portabilidade dos dados",
    "Revogação do consentimento",
  ],
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
  const [error, setError] = useState<string | null>(null);

  // ✅ HANDLE TOGGLE: Com tratamento de erro explícito
  const handleToggle = async (purpose: Purpose) => {
    // Não permite alterar finalidades essenciais
    if (essentialPurposes.includes(purpose)) {
      toast?.({
        title: "⚠️ Não é possível alterar",
        description: "Esta finalidade é essencial para o funcionamento do sistema.",
        variant: "default",
      });
      return;
    }
    
    setError(null);
    setRevoking(purpose);
    
    try {
      const success = await revokeConsent(purpose);
      if (success) {
        await refresh();
        toast?.({
          title: "✅ Preferência atualizada",
          description: `Você não receberá mais tratamentos para "${PURPOSE_LABELS[purpose].label}".`,
        });
      } else {
        setError("Não foi possível atualizar sua preferência. Tente novamente.");
      }
    } catch (err) {
      console.error("Erro ao revogar consentimento:", err);
      setError("Ocorreu um erro ao processar sua solicitação.");
    } finally {
      setRevoking(null);
    }
  };

  // ✅ LOADING STATE
  if (loading) {
    return (
      <Card>
        <CardContent className="p-6 text-center text-muted-foreground">
          <div className="flex items-center justify-center gap-2">
            <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-primary" />
            Carregando preferências de privacidade...
          </div>
        </CardContent>
      </Card>
    );
  }

  // ✅ ERROR STATE
  if (error) {
    return (
      <Card className="border-destructive/50">
        <CardContent className="p-6">
          <div className="flex items-start gap-3 text-destructive">
            <AlertCircle className="h-5 w-5 mt-0.5" />
            <div>
              <p className="font-medium">Erro ao carregar preferências</p>
              <p className="text-sm text-muted-foreground">{error}</p>
              <Button 
                variant="outline" 
                size="sm" 
                className="mt-3"
                onClick={() => refresh()}
              >
                Tentar novamente
              </Button>
            </div>
          </div>
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
            Versão do termo: {LGPD_CONFIG.version}
          </span>
        </CardDescription>
      </CardHeader>
      
      <CardContent className="space-y-4">
        {/* ✅ MAPEAMENTO SEGURO com ALL_PURPOSES */}
        {ALL_PURPOSES.map((purpose) => {
          const isActive = hasConsent(purpose);
          const isEssential = essentialPurposes.includes(purpose);
          const isRevocable = revocablePurposes.includes(purpose);
          const { label, desc, icon } = PURPOSE_LABELS[purpose];
          
          return (
            <div 
              key={purpose}
              className={`flex items-start justify-between gap-4 p-4 border rounded-lg transition-colors ${
                isEssential ? "bg-muted/30" : "hover:bg-muted/20"
              }`}
            >
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 mb-1">
                  {icon && <span className="text-sm" aria-hidden="true">{icon}</span>}
                  <span className="font-medium text-sm">{label}</span>
                  {isEssential && (
                    <Badge variant="secondary" className="text-[10px]">
                      Essencial
                    </Badge>
                  )}
                  {isActive && !isEssential && (
                    <Badge variant="default" className="text-[10px] bg-green-500 hover:bg-green-600">
                      Ativo
                    </Badge>
                  )}
                </div>
                <p className="text-xs text-muted-foreground">{desc}</p>
              </div>
              
              <div className="flex items-center gap-2">
                {isEssential ? (
                  <span 
                    className="text-xs text-muted-foreground flex items-center gap-1"
                    title="Esta finalidade é obrigatória e não pode ser desativada"
                  >
                    <Info className="h-3 w-3" />
                    Obrigatório
                  </span>
                ) : (
                  <Switch
                    checked={isActive}
                    onCheckedChange={() => handleToggle(purpose)}
                    disabled={revoking === purpose || loading}
                    aria-label={`Alternar consentimento para ${label}`}
                    aria-describedby={`${purpose}-description`}
                    id={`${purpose}-toggle`}
                  />
                )}
              </div>
            </div>
          );
        })}
        
        {/* ✅ RODAPÉ COM DIREITOS LGPD */}
        <div className="pt-4 border-t text-xs text-muted-foreground space-y-2">
          <p>
            <strong>Seus direitos LGPD (Art. 18):</strong>
          </p>
          <ul className="list-disc list-inside space-y-0.5 ml-1">
            {LGPD_CONFIG.rights.map((right, i) => (
              <li key={i}>{right}</li>
            ))}
          </ul>
          <p className="mt-2">
            Para exercer seus direitos:{" "}
            <a 
              href={`mailto:${LGPD_CONFIG.dpoEmail}`} 
              className="text-brand hover:underline font-medium"
            >
              {LGPD_CONFIG.dpoEmail}
            </a>
          </p>
        </div>
      </CardContent>
    </Card>
  );
}