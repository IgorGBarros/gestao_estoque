// src/components/admin/AdminSupportTab.tsx
import { useState, useEffect } from "react";
import { MessageCircle, Video, RefreshCw, Send, Loader2, Plus, Trash2, Pencil, User, ShieldCheck, Sparkles, X } from "lucide-react";
import { Badge } from "../ui/badge";
import { Button } from "../ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "../ui/tabs";
import { adminApi } from "../../lib/api";

interface Conversa {
  id: string;
  store_id: number;
  store_name: string;
  store_owner_email: string | null;
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
  sort_order: number;
  is_visible: boolean;
}

const STATUS_LABEL: Record<string, string> = {
  ai_handling: "Amorinha respondendo",
  escalated: "Aguardando equipe",
  resolved: "Resolvida",
  closed: "Encerrada",
};

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

export default function AdminSupportTab({ toast }: Props) {
  const [aba, setAba] = useState("conversations");

  return (
    <div className="space-y-4">
      <div>
        <h2 className="text-xl font-bold flex items-center gap-2">
          <MessageCircle className="h-5 w-5 text-primary" /> Suporte
        </h2>
        <p className="text-sm text-muted-foreground">Conversas escaladas pela Amorinha e vídeos tutoriais</p>
      </div>

      <Tabs value={aba} onValueChange={setAba} className="space-y-4">
        <TabsList>
          <TabsTrigger value="conversations" className="text-xs">Conversas</TabsTrigger>
          <TabsTrigger value="videos" className="text-xs">Vídeos Tutoriais</TabsTrigger>
        </TabsList>

        <TabsContent value="conversations">
          <ConversationsPanel toast={toast} />
        </TabsContent>

        <TabsContent value="videos">
          <VideosPanel toast={toast} />
        </TabsContent>
      </Tabs>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Conversas
// ─────────────────────────────────────────────────────────────
function ConversationsPanel({ toast }: Props) {
  const [conversas, setConversas] = useState<Conversa[]>([]);
  const [loading, setLoading] = useState(true);
  const [filtro, setFiltro] = useState<string>("escalated");
  const [ativa, setAtiva] = useState<Conversa | null>(null);
  const [resposta, setResposta] = useState("");
  const [enviando, setEnviando] = useState(false);

  const carregar = async () => {
    setLoading(true);
    try {
      const dados = await adminApi.listSupportConversations(filtro || undefined);
      setConversas(dados);
    } catch {
      toast({ title: "Erro", description: "Não deu pra carregar as conversas", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { carregar(); }, [filtro]);

  const abrir = async (id: string) => {
    try {
      const dados = await adminApi.getSupportConversation(id);
      setAtiva(dados);
    } catch {
      toast({ title: "Erro", description: "Não deu pra abrir essa conversa", variant: "destructive" });
    }
  };

  const responder = async () => {
    if (!ativa || !resposta.trim()) return;
    setEnviando(true);
    try {
      const dados = await adminApi.replySupportConversation(ativa.id, resposta.trim());
      setAtiva(dados);
      setResposta("");
      carregar();
    } catch {
      toast({ title: "Erro", description: "Não deu pra enviar a resposta", variant: "destructive" });
    } finally {
      setEnviando(false);
    }
  };

  const mudarStatus = async (novoStatus: string) => {
    if (!ativa) return;
    try {
      const dados = await adminApi.updateSupportConversationStatus(ativa.id, novoStatus);
      setAtiva(dados);
      toast({ title: `Marcada como ${STATUS_LABEL[novoStatus]}` });
      carregar();
    } catch {
      toast({ title: "Erro", description: "Não deu pra mudar o status", variant: "destructive" });
    }
  };

  if (ativa) {
    return (
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <div>
            <button onClick={() => setAtiva(null)} className="text-xs text-muted-foreground hover:text-foreground mb-1">
              ← Voltar pra lista
            </button>
            <CardTitle className="text-base">{ativa.subject || "(sem assunto)"}</CardTitle>
            <CardDescription>{ativa.store_name} · {ativa.store_owner_email}</CardDescription>
          </div>
          <div className="flex gap-2">
            <Badge variant={ativa.category === "bug" ? "destructive" : "secondary"}>
              {ativa.category === "bug" ? "Erro" : "Dúvida"}
            </Badge>
            <Badge variant="outline">{STATUS_LABEL[ativa.status]}</Badge>
          </div>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="max-h-96 space-y-3 overflow-y-auto rounded-lg border border-border p-3">
            {(ativa.messages || []).map((m) => (
              <div key={m.id} className={`flex ${m.sender === "admin" ? "justify-end" : "justify-start"}`}>
                <div className={`flex max-w-[80%] items-start gap-2 ${m.sender === "admin" ? "flex-row-reverse" : ""}`}>
                  <div className={`mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${
                    m.sender === "admin" ? "bg-emerald-500 text-white" : m.sender === "ai" ? "bg-primary/15 text-primary" : "bg-secondary"
                  }`}>
                    {m.sender === "admin" ? <ShieldCheck className="h-3.5 w-3.5" /> : m.sender === "ai" ? <Sparkles className="h-3.5 w-3.5" /> : <User className="h-3.5 w-3.5" />}
                  </div>
                  <div className={`rounded-2xl px-3 py-2 text-sm ${m.sender === "admin" ? "bg-emerald-500 text-white" : "bg-secondary"}`}>
                    {m.content}
                  </div>
                </div>
              </div>
            ))}
          </div>

          {ativa.status !== "resolved" && ativa.status !== "closed" && (
            <div className="flex gap-2">
              <input
                type="text"
                value={resposta}
                onChange={(e) => setResposta(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && responder()}
                placeholder="Responder à consultora..."
                className="flex-1 rounded-lg border border-input px-3 py-2 text-sm outline-none focus:border-primary"
              />
              <Button onClick={responder} disabled={enviando || !resposta.trim()} size="sm">
                {enviando ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4" />}
              </Button>
            </div>
          )}

          <div className="flex gap-2 border-t border-border pt-3">
            <Button size="sm" variant="outline" onClick={() => mudarStatus("resolved")} disabled={ativa.status === "resolved"}>
              Marcar como resolvida
            </Button>
            <Button size="sm" variant="ghost" onClick={() => mudarStatus("closed")} disabled={ativa.status === "closed"}>
              Encerrar
            </Button>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <CardTitle className="text-base">Conversas</CardTitle>
        <div className="flex items-center gap-2">
          <select
            value={filtro}
            onChange={(e) => setFiltro(e.target.value)}
            className="rounded-lg border border-input px-2 py-1.5 text-xs"
          >
            <option value="escalated">Aguardando equipe</option>
            <option value="ai_handling">Amorinha respondendo</option>
            <option value="resolved">Resolvidas</option>
            <option value="closed">Encerradas</option>
            <option value="">Todas</option>
          </select>
          <button onClick={carregar} className="rounded-lg border border-border p-1.5 hover:bg-secondary">
            <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
          </button>
        </div>
      </CardHeader>
      <CardContent>
        {loading ? (
          <div className="flex justify-center py-8"><Loader2 className="h-5 w-5 animate-spin text-primary" /></div>
        ) : conversas.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">Nenhuma conversa aqui.</p>
        ) : (
          <div className="space-y-2">
            {conversas.map((c) => (
              <button
                key={c.id}
                onClick={() => abrir(c.id)}
                className="flex w-full items-center justify-between gap-3 rounded-lg border border-border p-3 text-left hover:border-primary/30"
              >
                <div className="min-w-0">
                  <p className="truncate text-sm font-medium">{c.subject || "(sem assunto)"}</p>
                  <p className="text-xs text-muted-foreground">{c.store_name} · {c.store_owner_email}</p>
                </div>
                <Badge variant={c.category === "bug" ? "destructive" : "secondary"} className="shrink-0 text-[10px]">
                  {c.category === "bug" ? "Erro" : "Dúvida"}
                </Badge>
              </button>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

// ─────────────────────────────────────────────────────────────
// Vídeos
// ─────────────────────────────────────────────────────────────
function VideosPanel({ toast }: Props) {
  const [videos, setVideos] = useState<VideoTutorial[]>([]);
  const [loading, setLoading] = useState(true);
  const [editando, setEditando] = useState<VideoTutorial | null>(null);
  const [mostrarForm, setMostrarForm] = useState(false);

  const carregar = async () => {
    setLoading(true);
    try {
      setVideos(await adminApi.listTutorialVideos());
    } catch {
      toast({ title: "Erro", description: "Não deu pra carregar os vídeos", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { carregar(); }, []);

  const excluir = async (id: number) => {
    if (!confirm("Excluir este vídeo? Não tem como desfazer.")) return;
    try {
      await adminApi.deleteTutorialVideo(id);
      toast({ title: "Vídeo excluído" });
      carregar();
    } catch {
      toast({ title: "Erro", description: "Não deu pra excluir", variant: "destructive" });
    }
  };

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <CardTitle className="text-base flex items-center gap-2">
          <Video className="h-4 w-4" /> Vídeos Tutoriais
        </CardTitle>
        <Button size="sm" className="gap-1.5" onClick={() => { setEditando(null); setMostrarForm(true); }}>
          <Plus className="h-3.5 w-3.5" /> Novo vídeo
        </Button>
      </CardHeader>
      <CardContent>
        {mostrarForm && (
          <VideoForm
            video={editando}
            toast={toast}
            onSalvo={() => { setMostrarForm(false); carregar(); }}
            onCancelar={() => setMostrarForm(false)}
          />
        )}

        {loading ? (
          <div className="flex justify-center py-8"><Loader2 className="h-5 w-5 animate-spin text-primary" /></div>
        ) : videos.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">Nenhum vídeo cadastrado ainda.</p>
        ) : (
          <div className="space-y-2">
            {videos.map((v) => (
              <div key={v.id} className="flex items-center justify-between gap-3 rounded-lg border border-border p-3">
                <div className="min-w-0">
                  <p className="truncate text-sm font-medium">{v.title}</p>
                  <p className="truncate text-xs text-muted-foreground">{v.category || "Sem categoria"} · {v.is_visible ? "Visível" : "Oculto"}</p>
                </div>
                <div className="flex shrink-0 gap-1">
                  <button
                    onClick={() => { setEditando(v); setMostrarForm(true); }}
                    className="rounded-lg p-1.5 text-muted-foreground hover:bg-secondary"
                  >
                    <Pencil className="h-3.5 w-3.5" />
                  </button>
                  <button
                    onClick={() => excluir(v.id)}
                    className="rounded-lg p-1.5 text-destructive hover:bg-destructive/10"
                  >
                    <Trash2 className="h-3.5 w-3.5" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function VideoForm({ video, toast, onSalvo, onCancelar }: {
  video: VideoTutorial | null;
  toast: Props["toast"];
  onSalvo: () => void;
  onCancelar: () => void;
}) {
  const [title, setTitle] = useState(video?.title || "");
  const [description, setDescription] = useState(video?.description || "");
  const [videoUrl, setVideoUrl] = useState(video?.video_url || "");
  const [category, setCategory] = useState(video?.category || "");
  const [isVisible, setIsVisible] = useState(video?.is_visible ?? true);
  const [salvando, setSalvando] = useState(false);

  const salvar = async () => {
    if (!title.trim() || !videoUrl.trim()) {
      toast({ title: "Preencha título e link do vídeo", variant: "destructive" });
      return;
    }
    setSalvando(true);
    try {
      const dados = { title: title.trim(), description: description.trim(), video_url: videoUrl.trim(), category: category.trim(), is_visible: isVisible };
      if (video) {
        await adminApi.updateTutorialVideo(video.id, dados);
      } else {
        await adminApi.createTutorialVideo(dados);
      }
      toast({ title: video ? "Vídeo atualizado" : "Vídeo criado" });
      onSalvo();
    } catch {
      toast({ title: "Erro", description: "Não deu pra salvar", variant: "destructive" });
    } finally {
      setSalvando(false);
    }
  };

  return (
    <div className="mb-4 space-y-3 rounded-lg border border-primary/20 bg-primary/5 p-4">
      <div className="flex items-center justify-between">
        <p className="text-sm font-semibold">{video ? "Editar vídeo" : "Novo vídeo"}</p>
        <button onClick={onCancelar} className="rounded-lg p-1 hover:bg-secondary"><X className="h-4 w-4" /></button>
      </div>
      <input
        type="text" value={title} onChange={(e) => setTitle(e.target.value)}
        placeholder="Título (ex: Como cadastrar um produto)"
        className="w-full rounded-lg border border-input px-3 py-2 text-sm"
      />
      <input
        type="text" value={videoUrl} onChange={(e) => setVideoUrl(e.target.value)}
        placeholder="Link do vídeo (YouTube)"
        className="w-full rounded-lg border border-input px-3 py-2 text-sm"
      />
      <div className="grid grid-cols-2 gap-3">
        <input
          type="text" value={category} onChange={(e) => setCategory(e.target.value)}
          placeholder="Categoria (ex: Estoque)"
          className="rounded-lg border border-input px-3 py-2 text-sm"
        />
        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" checked={isVisible} onChange={(e) => setIsVisible(e.target.checked)} />
          Visível pras consultoras
        </label>
      </div>
      <textarea
        value={description} onChange={(e) => setDescription(e.target.value)}
        placeholder="Descrição (opcional)"
        rows={2}
        className="w-full rounded-lg border border-input px-3 py-2 text-sm"
      />
      <Button onClick={salvar} disabled={salvando} size="sm" className="w-full">
        {salvando ? <Loader2 className="h-4 w-4 animate-spin" /> : (video ? "Salvar alterações" : "Criar vídeo")}
      </Button>
    </div>
  );
}
