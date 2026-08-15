// components/NoveltyCarouselModal.tsx
//
// Substitui a faixa fina de promoção (cor crua vinda do admin, conflitava
// com a marca) por um carrossel num modal só — combina promoções ativas
// e novidades da Central de Ajuda no mesmo lugar. Aparece sozinho alguns
// minutos depois de a pessoa começar a usar (não no instante do login,
// pra não competir com o carregamento inicial da tela), no máximo 1 vez
// por dia — sem virar irritante repetindo toda hora que ela navega.
import { useState, useEffect, useCallback } from "react";
import { X, Sparkles, Newspaper, ChevronLeft, ChevronRight } from "lucide-react";
import { api } from "../services/api";
import { promotionTrackingApi } from "../lib/api";
import { useAuth } from "../hooks/useAuth";

const ESPERA_MS = 2 * 60 * 1000; // 2 minutos
const ULTIMA_EXIBICAO_KEY = "novidades_carrossel_ultima_exibicao";
const JANELA_REPETICAO_MS = 24 * 60 * 60 * 1000; // 1x por dia, no máximo

interface CartaoPromocao {
  tipo: "promocao";
  id: string;
  titulo: string;
  mensagem: string;
  desconto: string | null;
}

interface CartaoNovidade {
  tipo: "novidade";
  id: string;
  titulo: string;
  mensagem: string;
}

type Cartao = CartaoPromocao | CartaoNovidade;

export function NoveltyCarouselModal() {
  const { isAuthenticated } = useAuth();
  const [cartoes, setCartoes] = useState<Cartao[]>([]);
  const [indice, setIndice] = useState(0);
  const [aberto, setAberto] = useState(false);

  useEffect(() => {
    // ⚠️ Este componente mora no nível mais alto do App (junto do
    // TrialExpiredListener), não dentro de ProtectedLayout — senão o
    // timer de 2 minutos resetaria a cada troca de página. Só que isso
    // também o renderiza pra visitante não-logado (landing page); sem
    // esta checagem, tentaria buscar promoção/novidade sem sessão.
    if (!isAuthenticated) return;

    const ultima = Number(localStorage.getItem(ULTIMA_EXIBICAO_KEY) || 0);
    if (Date.now() - ultima < JANELA_REPETICAO_MS) return; // já mostrou hoje

    const timer = setTimeout(async () => {
      try {
        const [resPromo, resNovidades] = await Promise.all([
          api.get("promotions/active/").catch(() => ({ data: [] })),
          api.get("ajuda/?tipo=novidade").catch(() => ({ data: [] })),
        ]);

        const promos: Cartao[] = (resPromo.data || []).map((p: any) => ({
          tipo: "promocao" as const,
          id: p.id,
          titulo: p.title,
          mensagem: p.message,
          desconto:
            p.discount_percent > 0
              ? `${p.discount_percent}% OFF`
              : p.discount_amount > 0
              ? `R$ ${Number(p.discount_amount).toFixed(2)} OFF`
              : null,
        }));

        // Novidades mais recentes primeiro (ordem já vem crescente do
        // backend por "ordem"; aqui só limita pra não virar um carrossel
        // enorme — 3 novidades mais os cartões de promoção já bastam).
        const novidades: Cartao[] = (resNovidades.data || [])
          .slice(0, 3)
          .map((n: any) => ({
            tipo: "novidade" as const,
            id: String(n.id),
            titulo: n.titulo,
            mensagem: n.corpo?.length > 140 ? n.corpo.slice(0, 140) + "…" : n.corpo,
          }));

        const todosCartoes = [...promos, ...novidades];
        if (todosCartoes.length === 0) return;

        setCartoes(todosCartoes);
        setAberto(true);
        localStorage.setItem(ULTIMA_EXIBICAO_KEY, String(Date.now()));

        // Mesmo registro de visualização que a faixa antiga fazia —
        // conta pra métrica de "Visualizações" no admin-panel.
        promos.forEach((p) => promotionTrackingApi.registerView(p.id).catch(() => {}));
      } catch {
        /* sem promoção/novidade, ou erro de rede — não interrompe nada */
      }
    }, ESPERA_MS);

    return () => clearTimeout(timer);
  }, [isAuthenticated]);

  const proximo = useCallback(() => setIndice((i) => (i + 1) % cartoes.length), [cartoes.length]);
  const anterior = useCallback(() => setIndice((i) => (i - 1 + cartoes.length) % cartoes.length), [cartoes.length]);

  if (!aberto || cartoes.length === 0) return null;
  const cartao = cartoes[indice];

  return (
    <div className="fixed inset-0 z-[150] flex items-center justify-center bg-black/50 p-4">
      <div className="relative w-full max-w-sm overflow-hidden rounded-2xl bg-card shadow-2xl">
        <button
          onClick={() => setAberto(false)}
          className="absolute right-3 top-3 z-10 rounded-lg bg-black/10 p-1.5 text-white hover:bg-black/20"
        >
          <X className="h-4 w-4" />
        </button>

        {/* Cabeçalho com a paleta da marca, não a cor crua da promoção —
            era isso que deixava a faixa antiga com aparência conflitante. */}
        <div className="bg-gradient-to-br from-brand to-brand-hover px-5 pb-8 pt-6 text-white">
          <div className="flex items-center gap-2 text-xs font-medium uppercase tracking-wide opacity-90">
            {cartao.tipo === "promocao" ? <Sparkles className="h-3.5 w-3.5" /> : <Newspaper className="h-3.5 w-3.5" />}
            {cartao.tipo === "promocao" ? "Promoção" : "Novidade"}
          </div>
          <p className="mt-2 font-display text-lg font-bold">{cartao.titulo}</p>
          {cartao.tipo === "promocao" && cartao.desconto && (
            <span className="mt-1 inline-block rounded-full bg-white/20 px-2.5 py-0.5 text-xs font-bold">
              {cartao.desconto}
            </span>
          )}
        </div>

        <div className="px-5 py-4">
          <p className="text-sm leading-relaxed text-foreground">{cartao.mensagem}</p>

          {cartoes.length > 1 && (
            <div className="mt-4 flex items-center justify-between">
              <button onClick={anterior} className="rounded-lg p-1.5 text-muted-foreground hover:bg-secondary">
                <ChevronLeft className="h-4 w-4" />
              </button>
              <div className="flex gap-1.5">
                {cartoes.map((_, i) => (
                  <span
                    key={i}
                    className={`h-1.5 rounded-full transition-all ${i === indice ? "w-4 bg-brand" : "w-1.5 bg-border"}`}
                  />
                ))}
              </div>
              <button onClick={proximo} className="rounded-lg p-1.5 text-muted-foreground hover:bg-secondary">
                <ChevronRight className="h-4 w-4" />
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
