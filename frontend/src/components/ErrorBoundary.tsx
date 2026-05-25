// src/components/ErrorBoundary.tsx
import React, { Component, ErrorInfo, ReactNode } from "react";

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
  errorInfo: ErrorInfo | null;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = {
      hasError: false,
      error: null,
      errorInfo: null,
    };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error, errorInfo: null };
  }

 // src/components/ErrorBoundary.tsx
// src/components/ErrorBoundary.tsx - ATUALIZAR componentDidCatch
componentDidCatch(error: Error, errorInfo: ErrorInfo) {
  console.error("🚨 ERRO CAPTURADO:", {
    message: error.message || '(mensagem vazia)',
    name: error.name,
    stack: error.stack?.split('\n').slice(0, 15),
    componentStack: errorInfo.componentStack,
    timestamp: new Date().toISOString()
  });
  
  // Tentar identificar o componente problemático
  const lines = errorInfo.componentStack?.split('\n') || [];
  const suspiciousComponents = lines
    .filter(line => line.includes('at '))
    .slice(0, 5)
    .map(line => line.trim());
  
  console.error("🎯 Componentes suspeitos:", suspiciousComponents);
  
  // Verificar se é erro de hook
  if (error.message.includes('Hook') || error.message.includes('render')) {
    console.error("⚠️ Possível violação de regras de Hooks!");
  }
  
  // Verificar se é erro de contexto
  if (error.message.includes('Context') || error.message.includes('Provider')) {
    console.error("⚠️ Possível erro de Context/Provider!");
  }
  
  this.setState({ error, errorInfo });
}

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }
      
      return (
        <div className="min-h-screen flex items-center justify-center bg-background p-4">
          <div className="max-w-md w-full bg-card rounded-lg shadow-lg p-6 border border-border">
            <h2 className="text-xl font-bold text-destructive mb-4">
              ⚠️ Algo deu errado
            </h2>
            <p className="text-sm text-muted-foreground mb-4">
              {this.state.error?.message || "Erro desconhecido"}
            </p>
            <details className="text-xs text-muted-foreground whitespace-pre-wrap max-h-60 overflow-auto">
              <summary className="cursor-pointer font-medium mb-2">
                Detalhes técnicos (clique para expandir)
              </summary>
              <p>{this.state.error?.stack}</p>
              <p className="mt-2">{this.state.errorInfo?.componentStack}</p>
            </details>
            <button
              onClick={() => window.location.reload()}
              className="mt-4 w-full bg-primary text-primary-foreground py-2 rounded-lg font-medium hover:opacity-90"
            >
              Recarregar página
            </button>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}