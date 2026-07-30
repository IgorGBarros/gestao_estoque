import { useEffect, useMemo, useState } from "react";
import { ArrowLeft, Search, Download, MessageCircle, Trash2, ShieldOff, Loader2, Users, CheckCircle2, XCircle, Eye, X, Package, ShoppingBag } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { toast } from "sonner";
import { listLeads, getLead, anonymizeLead, deleteLead, exportLeadsCsv, downloadCsv, Lead } from "../lib/leads";
import { WA_TEMPLATES, WaTemplateKey, buildWaLink, renderTemplate } from "@/lib/whatsapp";

export default function CRM() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const tenantId = String(user?.id || "");

  const [leads, setLeads] = useState<Lead[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  // 🔹 Painel de histórico: qual cliente está aberto e os dados dela.
  const [detalheAberto, setDetalheAberto] = useState<Lead | null>(null);
  const [carregandoDetalhe, setCarregandoDetalhe] = useState(false);
  const [optInFilter, setOptInFilter] = useState<"all" | "yes" | "no">("all");
  const [tplKey, setTplKey] = useState<WaTemplateKey>("welcome");

  const load = async () => {
    if (!tenantId) return;
    setLoading(true);
    try {
      const data = await listLeads(tenantId);
      setLeads(data);
    } catch (e: any) {
      toast.error("Erro ao carregar leads", { description: e.message });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tenantId]);

  const filtered = useMemo(() => {
    return leads.filter((l) => {
      if (optInFilter === "yes" && !l.whatsapp_opt_in) return false;
      if (optInFilter === "no" && l.whatsapp_opt_in) return false;
      if (!search) return true;
      const q = search.toLowerCase();
      return (
        l.name.toLowerCase().includes(q) ||
        l.phone.includes(q) ||
        (l.email || "").toLowerCase().includes(q)
      );
    });
  }, [leads, search, optInFilter]);

  const template = WA_TEMPLATES.find((t) => t.key === tplKey) || WA_TEMPLATES[0];

  // 🔹 Abre o painel de histórico de um cliente — busca o detalhe completo
  // (o /crm/leads/<id> já vem com purchase_history embutido).
  const handleVerHistorico = async (l: Lead) => {
    setDetalheAberto(l); // mostra o painel já com o que se tem, enquanto carrega
    setCarregandoDetalhe(true);
    try {
      const completo = await getLead(l.id);
      setDetalheAberto(completo);
    } catch {
      toast.error("Não foi possível carregar o histórico");
    } finally {
      setCarregandoDetalhe(false);
    }
  };

  const handleWhatsapp = (l: Lead) => {
    if (l.anonymized_at) return toast.error("Lead anonimizado");
    const link = buildWaLink(l.phone, template.body, {
      name: l.name.split(" ")[0],
      seller: user?.name || "sua consultora",
      product: "",
      link: window.location.origin,
      discount: "10% OFF",
    });
    window.open(link, "_blank", "noopener,noreferrer");
  };

  const handleAnonymize = async (l: Lead) => {
    if (!confirm(`Anonimizar ${l.name}? Esta ação é irreversível.`)) return;
    await anonymizeLead(l.id);
    toast.success("Lead anonimizado");
    load();
  };

  const handleDelete = async (l: Lead) => {
    if (!confirm(`Excluir ${l.name} definitivamente?`)) return;
    await deleteLead(l.id);
    toast.success("Lead excluído");
    load();
  };

  const handleExport = () => {
    const csv = exportLeadsCsv(filtered);
    downloadCsv(`leads-${new Date().toISOString().slice(0, 10)}.csv`, csv);
    toast.success("CSV exportado");
  };

  const handleBulkAbandoned = () => {
    const targets = filtered.filter((l) => l.whatsapp_opt_in && !l.anonymized_at);
    if (targets.length === 0) return toast.error("Nenhum lead com opt-in");
    if (!confirm(`Abrir WhatsApp para ${targets.length} leads?`)) return;
    targets.forEach((l, i) => {
      setTimeout(() => {
        const link = buildWaLink(l.phone, WA_TEMPLATES[1].body, {
          name: l.name.split(" ")[0],
          link: window.location.origin,
          seller: user?.name || "",
        });
        window.open(link, "_blank", "noopener,noreferrer");
      }, i * 600);
    });
  };

  const optInCount = leads.filter((l) => l.whatsapp_opt_in).length;

  return (
    <>
    <div className="min-h-screen bg-background">
      <header className="sticky top-0 z-10 border-b border-border bg-card/95 backdrop-blur">
        <div className="mx-auto flex max-w-6xl items-center gap-3 px-4 py-3">
          <Button size="icon" variant="ghost" onClick={() => navigate("/")}>
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <div className="flex-1">
            <h1 className="font-display text-lg font-bold text-foreground">CRM</h1>
            <p className="text-xs text-muted-foreground">Seus leads capturados na vitrine</p>
          </div>
          <Button variant="outline" size="sm" onClick={handleExport}>
            <Download className="h-4 w-4" /> CSV
          </Button>
        </div>
      </header>

      <main className="mx-auto max-w-6xl space-y-4 px-4 py-6">
        {/* Stats */}
        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
          <StatCard icon={Users} label="Total" value={leads.length} />
          <StatCard icon={CheckCircle2} label="Opt-in WhatsApp" value={optInCount} />
          <StatCard icon={XCircle} label="Anonimizados" value={leads.filter((l) => l.anonymized_at).length} />
        </div>

        {/* Filters */}
        <div className="flex flex-col gap-3 sm:flex-row">
          <div className="relative flex-1">
            <Search className="pointer-events-none absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <Input
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Buscar nome, telefone ou email"
              className="pl-9"
            />
          </div>
          <Select value={optInFilter} onValueChange={(v: any) => setOptInFilter(v)}>
            <SelectTrigger className="w-full sm:w-44"><SelectValue /></SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Todos opt-in</SelectItem>
              <SelectItem value="yes">Com opt-in</SelectItem>
              <SelectItem value="no">Sem opt-in</SelectItem>
            </SelectContent>
          </Select>
          <Select value={tplKey} onValueChange={(v: any) => setTplKey(v)}>
            <SelectTrigger className="w-full sm:w-56"><SelectValue placeholder="Template" /></SelectTrigger>
            <SelectContent>
              {WA_TEMPLATES.map((t) => (
                <SelectItem key={t.key} value={t.key}>{t.label}</SelectItem>
              ))}
            </SelectContent>
          </Select>
          <Button variant="secondary" onClick={handleBulkAbandoned}>
            <MessageCircle className="h-4 w-4" /> Lembrar carrinhos
          </Button>
        </div>

        {/* Template preview */}
        <div className="rounded-lg border border-border bg-muted/30 p-3 text-xs text-muted-foreground">
          <span className="font-semibold text-foreground">Preview:</span>{" "}
          {renderTemplate(template.body, {
            name: "Maria",
            seller: user?.name || "Consultora",
            product: "Kaiak",
            link: "https://...",
            discount: "10% OFF",
          })}
        </div>

        {/* Table */}
        {loading ? (
          <div className="flex justify-center py-20"><Loader2 className="h-6 w-6 animate-spin text-primary" /></div>
        ) : filtered.length === 0 ? (
          <div className="rounded-xl border border-dashed border-border py-20 text-center text-sm text-muted-foreground">
            Nenhum lead encontrado.
          </div>
        ) : (
          <div className="overflow-x-auto rounded-xl border border-border bg-card">
            <table className="w-full min-w-[520px] text-sm">
              <thead className="bg-muted/40 text-xs uppercase text-muted-foreground">
                <tr>
                  <th className="px-4 py-3 text-left">Nome</th>
                  <th className="px-4 py-3 text-left">Telefone</th>
                  <th className="px-4 py-3 text-left">Opt-in</th>
                  <th className="px-4 py-3 text-left">Última visita</th>
                  <th className="px-4 py-3 text-left">Gasto</th>
                  <th className="px-4 py-3 text-right">Ações</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((l) => (
                  <tr key={l.id} className="border-t border-border hover:bg-muted/20">
                    <td className="px-4 py-3 font-medium text-foreground">
                      {l.name}
                      {l.anonymized_at && <Badge variant="outline" className="ml-2 text-xs">anonimizado</Badge>}
                    </td>
                    <td className="px-4 py-3 text-muted-foreground">{l.phone}</td>
                    <td className="px-4 py-3">
                      {l.whatsapp_opt_in ? (
                        <Badge className="bg-emerald-500/15 text-emerald-700">Sim</Badge>
                      ) : (
                        <Badge variant="outline">Não</Badge>
                      )}
                    </td>
                    <td className="px-4 py-3 text-xs text-muted-foreground">
                      {new Date(l.last_seen).toLocaleDateString("pt-BR")}
                    </td>
                    <td className="px-4 py-3 text-xs">R$ {Number(l.total_spent || 0).toFixed(2)}</td>
                    <td className="px-4 py-3">
                      <div className="flex items-center justify-end gap-1">
                        <Button
                          size="icon"
                          variant="ghost"
                          title="Ver histórico de compras"
                          onClick={() => handleVerHistorico(l)}
                          className="h-8 w-8 text-muted-foreground hover:text-foreground"
                        >
                          <Eye className="h-4 w-4" />
                        </Button>
                        <Button
                          size="icon"
                          variant="ghost"
                          disabled={!l.whatsapp_opt_in || !!l.anonymized_at}
                          title={!l.whatsapp_opt_in ? "Sem opt-in" : "Enviar WhatsApp"}
                          onClick={() => handleWhatsapp(l)}
                          className="h-8 w-8 text-emerald-600"
                        >
                          <MessageCircle className="h-4 w-4" />
                        </Button>
                        <Button size="icon" variant="ghost" title="Anonimizar (LGPD)" onClick={() => handleAnonymize(l)} className="h-8 w-8">
                          <ShieldOff className="h-4 w-4" />
                        </Button>
                        <Button size="icon" variant="ghost" title="Excluir" onClick={() => handleDelete(l)} className="h-8 w-8 text-destructive">
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </main>
    </div>

    {/* 🔹 Painel de histórico: o que essa cliente comprou, quando e por
        quanto — o que faltava pra "Meus Clientes" virar uma central de
        verdade, não só uma lista de contatos. */}
    {detalheAberto && (
      <div
        className="fixed inset-0 z-50 flex items-end justify-center bg-black/50 sm:items-center"
        onClick={() => setDetalheAberto(null)}
      >
        <div
          className="max-h-[85vh] w-full max-w-lg overflow-y-auto rounded-t-2xl bg-card p-5 sm:rounded-2xl"
          onClick={(e) => e.stopPropagation()}
        >
          <div className="flex items-start justify-between gap-3">
            <div>
              <h2 className="font-display text-lg font-bold text-foreground">
                {detalheAberto.name}
                {detalheAberto.anonymized_at && (
                  <Badge variant="outline" className="ml-2 text-xs">anonimizado</Badge>
                )}
              </h2>
              <p className="text-sm text-muted-foreground">{detalheAberto.phone}</p>
              {detalheAberto.email && (
                <p className="text-xs text-muted-foreground">{detalheAberto.email}</p>
              )}
            </div>
            <button
              onClick={() => setDetalheAberto(null)}
              className="rounded-full p-1.5 text-muted-foreground hover:bg-muted"
            >
              <X className="h-4 w-4" />
            </button>
          </div>

          {/* Resumo */}
          <div className="mt-4 grid grid-cols-3 gap-2">
            <div className="rounded-xl border border-border bg-secondary/30 p-3 text-center">
              <p className="text-lg font-bold text-foreground">{detalheAberto.total_orders}</p>
              <p className="text-[11px] text-muted-foreground">pedidos</p>
            </div>
            <div className="rounded-xl border border-border bg-secondary/30 p-3 text-center">
              <p className="text-lg font-bold text-foreground">
                R$ {Number(detalheAberto.total_spent || 0).toFixed(2)}
              </p>
              <p className="text-[11px] text-muted-foreground">total gasto</p>
            </div>
            <div className="rounded-xl border border-border bg-secondary/30 p-3 text-center">
              <p className="text-xs font-bold text-foreground">
                {detalheAberto.last_purchase_at
                  ? new Date(detalheAberto.last_purchase_at).toLocaleDateString("pt-BR")
                  : "—"}
              </p>
              <p className="text-[11px] text-muted-foreground">última compra</p>
            </div>
          </div>

          {/* Histórico */}
          <div className="mt-5">
            <h3 className="mb-2 flex items-center gap-1.5 text-sm font-semibold text-foreground">
              <ShoppingBag className="h-4 w-4" /> Histórico de compras
            </h3>

            {carregandoDetalhe ? (
              <div className="flex justify-center py-8">
                <Loader2 className="h-5 w-5 animate-spin text-brand" />
              </div>
            ) : !detalheAberto.purchase_history || detalheAberto.purchase_history.length === 0 ? (
              <div className="rounded-xl border border-border bg-card px-4 py-8 text-center">
                <Package className="mx-auto mb-2 h-5 w-5 text-muted-foreground" />
                <p className="text-sm text-muted-foreground">Nenhum pedido fechado ainda.</p>
              </div>
            ) : (
              <ul className="space-y-2">
                {detalheAberto.purchase_history.map((pedido) => (
                  <li key={pedido.cart_id} className="rounded-xl border border-border p-3">
                    <div className="flex items-center justify-between">
                      <span className="text-xs text-muted-foreground">
                        {new Date(pedido.date).toLocaleDateString("pt-BR")}
                      </span>
                      <span className="text-sm font-semibold text-foreground">
                        R$ {Number(pedido.total).toFixed(2)}
                      </span>
                    </div>
                    <ul className="mt-1.5 space-y-0.5">
                      {pedido.items.map((item, i) => (
                        <li key={i} className="flex items-center justify-between text-xs text-muted-foreground">
                          <span className="truncate">{item.quantity}x {item.product_name}</span>
                          <span className="shrink-0">R$ {Number(item.subtotal).toFixed(2)}</span>
                        </li>
                      ))}
                    </ul>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>
      </div>
    )}
    </>
  );
}

function StatCard({ icon: Icon, label, value }: { icon: any; label: string; value: number }) {
  return (
    <div className="rounded-xl border border-border bg-card p-4">
      <div className="flex items-center justify-between">
        <span className="text-xs text-muted-foreground">{label}</span>
        <Icon className="h-4 w-4 text-muted-foreground" />
      </div>
      <p className="mt-1 font-display text-2xl font-bold text-foreground">{value}</p>
    </div>
  );
}