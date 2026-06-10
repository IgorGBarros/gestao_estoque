// pages/Plans.tsx — VERSÃO REFATORADA COM TEMA DINÂMICO
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  ArrowLeft, Crown, Check, X, Sparkles,
  CreditCard, ExternalLink, MessageCircle, QrCode, Loader2,
} from "lucide-react";
import { usePlan } from "../hooks/usePlan";
import { useAuth } from "../hooks/useAuth";
import { useToast } from '../components/ui/use-toast'; // ✅ Importar useToast original para evitar dependência circular

type BillingCycle = "monthly" | "yearly";
type PaymentMethod = "stripe" | "link" | "pix" | "whatsapp";

const MONTHLY_PRICE = 39.9;
const YEARLY_PRICE = 399.0;
const YEARLY_SAVINGS = (MONTHLY_PRICE * 12 - YEARLY_PRICE).toFixed(2).replace(".", ",");

const FREE_FEATURES = [
  { text: "Até 50 produtos", included: true },
  { text: "Cadastro e baixa de estoque", included: true },
  { text: "Relatórios básicos", included: true },
  { text: "Vitrine online", included: false },
  { text: "Scanner de validade (OCR)", included: false },
  { text: "Alertas de vencimento", included: false },
  { text: "Histórico completo", included: false },
  { text: "Analytics avançado", included: false },
  { text: "Assistente IA", included: false },
];

const PRO_FEATURES = [
  { text: "Produtos ilimitados", included: true },
  { text: "Cadastro e baixa de estoque", included: true },
  { text: "Relatórios completos", included: true },
  { text: "Vitrine online personalizada", included: true },
  { text: "Scanner de validade (OCR)", included: true },
  { text: "Alertas de vencimento", included: true },
  { text: "Histórico completo", included: true },
  { text: "Analytics avançado", included: true },
  { text: "Assistente IA", included: true },
];

const ADMIN_WHATSAPP = "5511999999999";

export default function Plans() {
  const navigate = useNavigate();
  const { isPro } = usePlan();
  const { user } = useAuth();
  const { toast } = useToast();

  const [billing, setBilling] = useState<BillingCycle>("monthly");
  const [selectedMethod, setSelectedMethod] = useState<PaymentMethod | null>(null);
  const [processing, setProcessing] = useState(false);

  const currentPrice = billing === "monthly" ? MONTHLY_PRICE : YEARLY_PRICE;
  const priceDisplay = currentPrice.toFixed(2).replace(".", ",");
  const perMonthYearly = (YEARLY_PRICE / 12).toFixed(2).replace(".", ",");

  const handlePayment = async (method: PaymentMethod) => {
    setSelectedMethod(method);
    setProcessing(true);
    const planLabel = billing === "monthly" ? "Mensal" : "Anual";
    const priceLabel = `R$ ${priceDisplay}`;

    try {
      switch (method) {
        case "stripe": {
          toast({
            title: "Stripe em configuração",
            description:
              "O checkout por cartão será habilitado em breve. Use outro método por enquanto.",
          });
          break;
        }
        case "link": {
          const checkoutUrl = localStorage.getItem("admin_checkout_url");
          if (checkoutUrl) {
            window.open(checkoutUrl, "_blank");
          } else {
            toast({
              title: "Link não configurado",
              description:
                "O administrador ainda não configurou o link de checkout externo.",
              variant: "destructive",
            });
          }
          break;
        }
        case "pix": {
          toast({
            title: "PIX - Dados para pagamento",
            description: `Plano PRO ${planLabel}: ${priceLabel}. Envie o comprovante pelo WhatsApp para ativação.`,
          });
          const pixMsg = encodeURIComponent(
            `Olá! Quero assinar o plano PRO ${planLabel} (${priceLabel}). Segue meu comprovante PIX.\n\nEmail: ${user?.email || ""}`
          );
          window.open(`https://wa.me/${ADMIN_WHATSAPP}?text=${pixMsg}`, "_blank");
          break;
        }
        case "whatsapp": {
          const msg = encodeURIComponent(
            `Olá! Tenho interesse no plano PRO ${planLabel} (${priceLabel}).\n\nEmail: ${user?.email || ""}\nComo faço para assinar?`
          );
          window.open(`https://wa.me/${ADMIN_WHATSAPP}?text=${msg}`, "_blank");
          break;
        }
      }
    } catch (err: any) {
      toast({ title: "Erro", description: err.message, variant: "destructive" });
    } finally {
      setProcessing(false);
      setSelectedMethod(null);
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* ══════════════════════════════════════════
          HEADER
          ══════════════════════════════════════════ */}
      <header className="border-b border-border bg-card">
        <div className="mx-auto flex max-w-2xl items-center gap-3 px-6 py-4">
          <button
            onClick={() => navigate("/profile")}
            className="rounded-lg p-2 text-muted-foreground hover:text-foreground"
          >
            <ArrowLeft className="h-5 w-5" />
          </button>
          <h1 className="font-display text-lg font-bold text-foreground">
            Planos & Preços
          </h1>
        </div>
      </header>

      <main className="mx-auto max-w-2xl px-6 py-8 space-y-8">
        {/* ══════════════════════════════════════════
            BANNER PRO ATIVO
            ══════════════════════════════════════════ */}
        {isPro && (
          <div className="rounded-xl border border-brand/30 bg-brand/5 p-4 flex items-center gap-3">
            <Crown className="h-5 w-5 text-brand shrink-0" />
            <div>
              <p className="text-sm font-semibold text-foreground">Você já é PRO! 🎉</p>
              <p className="text-xs text-muted-foreground">
                Aproveite todos os recursos premium do sistema.
              </p>
            </div>
          </div>
        )}

        {/* ══════════════════════════════════════════
            BILLING TOGGLE
            ══════════════════════════════════════════ */}
        <div className="flex items-center justify-center gap-3">
          <button
            onClick={() => setBilling("monthly")}
            className={`rounded-xl px-5 py-2.5 text-sm font-semibold transition-all ${
              billing === "monthly"
                ? "bg-brand text-white shadow-md"
                : "bg-secondary text-muted-foreground hover:text-foreground"
            }`}
          >
            Mensal
          </button>
          <button
            onClick={() => setBilling("yearly")}
            className={`rounded-xl px-5 py-2.5 text-sm font-semibold transition-all relative ${
              billing === "yearly"
                ? "bg-brand text-white shadow-md"
                : "bg-secondary text-muted-foreground hover:text-foreground"
            }`}
          >
            Anual
            <span className="absolute -top-2 -right-2 rounded-full bg-success px-2 py-0.5 text-[9px] font-bold text-white">
              -17%
            </span>
          </button>
        </div>

        {/* ══════════════════════════════════════════
            PLANS GRID
            ══════════════════════════════════════════ */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {/* FREE Plan */}
          <div className="rounded-2xl border border-border bg-card p-6 space-y-5">
            <div>
              <h2 className="font-display text-xl font-bold text-foreground">Free</h2>
              <p className="text-xs text-muted-foreground mt-1">
                Para começar a organizar seu estoque
              </p>
            </div>
            <div className="flex items-baseline gap-1">
              <span className="text-3xl font-bold text-foreground">R$ 0</span>
              <span className="text-sm text-muted-foreground">/mês</span>
            </div>
            <button
              disabled={!isPro}
              className="w-full rounded-xl border border-border py-3 text-sm font-semibold text-muted-foreground bg-secondary/50 cursor-default"
            >
              {isPro ? "Seu plano anterior" : "Plano atual"}
            </button>
            <ul className="space-y-2.5">
              {FREE_FEATURES.map((f) => (
                <li key={f.text} className="flex items-center gap-2 text-sm">
                  {f.included ? (
                    <Check className="h-4 w-4 text-brand shrink-0" />
                  ) : (
                    <X className="h-4 w-4 text-muted-foreground/40 shrink-0" />
                  )}
                  <span
                    className={
                      f.included ? "text-foreground" : "text-muted-foreground/50"
                    }
                  >
                    {f.text}
                  </span>
                </li>
              ))}
            </ul>
          </div>

          {/* PRO Plan */}
          <div className="rounded-2xl border-2 border-brand bg-card p-6 space-y-5 relative overflow-hidden">
            <div className="absolute top-0 right-0 bg-brand text-white px-3 py-1 text-[10px] font-bold uppercase rounded-bl-xl">
              Popular
            </div>
            <div>
              <h2 className="font-display text-xl font-bold text-foreground flex items-center gap-2">
                <Sparkles className="h-5 w-5 text-brand" /> PRO
              </h2>
              <p className="text-xs text-muted-foreground mt-1">
                Tudo que você precisa para crescer
              </p>
            </div>
            <div>
              <div className="flex items-baseline gap-1">
                <span className="text-3xl font-bold text-foreground">
                  R$ {billing === "monthly" ? "39,90" : perMonthYearly}
                </span>
                <span className="text-sm text-muted-foreground">/mês</span>
              </div>
              {billing === "yearly" && (
                <div className="mt-1 space-y-0.5">
                  <p className="text-xs text-muted-foreground">
                    Cobrado{" "}
                    <strong className="text-foreground">R$ {priceDisplay}/ano</strong>
                  </p>
                  <p className="text-xs text-brand font-semibold">
                    Economia de R$ {YEARLY_SAVINGS}
                  </p>
                </div>
              )}
            </div>
            {isPro ? (
              <div className="w-full rounded-xl bg-brand/10 border border-brand/30 py-3 text-center text-sm font-semibold text-brand">
                ✓ Plano ativo
              </div>
            ) : (
              <div className="text-xs text-muted-foreground text-center py-1">
                Escolha como pagar abaixo ↓
              </div>
            )}
            <ul className="space-y-2.5">
              {PRO_FEATURES.map((f) => (
                <li key={f.text} className="flex items-center gap-2 text-sm">
                  <Check className="h-4 w-4 text-brand shrink-0" />
                  <span className="text-foreground">{f.text}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* ══════════════════════════════════════════
            PAYMENT METHODS
            ══════════════════════════════════════════ */}
        {!isPro && (
          <div className="space-y-4">
            <h3 className="font-display text-sm font-bold text-foreground text-center">
              Escolha a forma de pagamento
            </h3>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {/* Stripe / Card */}
              <button
                onClick={() => handlePayment("stripe")}
                disabled={processing}
                className="flex items-center gap-3 rounded-xl border border-border bg-card p-4 hover:border-brand/50 transition-all text-left group"
              >
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-brand/10 group-hover:bg-brand/20 transition-colors">
                  <CreditCard className="h-5 w-5 text-brand" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold text-foreground">Cartão de Crédito</p>
                  <p className="text-[10px] text-muted-foreground">
                    Via Stripe • Checkout seguro
                  </p>
                </div>
                {selectedMethod === "stripe" && processing ? (
                  <Loader2 className="h-4 w-4 animate-spin text-brand" />
                ) : (
                  <ExternalLink className="h-4 w-4 text-muted-foreground group-hover:text-brand transition-colors" />
                )}
              </button>

              {/* External Link */}
              <button
                onClick={() => handlePayment("link")}
                disabled={processing}
                className="flex items-center gap-3 rounded-xl border border-border bg-card p-4 hover:border-brand/50 transition-all text-left group"
              >
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-purple-500/10 group-hover:bg-purple-500/20 transition-colors">
                  <ExternalLink className="h-5 w-5 text-purple-500" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold text-foreground">Link de Pagamento</p>
                  <p className="text-[10px] text-muted-foreground">
                    Hotmart, Kiwify ou similar
                  </p>
                </div>
                {selectedMethod === "link" && processing ? (
                  <Loader2 className="h-4 w-4 animate-spin text-purple-500" />
                ) : (
                  <ExternalLink className="h-4 w-4 text-muted-foreground group-hover:text-purple-500 transition-colors" />
                )}
              </button>

              {/* PIX */}
              <button
                onClick={() => handlePayment("pix")}
                disabled={processing}
                className="flex items-center gap-3 rounded-xl border border-border bg-card p-4 hover:border-brand/50 transition-all text-left group"
              >
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-success/10 group-hover:bg-success/20 transition-colors">
                  <QrCode className="h-5 w-5 text-success" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold text-foreground">PIX</p>
                  <p className="text-[10px] text-muted-foreground">
                    Pagamento instantâneo • Envie comprovante
                  </p>
                </div>
                {selectedMethod === "pix" && processing ? (
                  <Loader2 className="h-4 w-4 animate-spin text-success" />
                ) : (
                  <QrCode className="h-4 w-4 text-muted-foreground group-hover:text-success transition-colors" />
                )}
              </button>

              {/* WhatsApp */}
              <button
                onClick={() => handlePayment("whatsapp")}
                disabled={processing}
                className="flex items-center gap-3 rounded-xl border border-border bg-card p-4 hover:border-brand/50 transition-all text-left group"
              >
                <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-success/10 group-hover:bg-success/20 transition-colors">
                  <MessageCircle className="h-5 w-5 text-success" />
                </div>
                <div className="flex-1">
                  <p className="text-sm font-semibold text-foreground">WhatsApp</p>
                  <p className="text-[10px] text-muted-foreground">
                    Fale com o suporte para assinar
                  </p>
                </div>
                {selectedMethod === "whatsapp" && processing ? (
                  <Loader2 className="h-4 w-4 animate-spin text-success" />
                ) : (
                  <MessageCircle className="h-4 w-4 text-muted-foreground group-hover:text-success transition-colors" />
                )}
              </button>
            </div>
            <p className="text-center text-[10px] text-muted-foreground">
              Após o pagamento, seu plano será ativado em até 24h (PIX/WhatsApp) ou
              instantaneamente (cartão/link).
            </p>
          </div>
        )}

        {/* ══════════════════════════════════════════
            FAQ
            ══════════════════════════════════════════ */}
        <div className="space-y-3">
          <h3 className="font-display text-sm font-bold text-foreground text-center">
            Perguntas Frequentes
          </h3>
          {[
            {
              q: "Posso cancelar a qualquer momento?",
              a: "Sim! Sem multa ou fidelidade. O acesso PRO continua até o fim do período pago.",
            },
            {
              q: "O pagamento é seguro?",
              a: "Sim! Usamos provedores certificados (Stripe, Hotmart, etc.) para processar pagamentos com total segurança.",
            },
            {
              q: "Quando meu plano PRO é ativado?",
              a: "Pagamentos por cartão são instantâneos. PIX e WhatsApp podem levar até 24h para ativação manual.",
            },
            {
              q: "E se eu ultrapassar 50 produtos no Free?",
              a: "Você precisará remover produtos ou fazer upgrade para o PRO para adicionar novos.",
            },
          ].map((faq) => (
            <div key={faq.q} className="rounded-xl border border-border bg-card p-4">
              <p className="text-sm font-semibold text-foreground">{faq.q}</p>
              <p className="text-xs text-muted-foreground mt-1">{faq.a}</p>
            </div>
          ))}
        </div>
      </main>
    </div>
  );
}