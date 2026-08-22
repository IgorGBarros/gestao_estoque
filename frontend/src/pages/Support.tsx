// pages/Support.tsx — Central de Ajuda + Minhas Conversas
//
// Duas abas: conteúdo (vídeos/FAQ/guia/novidade, em blocos por tipo) e o
// HISTÓRICO DE VERDADE das conversas de suporte — cada pergunta escalada
// pra equipe vira um ticket que fica registrado aqui pra sempre, com
// status e resposta, mesmo depois de resolvida. É a peça que faltava: o
// chat (balão flutuante) mostra só o que está em aberto agora; aqui é
// onde mora o histórico completo, igual qualquer central de suporte.
import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, PlayCircle, HelpCircle, BookOpen, Newspaper, MessageCircle, Send, Loader2, User, ShieldCheck, Sparkles, Plus } from "lucide-react";
import { api } from "../services/api";
import { marcarComoVista } from "../lib/supportSeen";
import { Badge } from "../components/ui/badge";
import { useSystemConfig } from "../hooks/useSystemConfig";

interface HelpContentItem {
  id: number;
  tipo: "video" | "faq" | "guia" | "novidade";
  titulo: string;
  corpo: string;
  video_url: string | null;
  categoria: string;
  ordem: number;
}
interface Conversa {
  id: string;
  category: "question" | "bug";
  status: "ai_handling" | "escalated" | "resolved" | "closed";
  subject: string;
  updated_at: string;
  last_message_sender?: "user" | "ai" | "admin";
  last_message_preview?: string;
  messages?: Mensagem[];
}
interface Mensagem {
  id: number;
  sender: "user" | "ai" | "admin";
  content: string;
  created_at: string;
}

const TIPO_INFO: Record<string, { label: string; icon: any }> = {
  video: { label: "Vídeos", icon: PlayCircle },
  faq: { label: "Dúvidas Frequentes", icon: HelpCircle },
  guia: { label: "Guias", icon: BookOpen },
  novidade: { label: "Novidades", icon: Newspaper },
};
const ORDEM_BLOCOS: HelpContentItem["tipo"][] = ["video", "faq", "guia", "novidade"];

const STATUS_LABEL: Record<string, string> = {
  ai_handling: "Amorinha respondendo",
  escalated: "Aguardando equipe",
  resolved: "Resolvida",
  closed: "Encerrada",
};
const STATUS_COR: Record<string, string> = {
  ai_handling: "bg-blue-50 text-blue-700 border-blue-200",
  escalated: "bg-amber-50 text-amber-700 border-amber-200",
  resolved: "bg-emerald-50 text-emerald-700 border-emerald-200",
  closed: "bg-secondary text-muted-foreground border-border",
};

/** Extrai só o ID do vídeo, de qualquer formato de link comum do YouTube. */
function youtubeId(url: string): string | null {
  const m = url.match(
    /(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/|shorts\/|live\/))([a-zA-Z0-9_-]{6,})/
  );
  return m ? m[1] : null;
}

/** Horário relativo, estilo helpdesk ("há 2 min", "ontem"). */
function tempoRelativo(iso: string): string {
  const diffMs = Date.now() - new Date(iso).getTime();
  const min = Math.floor(diffMs / 60000);
  if (min < 1) return "agora";
  if (min < 60) return `há ${min} min`;
  const h = Math.floor(min / 60);
  if (h < 24) return `há ${h}h`;
  const d = Math.floor(h / 24);
  if (d === 1) return "ontem";
  if (d < 7) return `há ${d} dias`;
  return new Date(iso).toLocaleDateString("pt-BR");
}

export default function Support() {
  const navigate = useNavigate();
  const [aba, setAba] = useState<"ajuda" | "conversas">("ajuda");

  return (
    <div className="min-h-screen bg-background pb-20">
      <header className="sticky top-0 z-20 border-b border-border bg-card">
        <div className="mx-auto flex max-w-3xl items-center gap-3 px-4 py-4">
          <button onClick={() => navigate("/app")} className="rounded-lg p-1.5 hover:bg-secondary">
            <ArrowLeft className="h-5 w-5" />
          </button>
          <h1 className="font-display text-lg font-bold text-foreground">Ajuda</h1>
        </div>
        <div className="mx-auto flex max-w-3xl gap-1 px-4 pb-2">
          <button
            onClick={() => setAba("ajuda")}
            className={`flex items-center gap-1.5 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
              aba === "ajuda" ? "bg-brand text-white" : "text-muted-foreground hover:bg-secondary"
            }`}
          >
            <BookOpen className="h-4 w-4" /> Central de Ajuda
          </button>
          <button
            onClick={() => setAba("conversas")}
            className={`flex items-center gap-1.5 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
              aba === "conversas" ? "bg-brand text-white" : "text-muted-foreground hover:bg-secondary"
            }`}
          >
            <MessageCircle className="h-4 w-4" /> Minhas Conversas
          </button>
        </div>
      </header>

      <main className="mx-auto max-w-3xl px-4 py-5">
        {aba === "ajuda" ? <CentralDeAjuda /> : <MinhasConversas />}
      </main>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Central de Ajuda — conteúdo em blocos por tipo
// ─────────────────────────────────────────────────────────────
function CentralDeAjuda() {
  const navigate = useNavigate();
  const [conteudos, setConteudos] = useState<HelpContentItem[]>([]);
  const [itemAtivo, setItemAtivo] = useState<HelpContentItem | null>(null);
  const [carregando, setCarregando] = useState(true);
  const [erro, setErro] = useState(false);

  const carregar = () => {
    setCarregando(true);
    api.get("ajuda/").then((r) => setConteudos(r.data)).catch(() => setErro(true)).finally(() => setCarregando(false));
  };

  useEffect(() => { carregar(); }, []);

  const blocos = ORDEM_BLOCOS.map((tipo) => ({
    tipo,
    info: TIPO_INFO[tipo],
    itens: conteudos.filter((c) => c.tipo === tipo),
  })).filter((b) => b.itens.length > 0);

  return (
    <div className="space-y-8">
      {carregando ? (
        <p className="py-10 text-center text-sm text-muted-foreground">Carregando...</p>
      ) : erro ? (
        <div className="py-10 text-center">
          <p className="text-sm text-destructive">Não deu pra carregar a Central de Ajuda agora.</p>
          <button onClick={() => { setErro(false); carregar(); }} className="mt-2 text-sm font-medium text-brand hover:underline">
            Tentar de novo
          </button>
        </div>
      ) : blocos.length === 0 ? (
        <p className="py-10 text-center text-sm text-muted-foreground">Nenhum conteúdo disponível ainda.</p>
      ) : (
        blocos.map(({ tipo, info, itens }) => (
          <section key={tipo}>
            <h2 className="mb-3 flex items-center gap-2 font-display text-base font-bold text-foreground">
              <info.icon className="h-4.5 w-4.5 text-brand" /> {info.label}
            </h2>

            {tipo === "video" ? (
              <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
                {itens.map((item) => {
                  const vid = item.video_url ? youtubeId(item.video_url) : null;
                  return (
                    <button key={item.id} onClick={() => setItemAtivo(item)} className="group text-left">
                      <div className="relative aspect-video overflow-hidden rounded-xl bg-secondary">
                        {vid ? (
                          <img
                            src={`https://img.youtube.com/vi/${vid}/hqdefault.jpg`}
                            alt={item.titulo}
                            className="h-full w-full object-cover transition-transform group-hover:scale-105"
                            onError={(e) => { (e.target as HTMLImageElement).style.display = "none"; }}
                          />
                        ) : (
                          <div className="flex h-full w-full items-center justify-center">
                            <PlayCircle className="h-8 w-8 text-muted-foreground" />
                          </div>
                        )}
                        <div className="absolute inset-0 flex items-center justify-center bg-black/20 opacity-0 transition-opacity group-hover:opacity-100">
                          <div className="flex h-9 w-9 items-center justify-center rounded-full bg-white/90">
                            <PlayCircle className="h-5 w-5 text-brand" />
                          </div>
                        </div>
                      </div>
                      <p className="mt-1.5 line-clamp-2 text-xs font-medium text-foreground">{item.titulo}</p>
                    </button>
                  );
                })}
              </div>
            ) : (
              <div className="space-y-2">
                {tipo === "guia" && (
                  <button
                    onClick={() => navigate("/?tour=1")}
                    className="flex w-full items-center gap-3 rounded-xl border border-brand/30 bg-brand-soft p-3 text-left transition-colors hover:border-brand/50"
                  >
                    <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-brand/15">
                      <Sparkles className="h-5 w-5 text-brand" />
                    </div>
                    <div className="min-w-0">
                      <p className="truncate font-medium text-foreground">Rever o tour rápido</p>
                      <p className="text-xs text-muted-foreground">Passeio interativo pelas funções principais</p>
                    </div>
                  </button>
                )}
                {itens.map((item) => (
                  <button
                    key={item.id}
                    onClick={() => setItemAtivo(item)}
                    className="flex w-full items-center gap-3 rounded-xl border border-border bg-card p-3 text-left transition-colors hover:border-brand/30"
                  >
                    <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-brand/10">
                      <info.icon className="h-5 w-5 text-brand" />
                    </div>
                    <div className="min-w-0">
                      <p className="truncate font-medium text-foreground">{item.titulo}</p>
                      {item.categoria && <p className="text-xs text-muted-foreground">{item.categoria}</p>}
                    </div>
                  </button>
                ))}
              </div>
            )}
          </section>
        ))
      )}

      {itemAtivo && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4" onClick={() => setItemAtivo(null)}>
          <div className="w-full max-w-2xl" onClick={(e) => e.stopPropagation()}>
            {itemAtivo.tipo === "video" && itemAtivo.video_url ? (
              <>
                <div className="aspect-video w-full overflow-hidden rounded-xl bg-black">
                  {youtubeId(itemAtivo.video_url) ? (
                    <iframe
                      className="h-full w-full"
                      src={`https://www.youtube.com/embed/${youtubeId(itemAtivo.video_url)}?autoplay=1`}
                      title={itemAtivo.titulo}
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                      allowFullScreen
                    />
                  ) : (
                    <div className="flex h-full items-center justify-center text-white">Vídeo indisponível</div>
                  )}
                </div>
                <div className="mt-3 rounded-xl bg-card p-3">
                  <p className="font-medium text-foreground">{itemAtivo.titulo}</p>
                  {itemAtivo.corpo && <p className="mt-1 text-sm text-muted-foreground">{itemAtivo.corpo}</p>}
                </div>
                <BotaoRetornoWhatsapp titulo={itemAtivo.titulo} />
              </>
            ) : (
              <div className="max-h-[80vh] overflow-y-auto rounded-xl bg-card p-5">
                <Badge variant="outline" className="mb-2">{TIPO_INFO[itemAtivo.tipo].label}</Badge>
                <p className="font-display text-lg font-bold text-foreground">{itemAtivo.titulo}</p>
                <p className="mt-2 whitespace-pre-wrap text-sm text-muted-foreground">{itemAtivo.corpo}</p>
                <BotaoRetornoWhatsapp titulo={itemAtivo.titulo} />
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}

// ⚠️ NOVO: "voltar pro WhatsApp" depois de ver um conteúdo de ajuda —
// pra quem assistiu o vídeo ou leu o FAQ e ainda ficou com dúvida, sem
// precisar navegar até outra tela pra achar como falar com o suporte.
// Usa o número já configurado em Sistema > Configurações — se ainda não
// tiver sido preenchido, simplesmente não aparece (não quebra a tela).
function BotaoRetornoWhatsapp({ titulo }: { titulo: string }) {
  const { whatsappSuporte } = useSystemConfig();
  if (!whatsappSuporte) return null;

  const texto = `Olá! Vi o conteúdo "${titulo}" na Central de Ajuda, mas ainda fiquei com uma dúvida.`;
  return (
    <a
      href={`https://api.whatsapp.com/send?phone=${whatsappSuporte}&text=${encodeURIComponent(texto)}`}
      target="_blank"
      rel="noopener noreferrer"
      className="mt-3 flex items-center justify-center gap-2 rounded-xl border border-emerald-300 bg-emerald-50 py-2.5 text-sm font-medium text-emerald-700 hover:bg-emerald-100"
    >
      <MessageCircle className="h-4 w-4" />
      Não resolveu? Fale com a gente no WhatsApp
    </a>
  );
}

// ─────────────────────────────────────────────────────────────
// Minhas Conversas — histórico persistente de tickets de suporte
// ─────────────────────────────────────────────────────────────
function MinhasConversas() {
  const [conversas, setConversas] = useState<Conversa[]>([]);
  const [carregando, setCarregando] = useState(true);
  const [ativa, setAtiva] = useState<Conversa | null>(null);

  const carregar = () => {
    setCarregando(true);
    api.get("chat/support/conversations/").then((r) => setConversas(r.data)).finally(() => setCarregando(false));
  };

  useEffect(() => { carregar(); }, []);

  const abrir = async (id: string) => {
    const r = await api.get(`chat/support/conversations/${id}/`);
    setAtiva(r.data);
    marcarComoVista(r.data.id, r.data.updated_at);
  };

  if (ativa) {
    return <ConversaDetalhe conversa={ativa} onVoltar={() => { setAtiva(null); carregar(); }} onAtualizada={setAtiva} />;
  }

  return (
    <div className="space-y-2">
      {carregando ? (
        <p className="py-10 text-center text-sm text-muted-foreground">Carregando...</p>
      ) : conversas.length === 0 ? (
        <p className="py-10 text-center text-sm text-muted-foreground">
          Nenhuma conversa ainda — use o balão da Amorinha (canto inferior direito) pra tirar uma dúvida.
        </p>
      ) : (
        conversas.map((c) => (
          <button
            key={c.id}
            onClick={() => abrir(c.id)}
            className="flex w-full items-center justify-between gap-3 rounded-xl border border-border bg-card p-3.5 text-left hover:border-brand/30"
          >
            <div className="min-w-0">
              <p className="truncate font-medium text-foreground">{c.subject || (c.category === "bug" ? "Reporte de erro" : "Dúvida")}</p>
              <p className="truncate text-xs text-muted-foreground">
                {c.last_message_sender === "admin" && <span className="font-medium text-brand">Equipe: </span>}
                {c.last_message_preview || "—"}
              </p>
            </div>
            <div className="flex shrink-0 flex-col items-end gap-1">
              <span className={`rounded-full border px-2 py-0.5 text-[10px] font-medium ${STATUS_COR[c.status]}`}>
                {STATUS_LABEL[c.status]}
              </span>
              <span className="text-[10px] text-muted-foreground">{tempoRelativo(c.updated_at)}</span>
            </div>
          </button>
        ))
      )}
    </div>
  );
}

function ConversaDetalhe({ conversa, onVoltar, onAtualizada }: {
  conversa: Conversa;
  onVoltar: () => void;
  onAtualizada: (c: Conversa) => void;
}) {
  const [mensagem, setMensagem] = useState("");
  const [enviando, setEnviando] = useState(false);
  const encerrada = conversa.status === "resolved" || conversa.status === "closed";

  const enviar = async () => {
    if (!mensagem.trim()) return;
    setEnviando(true);
    try {
      const r = await api.post(`chat/support/conversations/${conversa.id}/`, { message: mensagem.trim() });
      onAtualizada(r.data);
      setMensagem("");
    } finally {
      setEnviando(false);
    }
  };

  return (
    <div>
      <button onClick={onVoltar} className="mb-3 flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
        <ArrowLeft className="h-3.5 w-3.5" /> Todas as conversas
      </button>

      <div className="mb-3 flex items-center justify-between">
        <p className="font-medium text-foreground">{conversa.subject || "(sem assunto)"}</p>
        <span className={`rounded-full border px-2 py-0.5 text-[10px] font-medium ${STATUS_COR[conversa.status]}`}>
          {STATUS_LABEL[conversa.status]}
        </span>
      </div>

      <div className="space-y-3 rounded-xl border border-border bg-card p-3">
        {(conversa.messages || []).map((m) => (
          <div key={m.id} className={`flex ${m.sender === "user" ? "justify-end" : "justify-start"}`}>
            <div className={`flex max-w-[80%] items-start gap-2 ${m.sender === "user" ? "flex-row-reverse" : ""}`}>
              <div className={`mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${
                m.sender === "user" ? "bg-brand text-white" : m.sender === "admin" ? "bg-emerald-500 text-white" : "bg-brand/15 text-brand"
              }`}>
                {m.sender === "user" ? <User className="h-3.5 w-3.5" /> : m.sender === "admin" ? <ShieldCheck className="h-3.5 w-3.5" /> : <Sparkles className="h-3.5 w-3.5" />}
              </div>
              <div>
                <div className={`rounded-2xl px-3 py-2 text-sm ${m.sender === "user" ? "bg-brand text-white" : "bg-secondary text-foreground"}`}>
                  {m.content}
                </div>
                <p className={`mt-0.5 text-[10px] text-muted-foreground ${m.sender === "user" ? "text-right" : ""}`}>{tempoRelativo(m.created_at)}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {encerrada ? (
        <p className="mt-3 rounded-xl bg-secondary py-3 text-center text-xs text-muted-foreground">Essa conversa foi encerrada.</p>
      ) : (
        <div className="mt-3 flex gap-2">
          <input
            type="text"
            value={mensagem}
            onChange={(e) => setMensagem(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && enviar()}
            placeholder="Responder..."
            className="flex-1 rounded-xl border border-input bg-background px-3.5 py-2.5 text-sm outline-none focus:border-brand"
          />
          <button
            onClick={enviar}
            disabled={enviando || !mensagem.trim()}
            className="flex shrink-0 items-center justify-center rounded-xl bg-brand px-4 text-white hover:opacity-90 disabled:opacity-50"
          >
            {enviando ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4" />}
          </button>
        </div>
      )}
    </div>
  );
}