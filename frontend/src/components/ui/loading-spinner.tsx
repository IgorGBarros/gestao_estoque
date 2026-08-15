// components/ui/loading-spinner.tsx
//
// Componente único de loading — antes existiam 14 variações diferentes
// de tamanho/cor/ordem de classe do mesmo <Loader2 animate-spin /> em 38
// arquivos, sem nenhum padrão. Três tamanhos cobrem os casos reais do
// sistema: inline (dentro de botão, ao lado de texto), page (tela cheia
// esperando dado carregar) e small (indicador pequeno, tipo dentro de um
// card ou badge).
import { Loader2 } from "lucide-react";

export type LoadingSpinnerSize = "sm" | "inline" | "page";

const TAMANHOS: Record<LoadingSpinnerSize, string> = {
  sm: "h-3.5 w-3.5",
  inline: "h-4 w-4",
  page: "h-8 w-8",
};

interface LoadingSpinnerProps {
  /** @default "inline" — o tamanho mais comum, usado dentro de botão/linha de texto. */
  size?: LoadingSpinnerSize;
  /**
   * Cor do ícone. "inherit" (padrão) deixa herdar a cor do texto ao redor
   * — certo pra spinner dentro de botão colorido. "brand" força a cor da
   * marca — certo pra tela cheia, onde não há texto ao redor pra herdar.
   */
  color?: "inherit" | "brand" | "muted";
  className?: string;
}

export function LoadingSpinner({ size = "inline", color = "inherit", className = "" }: LoadingSpinnerProps) {
  const corClasse = color === "brand" ? "text-brand" : color === "muted" ? "text-muted-foreground" : "";
  return <Loader2 className={`animate-spin ${TAMANHOS[size]} ${corClasse} ${className}`.trim()} />;
}

/**
 * Tela cheia centralizada — pro caso mais comum de "página inteira
 * esperando carregar" (antes, cada tela reinventava essa div wrapper
 * na mão, com espaçamento e cor diferentes cada vez).
 */
export function LoadingPage({ label }: { label?: string }) {
  return (
    <div className="flex min-h-[50vh] flex-col items-center justify-center gap-3">
      <LoadingSpinner size="page" color="brand" />
      {label && <p className="text-sm text-muted-foreground">{label}</p>}
    </div>
  );
}
