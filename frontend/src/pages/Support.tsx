// pages/Support.tsx
//
// Suporte da consultora: dúvida ou reporte de erro (a Amorinha tenta
// responder dúvida primeiro, escala pra equipe quando não sabe; reporte de
// erro já nasce escalado) + galeria de vídeos tutoriais que o admin
// gerencia.
import { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, Send, MessageCircle, Video, Plus, Loader2, Sparkles, User, ShieldCheck, PlayCircle } from "lucide-react";
import { api } from "../services/api";
import { useToast } from '../components/ui/use-toast'; // ✅ Importar useToast original para evitar dependência circular

interface Conversa {
  id: string;
  category: "question" | "bug";
  status: "ai_handling" | "escalated" | "resolved" | "closed";
  subject: string;
  updated_at: string;
  messages?: Mensagem[];
}
interface Mensagem {
  id: number;
  sender: "user" | "ai" | "admin";
  content: string;
  created_at: string;
}
interface VideoTutorial {
  id: number;
  title: string;
  description: string;
  video_url: string;
  category: string;
}

const STATUS_LABEL: Record<string, string> = {
  ai_handling: "Amorinha respondendo",
  escalated: "Com a equipe",
  resolved: "Resolvida",
  closed: "Encerrada",
};

// Extrai o ID de embed do YouTube de qualquer formato de link comum.
function youtubeEmbedUrl(url: string): string | null {
  const m = url.match(/(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/))([a-zA-Z0-9_-]{6,})/);
  return m ? `https://www.youtube.com/embed/${m[1]}` : null;
}

export default function Support() {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [aba, setAba] = useState<"chat" | "videos">("chat");

  const [conversas, setConversas] = useState<Conversa[]>([]);
  const [conversaAtiva, setConversaAtiva] = useState<Conversa | null>(null);
  const [carregandoLista, setCarregandoLista] = useState(true);
  const [mostrarNova, setMostrarNova] = useState(false);

  const [videos, setVideos] = useState<VideoTutorial[]>([]);
  const [videoAtivo, setVideoAtivo] = useState<VideoTutorial | null>(null);

  useEffect(() => {
    carregarConversas();
    api.get("chat/videos/").then((r) => setVideos(r.data)).catch(() => {});
  }, []);

  const carregarConversas = async () => {
    setCarregandoLista(true);
    try {
      const r = await api.get("chat/support/conversations/");
      setConversas(r.data);
      if (r.data.length === 0) setMostrarNova(true);
    } catch {
      toast({ title: "Erro", description: "Não deu pra carregar suas conversas.", variant: "destructive" });
    } finally {
      setCarregandoLista(false);
    }
  };

  const abrirConversa = async (id: string) => {
    try {
      const r = await api.get(`chat/support/conversations/${id}/`);
      setConversaAtiva(r.data);
      setMostrarNova(false);
    } catch {
      toast({ title: "Erro", description: "Não deu pra abrir essa conversa.", variant: "destructive" });
    }
  };

  return (
    <div className="min-h-screen bg-background pb-20">
      <header className="sticky top-0 z-20 border-b border-border bg-card">
        <div className="mx-auto flex max-w-3xl items-center gap-3 px-4 py-4">
          <button onClick={() => navigate("/")} className="rounded-lg p-1.5 hover:bg-secondary">
            <ArrowLeft className="h-5 w-5" />
          </button>
          <h1 className="font-display text-lg font-bold text-foreground">Ajuda</h1>
        </div>
        <div className="mx-auto flex max-w-3xl gap-1 px-4 pb-2">
          <button
            onClick={() => setAba("chat")}
            className={`flex items-center gap-1.5 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
              aba === "chat" ? "bg-brand text-white" : "text-muted-foreground hover:bg-secondary"
            }`}
          >
            <MessageCircle className="h-4 w-4" /> Falar com a gente
          </button>
          <button
            onClick={() => setAba("videos")}
            className={`flex items-center gap-1.5 rounded-lg px-3 py-2 text-sm font-medium transition-colors ${
              aba === "videos" ? "bg-brand text-white" : "text-muted-foreground hover:bg-secondary"
            }`}
          >
            <Video className="h-4 w-4" /> Vídeos tutoriais
          </button>
        </div>
      </header>

      <main className="mx-auto max-w-3xl px-4 py-5">
        {aba === "chat" && (
          <ChatTab
            conversas={conversas}
            conversaAtiva={conversaAtiva}
            carregando={carregandoLista}
            mostrarNova={mostrarNova}
            onAbrirConversa={abrirConversa}
            onNovaConversa={() => { setConversaAtiva(null); setMostrarNova(true); }}
            onVoltarLista={() => { setConversaAtiva(null); setMostrarNova(false); carregarConversas(); }}
            onConversaCriada={(c) => { setConversaAtiva(c); setMostrarNova(false); carregarConversas(); }}
            onConversaAtualizada={(c) => setConversaAtiva(c)}
          />
        )}

        {aba === "videos" && (
          <div className="space-y-3">
            {videos.length === 0 ? (
              <p className="py-10 text-center text-sm text-muted-foreground">
                Nenhum vídeo tutorial disponível ainda.
              </p>
            ) : (
              videos.map((v) => (
                <button
                  key={v.id}
                  onClick={() => setVideoAtivo(v)}
                  className="flex w-full items-center gap-3 rounded-xl border border-border bg-card p-3 text-left transition-colors hover:border-brand/30"
                >
                  <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-lg bg-brand/10">
                    <PlayCircle className="h-6 w-6 text-brand" />
                  </div>
                  <div className="min-w-0">
                    <p className="truncate font-medium text-foreground">{v.title}</p>
                    {v.category && <p className="text-xs text-muted-foreground">{v.category}</p>}
                  </div>
                </button>
              ))
            )}
          </div>
        )}
      </main>

      {videoAtivo && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4"
          onClick={() => setVideoAtivo(null)}
        >
          <div className="w-full max-w-2xl" onClick={(e) => e.stopPropagation()}>
            <div className="aspect-video w-full overflow-hidden rounded-xl bg-black">
              {youtubeEmbedUrl(videoAtivo.video_url) ? (
                <iframe
                  className="h-full w-full"
                  src={youtubeEmbedUrl(videoAtivo.video_url)!}
                  title={videoAtivo.title}
                  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                  allowFullScreen
                />
              ) : (
                <a href={videoAtivo.video_url} target="_blank" rel="noopener noreferrer" className="flex h-full items-center justify-center text-white underline">
                  Abrir vídeo
                </a>
              )}
            </div>
            <div className="mt-3 rounded-xl bg-card p-3">
              <p className="font-medium text-foreground">{videoAtivo.title}</p>
              {videoAtivo.description && <p className="mt-1 text-sm text-muted-foreground">{videoAtivo.description}</p>}
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Aba de chat — lista de conversas + conversa ativa + formulário de nova
// ─────────────────────────────────────────────────────────────
function ChatTab({
  conversas, conversaAtiva, carregando, mostrarNova,
  onAbrirConversa, onNovaConversa, onVoltarLista, onConversaCriada, onConversaAtualizada,
}: {
  conversas: Conversa[];
  conversaAtiva: Conversa | null;
  carregando: boolean;
  mostrarNova: boolean;
  onAbrirConversa: (id: string) => void;
  onNovaConversa: () => void;
  onVoltarLista: () => void;
  onConversaCriada: (c: Conversa) => void;
  onConversaAtualizada: (c: Conversa) => void;
}) {
  if (carregando) {
    return <div className="flex justify-center py-10"><Loader2 className="h-5 w-5 animate-spin text-brand" /></div>;
  }

  if (conversaAtiva) {
    return <ConversaAtiva conversa={conversaAtiva} onVoltar={onVoltarLista} onAtualizada={onConversaAtualizada} />;
  }

  if (mostrarNova) {
    return <NovaConversaForm onCriada={onConversaCriada} onCancelar={conversas.length > 0 ? onVoltarLista : undefined} />;
  }

  return (
    <div className="space-y-3">
      <button
        onClick={onNovaConversa}
        className="flex w-full items-center justify-center gap-2 rounded-xl bg-brand py-3 text-sm font-bold text-white hover:opacity-90"
      >
        <Plus className="h-4 w-4" /> Nova conversa
      </button>
      {conversas.map((c) => (
        <button
          key={c.id}
          onClick={() => onAbrirConversa(c.id)}
          className="flex w-full items-center justify-between gap-3 rounded-xl border border-border bg-card p-3.5 text-left hover:border-brand/30"
        >
          <div className="min-w-0">
            <p className="truncate font-medium text-foreground">{c.subject || (c.category === "bug" ? "Reporte de erro" : "Dúvida")}</p>
            <p className="text-xs text-muted-foreground">{STATUS_LABEL[c.status]}</p>
          </div>
          <span
            className={`shrink-0 rounded-full px-2 py-0.5 text-[10px] font-semibold ${
              c.status === "escalated" ? "bg-amber-100 text-amber-700" :
              c.status === "resolved" ? "bg-emerald-100 text-emerald-700" :
              "bg-brand/10 text-brand"
            }`}
          >
            {c.category === "bug" ? "Erro" : "Dúvida"}
          </span>
        </button>
      ))}
    </div>
  );
}

function NovaConversaForm({ onCriada, onCancelar }: { onCriada: (c: Conversa) => void; onCancelar?: () => void }) {
  const { toast } = useToast();
  const [categoria, setCategoria] = useState<"question" | "bug">("question");
  const [assunto, setAssunto] = useState("");
  const [mensagem, setMensagem] = useState("");
  const [enviando, setEnviando] = useState(false);

  const enviar = async () => {
    if (!mensagem.trim()) return;
    setEnviando(true);
    try {
      const r = await api.post("chat/support/conversations/", {
        category: categoria, subject: assunto.trim(), message: mensagem.trim(),
      });
      onCriada(r.data);
    } catch {
      toast({ title: "Erro", description: "Não deu pra enviar. Tenta de novo?", variant: "destructive" });
    } finally {
      setEnviando(false);
    }
  };

  return (
    <div className="space-y-4">
      {onCancelar && (
        <button onClick={onCancelar} className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-3.5 w-3.5" /> Ver conversas
        </button>
      )}
      <div className="flex gap-2">
        <button
          onClick={() => setCategoria("question")}
          className={`flex-1 rounded-xl border py-2.5 text-sm font-medium ${categoria === "question" ? "border-brand bg-brand/5 text-brand" : "border-border text-muted-foreground"}`}
        >
          Tenho uma dúvida
        </button>
        <button
          onClick={() => setCategoria("bug")}
          className={`flex-1 rounded-xl border py-2.5 text-sm font-medium ${categoria === "bug" ? "border-destructive bg-destructive/5 text-destructive" : "border-border text-muted-foreground"}`}
        >
          Quero reportar um erro
        </button>
      </div>

      <input
        type="text"
        value={assunto}
        onChange={(e) => setAssunto(e.target.value)}
        placeholder="Assunto (opcional) — ex: Erro ao salvar produto"
        className="w-full rounded-xl border border-input bg-background px-3.5 py-2.5 text-sm outline-none focus:border-brand"
      />
      <textarea
        value={mensagem}
        onChange={(e) => setMensagem(e.target.value)}
        placeholder={categoria === "bug" ? "Descreva o que aconteceu, com o máximo de detalhe possível..." : "Qual sua dúvida?"}
        rows={4}
        className="w-full rounded-xl border border-input bg-background px-3.5 py-2.5 text-sm outline-none focus:border-brand"
      />
      <button
        onClick={enviar}
        disabled={enviando || !mensagem.trim()}
        className="flex w-full items-center justify-center gap-2 rounded-xl bg-brand py-3 text-sm font-bold text-white hover:opacity-90 disabled:opacity-50"
      >
        {enviando ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4" />}
        Enviar
      </button>
    </div>
  );
}

function ConversaAtiva({ conversa, onVoltar, onAtualizada }: { conversa: Conversa; onVoltar: () => void; onAtualizada: (c: Conversa) => void }) {
  const { toast } = useToast();
  const [mensagem, setMensagem] = useState("");
  const [enviando, setEnviando] = useState(false);
  const fimRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    fimRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [conversa.messages]);

  const enviar = async () => {
    if (!mensagem.trim()) return;
    setEnviando(true);
    try {
      const r = await api.post(`chat/support/conversations/${conversa.id}/`, { message: mensagem.trim() });
      onAtualizada(r.data);
      setMensagem("");
    } catch {
      toast({ title: "Erro", description: "Não deu pra enviar. Tenta de novo?", variant: "destructive" });
    } finally {
      setEnviando(false);
    }
  };

  const encerrada = conversa.status === "resolved" || conversa.status === "closed";

  return (
    <div className="flex h-[calc(100vh-160px)] flex-col">
      <div className="mb-3 flex items-center justify-between">
        <button onClick={onVoltar} className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground">
          <ArrowLeft className="h-3.5 w-3.5" /> Voltar
        </button>
        <span className="rounded-full bg-secondary px-2.5 py-1 text-[11px] font-semibold text-muted-foreground">
          {STATUS_LABEL[conversa.status]}
        </span>
      </div>

      <div className="flex-1 space-y-3 overflow-y-auto pb-3">
        {(conversa.messages || []).map((m) => (
          <div key={m.id} className={`flex ${m.sender === "user" ? "justify-end" : "justify-start"}`}>
            <div className={`flex max-w-[80%] items-start gap-2 ${m.sender === "user" ? "flex-row-reverse" : ""}`}>
              <div className={`mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${
                m.sender === "user" ? "bg-brand text-white" : m.sender === "admin" ? "bg-emerald-500 text-white" : "bg-brand/15 text-brand"
              }`}>
                {m.sender === "user" ? <User className="h-3.5 w-3.5" /> : m.sender === "admin" ? <ShieldCheck className="h-3.5 w-3.5" /> : <Sparkles className="h-3.5 w-3.5" />}
              </div>
              <div className={`rounded-2xl px-3.5 py-2.5 text-sm ${
                m.sender === "user" ? "bg-brand text-white" : "bg-card border border-border text-foreground"
              }`}>
                {m.content}
              </div>
            </div>
          </div>
        ))}
        <div ref={fimRef} />
      </div>

      {encerrada ? (
        <p className="rounded-xl bg-secondary py-3 text-center text-xs text-muted-foreground">
          Essa conversa foi encerrada.
        </p>
      ) : (
        <div className="flex gap-2">
          <input
            type="text"
            value={mensagem}
            onChange={(e) => setMensagem(e.target.value)}
            onKeyDown={(e) => e.key === "Enter" && enviar()}
            placeholder="Digite sua mensagem..."
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
