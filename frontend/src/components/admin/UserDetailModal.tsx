// src/components/admin/UserDetailModal.tsx
//
// Modal de detalhe da usuária — antes era uma linha expandida dentro da
// tabela, agora é um modal com abas, no mesmo espírito de CRM
// profissional (HubSpot, Intercom): cada aba cresce sozinha depois sem
// bagunçar as outras. Pensado pra crescer — adicionar uma aba nova
// (ex: "Notas internas", "Faturas") é só mais um <TabsTrigger>/<TabsContent>.
import { useState, useEffect } from "react";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from "../ui/dialog";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "../ui/tabs";
import {
  User, Mail, MessageCircle, Crown, Loader2, Send, Check, Clock,
} from "lucide-react";
import { adminApi } from "../../lib/api";
import type { AdminUser } from "../../pages/AdminPanel";

function formatDate(d: string | null) {
  if (!d) return "—";
  return new Date(d).toLocaleDateString("pt-BR");
}

interface Props {
  user: AdminUser | null;
  open: boolean;
  onClose: () => void;
  onTogglePlan: (user: AdminUser) => void;
  updatingPlan: boolean;
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

interface ModeloOpcao { value: string; label: string; }
interface HistoricoItem { canal: "email" | "whatsapp"; assunto: string | null; texto: string; quando: string; }

export default function UserDetailModal({ user, open, onClose, onTogglePlan, updatingPlan, toast }: Props) {
  const [modelosEmail, setModelosEmail] = useState<ModeloOpcao[]>([]);
  const [modelosWhatsapp, setModelosWhatsapp] = useState<ModeloOpcao[]>([]);

  const [assuntoEmail, setAssuntoEmail] = useState("");
  const [corpoEmail, setCorpoEmail] = useState("");
  const [enviandoEmail, setEnviandoEmail] = useState(false);

  const [textoWhatsapp, setTextoWhatsapp] = useState("");
  const [abrindoWhatsapp, setAbrindoWhatsapp] = useState(false);
  const [linkWhatsappGerado, setLinkWhatsappGerado] = useState(false);

  const [historico, setHistorico] = useState<HistoricoItem[]>([]);
  const [carregandoHistorico, setCarregandoHistorico] = useState(false);

  // Carrega os modelos disponíveis uma vez (não muda por usuária)
  useEffect(() => {
    if (!open) return;
    adminApi.listTemplates().then((r) => {
      setModelosEmail(r.email);
      setModelosWhatsapp(r.whatsapp);
    }).catch(() => {});
  }, [open]);

  // Reseta os campos e recarrega histórico toda vez que abre pra uma usuária diferente
  useEffect(() => {
    if (!open || !user) return;
    setAssuntoEmail("");
    setCorpoEmail("");
    setTextoWhatsapp("");
    setLinkWhatsappGerado(false);
    carregarHistorico();
  }, [open, user?.store_id]);

  const carregarHistorico = async () => {
    if (!user?.store_id) return;
    setCarregandoHistorico(true);
    try {
      setHistorico(await adminApi.historicoContato(Number(user.store_id)));
    } catch {
      // silencioso — histórico é informativo, não crítico
    } finally {
      setCarregandoHistorico(false);
    }
  };

  const carregarModeloEmail = async (templateKey: string) => {
    if (!templateKey || !user?.store_id) return;
    try {
      const r = await adminApi.renderizarModelo("email", templateKey, Number(user.store_id));
      setAssuntoEmail(r.assunto || "");
      setCorpoEmail(r.corpo_texto || "");
    } catch {
      toast({ title: "Não deu pra carregar o modelo", variant: "destructive" });
    }
  };

  const carregarModeloWhatsapp = async (templateKey: string) => {
    if (!templateKey || !user?.store_id) return;
    try {
      const r = await adminApi.renderizarModelo("whatsapp", templateKey, Number(user.store_id));
      setTextoWhatsapp(r.texto || "");
    } catch {
      toast({ title: "Não deu pra carregar o modelo", variant: "destructive" });
    }
  };

  const enviarEmail = async () => {
    if (!user?.store_id || !assuntoEmail.trim() || !corpoEmail.trim()) {
      toast({ title: "Preencha assunto e mensagem", variant: "destructive" });
      return;
    }
    setEnviandoEmail(true);
    try {
      await adminApi.enviarEmailContato({
        store_id: Number(user.store_id), assunto: assuntoEmail, corpo_texto: corpoEmail,
      });
      toast({ title: "E-mail enviado!" });
      setAssuntoEmail("");
      setCorpoEmail("");
      carregarHistorico();
    } catch (err: any) {
      toast({ title: "Não deu pra enviar", description: err?.response?.data?.error, variant: "destructive" });
    } finally {
      setEnviandoEmail(false);
    }
  };

  const abrirWhatsapp = async () => {
    if (!user?.store_id || !textoWhatsapp.trim()) {
      toast({ title: "Escreva a mensagem primeiro", variant: "destructive" });
      return;
    }
    setAbrindoWhatsapp(true);
    try {
      const { link } = await adminApi.gerarLinkWhatsapp(Number(user.store_id), textoWhatsapp);
      window.open(link, "_blank");
      setLinkWhatsappGerado(true);
    } catch (err: any) {
      toast({ title: "Não deu pra gerar o link", description: err?.response?.data?.error, variant: "destructive" });
    } finally {
      setAbrindoWhatsapp(false);
    }
  };

  const marcarWhatsappEnviado = async () => {
    if (!user?.store_id) return;
    try {
      await adminApi.marcarWhatsappEnviado({ store_id: Number(user.store_id), texto: textoWhatsapp });
      toast({ title: "Marcado como enviado" });
      setTextoWhatsapp("");
      setLinkWhatsappGerado(false);
      carregarHistorico();
    } catch {
      toast({ title: "Erro", description: "Não deu pra marcar", variant: "destructive" });
    }
  };

  if (!user) return null;

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <User className="h-4 w-4 text-primary" />
            {user.display_name || user.email}
          </DialogTitle>
        </DialogHeader>

        <Tabs defaultValue="geral" className="mt-2">
          <TabsList className="grid w-full grid-cols-4">
            <TabsTrigger value="geral">Visão Geral</TabsTrigger>
            <TabsTrigger value="assinatura">Assinatura</TabsTrigger>
            <TabsTrigger value="email">E-mail</TabsTrigger>
            <TabsTrigger value="whatsapp">WhatsApp</TabsTrigger>
          </TabsList>

          {/* ── Visão Geral ── */}
          <TabsContent value="geral" className="mt-4">
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div>
                <p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Email</p>
                <p className="font-medium text-xs break-all">{user.email}</p>
              </div>
              <div>
                <p className="text-muted-foreground text-xs font-semibold uppercase mb-1">WhatsApp</p>
                <p className="font-medium text-xs">{user.whatsapp_number || "Não informado"}</p>
              </div>
              <div>
                <p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Vitrine</p>
                <p className="font-medium text-xs">{user.store_slug || "Não criada"}</p>
              </div>
              <div>
                <p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Criada em</p>
                <p className="font-medium text-xs">{formatDate(user.created_at)}</p>
              </div>
              <div>
                <p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Produtos</p>
                <p className="font-medium text-xs">{user.product_count}</p>
              </div>
              {(user.campos_faltando || []).length > 0 && (
                <div>
                  <p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Cadastro incompleto</p>
                  <p className="font-medium text-xs text-amber-600">{(user.campos_faltando || []).join(", ")}</p>
                </div>
              )}
            </div>
          </TabsContent>

          {/* ── Assinatura ── */}
          <TabsContent value="assinatura" className="mt-4">
            <div className="rounded-lg border border-border p-3">
              <h4 className="font-semibold text-sm mb-2 flex items-center gap-2">
                <Crown className="h-4 w-4 text-amber-500" /> Assinatura
              </h4>
              <div className="grid grid-cols-2 gap-3 text-xs mb-3">
                <div>
                  <p className="text-muted-foreground font-semibold uppercase mb-0.5">Plano</p>
                  <p className="font-medium uppercase">{user.plan}</p>
                </div>
                <div>
                  <p className="text-muted-foreground font-semibold uppercase mb-0.5">Status</p>
                  <p className="font-medium">{user.subscription_status || "N/A"}</p>
                </div>
                <div>
                  <p className="text-muted-foreground font-semibold uppercase mb-0.5">Início</p>
                  <p className="font-medium">{formatDate(user.subscription_started_at)}</p>
                </div>
                <div>
                  <p className="text-muted-foreground font-semibold uppercase mb-0.5">Expira em</p>
                  <p className="font-medium">{formatDate(user.subscription_expires_at)}</p>
                </div>
              </div>
              <button
                onClick={() => onTogglePlan(user)}
                disabled={updatingPlan}
                className="w-full rounded-lg border border-border py-2 text-xs font-medium hover:bg-secondary disabled:opacity-50"
              >
                {user.plan === "pro" ? "Rebaixar pra Free" : "Virar PRO"}
              </button>
            </div>
          </TabsContent>

          {/* ── E-mail ── */}
          <TabsContent value="email" className="mt-4 space-y-3">
            <div>
              <label className="text-xs font-medium text-muted-foreground">Carregar modelo (opcional)</label>
              <select
                onChange={(e) => carregarModeloEmail(e.target.value)}
                defaultValue=""
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              >
                <option value="">Escrever do zero...</option>
                {modelosEmail.map((m) => (
                  <option key={m.value} value={m.value}>{m.label}</option>
                ))}
              </select>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">Assunto</label>
              <input
                value={assuntoEmail}
                onChange={(e) => setAssuntoEmail(e.target.value)}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">Mensagem</label>
              <textarea
                value={corpoEmail}
                onChange={(e) => setCorpoEmail(e.target.value)}
                rows={7}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand resize-none"
              />
            </div>
            <button
              onClick={enviarEmail}
              disabled={enviandoEmail}
              className="flex w-full items-center justify-center gap-2 rounded-lg bg-brand py-2.5 text-sm font-semibold text-white hover:opacity-90 disabled:opacity-50"
            >
              {enviandoEmail ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4" />}
              Enviar e-mail
            </button>

            <HistoricoLista itens={historico.filter((h) => h.canal === "email")} carregando={carregandoHistorico} />
          </TabsContent>

          {/* ── WhatsApp ── */}
          <TabsContent value="whatsapp" className="mt-4 space-y-3">
            {!user.whatsapp_number ? (
              <p className="rounded-lg border border-dashed border-border p-4 text-center text-xs text-muted-foreground">
                Essa usuária não tem WhatsApp cadastrado.
              </p>
            ) : (
              <>
                <div>
                  <label className="text-xs font-medium text-muted-foreground">Carregar modelo (opcional)</label>
                  <select
                    onChange={(e) => carregarModeloWhatsapp(e.target.value)}
                    defaultValue=""
                    className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                  >
                    <option value="">Escrever do zero...</option>
                    {modelosWhatsapp.map((m) => (
                      <option key={m.value} value={m.value}>{m.label}</option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="text-xs font-medium text-muted-foreground">Mensagem</label>
                  <textarea
                    value={textoWhatsapp}
                    onChange={(e) => setTextoWhatsapp(e.target.value)}
                    rows={7}
                    className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand resize-none"
                  />
                </div>
                <button
                  onClick={abrirWhatsapp}
                  disabled={abrindoWhatsapp}
                  className="flex w-full items-center justify-center gap-2 rounded-lg bg-emerald-600 py-2.5 text-sm font-semibold text-white hover:opacity-90 disabled:opacity-50"
                >
                  {abrindoWhatsapp ? <Loader2 className="h-4 w-4 animate-spin" /> : <MessageCircle className="h-4 w-4" />}
                  Abrir WhatsApp
                </button>
                {linkWhatsappGerado && (
                  <button
                    onClick={marcarWhatsappEnviado}
                    className="flex w-full items-center justify-center gap-2 rounded-lg border border-emerald-300 py-2 text-xs font-medium text-emerald-700 hover:bg-emerald-50"
                  >
                    <Check className="h-3.5 w-3.5" /> Confirmar que mandei de verdade
                  </button>
                )}

                <HistoricoLista itens={historico.filter((h) => h.canal === "whatsapp")} carregando={carregandoHistorico} />
              </>
            )}
          </TabsContent>
        </Tabs>
      </DialogContent>
    </Dialog>
  );
}

function HistoricoLista({ itens, carregando }: { itens: HistoricoItem[]; carregando: boolean }) {
  if (carregando) {
    return <div className="flex justify-center py-3"><Loader2 className="h-4 w-4 animate-spin text-muted-foreground" /></div>;
  }
  if (itens.length === 0) return null;

  return (
    <div className="mt-2 border-t border-border pt-3">
      <p className="mb-2 flex items-center gap-1.5 text-xs font-semibold text-muted-foreground">
        <Clock className="h-3.5 w-3.5" /> Histórico
      </p>
      <div className="space-y-2 max-h-40 overflow-y-auto">
        {itens.map((h, i) => (
          <div key={i} className="rounded-lg bg-secondary/40 p-2 text-xs">
            {h.assunto && <p className="font-medium text-foreground">{h.assunto}</p>}
            <p className="text-muted-foreground line-clamp-2">{h.texto}</p>
            <p className="mt-1 text-[10px] text-muted-foreground/70">{formatDate(h.quando)}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
