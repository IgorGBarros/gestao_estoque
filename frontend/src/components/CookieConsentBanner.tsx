// src/components/CookieConsentBanner.tsx
import { useState, useEffect } from "react";
import { useConsent, PURPOSES, Purpose } from "../hooks/useConsent";
import { Button } from "./ui/button";
import { Checkbox } from "./ui/checkbox";
import { X } from "lucide-react";

export function CookieConsentBanner() {
  const { recordConsent, hasConsent } = useConsent();
  const [visible, setVisible] = useState(false);
  const [loading, setLoading] = useState(false);
  
  // Preferências do usuário
  const [preferences, setPreferences] = useState<Record<Purpose, boolean>>({
    [PURPOSES.ESSENTIAL]: true,      // Sempre true, não pode ser desmarcado
    [PURPOSES.AUTH]: true,           // Sempre true
    [PURPOSES.SERVICE]: true,        // Sempre true
    [PURPOSES.ANALYTICS]: false,
    [PURPOSES.MARKETING]: false,
    [PURPOSES.BEHAVIOR]: false,
    [PURPOSES.AI]: false,
  });

  // ✅ Verificar se já tem consentimento ao montar
  useEffect(() => {
    const checkConsent = async () => {
      // Se já tem consentimento para finalidades essenciais, esconde banner
      const hasEssential = hasConsent(PURPOSES.ESSENTIAL);
      
      // Também verifica localStorage para fallback
      const accepted = localStorage.getItem("cookie_consent_accepted");
      
      if (hasEssential || accepted === "true") {
        setVisible(false);
      } else {
        setVisible(true);
      }
    };
    
    // Só verifica após pequeno delay para evitar race condition
    const timer = setTimeout(checkConsent, 500);
    return () => clearTimeout(timer);
  }, [hasConsent]);

  // ✅ Handler para aceitar consentimento
  const handleAccept = async () => {
    setLoading(true);
    
    // Coletar finalidades aceitas
    const acceptedPurposes = (Object.entries(preferences) as [Purpose, boolean][])
      .filter(([_, accepted]) => accepted)
      .map(([purpose]) => purpose);
    
    try {
      // Registrar consentimento no backend
      const success = await recordConsent(acceptedPurposes);
      
      if (success) {
        // Marcar como aceito no localStorage (fallback)
        localStorage.setItem("cookie_consent_accepted", "true");
        localStorage.setItem("cookie_consent_version", "v1.0_2026-05");
        
        // Esconder banner
        setVisible(false);
        
        // Feedback visual
        console.log("✅ Consentimento registrado:", acceptedPurposes);
      }
    } catch (error) {
      console.error("❌ Erro ao registrar consentimento:", error);
    } finally {
      setLoading(false);
    }
  };

  // ✅ Handler para rejeitar (apenas finalidades essenciais)
  const handleReject = async () => {
    setLoading(true);
    
    try {
      // Registrar apenas finalidades essenciais
      const essential = [PURPOSES.ESSENTIAL, PURPOSES.AUTH, PURPOSES.SERVICE];
      const success = await recordConsent(essential as Purpose[]);
      
      if (success) {
        localStorage.setItem("cookie_consent_accepted", "true");
        localStorage.setItem("cookie_consent_version", "v1.0_2026-05");
        setVisible(false);
      }
    } catch (error) {
      console.error("❌ Erro ao registrar consentimento mínimo:", error);
    } finally {
      setLoading(false);
    }
  };

  const essentialPurposes: Purpose[] = [PURPOSES.ESSENTIAL, PURPOSES.AUTH, PURPOSES.SERVICE];

  // ✅ Toggle para preferências
  const togglePreference = (purpose: Purpose) => {
    // Não permite desmarcar finalidades essenciais
    if (essentialPurposes.includes(purpose)) {
      return;
    }
    
    setPreferences(prev => ({
      ...prev,
      [purpose]: !prev[purpose]
    }));
  };

  // ✅ Se não deve aparecer, retorna null
  if (!visible) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 bg-card border-t border-border shadow-lg">
      <div className="max-w-4xl mx-auto px-4 py-4 md:py-6">
        {/* Header */}
        <div className="flex items-start justify-between gap-4 mb-4">
          <div className="flex-1">
            <h3 className="font-semibold text-lg mb-1">🍪 Preferências de Cookies</h3>
            <p className="text-sm text-muted-foreground">
              Utilizamos cookies e dados para melhorar sua experiência, analisar o uso do sistema 
              e personalizar recursos. Você pode escolher quais finalidades aceitar.
              {" "}
              <a 
                href="/privacidade" 
                target="_blank" 
                rel="noopener noreferrer"
                className="text-brand hover:underline"
              >
                Saiba mais
              </a>
            </p>
          </div>
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setVisible(false)}
            className="shrink-0"
            disabled={loading}
          >
            <X className="h-4 w-4" />
          </Button>
        </div>

        {/* Preferências */}
        <div className="grid gap-3 mb-4">
          {/* Essenciais - sempre marcados */}
          <div className="flex items-start gap-3 p-3 rounded-lg bg-muted/50">
            <Checkbox 
              id={PURPOSES.ESSENTIAL} 
              checked={true} 
              disabled 
              className="mt-0.5"
            />
            <label htmlFor={PURPOSES.ESSENTIAL} className="text-sm leading-tight">
              <span className="font-medium">Funcionamento Essencial</span>
              <p className="text-muted-foreground text-xs">
                Necessário para autenticação, segurança e entrega do serviço. Não pode ser desativado.
              </p>
            </label>
          </div>

          {/* Analytics */}
          <div className="flex items-start gap-3 p-3 rounded-lg hover:bg-muted/30 transition-colors">
            <Checkbox 
              id={PURPOSES.ANALYTICS} 
              checked={preferences[PURPOSES.ANALYTICS]}
              onCheckedChange={() => togglePreference(PURPOSES.ANALYTICS)}
              className="mt-0.5"
              disabled={loading}
            />
            <label htmlFor={PURPOSES.ANALYTICS} className="text-sm leading-tight cursor-pointer">
              <span className="font-medium">Analytics e Melhorias</span>
              <p className="text-muted-foreground text-xs">
                Coleta de dados de uso anônimos para melhorar a experiência e corrigir problemas.
              </p>
            </label>
          </div>

          {/* Marketing */}
          <div className="flex items-start gap-3 p-3 rounded-lg hover:bg-muted/30 transition-colors">
            <Checkbox 
              id={PURPOSES.MARKETING} 
              checked={preferences[PURPOSES.MARKETING]}
              onCheckedChange={() => togglePreference(PURPOSES.MARKETING)}
              className="mt-0.5"
              disabled={loading}
            />
            <label htmlFor={PURPOSES.MARKETING} className="text-sm leading-tight cursor-pointer">
              <span className="font-medium">Comunicações Promocionais</span>
              <p className="text-muted-foreground text-xs">
                Receber ofertas, novidades e conteúdos relevantes sobre nossos produtos.
              </p>
            </label>
          </div>

          {/* IA/Comportamento */}
          <div className="flex items-start gap-3 p-3 rounded-lg hover:bg-muted/30 transition-colors">
            <Checkbox 
              id={PURPOSES.BEHAVIOR} 
              checked={preferences[PURPOSES.BEHAVIOR]}
              onCheckedChange={() => togglePreference(PURPOSES.BEHAVIOR)}
              className="mt-0.5"
              disabled={loading}
            />
            <label htmlFor={PURPOSES.BEHAVIOR} className="text-sm leading-tight cursor-pointer">
              <span className="font-medium">Insights com IA</span>
              <p className="text-muted-foreground text-xs">
                Padrões de uso anonimizados para treinar recursos de inteligência artificial.
              </p>
            </label>
          </div>
        </div>

        {/* Botões de ação */}
        <div className="flex flex-col sm:flex-row gap-3 justify-end">
          <Button
            variant="outline"
            onClick={handleReject}
            disabled={loading}
            className="w-full sm:w-auto"
          >
            Aceitar apenas o essencial
          </Button>
          <Button
            onClick={handleAccept}
            disabled={loading}
            className="w-full sm:w-auto bg-brand hover:bg-brand/90"
          >
            {loading ? "Salvando..." : "Aceitar selecionados"}
          </Button>
        </div>

        {/* Footer informativo */}
        <p className="text-xs text-muted-foreground mt-4 text-center">
          Você pode alterar suas preferências a qualquer momento em{" "}
          <a href="/profile" className="text-brand hover:underline">Configurações → Privacidade</a>.
          <br />
          Versão do termo: v1.0_2026-05
        </p>
      </div>
    </div>
  );
}