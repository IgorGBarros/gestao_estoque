// pages/Dashboard.tsx — VERSÃO ENXUTA
//
// A versão anterior tinha 24 indicadores (ROI Potencial, Giro de Estoque,
// Taxa de Conversão, Saúde Geral...), 68 cards e 8 gráficos. Nenhum deles
// respondia à pergunta que a consultora realmente faz: "e agora, o que faço?".
//
// Esta versão responde quatro perguntas, nessa ordem:
//   1. Quanto sobrou este mês?    → painel Meu Caixa (MEI)
//   2. O que precisa de atenção?  → produtos vencendo e acabando, COM NOME
//   3. O que devo repor?          → o que mais vende
//   4. Estou melhorando?          → comparação com o mês anterior
//
// Decisão importante: saíram os números "potenciais" (Lucro Potencial, Receita
// Potencial, ROI Potencial). Eles mostram dinheiro que ela AINDA NÃO TEM — o
// que ganharia se vendesse todo o estoque, coisa que nunca acontece. Exibidos
// ao lado do lucro real, criam otimismo falso e incentivam comprar mais
// estoque do que ela consegue vender.
//
// Os indicadores de gestão que saíram daqui foram para o admin-panel, onde
// servem para acompanhar a saúde de todas as consultoras.
import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import {
  AlertTriangle, Calendar, Package, TrendingUp, TrendingDown,
  Crown, Loader2, ChevronRight, Trophy,
} from "lucide-react";
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
} from "recharts";
import { api } from "../services/api";
import { useFeatureGates } from "../hooks/useFeatureGates";
import { useExpiryAlerts } from "../hooks/useExpiryAlerts";
import MeicashFlow from "../components/MeicashFlow";

const dinheiro = (v: number) =>
  (v || 0).toLocaleString("pt-BR", { style: "currency", currency: "BRL" });

interface TopProduct {
  name: string;
  total_sold: number;
  revenue: number;
}

interface LowStockAlert {
  id: number | string;
  product_name: string;
  current_stock: number;
}

interface MonthPoint {
  month_short: string;
  revenue: number;
}

export default function Dashboard() {
  const navigate = useNavigate();
  const { isLocked, loading: gatesLoading } = useFeatureGates();
  const bloqueado = !gatesLoading && isLocked("dashboard_charts");

  const { alerts: expiryAlerts } = useExpiryAlerts();

  const [topProdutos, setTopProdutos] = useState<TopProduct[]>([]);
  const [estoqueBaixo, setEstoqueBaixo] = useState<LowStockAlert[]>([]);
  const [meses, setMeses] = useState<MonthPoint[]>([]);
  const [itensVendidos, setItensVendidos] = useState(0);
  const [ticketMedio, setTicketMedio] = useState(0);
  const [lucro, setLucro] = useState(0);
  const [carregando, setCarregando] = useState(true);

  useEffect(() => {
    if (gatesLoading || bloqueado) return;

    api.get("/dashboard/overview/?period=30d")
      .then(({ data: d }) => {
        setTopProdutos(d?.charts?.top_products?.slice(0, 5) ?? []);
        setEstoqueBaixo(d?.alerts?.low_stock?.slice(0, 5) ?? []);
        // A API devolve do mês mais recente para o mais antigo.
        setMeses([...(d?.sales?.monthly_comparison ?? [])].reverse());
        setItensVendidos(d?.sales?.total_items_sold_30d ?? 0);
        setTicketMedio(d?.financial?.avg_ticket ?? 0);
        setLucro(d?.financial?.real_profit ?? 0);
      })
      .catch(() => { /* a tela ainda serve com o painel de caixa */ })
      .finally(() => setCarregando(false));
  }, [gatesLoading, bloqueado]);

  if (gatesLoading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-brand" />
      </div>
    );
  }

  if (bloqueado) {
    return (
      <div className="mx-auto max-w-md px-4 py-12 text-center">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl bg-brand/10">
          <Crown className="h-7 w-7 text-brand" />
        </div>
        <h1 className="font-display text-lg font-bold text-foreground">
          Relatórios são um recurso PRO
        </h1>
        <p className="mt-2 text-sm text-muted-foreground">
          Acompanhe seu lucro, o que mais vende e o que está para vencer.
        </p>
        <button
          onClick={() => navigate("/plans")}
          className="mt-6 w-full rounded-xl bg-brand py-3 text-sm font-bold text-white transition-opacity hover:opacity-90"
        >
          Ver planos
        </button>
      </div>
    );
  }

  // Vencendo: os mais urgentes primeiro
  const vencendo = [...expiryAlerts].sort((a, b) => a.daysLeft - b.daysLeft).slice(0, 5);
  const temAtencao = vencendo.length > 0 || estoqueBaixo.length > 0;

  // Comparação com o mês anterior
  const mesAtual = meses[meses.length - 1]?.revenue ?? 0;
  const mesAnterior = meses[meses.length - 2]?.revenue ?? 0;
  const variacao =
    mesAnterior > 0 ? ((mesAtual - mesAnterior) / mesAnterior) * 100 : null;

  return (
    <div className="mx-auto max-w-3xl space-y-8 p-4 sm:p-6">
      {/* 1. Quanto sobrou — painel do caixa (MEI) */}
      <MeicashFlow />

      {/* 2. O que precisa de atenção agora */}
      {temAtencao && (
        <section className="space-y-3">
          <h2 className="font-display text-base font-bold text-foreground">
            Precisa de atenção
          </h2>

          {vencendo.length > 0 && (
            <div className="overflow-hidden rounded-xl border border-amber-500/20 bg-amber-500/5">
              <div className="flex items-center gap-2 border-b border-amber-500/15 px-4 py-2.5">
                <Calendar className="h-4 w-4 shrink-0 text-amber-600" />
                <span className="text-sm font-semibold text-foreground">
                  Vencendo em breve
                </span>
              </div>
              <ul>
                {vencendo.map((a, i) => (
                  <li
                    key={`${a.product_name}-${i}`}
                    className="flex items-center justify-between gap-3 border-b border-amber-500/10 px-4 py-2.5 last:border-0"
                  >
                    <span className="min-w-0 flex-1 truncate text-sm text-foreground">
                      {a.product_name}
                    </span>
                    <span
                      className={`shrink-0 text-xs font-semibold ${
                        a.daysLeft <= 7 ? "text-destructive" : "text-amber-600"
                      }`}
                    >
                      {a.daysLeft <= 0
                        ? "vencido"
                        : a.daysLeft === 1
                        ? "vence amanhã"
                        : `${a.daysLeft} dias`}
                    </span>
                  </li>
                ))}
              </ul>
              <button
                onClick={() => navigate("/products")}
                className="flex w-full items-center justify-center gap-1 py-2.5 text-xs font-medium text-amber-700 transition-colors hover:bg-amber-500/10"
              >
                Ver no estoque <ChevronRight className="h-3 w-3" />
              </button>
            </div>
          )}

          {estoqueBaixo.length > 0 && (
            <div className="overflow-hidden rounded-xl border border-rose-500/20 bg-rose-500/5">
              <div className="flex items-center gap-2 border-b border-rose-500/15 px-4 py-2.5">
                <AlertTriangle className="h-4 w-4 shrink-0 text-rose-600" />
                <span className="text-sm font-semibold text-foreground">
                  Acabando
                </span>
              </div>
              <ul>
                {estoqueBaixo.map((item) => (
                  <li
                    key={item.id}
                    className="flex items-center justify-between gap-3 border-b border-rose-500/10 px-4 py-2.5 last:border-0"
                  >
                    <span className="min-w-0 flex-1 truncate text-sm text-foreground">
                      {item.product_name}
                    </span>
                    <span className="shrink-0 text-xs font-semibold text-rose-600">
                      {item.current_stock === 0
                        ? "acabou"
                        : `restam ${item.current_stock}`}
                    </span>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </section>
      )}

      {/* 3. O que mais vende — para saber o que repor */}
      <section className="space-y-3">
        <h2 className="font-display text-base font-bold text-foreground">
          Seus campeões de venda
        </h2>
        <p className="-mt-1 text-xs text-muted-foreground">Últimos 30 dias</p>

        {carregando ? (
          <div className="flex justify-center py-8">
            <Loader2 className="h-5 w-5 animate-spin text-brand" />
          </div>
        ) : topProdutos.length === 0 ? (
          <div className="rounded-xl border border-border bg-card px-4 py-8 text-center">
            <Package className="mx-auto mb-2 h-6 w-6 text-muted-foreground" />
            <p className="text-sm text-muted-foreground">
              Nenhuma venda registrada ainda.
            </p>
          </div>
        ) : (
          <ul className="overflow-hidden rounded-xl border border-border bg-card">
            {topProdutos.map((p, i) => (
              <li
                key={p.name}
                className="flex items-center gap-3 border-b border-border px-4 py-3 last:border-0"
              >
                <span
                  className={`flex h-6 w-6 shrink-0 items-center justify-center rounded-full text-xs font-bold ${
                    i === 0
                      ? "bg-amber-500/15 text-amber-600"
                      : "bg-muted text-muted-foreground"
                  }`}
                >
                  {i === 0 ? <Trophy className="h-3 w-3" /> : i + 1}
                </span>
                <span className="min-w-0 flex-1 truncate text-sm text-foreground">
                  {p.name}
                </span>
                <span className="shrink-0 text-right">
                  <span className="block text-sm font-semibold text-foreground">
                    {p.total_sold} un
                  </span>
                  <span className="block text-[11px] text-muted-foreground">
                    {dinheiro(p.revenue)}
                  </span>
                </span>
              </li>
            ))}
          </ul>
        )}
      </section>

      {/* 4. Estou melhorando? */}
      {meses.length > 1 && (
        <section className="space-y-3">
          <h2 className="font-display text-base font-bold text-foreground">
            Como você vem indo
          </h2>

          {variacao !== null && (
            <div className="flex items-center gap-2 rounded-xl border border-border bg-card px-4 py-3">
              {variacao >= 0 ? (
                <TrendingUp className="h-4 w-4 shrink-0 text-emerald-600" />
              ) : (
                <TrendingDown className="h-4 w-4 shrink-0 text-rose-600" />
              )}
              <p className="text-sm text-foreground">
                Você vendeu{" "}
                <strong className={variacao >= 0 ? "text-emerald-600" : "text-rose-600"}>
                  {Math.abs(variacao).toFixed(0)}% {variacao >= 0 ? "a mais" : "a menos"}
                </strong>{" "}
                que no mês passado.
              </p>
            </div>
          )}

          <div className="rounded-xl border border-border bg-card p-4">
            <ResponsiveContainer width="100%" height={180}>
              <BarChart data={meses}>
                <CartesianGrid strokeDasharray="3 3" vertical={false} opacity={0.3} />
                <XAxis dataKey="month_short" tick={{ fontSize: 11 }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 11 }} axisLine={false} tickLine={false} width={48} />
                <Tooltip
                  formatter={(v: number) => [dinheiro(v), "Vendas"]}
                  contentStyle={{ borderRadius: 8, fontSize: 12 }}
                />
                <Bar dataKey="revenue" fill="hsl(var(--brand))" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>

          {/* Os três números que ela entende sem explicação */}
          <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
            <div className="rounded-xl border border-border bg-card p-4">
              <p className="text-xs text-muted-foreground">Você lucrou</p>
              <p className="mt-1 text-lg font-bold text-emerald-600">{dinheiro(lucro)}</p>
            </div>
            <div className="rounded-xl border border-border bg-card p-4">
              <p className="text-xs text-muted-foreground">Produtos vendidos</p>
              <p className="mt-1 text-lg font-bold text-foreground">{itensVendidos}</p>
            </div>
            <div className="rounded-xl border border-border bg-card p-4">
              <p className="text-xs text-muted-foreground">Cada venda rende</p>
              <p className="mt-1 text-lg font-bold text-foreground">{dinheiro(ticketMedio)}</p>
            </div>
          </div>
        </section>
      )}
    </div>
  );
}
