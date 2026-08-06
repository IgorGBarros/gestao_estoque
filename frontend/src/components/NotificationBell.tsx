// components/NotificationBell.tsx — VERSÃO REFATORADA COM PALETA DA MARCA
import { useState, useRef, useEffect } from "react";
import { Bell, AlertTriangle, Clock, X, ChevronRight, Trophy, Star, Flame, TrendingUp, Package, Crown, Users, Cake, ShoppingBag, Percent, Sparkles, MessageCircle, ShieldCheck } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useExpiryAlerts, ExpiryAlert } from "../hooks/useExpiryAlerts";
import { useSalesNotifications, SalesMilestone, WeeklyInsight } from "../hooks/useSalesNotifications";
import { useSubscriptionAlert } from "../hooks/useSubscriptionAlert";
import { useCrmNotifications } from "../hooks/useCrmNotifications";
import { formatMoney } from "../lib/api";
import { api } from "../services/api";
import { temRespostaNaoVista, marcarComoVista } from "../lib/supportSeen";
import { AnimatePresence, motion } from "framer-motion";

interface Promocao {
  id: string;
  title: string;
  message: string;
  discount_percent: number;
  discount_amount: number;
}
interface Novidade {
  id: number;
  titulo: string;
  corpo: string;
}
interface Ticket {
  id: string;
  subject: string;
  status: string;
  updated_at: string;
  last_message_sender?: string;
  last_message_preview?: string;
}

// Guarda o que já foi visto — mesmo padrão simples que o PromotionBanner
// já usa (localStorage, sem precisar de tabela nova de "lido/não lido" no
// backend só pra isto).
const VISTOS_KEY = "novidades_promocoes_vistos";
function jaFoiVisto(id: string): boolean {
  try {
    return (JSON.parse(localStorage.getItem(VISTOS_KEY) || "[]") as string[]).includes(id);
  } catch {
    return false;
  }
}
function marcarComoVisto(ids: string[]) {
  try {
    const vistos: string[] = JSON.parse(localStorage.getItem(VISTOS_KEY) || "[]");
    localStorage.setItem(VISTOS_KEY, JSON.stringify([...new Set([...vistos, ...ids])].slice(-100)));
  } catch { /* localStorage indisponível não é motivo pra quebrar a tela */ }
}

function formatDaysLeft(days: number): string {
  if (days <= 0) return "Vencido!";
  if (days === 1) return "Vence amanhã";
  return `${days} dias`;
}

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString("pt-BR");
}

export default function NotificationBell() {
  const navigate = useNavigate();
  const { alerts: expiryAlerts, totalCount: expiryCount, criticalCount } = useExpiryAlerts();
  const { milestones, weeklyInsight, notificationCount: salesCount, dismissMilestone } = useSalesNotifications();
  const { subscriptionAlert } = useSubscriptionAlert();
  const { crmItens } = useCrmNotifications();

  const [open, setOpen] = useState(false);
  const [activeTab, setActiveTab] = useState<"all" | "expiry" | "sales" | "promocoes" | "novidades" | "suporte">("all");
  const ref = useRef<HTMLDivElement>(null);

  const [promocoes, setPromocoes] = useState<Promocao[]>([]);
  const [novidades, setNovidades] = useState<Novidade[]>([]);
  const [tickets, setTickets] = useState<Ticket[]>([]);

  useEffect(() => {
    api.get("promotions/active/").then((r) => setPromocoes(r.data || [])).catch(() => {});
    api.get("ajuda/?tipo=novidade").then((r) => setNovidades(r.data || [])).catch(() => {});
    api.get("chat/support/conversations/").then((r) => setTickets(r.data || [])).catch(() => {});
  }, []);

  const promocoesNaoVistas = promocoes.filter((p) => !jaFoiVisto(`promo-${p.id}`));
  const novidadesNaoVistas = novidades.filter((n) => !jaFoiVisto(`novidade-${n.id}`));
  const ticketsComRespostaNova = tickets.filter((t) => temRespostaNaoVista(t.id, t.updated_at, t.last_message_sender));

  const salesMilestonesEnabled = localStorage.getItem("notif_sales_milestones") !== "false";
  const weeklyInsightsEnabled = localStorage.getItem("notif_weekly_insights") !== "false";
  const expiryEnabled = localStorage.getItem("notif_expiry_alerts") !== "false";

  const filteredMilestones = salesMilestonesEnabled ? milestones : [];
  const filteredWeekly = weeklyInsightsEnabled ? weeklyInsight : null;
  const filteredExpiry = expiryEnabled ? expiryAlerts : [];
  const filteredExpiryCount = expiryEnabled ? expiryCount : 0;
  const filteredCritical = expiryEnabled ? criticalCount : 0;
  const filteredSalesCount = filteredMilestones.length + (filteredWeekly ? 1 : 0);
  const subCount = subscriptionAlert ? 1 : 0;
  const totalCount = filteredExpiryCount + filteredSalesCount + subCount + crmItens.length + promocoesNaoVistas.length + novidadesNaoVistas.length + ticketsComRespostaNova.length;

  // Ao abrir o painel, tudo que está em "Promoções"/"Novidades" nesse
  // momento vira "visto" — mesmo padrão de qualquer central de
  // notificação (não fica marcado como novo pra sempre só por ter existido).
  useEffect(() => {
    if (open && (promocoes.length > 0 || novidades.length > 0)) {
      marcarComoVisto([...promocoes.map((p) => `promo-${p.id}`), ...novidades.map((n) => `novidade-${n.id}`)]);
    }
  }, [open, promocoes, novidades]);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    if (open) document.addEventListener("mousedown", handler);
    return () => document.removeEventListener("mousedown", handler);
  }, [open]);

  if (totalCount === 0) {
    return (
      <div
        className="relative rounded-lg p-2 text-muted-foreground/60"
        title="Nenhuma notificação no momento"
        aria-label="Nenhuma notificação"
      >
        <Bell className="h-5 w-5" />
      </div>
    );
  }

  const hasCritical = filteredCritical > 0 || subscriptionAlert?.expired === true;

  return (
    <div ref={ref} className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="relative rounded-lg p-2 text-muted-foreground hover:bg-brand-soft hover:text-brand transition-colors"
      >
        <Bell className="h-5 w-5" />
        <span
          className={`absolute -right-0.5 -top-0.5 flex h-5 w-5 items-center justify-center rounded-full text-[10px] font-bold text-white ${
            hasCritical
              ? "bg-destructive"
              : filteredMilestones.length > 0
              ? "bg-brand"
              : "bg-brand-rose"
          }`}
        >
          {totalCount > 9 ? "9+" : totalCount}
        </span>
        {hasCritical && (
          <span className="absolute -right-0.5 -top-0.5 h-5 w-5 animate-ping rounded-full bg-destructive/40" />
        )}
      </button>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, y: -8, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: -8, scale: 0.95 }}
            transition={{ duration: 0.15 }}
            className="absolute right-0 top-12 z-50 w-[calc(100vw-2rem)] max-w-[340px] rounded-xl border border-brand/15 bg-card shadow-xl"
          >
            {/* Header */}
            <div className="flex items-center justify-between border-b border-brand-peach/30 px-4 py-3">
              <div className="flex items-center gap-2">
                <Bell className="h-4 w-4 text-brand" />
                <h3 className="text-sm font-semibold text-foreground">Notificações</h3>
                <span className="rounded-full bg-brand/10 px-2 py-0.5 text-[10px] font-bold text-brand">
                  {totalCount}
                </span>
              </div>
              <button
                onClick={() => setOpen(false)}
                className="rounded-lg p-1 text-muted-foreground hover:text-foreground"
              >
                <X className="h-4 w-4" />
              </button>
            </div>

            {/* Tabs — rolagem horizontal porque com Promoções/Novidades
                juntas já são 5 abas, apertado demais pra dividir em partes
                iguais (flex-1) num painel de 340px. */}
            <div className="flex overflow-x-auto border-b border-brand-peach/30">
              {([
                { key: "all" as const, label: "Tudo", count: totalCount },
                { key: "sales" as const, label: "Vendas", count: filteredSalesCount },
                { key: "expiry" as const, label: "Validade", count: filteredExpiryCount },
                { key: "promocoes" as const, label: "Promoções", count: promocoesNaoVistas.length },
                { key: "novidades" as const, label: "Novidades", count: novidadesNaoVistas.length },
                { key: "suporte" as const, label: "Suporte", count: ticketsComRespostaNova.length },
              ]).map((tab) => (
                <button
                  key={tab.key}
                  onClick={() => setActiveTab(tab.key)}
                  className={`shrink-0 px-3 py-2 text-xs font-medium transition-colors ${
                    activeTab === tab.key
                      ? "border-b-2 border-brand text-brand"
                      : "text-brand-rose/70 hover:text-foreground"
                  }`}
                >
                  {tab.label}{" "}
                  {tab.count > 0 && (
                    <span className="ml-1 opacity-60">({tab.count})</span>
                  )}
                </button>
              ))}
            </div>

            {/* Content */}
            <div className="max-h-96 overflow-y-auto">
              {/* Assinatura vencendo/vencida — sempre no topo */}
              {subscriptionAlert && (
                <SubscriptionAlertItem
                  alert={subscriptionAlert}
                  onNavigate={() => {
                    setOpen(false);
                    navigate("/plans");
                  }}
                />
              )}

              {/* CRM: novos clientes, aniversários, carrinho abandonado —
                  todas levam para a central de clientes. */}
              {crmItens.map((item) => (
                <CrmNotificationItem
                  key={item.key}
                  item={item}
                  onNavigate={() => {
                    setOpen(false);
                    navigate("/crm");
                  }}
                />
              ))}

              {/* Milestones */}
              {(activeTab === "all" || activeTab === "sales") &&
                filteredMilestones.map((m) => (
                  <MilestoneItem
                    key={m.id}
                    milestone={m}
                    onDismiss={() => dismissMilestone(m.value)}
                    onNavigate={() => {
                      setOpen(false);
                      navigate("/dashboard");
                    }}
                  />
                ))}

              {/* Weekly insight */}
              {(activeTab === "all" || activeTab === "sales") && filteredWeekly && (
                <WeeklyInsightItem
                  insight={filteredWeekly}
                  onNavigate={() => {
                    setOpen(false);
                    navigate("/dashboard");
                  }}
                />
              )}

              {/* Expiry alerts */}
              {(activeTab === "all" || activeTab === "expiry") &&
                filteredExpiry
                  .slice(0, activeTab === "expiry" ? 15 : 5)
                  .map((alert) => (
                    <ExpiryAlertItem
                      key={alert.id}
                      alert={alert}
                      onNavigate={() => {
                        setOpen(false);
                        navigate(`/products/${alert.id}/edit`);
                      }}
                    />
                  ))}

              {/* Promoções — só na aba própria, "Tudo" não mistura (já
                  existe o PromotionBanner pra dar destaque na tela
                  principal; aqui é o histórico completo). */}
              {activeTab === "promocoes" &&
                promocoes.map((p) => <PromocaoItem key={p.id} promocao={p} />)}

              {/* Novidades */}
              {activeTab === "novidades" &&
                novidades.map((n) => (
                  <NovidadeItem
                    key={n.id}
                    novidade={n}
                    onNavigate={() => {
                      setOpen(false);
                      navigate("/support");
                    }}
                  />
                ))}

              {/* Suporte — conversas com resposta da equipe */}
              {activeTab === "suporte" &&
                tickets.map((t) => (
                  <TicketItem
                    key={t.id}
                    ticket={t}
                    onNavigate={() => {
                      setOpen(false);
                      marcarComoVista(t.id, t.updated_at);
                      navigate("/support");
                    }}
                  />
                ))}

              {/* Empty states */}
              {activeTab === "sales" && filteredSalesCount === 0 && (
                <div className="px-4 py-8 text-center text-xs text-brand-rose/60">
                  Nenhuma notificação de vendas
                </div>
              )}
              {activeTab === "expiry" && filteredExpiryCount === 0 && (
                <div className="px-4 py-8 text-center text-xs text-brand-rose/60">
                  Nenhum alerta de validade
                </div>
              )}
              {activeTab === "promocoes" && promocoes.length === 0 && (
                <div className="px-4 py-8 text-center text-xs text-brand-rose/60">
                  Nenhuma promoção ativa no momento
                </div>
              )}
              {activeTab === "novidades" && novidades.length === 0 && (
                <div className="px-4 py-8 text-center text-xs text-brand-rose/60">
                  Nenhuma novidade por aqui ainda
                </div>
              )}
              {activeTab === "suporte" && tickets.length === 0 && (
                <div className="px-4 py-8 text-center text-xs text-brand-rose/60">
                  Nenhuma conversa de suporte ainda
                </div>
              )}
            </div>

            {/* Footer */}
            <div className="border-t border-brand-peach/30 px-4 py-2">
              <button
                onClick={() => {
                  setOpen(false);
                  navigate("/settings");
                }}
                className="w-full text-center text-xs text-brand hover:underline"
              >
                Gerenciar notificações
              </button>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}

// ── Milestone Item ──
function MilestoneItem({
  milestone,
  onDismiss,
  onNavigate,
}: {
  milestone: SalesMilestone;
  onDismiss: () => void;
  onNavigate: () => void;
}) {
  const IconMap = { trophy: Trophy, star: Star, flame: Flame };
  const Icon = IconMap[milestone.icon];

  return (
    <div className="flex items-center gap-3 bg-brand-soft px-4 py-3 border-b border-brand-peach/30">
      <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-brand/10">
        <Icon className="h-5 w-5 text-brand" />
      </div>
      <button onClick={onNavigate} className="min-w-0 flex-1 text-left">
        <p className="text-sm font-semibold text-foreground">{milestone.title}</p>
        <p className="text-[11px] text-brand-rose/70">{milestone.description}</p>
      </button>
      <button
        onClick={onDismiss}
        className="shrink-0 rounded-lg p-1 text-brand-rose/50 hover:text-foreground"
        title="Dispensar"
      >
        <X className="h-3.5 w-3.5" />
      </button>
    </div>
  );
}

// ── Weekly Insight Item ──
function WeeklyInsightItem({
  insight,
  onNavigate,
}: {
  insight: WeeklyInsight;
  onNavigate: () => void;
}) {
  return (
    <button
      onClick={onNavigate}
      className="w-full border-b border-brand-peach/30 px-4 py-3 text-left transition-colors hover:bg-brand-soft/50"
    >
      <div className="flex items-center gap-2 mb-2">
        <TrendingUp className="h-4 w-4 text-brand" />
        <span className="text-sm font-semibold text-foreground">{insight.title}</span>
      </div>
      <div className="space-y-1.5">
        {insight.products.map((p, i) => (
          <div key={p.barcode} className="flex items-center gap-2">
            <span
              className={`flex h-5 w-5 items-center justify-center rounded-full text-[10px] font-bold ${
                i === 0
                  ? "bg-brand-peach/50 text-brand"
                  : "bg-brand-lavender/30 text-brand-rose"
              }`}
            >
              {i + 1}
            </span>
            <span className="flex-1 truncate text-xs text-foreground">
              {p.product_name}
            </span>
            <span className="text-[10px] font-mono text-brand-rose/70">
              {p.totalQty} un.
            </span>
            {p.totalRevenue > 0 && (
              <span className="text-[10px] font-mono font-medium text-brand">
                {formatMoney(p.totalRevenue)}
              </span>
            )}
          </div>
        ))}
      </div>
    </button>
  );
}

// ── Expiry Alert Item ──
function CrmNotificationItem({
  item, onNavigate,
}: {
  item: { tipo: string; titulo: string; descricao: string };
  onNavigate: () => void;
}) {
  const Icone = item.tipo === "novo_lead" ? Users
    : item.tipo === "aniversario" ? Cake
    : ShoppingBag;
  return (
    <button
      onClick={onNavigate}
      className="flex w-full items-center gap-3 border-b border-brand-peach/30 px-4 py-3 text-left transition-colors hover:bg-brand-soft/50"
    >
      <Icone className="h-4 w-4 shrink-0 text-brand" />
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-medium text-foreground">{item.titulo}</p>
        <p className="mt-0.5 truncate text-xs text-muted-foreground">{item.descricao}</p>
      </div>
      <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground" />
    </button>
  );
}

function SubscriptionAlertItem({
  alert,
  onNavigate,
}: {
  alert: { daysLeft: number; expired: boolean; expiresAt: string | null };
  onNavigate: () => void;
}) {
  const venceEm = alert.expiresAt
    ? new Date(alert.expiresAt).toLocaleDateString("pt-BR")
    : null;

  const titulo = alert.expired
    ? "Sua assinatura PRO venceu"
    : alert.daysLeft <= 1
    ? "Sua assinatura vence amanhã"
    : `Sua assinatura vence em ${alert.daysLeft} dias`;

  const descricao = alert.expired
    ? "Renove para não perder os recursos PRO"
    : venceEm
    ? `Renove até ${venceEm} para continuar`
    : "Renove para continuar com o PRO";

  return (
    <button
      onClick={onNavigate}
      className={`flex w-full items-center gap-3 border-b border-brand-peach/30 px-4 py-3 text-left transition-colors hover:bg-brand-soft/50 ${
        alert.expired ? "bg-destructive/5" : "bg-brand/5"
      }`}
    >
      <div className="shrink-0">
        {alert.expired ? (
          <AlertTriangle className="h-4 w-4 text-destructive" />
        ) : (
          <Crown className="h-4 w-4 text-brand" />
        )}
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-medium text-foreground">{titulo}</p>
        <p className="mt-0.5 truncate text-xs text-muted-foreground">{descricao}</p>
      </div>
      <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground" />
    </button>
  );
}

function ExpiryAlertItem({
  alert,
  onNavigate,
}: {
  alert: ExpiryAlert;
  onNavigate: () => void;
}) {
  const isCritical = alert.severity === "critical";

  return (
    <button
      onClick={onNavigate}
      className={`flex w-full items-center gap-3 px-4 py-3 text-left transition-colors hover:bg-brand-soft/50 ${
        isCritical ? "bg-destructive/5" : "bg-brand-peach/20"
      }`}
    >
      <div className="shrink-0">
        {isCritical ? (
          <AlertTriangle className="h-4 w-4 text-destructive" />
        ) : (
          <Clock className="h-4 w-4 text-brand-rose" />
        )}
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-medium text-foreground">
          {alert.product_name}
        </p>
        <div className="mt-0.5 flex items-center gap-2">
          <span
            className={`rounded-full border px-1.5 py-0.5 text-[10px] font-semibold ${
              isCritical
                ? "bg-destructive/10 text-destructive border-destructive/20"
                : "bg-brand-peach/40 text-brand-rose border-brand-peach"
            }`}
          >
            {formatDaysLeft(alert.daysLeft)}
          </span>
          <span className="text-[10px] text-brand-rose/60">
            {formatDate(alert.expiry_date)}
          </span>
        </div>
      </div>
      <ChevronRight className="h-4 w-4 shrink-0 text-brand-rose/40" />
    </button>
  );
}
// ── Promoção Item ──
function PromocaoItem({ promocao }: { promocao: Promocao }) {
  const desconto =
    promocao.discount_percent > 0
      ? `${promocao.discount_percent}% OFF`
      : promocao.discount_amount > 0
      ? `${formatMoney(Number(promocao.discount_amount))} OFF`
      : null;

  return (
    <div className="flex items-start gap-3 border-b border-brand-peach/30 bg-brand-peach/10 px-4 py-3">
      <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-brand/10">
        <Percent className="h-5 w-5 text-brand" />
      </div>
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <p className="truncate text-sm font-semibold text-foreground">{promocao.title}</p>
          {desconto && (
            <span className="shrink-0 rounded-full bg-brand px-1.5 py-0.5 text-[10px] font-bold text-white">{desconto}</span>
          )}
        </div>
        <p className="mt-0.5 line-clamp-2 text-[11px] text-brand-rose/70">{promocao.message}</p>
      </div>
    </div>
  );
}

// ── Novidade Item ──
function NovidadeItem({ novidade, onNavigate }: { novidade: Novidade; onNavigate: () => void }) {
  return (
    <button onClick={onNavigate} className="flex w-full items-start gap-3 border-b border-brand-peach/30 px-4 py-3 text-left transition-colors hover:bg-brand-soft/50">
      <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-brand/10">
        <Sparkles className="h-5 w-5 text-brand" />
      </div>
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm font-semibold text-foreground">{novidade.titulo}</p>
        <p className="mt-0.5 line-clamp-2 text-[11px] text-brand-rose/70">{novidade.corpo}</p>
      </div>
      <ChevronRight className="h-4 w-4 shrink-0 text-brand-rose/40" />
    </button>
  );
}
// ── Ticket de Suporte Item ──
function TicketItem({ ticket, onNavigate }: { ticket: Ticket; onNavigate: () => void }) {
  const naoVista = temRespostaNaoVista(ticket.id, ticket.updated_at, ticket.last_message_sender);

  return (
    <button
      onClick={onNavigate}
      className={`flex w-full items-start gap-3 border-b border-brand-peach/30 px-4 py-3 text-left transition-colors hover:bg-brand-soft/50 ${naoVista ? "bg-brand/5" : ""}`}
    >
      <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-brand/10">
        <ShieldCheck className="h-5 w-5 text-brand" />
      </div>
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-1.5">
          <p className="truncate text-sm font-semibold text-foreground">{ticket.subject || "Conversa de suporte"}</p>
          {naoVista && <span className="h-1.5 w-1.5 shrink-0 rounded-full bg-destructive" />}
        </div>
        <p className="mt-0.5 line-clamp-2 text-[11px] text-brand-rose/70">
          {ticket.last_message_sender === "admin" && <span className="font-medium">Equipe: </span>}
          {ticket.last_message_preview || "—"}
        </p>
      </div>
      <ChevronRight className="h-4 w-4 shrink-0 text-brand-rose/40" />
    </button>
  );
}