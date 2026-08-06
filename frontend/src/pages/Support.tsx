// components/ChatAssistant.tsx — VERSÃO REFATORADA COM PALETA DA MARCA
//
// ⚠️ Conceito básico de helpdesk: o chat mostra DUAS coisas separadas —
//   1. O histórico de CONSULTA (pergunta sobre estoque/vendas), que
//      continua acumulando normalmente, é conversa fluida com a Amorinha.
//   2. Um TICKET DE SUPORTE ativo (se houver) — só o que está em aberto
//      AGORA, esperando resposta. Não acumula tickets antigos aqui dentro
//      — o histórico completo e permanente mora em Central de Ajuda >
//      Minhas Conversas (pages/Support.tsx). Quando o ticket é resolvido,
//      some daqui (com um aviso rápido) e vira só histórico lá.
import React, { useState, useRef, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { motion, AnimatePresence } from "framer-motion";
import { X, Send, User, PlayCircle, HelpCircle, BookOpen, Newspaper, ShieldCheck, ExternalLink } from "lucide-react";
import { api } from "../services/api";
import { temRespostaNaoVista, marcarComoVista } from "../lib/supportSeen";
import amorinhaAvatar from "../assets/amorinha-avatar.png"; 

interface ResultadoAjuda {
  id: number;
  tipo: "video" | "faq" | "guia" | "novidade";
  titulo: string;
  resumo: string;
  video_url: string | null;
}
interface ChatMessage {
  id: string;
  role: "user" | "assistant";
  content: string;
  timestamp: Date;
  resultados?: ResultadoAjuda[];
}
interface TicketMensagem {
  id: number;
  sender: "user" | "ai" | "admin";
  content: string;
  created_at: string;
}
interface Ticket {
  id: string;
  status: "ai_handling" | "escalated" | "resolved" | "closed";
  subject: string;
  updated_at: string;
  messages: TicketMensagem[];
}

const SUGGESTIONS = [
  "Quantos Kaiak eu tenho?",
  "Quais produtos estão acabando?",
  "Como funciona a vitrine?",
  "Quais os mais vendidos?",
];
const TIPO_ICON: Record<string, any> = { video: PlayCircle, faq: HelpCircle, guia: BookOpen, novidade: Newspaper };
const MENSAGEM_BOAS_VINDAS: ChatMessage = {
  id: "welcome",
  role: "assistant",
  content: "Olá! 👋 Sou a Amorinha. Pergunte sobre seu estoque e vendas, ou tire uma dúvida sobre como usar o sistema — eu entendo os dois! 💜",
  timestamp: new Date(),
};

// ⚠️ ID do ticket ativo — persistido só aqui (é o "qual ticket estou
// acompanhando agora"); o rastreamento de "já vi a resposta" fica no
// utilitário compartilhado (lib/supportSeen.ts), usado igual pelo sino.
const TICKET_ID_KEY = "supportConversationId";

export const ChatAssistant: React.FC = () => {
  const navigate = useNavigate();
  const [isOpen, setIsOpen] = useState(false);
  const [messages, setMessages] = useState<ChatMessage[]>(() => {
    try {
      const data = localStorage.getItem("chatHistory");
      if (data) return JSON.parse(data).map((m: any) => ({ ...m, timestamp: new Date(m.timestamp) }));
    } catch (_) {}
    return [MENSAGEM_BOAS_VINDAS];
  });
  const [input, setInput] = useState("");
  const [isLoading, setIsLoading] = useState(false);

  // Ticket de suporte ativo — carregado do backend quando existe, nunca
  // do localStorage diretamente (localStorage só guarda o ID; o conteúdo
  // vem sempre fresco, pra nunca mostrar coisa desatualizada).
  const [ticket, setTicket] = useState<Ticket | null>(null);
  const [ticketId, setTicketId] = useState<string | null>(() => localStorage.getItem(TICKET_ID_KEY));
  const [hasUnread, setHasUnread] = useState(false);

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const isOpenRef = useRef(isOpen);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
    localStorage.setItem("chatHistory", JSON.stringify(messages));
  }, [messages]);

  useEffect(() => {
    if (isOpen) inputRef.current?.focus();
  }, [isOpen]);

  useEffect(() => {
    isOpenRef.current = isOpen;
    if (isOpen) {
      setHasUnread(false);
      if (ticket) marcarComoVista(ticket.id, ticket.updated_at);
    }
  }, [isOpen]);

  useEffect(() => {
    if (ticketId) localStorage.setItem(TICKET_ID_KEY, ticketId);
    else localStorage.removeItem(TICKET_ID_KEY);
  }, [ticketId]);

  // ── Acompanha o ticket ativo (se houver) — verifica resposta nova
  // periodicamente, mesmo com o chat fechado, e atualiza o painel do
  // ticket direto (não mistura com o histórico de consulta). ──
  useEffect(() => {
    if (!ticketId) {
      setTicket(null);
      return;
    }

    const verificar = async () => {
      try {
        const res = await api.get(`chat/support/conversations/${ticketId}/`);
        const dados: Ticket = res.data;
        setTicket(dados);

        const mensagens = dados.messages || [];
        const ultima = mensagens[mensagens.length - 1];
        if (ultima && temRespostaNaoVista(dados.id, dados.updated_at, "admin")) {
          if (!isOpenRef.current) setHasUnread(true);
        }
        // Estar com o chat ABERTO já conta como "vista" — não faz sentido
        // manter marcado como não-lida uma resposta que está literalmente
        // visível na tela agora.
        if (isOpenRef.current) marcarComoVista(dados.id, dados.updated_at);

        // Resolvida/encerrada: continua visível no painel por esta
        // sessão (a consultora vê a resposta final), mas deixa de ser "o
        // ticket ativo" — a próxima dúvida abre um ticket novo. O
        // histórico permanente já está garantido em Minhas Conversas.
        if (dados.status === "resolved" || dados.status === "closed") {
          setTicketId(null);
        }
      } catch {
        // Falha de rede numa verificação de fundo não interrompe nada —
        // só tenta de novo no próximo ciclo.
      }
    };

    verificar();
    const intervalo = setInterval(verificar, 45000);
    return () => clearInterval(intervalo);
  }, [ticketId]);

  const handleSend = async (text?: string) => {
    const msg = text || input.trim();
    if (!msg || isLoading) return;

    const userMessage: ChatMessage = { id: crypto.randomUUID(), role: "user", content: msg, timestamp: new Date() };
    setMessages((prev) => [...prev, userMessage]);
    setInput("");
    setIsLoading(true);

    try {
      if (ticketId) {
        // Já tem ticket em aberto — a mensagem vai direto pra ele, não
        // tenta rotear de novo (a consultora já está falando com gente).
        const res = await api.post(`chat/support/conversations/${ticketId}/`, { message: msg });
        setTicket(res.data);
        setMessages((prev) => [...prev, { id: crypto.randomUUID(), role: "assistant", content: "Adicionei sua mensagem na conversa com a equipe — veja a resposta ali embaixo. 👇", timestamp: new Date() }]);
        setIsLoading(false);
        return;
      }

      const historico: { question: string; answer: string }[] = [];
      for (let i = 0; i < messages.length - 1; i++) {
        if (messages[i].role === "user" && messages[i + 1].role === "assistant") {
          historico.push({ question: messages[i].content, answer: messages[i + 1].content });
        }
      }

      const res = await api.post("chat/unified/", { message: msg, history: historico.slice(-3), conversation_id: null });
      const dados = res.data;

      if (dados.tipo === "consulta") {
        setMessages((prev) => [...prev, { id: crypto.randomUUID(), role: "assistant", content: dados.resposta, timestamp: new Date() }]);
      } else if (dados.tipo === "ajuda_encontrada") {
        setMessages((prev) => [...prev, { id: crypto.randomUUID(), role: "assistant", content: "Encontrei isso que pode ajudar:", timestamp: new Date(), resultados: dados.resultados }]);
      } else if (dados.tipo === "escalado") {
        setTicketId(dados.conversation_id);
        setMessages((prev) => [...prev, { id: crypto.randomUUID(), role: "assistant", content: "Encaminhei sua pergunta pra equipe — acompanhe a resposta no painel abaixo. 👇", timestamp: new Date() }]);
      }
    } catch (error: any) {
      const semConsentimento = error?.response?.status === 403;
      setMessages((prev) => [
        ...prev,
        {
          id: crypto.randomUUID(),
          role: "assistant",
          content: semConsentimento
            ? "Pra eu poder te ajudar, preciso que você ative o uso de IA. Vá em Configurações → Privacidade e ligue \"Recursos de inteligência artificial\" — aí é só voltar aqui e perguntar de novo. 💜"
            : "⚠️ Ocorreu um erro. Tenta de novo?",
          timestamp: new Date(),
        },
      ]);
    }
    setIsLoading(false);
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      handleSend();
    }
  };

  return (
    <>
      <AnimatePresence>
        {!isOpen && (
          <div className="fixed bottom-6 right-6 z-50">
            <motion.button
              initial={{ scale: 0, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0, opacity: 0 }}
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              onClick={() => setIsOpen(true)}
              className="relative flex h-14 w-14 items-center justify-center rounded-full bg-brand shadow-lg shadow-brand/30 transition-shadow hover:shadow-xl hover:shadow-brand/40 overflow-hidden"
            >
              <img
                src={amorinhaAvatar}
                alt="Amorinha"
                className="h-full w-full object-cover"
                onError={(e) => {
                  (e.target as HTMLImageElement).style.display = "none";
                  (e.target as HTMLImageElement).parentElement!.innerHTML =
                    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>';
                }}
              />
            </motion.button>
            {/* Notificação: resposta do atendente chegou e a consultora
                ainda não abriu o chat pra ver. Mesma marcação (localStorage)
                que a aba "Suporte" do sino usa — nunca vão discordar. */}
            {hasUnread && (
              <motion.span
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                className="absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full bg-destructive text-[10px] font-bold text-white ring-2 ring-background"
              >
                1
              </motion.span>
            )}
          </div>
        )}
      </AnimatePresence>

      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 20, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 20, scale: 0.95 }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="fixed bottom-4 right-4 left-4 z-50 flex h-[70vh] max-h-[560px] flex-col overflow-hidden rounded-2xl border border-brand/20 bg-card shadow-2xl sm:left-auto sm:bottom-6 sm:right-6 sm:h-[560px] sm:w-[380px]"
          >
            <div className="flex items-center justify-between bg-gradient-to-r from-brand to-brand-hover px-4 py-3">
              <div className="flex items-center gap-2">
                <div className="h-9 w-9 rounded-full overflow-hidden border-2 border-white/30 shrink-0">
                  <img src={amorinhaAvatar} alt="Amorinha" className="h-full w-full object-cover" />
                </div>
                <div>
                  <p className="text-sm font-semibold text-white">Amorinha</p>
                  <p className="text-xs text-white/70">Estoque, vendas e dúvidas 💜</p>
                </div>
              </div>
              <button onClick={() => setIsOpen(false)} className="rounded-full p-1 text-white/70 transition-colors hover:bg-white/20 hover:text-white">
                <X className="h-5 w-5" />
              </button>
            </div>

            <div className="flex-1 overflow-y-auto px-4 py-3 space-y-3">
              {messages.map((msg) => (
                <motion.div key={msg.id} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} className={`flex flex-col gap-2 ${msg.role === "user" ? "items-end" : "items-start"}`}>
                  <div className={`flex gap-2 ${msg.role === "user" ? "flex-row-reverse" : ""}`}>
                    {msg.role === "assistant" && (
                      <div className="mt-1 h-6 w-6 shrink-0 rounded-full overflow-hidden border border-brand/20">
                        <img src={amorinhaAvatar} alt="Amorinha" className="h-full w-full object-cover" />
                      </div>
                    )}
                    <div className={`max-w-[75%] rounded-2xl px-3 py-2 text-sm leading-relaxed ${msg.role === "user" ? "bg-brand text-white rounded-br-md" : "bg-brand-soft text-foreground border border-brand/10 rounded-bl-md"}`}>
                      {msg.content.split("\n").map((line, i) => (
                        <p key={i} className={i > 0 ? "mt-1" : ""}>
                          {line.split(/(\*\*.*?\*\*)/).map((part, j) =>
                            part.startsWith("**") && part.endsWith("**") ? <strong key={j}>{part.slice(2, -2)}</strong> : <span key={j}>{part}</span>
                          )}
                        </p>
                      ))}
                    </div>
                    {msg.role === "user" && (
                      <div className="mt-1 flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-brand-soft">
                        <User className="h-3.5 w-3.5 text-brand-rose" />
                      </div>
                    )}
                  </div>

                  {msg.resultados && msg.resultados.length > 0 && (
                    <div className="ml-8 w-full max-w-[85%] space-y-1.5">
                      {msg.resultados.map((r) => {
                        const Icon = TIPO_ICON[r.tipo] || HelpCircle;
                        return (
                          <a key={r.id} href="/support" className="flex items-start gap-2 rounded-xl border border-brand/15 bg-card p-2.5 text-left transition-colors hover:border-brand/30">
                            <Icon className="mt-0.5 h-4 w-4 shrink-0 text-brand" />
                            <div className="min-w-0">
                              <p className="truncate text-xs font-semibold text-foreground">{r.titulo}</p>
                              <p className="line-clamp-2 text-[11px] text-muted-foreground">{r.resumo}</p>
                            </div>
                          </a>
                        );
                      })}
                    </div>
                  )}
                </motion.div>
              ))}

              {isLoading && (
                <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="flex items-center gap-2">
                  <div className="h-6 w-6 rounded-full overflow-hidden border border-brand/20">
                    <img src={amorinhaAvatar} alt="Amorinha" className="h-full w-full object-cover" />
                  </div>
                  <div className="flex gap-1 rounded-2xl bg-brand-soft px-4 py-3">
                    <span className="h-2 w-2 animate-bounce rounded-full bg-brand-rose/50" />
                    <span className="h-2 w-2 animate-bounce rounded-full bg-brand-rose/50 animation-delay-[150ms]" />
                    <span className="h-2 w-2 animate-bounce rounded-full bg-brand-rose/50 animation-delay-[300ms]" />
                  </div>
                </motion.div>
              )}

              {messages.length === 1 && !ticketId && (
                <div className="flex flex-wrap gap-1.5 pt-1">
                  {SUGGESTIONS.map((s) => (
                    <button key={s} onClick={() => handleSend(s)} className="rounded-full border border-brand-peach bg-brand-soft px-3 py-1 text-xs text-brand-rose transition-colors hover:border-brand/30 hover:bg-brand-peach/30 hover:text-brand">
                      {s}
                    </button>
                  ))}
                </div>
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* ── Painel do ticket ativo — só o que está em aberto AGORA,
                separado do histórico de consulta acima. Some quando
                resolve; o registro completo fica em Minhas Conversas. ── */}
            {ticket && (
              <div className="max-h-40 overflow-y-auto border-t border-brand-peach/30 bg-brand-soft/40 px-4 py-2.5">
                <div className="mb-1.5 flex items-center justify-between">
                  <span className="flex items-center gap-1 text-[11px] font-semibold text-brand">
                    <ShieldCheck className="h-3 w-3" /> Ticket com a equipe
                  </span>
                  <button
                    onClick={() => { setIsOpen(false); navigate("/support"); }}
                    className="flex items-center gap-0.5 text-[10px] text-brand-rose/70 hover:text-brand hover:underline"
                  >
                    Ver histórico <ExternalLink className="h-2.5 w-2.5" />
                  </button>
                </div>
                {ticket.messages.slice(-3).map((m) => (
                  <div key={m.id} className={`mb-1 text-xs ${m.sender === "user" ? "text-right" : ""}`}>
                    <span className={`inline-block max-w-[85%] rounded-lg px-2 py-1 ${m.sender === "admin" ? "bg-emerald-100 text-emerald-800" : m.sender === "user" ? "bg-brand text-white" : "bg-secondary"}`}>
                      {m.content}
                    </span>
                  </div>
                ))}
              </div>
            )}

            <div className="border-t border-brand-peach/30 bg-card p-3">
              <div className="flex items-center gap-2 rounded-xl border border-brand/15 bg-brand-soft/50 px-3 py-2 focus-within:border-brand/30 focus-within:ring-1 focus-within:ring-brand/20">
                <input
                  ref={inputRef}
                  type="text"
                  placeholder={ticketId ? "Continue a conversa com a equipe..." : "Pergunte ou tire uma dúvida..."}
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyDown={handleKeyDown}
                  disabled={isLoading}
                  className="flex-1 bg-transparent text-sm outline-none placeholder:text-brand-rose/50 disabled:opacity-50"
                />
                <button onClick={() => handleSend()} disabled={!input.trim() || isLoading} className="flex h-8 w-8 items-center justify-center rounded-lg bg-brand text-white transition-opacity disabled:opacity-30">
                  <Send className="h-4 w-4" />
                </button>
              </div>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
};