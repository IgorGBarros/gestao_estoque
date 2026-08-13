// components/OnboardingTour.tsx
//
// Tour interativo de primeiros passos — destaca elementos reais da tela
// (marcados com data-tour="id" em Index.tsx) com um "spotlight" (recorte
// no overlay escuro), e um cartão com explicação + navegação. Some
// sozinho quando termina ou quando a pessoa clica "Pular", e marca
// onboarding_completed=true no perfil pra não aparecer de novo sozinho —
// mas pode ser revisto a qualquer momento pela Central de Ajuda.
import React, { useEffect, useState, useCallback } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, ChevronRight, ChevronLeft } from "lucide-react";

export interface TourStep {
  target: string; // valor do data-tour do elemento a destacar
  title: string;
  description: string;
}

interface Rect {
  top: number;
  left: number;
  width: number;
  height: number;
}

const PADDING = 8; // respiro ao redor do elemento destacado

export const ONBOARDING_STEPS: TourStep[] = [
  {
    target: "cadastrar",
    title: "Cadastrar produto",
    description: "Escaneie o código de barras pra cadastrar rápido — nome, preço e foto costumam vir preenchidos sozinhos.",
  },
  {
    target: "baixa",
    title: "Baixa",
    description: "Toda vez que vender algo, registre aqui. O estoque desconta sozinho do lote certo (o que vence primeiro).",
  },
  {
    target: "estoque",
    title: "Meu Estoque",
    description: "Veja tudo que você tem cadastrado, quantidade e validade de cada lote, num lugar só.",
  },
  {
    target: "dashboard",
    title: "Dashboard",
    description: "Aqui você vê seu lucro de verdade — já descontando o custo de cada produto, não só o total vendido.",
  },
  {
    target: "vitrine",
    title: "Vitrine",
    description: "Sua loja online. Compartilhe o link no WhatsApp pra suas clientes verem o catálogo e fazerem pedido.",
  },
  {
    target: "crm",
    title: "Meus Clientes",
    description: "Histórico de compra de cada cliente, incluindo fiado (venda a prazo) — nunca perde o controle de quem deve.",
  },
  {
    target: "notificacoes",
    title: "Notificações",
    description: "Avisa sozinho quando um produto está perto de vencer, quando bate uma meta de venda, ou quando o suporte responde.",
  },
];

interface Props {
  steps?: TourStep[];
  onFinish: () => void;
}

export const OnboardingTour: React.FC<Props> = ({ steps = ONBOARDING_STEPS, onFinish }) => {
  const [stepIndex, setStepIndex] = useState(0);
  const [rect, setRect] = useState<Rect | null>(null);

  const step = steps[stepIndex];
  const isLast = stepIndex === steps.length - 1;

  const medirAlvo = useCallback(() => {
    const el = document.querySelector<HTMLElement>(`[data-tour="${step?.target}"]`);
    if (!el) {
      setRect(null);
      return;
    }
    el.scrollIntoView({ behavior: "smooth", block: "center" });
    // Espera o scroll assentar antes de medir a posição de verdade.
    setTimeout(() => {
      const r = el.getBoundingClientRect();
      setRect({ top: r.top, left: r.left, width: r.width, height: r.height });
    }, 300);
  }, [step]);

  useEffect(() => {
    medirAlvo();
    window.addEventListener("resize", medirAlvo);
    return () => window.removeEventListener("resize", medirAlvo);
  }, [medirAlvo]);

  // ⚠️ Se o elemento-alvo não existir na tela (ex: passo desatualizado
  // depois de uma mudança de layout), pula esse passo automaticamente em
  // vez de travar o tour mostrando só um overlay sem nada destacado.
  useEffect(() => {
    if (rect === null) {
      const el = document.querySelector(`[data-tour="${step?.target}"]`);
      if (!el && stepIndex < steps.length - 1) {
        const timer = setTimeout(() => setStepIndex((i) => i + 1), 50);
        return () => clearTimeout(timer);
      }
    }
  }, [rect, step, stepIndex, steps.length]);

  const avancar = () => {
    if (isLast) onFinish();
    else setStepIndex((i) => i + 1);
  };
  const voltar = () => setStepIndex((i) => Math.max(0, i - 1));

  if (!step) return null;

  // Posição do cartão — abaixo do elemento por padrão, acima se não
  // couber (perto do fim da tela).
  const espacoAbaixo = rect ? window.innerHeight - (rect.top + rect.height) : 999;
  const cardAcima = espacoAbaixo < 220;
  const cardTop = rect ? (cardAcima ? rect.top - PADDING : rect.top + rect.height + PADDING + 12) : window.innerHeight / 2;
  const cardLeft = rect ? Math.min(Math.max(rect.left, 16), window.innerWidth - 336) : 16;

  return (
    <div className="fixed inset-0 z-[100]">
      {/* Overlay escuro com "buraco" recortado no elemento destacado —
          técnica de máscara SVG, funciona com qualquer formato de canto
          arredondado sem precisar de clip-path complicado. */}
      <svg className="pointer-events-none absolute inset-0 h-full w-full">
        <defs>
          <mask id="spotlight-mask">
            <rect x="0" y="0" width="100%" height="100%" fill="white" />
            {rect && (
              <rect
                x={rect.left - PADDING}
                y={rect.top - PADDING}
                width={rect.width + PADDING * 2}
                height={rect.height + PADDING * 2}
                rx="12"
                fill="black"
              />
            )}
          </mask>
        </defs>
        <rect x="0" y="0" width="100%" height="100%" fill="black" opacity="0.6" mask="url(#spotlight-mask)" />
      </svg>

      {rect && (
        <div
          className="pointer-events-none absolute rounded-xl ring-2 ring-brand transition-all duration-300"
          style={{ top: rect.top - PADDING, left: rect.left - PADDING, width: rect.width + PADDING * 2, height: rect.height + PADDING * 2 }}
        />
      )}

      {/* Cartão de explicação + navegação */}
      <AnimatePresence mode="wait">
        <motion.div
          key={stepIndex}
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0 }}
          className="absolute w-[320px] rounded-2xl border border-brand/20 bg-card p-4 shadow-2xl"
          style={{ top: cardTop, left: cardLeft, transform: cardAcima ? "translateY(-100%)" : undefined }}
        >
          <div className="mb-2 flex items-center justify-between">
            <span className="text-xs font-medium text-muted-foreground">{stepIndex + 1} de {steps.length}</span>
            <button onClick={onFinish} className="rounded-lg p-1 text-muted-foreground hover:bg-secondary" title="Pular tour">
              <X className="h-4 w-4" />
            </button>
          </div>
          <p className="font-display text-base font-bold text-foreground">{step.title}</p>
          <p className="mt-1 text-sm text-muted-foreground">{step.description}</p>

          <div className="mt-4 flex items-center justify-between">
            <button onClick={onFinish} className="text-xs font-medium text-muted-foreground hover:text-foreground">
              Pular
            </button>
            <div className="flex items-center gap-2">
              {stepIndex > 0 && (
                <button onClick={voltar} className="flex h-8 w-8 items-center justify-center rounded-lg border border-border hover:bg-secondary">
                  <ChevronLeft className="h-4 w-4" />
                </button>
              )}
              <button onClick={avancar} className="flex items-center gap-1 rounded-lg bg-brand px-3 py-1.5 text-sm font-medium text-white hover:opacity-90">
                {isLast ? "Concluir" : "Próximo"}
                {!isLast && <ChevronRight className="h-4 w-4" />}
              </button>
            </div>
          </div>
        </motion.div>
      </AnimatePresence>
    </div>
  );
};
