// pages/Index.tsx — VERSÃO SEGURA E OTIMIZADA
import { useNavigate, useSearchParams } from "react-router-dom";
import { useEffect, useState, useRef } from "react";
import {
  Package, TrendingDown, DollarSign, BarChart3, ScanBarcode, List,
  ArrowDownCircle, Settings, PieChart, Store, History, User,
  Users, Compass,
} from "lucide-react";
import { statsApi, profileApi } from "../lib/api";
import { api } from "../services/api";
import { useAuth } from "../hooks/useAuth";
import { useFeatureGates } from "../hooks/useFeatureGates";
import { ChatAssistant } from "../components/ChatAssistant";
import NotificationBell from "../components/NotificationBell";
import { OnboardingTour } from "../components/OnboardingTour";
import ProBadge from "../components/ProBadge";
import UpgradeModal from "../components/UpgradeModal";
import ProfileCompletionBanner from "../components/ProfileCompletionBanner";
import amorinhaAvatar from "../assets/amorinha-avatar.png";
import AiTrainingConsentBanner from "@/components/AitrainingConsentBanner";
import { useSystemConfig } from "../hooks/useSystemConfig";

interface Stats {
  investedValue: number;
  potentialValue: number;
  projectedProfit: number;
  monthSales: number;
  monthProfit: number;
}

export default function Index() {
  const navigate = useNavigate();
  const [, setSearchParams] = useSearchParams();
  const { user, refreshProfile } = useAuth();
  const { isLocked, loading: gatesLoading } = useFeatureGates();
  const { aiEnabled } = useSystemConfig();
  const [stats, setStats] = useState<Stats>({
    investedValue: 0,
    potentialValue: 0,
    projectedProfit: 0,
    monthSales: 0,
    monthProfit: 0,
  });
  const [loading, setLoading] = useState(true);
  const [showTour, setShowTour] = useState(false);
  const tourInicializado = useRef(false);
  const [showUpgrade, setShowUpgrade] = useState(false);
  const [upgradeCtx, setUpgradeCtx] = useState({ feature: "", description: "" });
  const [storeSlug, setStoreSlug] = useState<string | null>(null);

  // 🧭 Mostra o tour sozinho na primeira vez (onboarding_completed ainda
  // false), ou sob demanda quando vem da Central de Ajuda com ?tour=1 —
  // nesse segundo caso, mostra de novo mesmo já tendo sido concluído.
  //
  // ⚠️ CORREÇÃO: a versão anterior usava useState pro "já decidiu" e
  // colocava searchParams/setSearchParams no array de dependências — só
  // que o próprio efeito CHAMA setSearchParams (pra limpar o ?tour=1 da
  // URL), o que muda a referência de searchParams, o que podia disparar
  // o efeito de novo antes do primeiro ciclo assentar. Um useRef não
  // participa de array de dependência e não causa re-render — junto com
  // tirar searchParams/setSearchParams das dependências (só precisa ler
  // o valor UMA vez, no mount), a lógica fica bem mais previsível.
  useEffect(() => {
    if (tourInicializado.current) return;

    const forcarViaLink = new URLSearchParams(window.location.search).get("tour") === "1";

    if (forcarViaLink) {
      tourInicializado.current = true;
      setShowTour(true);
      // Limpa o parâmetro da URL pra não reabrir de novo num refresh manual.
      const params = new URLSearchParams(window.location.search);
      params.delete("tour");
      setSearchParams(params, { replace: true });
      return;
    }

    // ⚠️ Se 'user' ainda não carregou, NÃO marca como decidido — o efeito
    // roda de novo (sem custo, só checa a condição) assim que 'user'
    // chegar. Marcar cedo demais aqui faria o tour nunca aparecer pra
    // usuária genuinamente nova, porque a decisão "não precisa" seria
    // tomada com dado incompleto, antes do onboarding_completed real
    // estar disponível.
    if (!user) return;

    tourInicializado.current = true;
    if (user.onboarding_completed === false) {
      setShowTour(true);
    }
  }, [user]);

  const finalizarTour = () => {
    setShowTour(false);
    // ⚠️ CORREÇÃO: antes só persistia no backend, mas nunca atualizava o
    // `user` que já estava em memória no useAuth — como o Index.tsx
    // desmonta e remonta a cada troca de rota (o React perde todo o
    // estado local, incluindo `tourJaDecidido`), a checagem seguinte
    // sempre lia o valor ANTIGO de onboarding_completed (ainda false),
    // fazendo o tour reaparecer toda vez que voltava pro Index. Chamar
    // refreshProfile() aqui atualiza o `user` em memória (e no
    // localStorage) na hora, então a próxima checagem já vê o valor certo.
    profileApi.update({ onboarding_completed: true })
      .then(() => refreshProfile())
      .catch(() => {});
  };

  useEffect(() => {
    if (!user) return;

    // ✅ store_slug já vem no objeto `user` do useAuth (o login espalha o
    // profile inteiro nele) — não precisa de outra chamada a /profile/.
    // Era esta busca extra que disparava GET /profile/ toda vez que se
    // voltava para a home.
    setStoreSlug((user as any).store_slug ?? null);

    const fetchData = async () => {
      try {
        // statsApi.getDashboard() tem cache de 30s + deduplicação — voltar
        // pra home dentro da janela não gera requisição de rede.
        const statsRes = await statsApi.getDashboard();
        setStats(statsRes);
      } catch (err) {
        console.error("Erro ao carregar estatísticas:", err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
    // ✅ Depender de user?.id (primitivo), não do objeto inteiro: o useAuth
    // recria o objeto em vários momentos e isso re-disparava este efeito.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.id]);

  const fmt = (v: number) => `R$ ${v.toLocaleString("pt-BR", { minimumFractionDigits: 2 })}`;

  const statCards = [
    { label: "Valor Investido", value: fmt(stats.investedValue), icon: Package, color: "text-muted-foreground" },
    { label: "Potencial de Venda", value: fmt(stats.potentialValue), icon: DollarSign, color: "text-brand" },
    { label: "Lucro Estimado Geral", value: fmt(stats.projectedProfit), icon: BarChart3, color: "text-success" },
    { label: "Vendas deste Mês", value: fmt(stats.monthSales), icon: TrendingDown, color: "text-foreground" },
    { label: "Lucro Real do Mês", value: fmt(stats.monthProfit), icon: BarChart3, color: "text-success" },
  ];

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* ══ HEADER ══ */}
      <header className="sticky top-0 z-20 border-b border-border bg-card">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-full overflow-hidden border-2 border-brand/20 shadow-sm">
              <img
                src={amorinhaAvatar}
                alt="Minha Amora"
                className="h-full w-full object-cover"
                onError={(e) => {
                  const parent = (e.target as HTMLImageElement).parentElement!;
                  parent.innerHTML = '';
                  parent.className = "flex h-10 w-10 items-center justify-center rounded-full bg-brand shadow-sm";
                  const icon = document.createElement('span');
                  icon.textContent = '🍇';
                  icon.className = 'text-lg';
                  parent.appendChild(icon);
                }}
              />
            </div>
            <div>
              <h1 className="font-display text-lg font-bold text-foreground">Minha Amora</h1>
              <p className="text-xs text-muted-foreground">Gestão inteligente de estoque</p>
            </div>
          </div>

          <div className="flex items-center gap-1 relative">
            {/* ⚠️ CORREÇÃO: antes era um botão estático que sempre mostrava
                "Tudo tranquilo por aqui!", sem ligação com dado real
                nenhum. NotificationBell.tsx já existia pronto (alertas de
                validade, marcos de venda, assinatura, CRM) mas nunca
                tinha sido importado em lugar nenhum — só faltava plugar. */}
            {/* ⚠️ NOVO: atalho direto pro tour — antes só existia pelo
                caminho Perfil → Central de Ajuda → aba Guias (3 cliques
                pra achar). Aqui é 1 clique, e não precisa navegar pra
                lugar nenhum — chama o tour direto, já que estamos no
                Index de qualquer forma. */}
            <button
              onClick={() => setShowTour(true)}
              className="rounded-lg p-2 text-muted-foreground hover:bg-secondary hover:text-foreground transition-colors"
              title="Rever o tour rápido"
            >
              <Compass className="h-5 w-5" />
            </button>
            <span data-tour="notificacoes"><NotificationBell /></span>
            <button onClick={() => navigate("/profile")} className="rounded-lg p-2 text-muted-foreground hover:bg-secondary hover:text-foreground transition-colors">
              <User className="h-5 w-5" />
            </button>
            <button onClick={() => navigate("/settings")} className="rounded-lg p-2 text-muted-foreground hover:bg-secondary hover:text-foreground transition-colors">
              <Settings className="h-5 w-5" />
            </button>
          </div>
        </div>
      </header>

      {/* ══ MAIN ══ */}
      <main className="mx-auto max-w-6xl px-6 py-8 space-y-6">
        <ProfileCompletionBanner />
        <AiTrainingConsentBanner />

        {/* CARDS FINANCEIROS */}
        <div className="grid grid-cols-2 gap-3 lg:grid-cols-5">
          {statCards.map((stat) => (
            <div key={stat.label} className="rounded-xl border border-border bg-card p-5 transition-shadow hover:shadow-md">
              <div className="flex items-center justify-between mb-2">
                <span className="text-xs font-semibold uppercase text-muted-foreground">{stat.label}</span>
                <stat.icon className={`h-4 w-4 ${stat.color} opacity-70`} />
              </div>
              <p className={`font-display text-2xl font-bold ${stat.color}`}>
                {loading ? <span className="animate-pulse text-muted-foreground/50">R$ ...</span> : stat.value}
              </p>
            </div>
          ))}
        </div>

        {/* BOTÕES DE AÇÃO */}
        <div className="mt-8 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-5">
          <ActionBtn onClick={() => navigate("/add")} icon={ScanBarcode} label="Cadastrar" desc="Escanear entrada" primary tourId="cadastrar" />
          <ActionBtn onClick={() => navigate("/withdraw")} icon={ArrowDownCircle} label="Baixa" desc="Registrar saída" tourId="baixa" />
          <ActionBtn onClick={() => navigate("/products")} icon={List} label="Meu Estoque" desc="Lista completa" tourId="estoque" />
          <ActionBtn onClick={() => navigate("/history")} icon={History} label="Extrato" desc="Movimentações" />
          <ActionBtn onClick={() => navigate("/crm")} icon={Users} label="Meus Clientes" desc="Quem comprou na vitrine" tourId="crm" />
          {/* ⚠️ REMOVIDO (Etapa 3): botão de Ajuda que levava direto pra
              /support. O acesso à ajuda agora vive dentro do Profile
              (seção "Aprenda a usar" + link "Ver central de ajuda"),
              deixando o Index só com as ações do dia a dia de estoque. */}
          <ActionBtn
            onClick={() => {
              // Bloqueado: oferece o upgrade em vez de levar a uma tela que
              // vai negar o acesso.
              if (isLocked("dashboard_charts")) {
                setUpgradeCtx({ feature: "Dashboard", description: "Veja lucro real, fluxo de caixa e gráficos das suas vendas." });
                setShowUpgrade(true);
              } else {
                navigate("/dashboard");
              }
            }}
            icon={PieChart}
            label="Dashboard"
            desc="Gráficos e análises"
            proBadge={isLocked("dashboard_charts")}
            proBadgeLoading={gatesLoading}
            tourId="dashboard"
          />
          <ActionBtn
            onClick={() => {
              if (isLocked("storefront")) {
                setUpgradeCtx({ feature: "Vitrine Digital", description: "Crie sua loja online e venda pelo WhatsApp automaticamente." });
                setShowUpgrade(true);
              } else if (storeSlug) {
                window.open(`${window.location.origin}/vitrine/${storeSlug}`, "_blank");
              } else {
                navigate("/profile");
              }
            }}
            icon={Store}
            label="Vitrine"
            desc="Sua loja online"
            proBadge={isLocked("storefront")}
            proBadgeLoading={gatesLoading}
            tourId="vitrine"
          />
        </div>

        <div className="mt-10 text-center text-sm text-muted-foreground bg-brand-soft p-4 rounded-xl border border-brand/10">
          {gatesLoading ? (
            <div className="flex items-center justify-center gap-2 animate-pulse">
              <div className="h-6 w-6 rounded-full bg-brand/15" />
              <span className="h-3 w-48 rounded bg-brand/15" />
            </div>
          ) : !isLocked("chat_assistant") ? (
            <div className="flex items-center justify-center gap-2">
              <div className="h-6 w-6 rounded-full overflow-hidden border border-brand/20">
                <img src={amorinhaAvatar} alt="Amorinha" className="h-full w-full object-cover" />
              </div>
              <span>
                Converse com a <strong className="text-brand">Amorinha</strong> no canto inferior direito 💜
              </span>
            </div>
          ) : (
            <span>🔒 A Amorinha é uma funcionalidade exclusiva do plano PRO</span>
          )}
        </div>

        {/* 🤝 Card de indicação — consultora compartilha seu link único */}
        <ReferralCard />
      </main>

      {/* ⚙️ Além do gate por plano (chat_assistant), agora também respeita o
          flag global "Assistente IA" do admin-panel — antes essa flag não
          controlava nada de verdade, era só localStorage sem consumidor. */}
      {!gatesLoading && !isLocked("chat_assistant") && aiEnabled && <ChatAssistant />}

      {showTour && <OnboardingTour onFinish={finalizarTour} />}
      <UpgradeModal
        isOpen={showUpgrade}
        onClose={() => setShowUpgrade(false)}
        feature={upgradeCtx.feature}
        description={upgradeCtx.description}
      />
    </div>
  );
}

/* ══ ACTION BUTTON ══ */
function ActionBtn({
  onClick,
  icon: Icon,
  label,
  desc,
  primary,
  proBadge,
  proBadgeLoading,
  tourId,
}: {
  onClick: () => void;
  icon: typeof Package;
  label: string;
  desc: string;
  primary?: boolean;
  proBadge?: boolean;
  proBadgeLoading?: boolean;
  tourId?: string;
}) {
  return (
    <button
      onClick={onClick}
      data-tour={tourId}
      className={`flex items-center gap-3 rounded-xl p-4 text-left transition-all hover:scale-[1.02] hover:shadow-md ${
        primary
          ? "border-2 border-brand bg-gradient-to-br from-brand to-brand-hover shadow-sm"
          : "border border-border bg-card hover:bg-brand-soft" // ✅ Corrigido: hover:bg-brand-soft
      }`}
    >
      <div className={`flex h-10 w-10 shrink-0 items-center justify-center rounded-lg ${primary ? "bg-white/20" : "bg-brand/10"}`}>
        <Icon className={`h-5 w-5 ${primary ? "text-white" : "text-brand"}`} />
      </div>
      <div className="min-w-0">
        <p className={`text-sm font-bold flex items-center gap-1.5 ${primary ? "text-white" : "text-foreground"}`}>
          {label}
          {proBadgeLoading ? (
            <span className="inline-block h-4 w-8 rounded-full bg-brand/15 animate-pulse" />
          ) : (
            proBadge && <ProBadge />
          )}
        </p>
        <p className={`text-xs truncate mt-0.5 ${primary ? "text-white/80" : "text-muted-foreground"}`}>
          {desc}
        </p>
      </div>
    </button>
  );
}

// 🤝 Card de indicação — consultora vê e compartilha seu link único
function ReferralCard() {
  const [dados, setDados] = useState<{
    code: string; link: string; times_used: number;
    bonus_trial_days: number; referrer_bonus_days: number;
  } | null>(null);
  const [copiado, setCopiado] = useState(false);

  useEffect(() => {
    api.get("/growth/meu-codigo/")
      .then((r) => setDados(r.data))
      .catch(() => {}); // silencioso — card não aparece se falhar
  }, []);

  if (!dados) return null;

  const copiar = () => {
    navigator.clipboard.writeText(dados.link).then(() => {
      setCopiado(true);
      setTimeout(() => setCopiado(false), 2000);
    });
  };

  const compartilharWhatsApp = () => {
    const texto = encodeURIComponent(
      `Oi! Uso o Minha Amora pra controlar meu estoque e calcular meu lucro real 🌸\n` +
      `Você pode testar grátis por ${dados.bonus_trial_days} dias com meu link:\n${dados.link}`
    );
    window.open(`https://wa.me/?text=${texto}`, "_blank", "noopener");
  };

  return (
    <div className="rounded-xl border border-brand/20 bg-gradient-to-r from-[#FDF2F7] to-white p-4 space-y-3">
      <div className="flex items-start justify-between gap-3">
        <div>
          <p className="text-sm font-bold text-foreground">
            🤝 Indique e ganhe {dados.referrer_bonus_days} dias grátis
          </p>
          <p className="text-xs text-muted-foreground mt-0.5">
            Cada consultora que se cadastrar com seu link ganha {dados.bonus_trial_days} dias de teste.
            {dados.times_used > 0 && (
              <> Você já indicou <strong>{dados.times_used}</strong> consultora{dados.times_used > 1 ? "s" : ""}.</>
            )}
          </p>
        </div>
        <div className="shrink-0 flex h-9 w-9 items-center justify-center rounded-full bg-brand/10 text-lg">
          🎁
        </div>
      </div>

      <div className="flex gap-2">
        <div className="flex-1 overflow-hidden rounded-lg border border-border bg-background px-3 py-2">
          <p className="truncate font-mono text-[11px] text-muted-foreground">{dados.link}</p>
        </div>
        <button
          onClick={copiar}
          className="shrink-0 rounded-lg border border-border bg-card px-3 py-2 text-xs font-medium hover:bg-secondary transition-colors"
        >
          {copiado ? "✓ Copiado" : "Copiar"}
        </button>
      </div>

      <button
        onClick={compartilharWhatsApp}
        className="flex w-full items-center justify-center gap-2 rounded-xl bg-emerald-600 py-2.5 text-sm font-semibold text-white hover:opacity-90 active:scale-95 transition-all"
      >
        <svg className="h-4 w-4" viewBox="0 0 24 24" fill="currentColor">
          <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z"/>
        </svg>
        Compartilhar no WhatsApp
      </button>
    </div>
  );
}