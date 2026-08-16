// src/components/admin/AdminReferralTab.tsx
//
// Códigos de indicação — não é programa aberto ao público, é individual:
// cada código é gerado especificamente pra uma pessoa convidada
// pessoalmente (ex: uma líder de grupo). Substitui rodar o comando
// `criar_codigo_indicacao` direto no terminal.
import { useState, useEffect } from "react";
import { Gift, Copy, Check, X, Plus, RefreshCw, Loader2 } from "lucide-react";
import { Badge } from "../ui/badge";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { adminApi } from "../../lib/api";

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

interface CodigoIndicacao {
  id: number;
  code: string;
  label: string;
  referrer_store_name: string | null;
  referrer_store_email: string | null;
  bonus_trial_days: number;
  referrer_bonus_days: number;
  max_uses: number | null;
  times_used: number;
  esgotado: boolean;
  active: boolean;
  created_at: string;
}

export default function AdminReferralTab({ toast }: Props) {
  const [codigos, setCodigos] = useState<CodigoIndicacao[]>([]);
  const [loading, setLoading] = useState(true);
  const [mostrarForm, setMostrarForm] = useState(false);
  const [salvando, setSalvando] = useState(false);
  const [copiado, setCopiado] = useState<number | null>(null);

  const [form, setForm] = useState({
    nome: "",
    indicado_por_email: "",
    dias_teste: 30,
    dias_bonus_indicadora: 7,
    limite_usos: 1,
  });

  const carregar = async () => {
    setLoading(true);
    try {
      const dados = await adminApi.listReferralCodes();
      setCodigos(dados);
    } catch {
      toast({ title: "Erro", description: "Não deu pra carregar os códigos", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { carregar(); }, []);

  const criar = async () => {
    if (!form.nome.trim()) {
      toast({ title: "Falta o nome", description: "Diga pra quem é esse código", variant: "destructive" });
      return;
    }
    setSalvando(true);
    try {
      const novo = await adminApi.createReferralCode(form);
      toast({ title: "Código criado!", description: `${novo.code} — pronto pra passar` });
      setCodigos((prev) => [novo, ...prev]);
      setForm({ nome: "", indicado_por_email: "", dias_teste: 30, dias_bonus_indicadora: 7, limite_usos: 1 });
      setMostrarForm(false);
    } catch (err: any) {
      toast({
        title: "Não deu pra criar",
        description: err?.response?.data?.error || "Confira o e-mail da indicadora, se informou um.",
        variant: "destructive",
      });
    } finally {
      setSalvando(false);
    }
  };

  const alternar = async (codigo: CodigoIndicacao) => {
    try {
      const atualizado = await adminApi.toggleReferralCode(codigo.id);
      setCodigos((prev) => prev.map((c) => (c.id === codigo.id ? atualizado : c)));
    } catch {
      toast({ title: "Erro", description: "Não deu pra atualizar", variant: "destructive" });
    }
  };

  const copiar = (codigo: CodigoIndicacao) => {
    navigator.clipboard.writeText(codigo.code);
    setCopiado(codigo.id);
    setTimeout(() => setCopiado(null), 1500);
  };

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-base flex items-center gap-2">
            <Gift className="h-4 w-4" /> Códigos de Indicação
          </CardTitle>
          <CardDescription>
            Um código por pessoa convidada — não é aberto ao público
          </CardDescription>
        </div>
        <div className="flex gap-2">
          <button onClick={carregar} className="rounded-lg border border-border p-1.5 hover:bg-secondary">
            <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
          </button>
          <button
            onClick={() => setMostrarForm((v) => !v)}
            className="flex items-center gap-1.5 rounded-lg bg-brand px-3 py-1.5 text-sm font-medium text-white hover:opacity-90"
          >
            <Plus className="h-3.5 w-3.5" /> Novo código
          </button>
        </div>
      </CardHeader>
      <CardContent>
        {mostrarForm && (
          <div className="mb-5 space-y-3 rounded-xl border border-brand/20 bg-brand-soft p-4">
            <div>
              <label className="text-xs font-medium text-muted-foreground">Nome de quem vai receber *</label>
              <input
                type="text"
                value={form.nome}
                onChange={(e) => setForm((f) => ({ ...f, nome: e.target.value }))}
                placeholder="Ex: Maria Líder"
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">
                E-mail de quem está indicando (opcional — quem ganha o bônus)
              </label>
              <input
                type="email"
                value={form.indicado_por_email}
                onChange={(e) => setForm((f) => ({ ...f, indicado_por_email: e.target.value }))}
                placeholder="esposa@exemplo.com"
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
            <div className="grid grid-cols-3 gap-3">
              <div>
                <label className="text-xs font-medium text-muted-foreground">Dias de teste</label>
                <input
                  type="number"
                  value={form.dias_teste}
                  onChange={(e) => setForm((f) => ({ ...f, dias_teste: Number(e.target.value) }))}
                  className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                />
              </div>
              <div>
                <label className="text-xs font-medium text-muted-foreground">Bônus indicadora</label>
                <input
                  type="number"
                  value={form.dias_bonus_indicadora}
                  onChange={(e) => setForm((f) => ({ ...f, dias_bonus_indicadora: Number(e.target.value) }))}
                  className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                />
              </div>
              <div>
                <label className="text-xs font-medium text-muted-foreground">Limite de usos</label>
                <input
                  type="number"
                  value={form.limite_usos}
                  onChange={(e) => setForm((f) => ({ ...f, limite_usos: Number(e.target.value) }))}
                  className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                />
              </div>
            </div>
            <div className="flex justify-end gap-2 pt-1">
              <button onClick={() => setMostrarForm(false)} className="rounded-lg border border-border px-4 py-2 text-sm hover:bg-secondary">
                Cancelar
              </button>
              <button
                onClick={criar}
                disabled={salvando}
                className="flex items-center gap-1.5 rounded-lg bg-brand px-4 py-2 text-sm font-medium text-white hover:opacity-90 disabled:opacity-50"
              >
                {salvando ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <Gift className="h-3.5 w-3.5" />}
                Criar código
              </button>
            </div>
          </div>
        )}

        {loading ? (
          <div className="flex justify-center py-8"><Loader2 className="h-5 w-5 animate-spin text-primary" /></div>
        ) : codigos.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">
            Nenhum código criado ainda — clique em "Novo código" pra convidar alguém.
          </p>
        ) : (
          <div className="space-y-2">
            {codigos.map((c) => (
              <div key={c.id} className={`flex items-center justify-between gap-3 rounded-lg border p-3 ${c.active ? "border-border" : "border-border opacity-50"}`}>
                <div className="min-w-0 flex-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <button
                      onClick={() => copiar(c)}
                      className="flex items-center gap-1 rounded-md bg-brand/10 px-2 py-0.5 font-mono text-xs font-bold text-brand hover:bg-brand/20"
                      title="Copiar código"
                    >
                      {copiado === c.id ? <Check className="h-3 w-3" /> : <Copy className="h-3 w-3" />}
                      {c.code}
                    </button>
                    <span className="text-sm font-medium text-foreground">{c.label}</span>
                    {c.esgotado && <Badge variant="outline" className="text-[10px] text-destructive border-destructive/30">Esgotado</Badge>}
                    {!c.active && <Badge variant="outline" className="text-[10px]">Desativado</Badge>}
                  </div>
                  <p className="mt-0.5 text-xs text-muted-foreground">
                    {c.referrer_store_name ? `Indicado por ${c.referrer_store_name} (${c.referrer_store_email})` : "Sem indicadora vinculada"}
                    {" · "}{c.bonus_trial_days}d de teste · +{c.referrer_bonus_days}d pra indicadora
                    {" · "}usado {c.times_used}{c.max_uses ? `/${c.max_uses}` : ""}
                  </p>
                </div>
                <button
                  onClick={() => alternar(c)}
                  className={`shrink-0 rounded-lg border px-3 py-1.5 text-xs font-medium ${
                    c.active
                      ? "border-destructive/30 text-destructive hover:bg-destructive/10"
                      : "border-emerald-300 text-emerald-600 hover:bg-emerald-50"
                  }`}
                >
                  {c.active ? "Desativar" : "Reativar"}
                </button>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}
