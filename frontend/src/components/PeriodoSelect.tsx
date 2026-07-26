// components/PeriodoSelect.tsx
// Seletor de período usado nos Relatórios e no painel do MEI.
//
// Dropdown em vez de botões: são poucas opções, mas ocupam menos espaço na
// tela do celular e o rótulo escolhido fica sempre visível — com botões, a
// consultora precisa procurar qual está destacado.
import { Calendar, ChevronDown } from "lucide-react";
import type { PeriodoRelatorio } from "../lib/api";

export const OPCOES_PERIODO: { valor: PeriodoRelatorio; rotulo: string }[] = [
  { valor: "30d", rotulo: "Últimos 30 dias" },
  { valor: "60d", rotulo: "Últimos 60 dias" },
  { valor: "90d", rotulo: "Últimos 90 dias" },
];

interface Props {
  valor: PeriodoRelatorio;
  onChange: (v: PeriodoRelatorio) => void;
  /** Versão reduzida, para caber ao lado de um título. */
  compacto?: boolean;
}

export default function PeriodoSelect({ valor, onChange, compacto }: Props) {
  return (
    <div
      className={`relative flex items-center gap-2 rounded-lg border border-border bg-card ${
        compacto ? "px-2.5 py-1.5" : "px-3 py-2"
      }`}
    >
      <Calendar className={`shrink-0 text-muted-foreground ${compacto ? "h-3.5 w-3.5" : "h-4 w-4"}`} />
      <select
        value={valor}
        onChange={(e) => onChange(e.target.value as PeriodoRelatorio)}
        aria-label="Período do relatório"
        className={`w-full cursor-pointer appearance-none bg-transparent pr-5 font-medium text-foreground outline-none ${
          compacto ? "text-[11px]" : "text-sm"
        }`}
      >
        {OPCOES_PERIODO.map((o) => (
          <option key={o.valor} value={o.valor}>
            {o.rotulo}
          </option>
        ))}
      </select>
      <ChevronDown
        className={`pointer-events-none absolute right-2 shrink-0 text-muted-foreground ${
          compacto ? "h-3 w-3" : "h-3.5 w-3.5"
        }`}
      />
    </div>
  );
}