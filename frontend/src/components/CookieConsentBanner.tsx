// src/components/CookieConsentBanner.tsx
import { useState, useEffect } from "react";
import { Button } from "./ui/button";

export function CookieConsentBanner() {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    // Só mostra se nunca aceitou e não está logado
    const accepted = localStorage.getItem("cookie_banner_accepted");
    if (!accepted) setVisible(true);
  }, []);

  const handleAccept = () => {
    localStorage.setItem("cookie_banner_accepted", "true");
    localStorage.setItem("cookie_banner_version", "v1.0_2026-05");
    
    // Opcional: Registrar anonimamente para auditoria
    const sessionId = localStorage.getItem("anonymous_session_id") || uuidv4();
    localStorage.setItem("anonymous_session_id", sessionId);
    
    // Chamada anônima (não quebra se falhar)
    fetch(`${import.meta.env.VITE_API_BASE_URL}/api/consent/`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        session_id: sessionId,
        version: "v1.0_2026-05",
        purposes: ["essential", "service_delivery"], // Apenas o básico
        accepted_at: new Date().toISOString()
      })
    }).catch(() => {});

    setVisible(false);
  };

  if (!visible) return null;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 bg-card border-t border-border shadow-lg">
      <div className="max-w-4xl mx-auto px-4 py-4 flex flex-col sm:flex-row items-center justify-between gap-4">
        <p className="text-sm text-muted-foreground">
          Usamos cookies essenciais para o funcionamento do sistema. 
          <a href="/privacidade" className="text-brand hover:underline ml-1">Saiba mais</a>
        </p>
        <Button onClick={handleAccept} size="sm" className="bg-brand hover:bg-brand/90">
          Aceitar e continuar
        </Button>
      </div>
    </div>
  );
}

function uuidv4(): string {
  throw new Error("Function not implemented.");
}
