// src/components/admin/AdminSupportTab.tsx
import { useState, useEffect } from "react";
import { MessageCircle, Video, RefreshCw, Send, Plus, Trash2, Pencil, User, ShieldCheck, Sparkles, X, BookOpen, HelpCircle, Newspaper, Search, AlertTriangle, Bot, CheckCircle2, Archive } from "lucide-react";
import { Badge } from "../ui/badge";
import { Button } from "../ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "../ui/tabs";
import { adminApi } from "../../lib/api";
import { LoadingSpinner } from "../ui/loading-spinner";

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
          <TabsTrigger value="help-content" className="text-xs">Central de Ajuda</TabsTrigger>
        </TabsList>

        <TabsContent value="conversations">
          <ConversationsPanel toast={toast} />
        </TabsContent>

        <TabsContent value="help-content">
          <HelpContentPanel toast={toast} />
        </TabsContent>
      </Tabs>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Conversas
// ─────────────────────────────────────────────────────────────
const STATUS_COR: Record<string, string> = {
  escalated: "bg-amber-50 text-amber-700 border-amber-200",
  ai_handling: "bg-blue-50 text-blue-700 border-blue-200",
  resolved: "bg-emerald-50 text-emerald-700 border-emerald-200",
  closed: "bg-secondary text-muted-foreground border-border",
};
const STATUS_ICON: Record<string, any> = {
  escalated: AlertTriangle,
  ai_handling: Bot,
  resolved: CheckCircle2,
  closed: Archive,
};

/** Horário relativo, estilo helpdesk ("há 2 min", "ontem", "há 5 dias"). */
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

function ConversationsPanel({ toast }: Props) {
  const [conversas, setConversas] = useState<Conversa[]>([]);
  const [loading, setLoading] = useState(true);
  const [filtro, setFiltro] = useState<string>("escalated");
  const [busca, setBusca] = useState("");
  const [ativaId, setAtivaId] = useState<string | null>(null);
  const [ativa, setAtiva] = useState<Conversa | null>(null);
  const [carregandoDetalhe, setCarregandoDetalhe] = useState(false);
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
    setAtivaId(id);
    setCarregandoDetalhe(true);
    try {
      const dados = await adminApi.getSupportConversation(id);
      setAtiva(dados);
    } catch {
      toast({ title: "Erro", description: "Não deu pra abrir essa conversa", variant: "destructive" });
    } finally {
      setCarregandoDetalhe(false);
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

  const conversasFiltradas = busca.trim()
    ? conversas.filter((c) =>
        (c.subject || "").toLowerCase().includes(busca.toLowerCase()) ||
        c.store_name.toLowerCase().includes(busca.toLowerCase()) ||
        (c.store_owner_email || "").toLowerCase().includes(busca.toLowerCase())
      )
    : conversas;

  // Resumo rápido por status — visão de triagem de helpdesk, sem precisar
  // trocar o filtro pra saber o volume de cada fila.
  const resumo = {
    escalated: conversas.filter((c) => c.status === "escalated").length,
    ai_handling: conversas.filter((c) => c.status === "ai_handling").length,
  };

  return (
    <Card className="overflow-hidden">
      <CardHeader className="border-b border-border pb-3">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <CardTitle className="text-base">Conversas</CardTitle>
          <div className="flex items-center gap-3 text-xs text-muted-foreground">
            <span className="flex items-center gap-1"><AlertTriangle className="h-3.5 w-3.5 text-amber-500" /> {resumo.escalated} aguardando</span>
            <span className="flex items-center gap-1"><Bot className="h-3.5 w-3.5 text-blue-500" /> {resumo.ai_handling} com a Amorinha</span>
            <button onClick={carregar} className="rounded-lg border border-border p-1.5 hover:bg-secondary">
              <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
            </button>
          </div>
        </div>
      </CardHeader>

      {/* Tela dividida — lista à esquerda, conversa aberta à direita, lado
          a lado (padrão de qualquer helpdesk profissional: Zendesk,
          Intercom etc.) — não troca de tela, só troca o painel direito. */}
      <div className="flex h-[600px]">
        <div className="flex w-[320px] shrink-0 flex-col border-r border-border">
          <div className="space-y-2 border-b border-border p-3">
            <div className="relative">
              <Search className="absolute left-2.5 top-2.5 h-3.5 w-3.5 text-muted-foreground" />
              <input
                type="text"
                value={busca}
                onChange={(e) => setBusca(e.target.value)}
                placeholder="Buscar por loja ou assunto..."
                className="w-full rounded-lg border border-input py-1.5 pl-8 pr-2 text-xs outline-none focus:border-primary"
              />
            </div>
            <select
              value={filtro}
              onChange={(e) => setFiltro(e.target.value)}
              className="w-full rounded-lg border border-input px-2 py-1.5 text-xs"
            >
              <option value="escalated">Aguardando equipe</option>
              <option value="ai_handling">Amorinha respondendo</option>
              <option value="resolved">Resolvidas</option>
              <option value="closed">Encerradas</option>
              <option value="">Todas</option>
            </select>
          </div>

          <div className="flex-1 overflow-y-auto">
            {loading ? (
              <div className="flex justify-center py-8"><LoadingSpinner color="brand" /></div>
            ) : conversasFiltradas.length === 0 ? (
              <p className="px-3 py-8 text-center text-sm text-muted-foreground">Nenhuma conversa aqui.</p>
            ) : (
              conversasFiltradas.map((c) => {
                const StatusIcon = STATUS_ICON[c.status];
                const selecionada = c.id === ativaId;
                return (
                  <button
                    key={c.id}
                    onClick={() => abrir(c.id)}
                    className={`flex w-full flex-col gap-1 border-b border-border p-3 text-left transition-colors ${
                      selecionada ? "bg-primary/5" : "hover:bg-secondary/50"
                    }`}
                  >
                    <div className="flex items-center justify-between gap-2">
                      <p className="truncate text-sm font-medium text-foreground">{c.store_name}</p>
                      <span className="shrink-0 text-[10px] text-muted-foreground">{tempoRelativo(c.updated_at)}</span>
                    </div>
                    <p className="truncate text-xs text-muted-foreground">{c.subject || "(sem assunto)"}</p>
                    <div className="flex items-center gap-1.5">
                      <span className={`flex items-center gap-1 rounded-full border px-1.5 py-0.5 text-[10px] font-medium ${STATUS_COR[c.status]}`}>
                        <StatusIcon className="h-2.5 w-2.5" /> {STATUS_LABEL[c.status]}
                      </span>
                      {c.category === "bug" && (
                        <Badge variant="destructive" className="text-[10px]">Erro</Badge>
                      )}
                    </div>
                  </button>
                );
              })
            )}
          </div>
        </div>

        {/* Painel direito — a conversa aberta */}
        <div className="flex flex-1 flex-col">
          {!ativaId ? (
            <div className="flex flex-1 items-center justify-center text-sm text-muted-foreground">
              Selecione uma conversa pra ver os detalhes
            </div>
          ) : carregandoDetalhe || !ativa ? (
            <div className="flex flex-1 items-center justify-center"><LoadingSpinner color="brand" /></div>
          ) : (
            <>
              <div className="flex items-center justify-between border-b border-border p-3">
                <div>
                  <p className="text-sm font-semibold text-foreground">{ativa.subject || "(sem assunto)"}</p>
                  <p className="text-xs text-muted-foreground">{ativa.store_name} · {ativa.store_owner_email}</p>
                </div>
                <div className="flex items-center gap-2">
                  <Badge variant={ativa.category === "bug" ? "destructive" : "secondary"} className="text-[10px]">
                    {ativa.category === "bug" ? "Erro" : "Dúvida"}
                  </Badge>
                  <span className={`flex items-center gap-1 rounded-full border px-2 py-0.5 text-[10px] font-medium ${STATUS_COR[ativa.status]}`}>
                    {STATUS_LABEL[ativa.status]}
                  </span>
                </div>
              </div>

              <div className="flex-1 space-y-3 overflow-y-auto p-4">
                {(ativa.messages || []).map((m) => (
                  <div key={m.id} className={`flex ${m.sender === "admin" ? "justify-end" : "justify-start"}`}>
                    <div className={`flex max-w-[75%] items-start gap-2 ${m.sender === "admin" ? "flex-row-reverse" : ""}`}>
                      <div className={`mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-full ${
                        m.sender === "admin" ? "bg-emerald-500 text-white" : m.sender === "ai" ? "bg-primary/15 text-primary" : "bg-secondary"
                      }`}>
                        {m.sender === "admin" ? <ShieldCheck className="h-3.5 w-3.5" /> : m.sender === "ai" ? <Sparkles className="h-3.5 w-3.5" /> : <User className="h-3.5 w-3.5" />}
                      </div>
                      <div>
                        <div className={`rounded-2xl px-3 py-2 text-sm ${m.sender === "admin" ? "bg-emerald-500 text-white" : "bg-secondary"}`}>
                          {m.content}
                        </div>
                        <p className={`mt-0.5 text-[10px] text-muted-foreground ${m.sender === "admin" ? "text-right" : ""}`}>
                          {tempoRelativo(m.created_at)}
                        </p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>

              {ativa.status !== "resolved" && ativa.status !== "closed" && (
                <div className="flex gap-2 border-t border-border p-3">
                  <input
                    type="text"
                    value={resposta}
                    onChange={(e) => setResposta(e.target.value)}
                    onKeyDown={(e) => e.key === "Enter" && responder()}
                    placeholder="Responder à consultora..."
                    className="flex-1 rounded-lg border border-input px-3 py-2 text-sm outline-none focus:border-primary"
                  />
                  <Button onClick={responder} disabled={enviando || !resposta.trim()} size="sm">
                    {enviando ? <LoadingSpinner /> : <Send className="h-4 w-4" />}
                  </Button>
                </div>
              )}

              <div className="flex gap-2 border-t border-border p-3">
                <Button size="sm" variant="outline" onClick={() => mudarStatus("resolved")} disabled={ativa.status === "resolved"}>
                  Marcar como resolvida
                </Button>
                <Button size="sm" variant="ghost" onClick={() => mudarStatus("closed")} disabled={ativa.status === "closed"}>
                  Encerrar
                </Button>
              </div>
            </>
          )}
        </div>
      </div>
    </Card>
  );
}

// ─────────────────────────────────────────────────────────────
// Central de Ajuda (HelpContent) — vídeo, FAQ, guia, novidade, tudo num
// só CRUD. Substitui o antigo painel de "Vídeos Tutoriais".
// ─────────────────────────────────────────────────────────────

interface HelpContentItem {
  id: number;
  tipo: "video" | "faq" | "guia" | "novidade";
  titulo: string;
  corpo: string;
  video_url: string | null;
  categoria: string;
  status: "rascunho" | "visivel";
  ordem: number;
}

const TIPO_INFO: Record<string, { label: string; icon: any }> = {
  video: { label: "Vídeo", icon: Video },
  faq: { label: "FAQ", icon: HelpCircle },
  guia: { label: "Guia", icon: BookOpen },
  novidade: { label: "Novidade", icon: Newspaper },
};

function HelpContentPanel({ toast }: Props) {
  const [itens, setItens] = useState<HelpContentItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [editando, setEditando] = useState<HelpContentItem | null>(null);
  const [mostrarForm, setMostrarForm] = useState(false);

  const [filtroTipo, setFiltroTipo] = useState("");
  const [filtroCategoria, setFiltroCategoria] = useState("");
  const [filtroStatus, setFiltroStatus] = useState("");

  const carregar = async () => {
    setLoading(true);
    try {
      const dados = await adminApi.listHelpContent({
        tipo: filtroTipo || undefined,
        categoria: filtroCategoria || undefined,
        status: filtroStatus || undefined,
      });
      setItens(dados);
    } catch {
      toast({ title: "Erro", description: "Não deu pra carregar o conteúdo", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { carregar(); }, [filtroTipo, filtroCategoria, filtroStatus]);

  const excluir = async (id: number) => {
    if (!confirm("Excluir este conteúdo? Não tem como desfazer.")) return;
    try {
      await adminApi.deleteHelpContent(id);
      toast({ title: "Conteúdo excluído" });
      carregar();
    } catch {
      toast({ title: "Erro", description: "Não deu pra excluir", variant: "destructive" });
    }
  };

  // Categorias distintas já usadas, pro filtro — não é uma lista fixa, é o
  // que o admin já cadastrou até agora.
  const categoriasExistentes = Array.from(new Set(itens.map((i) => i.categoria).filter(Boolean)));

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-base flex items-center gap-2">
            <BookOpen className="h-4 w-4" /> Central de Ajuda
          </CardTitle>
          <CardDescription>Vídeos, FAQs, guias e novidades — a mesma base que alimenta o chat e a página de suporte</CardDescription>
        </div>
        <Button size="sm" className="gap-1.5" onClick={() => { setEditando(null); setMostrarForm(true); }}>
          <Plus className="h-3.5 w-3.5" /> Novo conteúdo
        </Button>
      </CardHeader>
      <CardContent>
        <div className="mb-4 flex flex-wrap gap-2">
          <select value={filtroTipo} onChange={(e) => setFiltroTipo(e.target.value)} className="rounded-lg border border-input px-2 py-1.5 text-xs">
            <option value="">Todos os tipos</option>
            {Object.entries(TIPO_INFO).map(([k, v]) => <option key={k} value={k}>{v.label}</option>)}
          </select>
          <select value={filtroCategoria} onChange={(e) => setFiltroCategoria(e.target.value)} className="rounded-lg border border-input px-2 py-1.5 text-xs">
            <option value="">Todas as categorias</option>
            {categoriasExistentes.map((c) => <option key={c} value={c}>{c}</option>)}
          </select>
          <select value={filtroStatus} onChange={(e) => setFiltroStatus(e.target.value)} className="rounded-lg border border-input px-2 py-1.5 text-xs">
            <option value="">Todos os status</option>
            <option value="rascunho">Rascunho</option>
            <option value="visivel">Visível</option>
          </select>
          <button onClick={carregar} className="rounded-lg border border-border p-1.5 hover:bg-secondary">
            <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
          </button>
        </div>

        {mostrarForm && (
          <HelpContentForm
            item={editando}
            toast={toast}
            onSalvo={() => { setMostrarForm(false); carregar(); }}
            onCancelar={() => setMostrarForm(false)}
          />
        )}

        {loading ? (
          <div className="flex justify-center py-8"><LoadingSpinner color="brand" /></div>
        ) : itens.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">Nenhum conteúdo aqui ainda.</p>
        ) : (
          <div className="space-y-2">
            {itens.map((item) => {
              const info = TIPO_INFO[item.tipo];
              const Icon = info.icon;
              return (
                <div key={item.id} className="flex items-center justify-between gap-3 rounded-lg border border-border p-3">
                  <div className="flex min-w-0 items-center gap-2.5">
                    <div className="flex h-8 w-8 shrink-0 items-center justify-center rounded-lg bg-primary/10">
                      <Icon className="h-4 w-4 text-primary" />
                    </div>
                    <div className="min-w-0">
                      <div className="flex items-center gap-2">
                        <p className="truncate text-sm font-medium">{item.titulo}</p>
                        <Badge variant="outline" className="shrink-0 text-[10px]">{info.label}</Badge>
                      </div>
                      <p className="truncate text-xs text-muted-foreground">
                        {item.categoria || "Sem categoria"} · {item.status === "visivel" ? "Visível" : "Rascunho"}
                      </p>
                    </div>
                  </div>
                  <div className="flex shrink-0 gap-1">
                    <button onClick={() => { setEditando(item); setMostrarForm(true); }} className="rounded-lg p-1.5 text-muted-foreground hover:bg-secondary">
                      <Pencil className="h-3.5 w-3.5" />
                    </button>
                    <button onClick={() => excluir(item.id)} className="rounded-lg p-1.5 text-destructive hover:bg-destructive/10">
                      <Trash2 className="h-3.5 w-3.5" />
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </CardContent>
    </Card>
  );
}

function HelpContentForm({ item, toast, onSalvo, onCancelar }: {
  item: HelpContentItem | null;
  toast: Props["toast"];
  onSalvo: () => void;
  onCancelar: () => void;
}) {
  const [tipo, setTipo] = useState<HelpContentItem["tipo"]>(item?.tipo || "video");
  const [titulo, setTitulo] = useState(item?.titulo || "");
  const [corpo, setCorpo] = useState(item?.corpo || "");
  const [videoUrl, setVideoUrl] = useState(item?.video_url || "");
  const [categoria, setCategoria] = useState(item?.categoria || "");
  const [status, setStatus] = useState<HelpContentItem["status"]>(item?.status || "rascunho");
  const [salvando, setSalvando] = useState(false);

  // ⚠️ Mesma regra do backend, espelhada aqui só pra dar feedback antes de
  // enviar — a validação de verdade continua no servidor.
  const precisaVideoUrl = tipo === "video";
  const precisaCorpo = tipo === "faq" || tipo === "guia" || tipo === "novidade";

  const salvar = async () => {
    if (!titulo.trim()) {
      toast({ title: "Preencha o título", variant: "destructive" });
      return;
    }
    if (precisaVideoUrl && !videoUrl.trim()) {
      toast({ title: "Vídeo precisa de um link", variant: "destructive" });
      return;
    }
    if (precisaCorpo && !corpo.trim()) {
      toast({ title: `${TIPO_INFO[tipo].label} precisa de um texto`, variant: "destructive" });
      return;
    }
    setSalvando(true);
    try {
      const dados = {
        tipo, titulo: titulo.trim(), corpo: corpo.trim(),
        video_url: videoUrl.trim() || null, categoria: categoria.trim(), status,
      };
      if (item) {
        await adminApi.updateHelpContent(item.id, dados);
      } else {
        await adminApi.createHelpContent(dados);
      }
      toast({ title: item ? "Conteúdo atualizado" : "Conteúdo criado" });
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
        <p className="text-sm font-semibold">{item ? "Editar conteúdo" : "Novo conteúdo"}</p>
        <button onClick={onCancelar} className="rounded-lg p-1 hover:bg-secondary"><X className="h-4 w-4" /></button>
      </div>

      {/* Seletor de tipo — só disponível na criação; mudar o tipo de algo
          já publicado é raro e arriscado (perderia corpo/video_url sem
          querer), então mantém fixo na edição. */}
      {!item ? (
        <div className="flex gap-1.5">
          {Object.entries(TIPO_INFO).map(([k, v]) => (
            <button
              key={k}
              onClick={() => setTipo(k as HelpContentItem["tipo"])}
              className={`flex flex-1 items-center justify-center gap-1.5 rounded-lg border py-2 text-xs font-medium ${
                tipo === k ? "border-primary bg-primary/10 text-primary" : "border-border text-muted-foreground"
              }`}
            >
              <v.icon className="h-3.5 w-3.5" /> {v.label}
            </button>
          ))}
        </div>
      ) : (
        <Badge variant="outline" className="w-fit">{TIPO_INFO[tipo].label}</Badge>
      )}

      <input
        type="text" value={titulo} onChange={(e) => setTitulo(e.target.value)}
        placeholder="Título"
        className="w-full rounded-lg border border-input px-3 py-2 text-sm"
      />

      {precisaVideoUrl && (
        <input
          type="text" value={videoUrl} onChange={(e) => setVideoUrl(e.target.value)}
          placeholder="Link do vídeo (YouTube)"
          className="w-full rounded-lg border border-input px-3 py-2 text-sm"
        />
      )}

      {(precisaCorpo || tipo === "video") && (
        <textarea
          value={corpo} onChange={(e) => setCorpo(e.target.value)}
          placeholder={tipo === "video" ? "Descrição (opcional)" : "Texto do conteúdo"}
          rows={precisaCorpo ? 4 : 2}
          className="w-full rounded-lg border border-input px-3 py-2 text-sm"
        />
      )}

      <div className="grid grid-cols-2 gap-3">
        <input
          type="text" value={categoria} onChange={(e) => setCategoria(e.target.value)}
          placeholder="Categoria (ex: Estoque)"
          className="rounded-lg border border-input px-3 py-2 text-sm"
        />
        <select value={status} onChange={(e) => setStatus(e.target.value as HelpContentItem["status"])} className="rounded-lg border border-input px-3 py-2 text-sm">
          <option value="rascunho">Rascunho</option>
          <option value="visivel">Visível</option>
        </select>
      </div>

      <Button onClick={salvar} disabled={salvando} size="sm" className="w-full">
        {salvando ? <LoadingSpinner /> : (item ? "Salvar alterações" : "Criar conteúdo")}
      </Button>
    </div>
  );
}