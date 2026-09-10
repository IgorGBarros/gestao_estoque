// src/components/admin/AdminGrowthTab.tsx
import { useState, useEffect } from "react";
import { TrendingUp, TrendingDown, Users, AlertTriangle, RefreshCw, Target, BarChart3, Zap, GitBranch } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { adminApi } from "../../lib/api";
import { LoadingSpinner } from "../ui/loading-spinner";

interface Props {
  toast: (o: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}
interface GrowthData {
  north_star: { valor: number; anterior: number; variacao: number };
  funil: { total: number; em_trial: number; ativadas: number; pagantes: number; novos_30d: number; ativados_30d: number; pagantes_30d: number; activation_rate: number; trial_conversion: number };
  churn_risk: { store_id: number; email: string; score: number; nivel: string; vendas_30d: number; dias_sem_login: number }[];
  canais: { canal: string; total: number; pagantes: number; conversao: number }[];
  indicacoes: { total: number; ultimos_30d: number };
}

function Badge({ nivel }: { nivel: string }) {
  const cls = nivel === 'CRITICAL' ? 'bg-red-100 text-red-700 border-red-200'
    : nivel === 'HIGH' ? 'bg-amber-100 text-amber-700 border-amber-200'
    : 'bg-yellow-100 text-yellow-700 border-yellow-200';
  return <span className={`rounded-full border px-2 py-0.5 text-[10px] font-bold ${cls}`}>{nivel}</span>;
}

function Taxa({ label, val, meta }: { label: string; val: number; meta: number }) {
  const ok = val >= meta;
  return (
    <div className={`rounded-lg border p-3 ${ok ? 'border-emerald-200 bg-emerald-50' : 'border-amber-200 bg-amber-50'}`}>
      <div className="flex justify-between">
        <p className="text-xs font-medium">{label}</p>
        <p className={`text-sm font-bold ${ok ? 'text-emerald-700' : 'text-amber-700'}`}>{val}%</p>
      </div>
      <div className="mt-1.5 h-1.5 rounded-full bg-black/10">
        <div className={`h-full rounded-full ${ok ? 'bg-emerald-500' : 'bg-amber-500'}`} style={{ width: `${Math.min(val / meta * 100, 100)}%` }} />
      </div>
      <p className="mt-1 text-[10px] text-muted-foreground">Meta: {meta}%</p>
    </div>
  );
}

export default function AdminGrowthTab({ toast }: Props) {
  const [dados, setDados] = useState<GrowthData | null>(null);
  const [loading, setLoading] = useState(true);
  const [onboarding, setOnboarding] = useState<any>(null);

  const carregar = async () => {
    setLoading(true);
    try {
      const [g, o] = await Promise.all([adminApi.growthDashboard(), adminApi.growthOnboarding()]);
      setDados(g);
      setOnboarding(o);
    }
    catch { toast({ title: "Erro ao carregar growth", variant: "destructive" }); }
    finally { setLoading(false); }
  };
  useEffect(() => { carregar(); }, []);

  if (loading) return <div className="flex justify-center py-12"><LoadingSpinner size="page" color="brand" /></div>;
  if (!dados) return null;
  const { north_star: ns, funil, churn_risk, canais, indicacoes } = dados;

  return (
    <div className="space-y-5">
      <div className="flex items-center justify-between">
        <h2 className="text-xl font-bold flex items-center gap-2"><BarChart3 className="h-5 w-5 text-brand" /> Growth Dashboard</h2>
        <button onClick={carregar} className="rounded-lg border border-border p-1.5 hover:bg-secondary"><RefreshCw className="h-4 w-4" /></button>
      </div>

      {/* North Star */}
      <Card className="border-brand/20 bg-brand/5">
        <CardContent className="pt-5">
          <div className="flex items-start justify-between">
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-brand">⭐ North Star Metric</p>
              <p className="text-xs text-muted-foreground">Consultoras com 3+ vendas nos últimos 7 dias</p>
              <p className="mt-3 text-5xl font-bold">{ns.valor}</p>
              <div className="mt-2 flex items-center gap-1.5">
                {ns.variacao >= 0 ? <TrendingUp className="h-4 w-4 text-emerald-600" /> : <TrendingDown className="h-4 w-4 text-red-600" />}
                <span className={`text-sm font-medium ${ns.variacao >= 0 ? 'text-emerald-600' : 'text-red-600'}`}>
                  {ns.variacao >= 0 ? '+' : ''}{ns.variacao} vs semana anterior ({ns.anterior})
                </span>
              </div>
            </div>
            <Target className="h-12 w-12 text-brand/20" />
          </div>
        </CardContent>
      </Card>

      {/* Funil */}
      <Card>
        <CardHeader><CardTitle className="text-base flex items-center gap-2"><Users className="h-4 w-4" /> Funil de Conversão</CardTitle><CardDescription>30 dias</CardDescription></CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            {[['Total lojas', funil.total, false], ['Em trial', funil.em_trial, false], ['Ativadas', funil.ativadas, false], ['Pagantes ativas', funil.pagantes, true]].map(([l, v, d]) => (
              <div key={String(l)} className={`rounded-xl border p-3 text-center ${d ? 'border-brand/30 bg-brand/5' : 'border-border'}`}>
                <p className={`text-2xl font-bold ${d ? 'text-brand' : ''}`}>{v as number}</p>
                <p className="text-[10px] text-muted-foreground mt-0.5">{l as string}</p>
              </div>
            ))}
          </div>
          <div className="grid grid-cols-3 gap-3 text-center text-xs">
            {[['Novos (30d)', funil.novos_30d], ['Ativados (30d)', funil.ativados_30d], ['Pagantes (30d)', funil.pagantes_30d]].map(([l, v]) => (
              <div key={String(l)} className="rounded-lg border border-border p-2">
                <p className="text-lg font-bold">{v as number}</p>
                <p className="text-muted-foreground">{l as string}</p>
              </div>
            ))}
          </div>
          <div className="grid grid-cols-2 gap-3">
            <Taxa label="Activation Rate" val={funil.activation_rate} meta={35} />
            <Taxa label="Trial → Pagante" val={funil.trial_conversion} meta={20} />
          </div>
        </CardContent>
      </Card>

      {/* Canais UTM */}
      <Card>
        <CardHeader><CardTitle className="text-base flex items-center gap-2"><Zap className="h-4 w-4" /> Aquisição por Canal (UTM)</CardTitle></CardHeader>
        <CardContent>
          {canais.length === 0
            ? <p className="text-sm text-muted-foreground text-center py-4">Nenhum UTM capturado ainda — adicione parâmetros UTM nos links do Instagram e WhatsApp.</p>
            : <div className="space-y-2">{canais.map(c => (
                <div key={c.canal} className="flex items-center justify-between gap-3 rounded-lg border border-border p-3">
                  <div><p className="text-sm font-medium capitalize">{c.canal}</p><p className="text-xs text-muted-foreground">{c.total} cadastros · {c.pagantes} pagantes</p></div>
                  <div className="text-right">
                    <p className={`text-sm font-bold ${c.conversao >= 20 ? 'text-emerald-600' : c.conversao >= 10 ? 'text-amber-600' : 'text-muted-foreground'}`}>{c.conversao}%</p>
                    <p className="text-[10px] text-muted-foreground">conversão</p>
                  </div>
                </div>
              ))}</div>
          }
        </CardContent>
      </Card>

      {/* Churn Risk */}
      <Card>
        <CardHeader><CardTitle className="text-base flex items-center gap-2"><AlertTriangle className="h-4 w-4 text-amber-500" /> Churn Risk Score</CardTitle><CardDescription>Consultoras pagantes com sinais de risco</CardDescription></CardHeader>
        <CardContent>
          {churn_risk.length === 0
            ? <p className="text-sm text-muted-foreground text-center py-4">✅ Nenhuma consultora pagante em risco agora.</p>
            : <div className="space-y-2">{churn_risk.map(c => (
                <div key={c.store_id} className={`flex items-center justify-between gap-3 rounded-lg border p-3 ${c.nivel === 'CRITICAL' ? 'border-red-200 bg-red-50' : 'border-amber-200 bg-amber-50'}`}>
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-medium">{c.email}</p>
                    <p className="text-xs text-muted-foreground">{c.vendas_30d} vendas (30d) · sem login há {c.dias_sem_login === 999 ? '—' : `${c.dias_sem_login}d`}</p>
                  </div>
                  <div className="flex shrink-0 items-center gap-2">
                    <span className="text-sm font-bold">{c.score}pts</span>
                    <Badge nivel={c.nivel} />
                  </div>
                </div>
              ))}</div>
          }
        </CardContent>
      </Card>

      {/* Indicações */}
      <Card>
        <CardHeader><CardTitle className="text-base">🤝 Indicações</CardTitle></CardHeader>
        <CardContent>
          <div className="grid grid-cols-2 gap-3 text-center">
            <div className="rounded-lg border border-border p-3"><p className="text-2xl font-bold">{indicacoes.total}</p><p className="text-xs text-muted-foreground">Total histórico</p></div>
            <div className="rounded-lg border border-border p-3"><p className="text-2xl font-bold">{indicacoes.ultimos_30d}</p><p className="text-xs text-muted-foreground">Últimos 30 dias</p></div>
          </div>
        </CardContent>
      </Card>

      {/* Onboarding Stages */}
      {onboarding && (
        <Card>
          <CardHeader>
            <CardTitle className="text-base flex items-center gap-2">
              <GitBranch className="h-4 w-4" /> Estágios de Onboarding
            </CardTitle>
            <CardDescription>Onde cada consultora está no funil</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 gap-2 sm:grid-cols-3">
              {[
                { key: 'trial_recente',        label: 'Trial < 3 dias',    cor: 'border-blue-200 bg-blue-50 text-blue-700' },
                { key: 'sem_ativacao_risco',   label: 'Sem ativar (3-7d)', cor: 'border-amber-200 bg-amber-50 text-amber-700' },
                { key: 'sem_ativacao_critico', label: 'Sem ativar > 7d',   cor: 'border-red-200 bg-red-50 text-red-700' },
                { key: 'ativado_trial',        label: 'Ativou (trial)',     cor: 'border-emerald-200 bg-emerald-50 text-emerald-700' },
                { key: 'pagante_ativo',        label: 'Pagante ativo',      cor: 'border-brand/30 bg-brand/5 text-brand' },
                { key: 'pagante_em_risco',     label: 'Pagante em risco',   cor: 'border-orange-200 bg-orange-50 text-orange-700' },
              ].map(({ key, label, cor }) => (
                <div key={key} className={`rounded-lg border p-3 text-center ${cor}`}>
                  <p className="text-xl font-bold">{onboarding.totais[key] ?? 0}</p>
                  <p className="text-[10px] font-medium mt-0.5">{label}</p>
                </div>
              ))}
            </div>
            {/* Consultoras críticas sem ativação */}
            {onboarding.estagios.sem_ativacao_critico?.length > 0 && (
              <div className="mt-4 space-y-1">
                <p className="text-xs font-semibold text-red-700 mb-2">⚠️ Precisam de intervenção agora:</p>
                {onboarding.estagios.sem_ativacao_critico.slice(0, 5).map((c: any) => (
                  <div key={c.email} className="flex items-center justify-between rounded-lg bg-red-50 border border-red-200 px-3 py-1.5 text-xs">
                    <span className="truncate">{c.email}</span>
                    <span className="shrink-0 text-red-600 font-medium ml-2">D{c.dias_cadastrado}</span>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>
      )}
    </div>
  );
}