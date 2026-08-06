// components/ChatAssistant.tsx — VERSÃO REFATORADA COM PALETA DA MARCA
//
// ⚠️ Chat único, sem menu de escolha — a consultora só digita o que
// quiser, e o BACKEND decide se é consulta de dados (estoque/vendas) ou
// dúvida de ajuda (busca na Central de Ajuda; sem achar, escala pra
// humano). Um único endpoint: POST /api/chat/unified/.
import React, { useState, useRef, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { X, Send, User, PlayCircle, HelpCircle, BookOpen, Newspaper } from "lucide-react";
import { api } from "../services/api";
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

export const ChatAssistant: React.FC = () => {
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
  // ⚠️ CORREÇÃO: antes só vivia em memória (useState puro) — se a página
  // recarregasse, a conversa "esquecia" que já tinha sido escalada, e a
  // próxima mensagem passava pelo roteamento inteiro de novo (podendo
  // escalar uma SEGUNDA conversa duplicada). Agora persiste igual o
  // histórico de mensagens já persistia.
  const [conversationId, setConversationId] = useState<string | null>(() => localStorage.getItem("supportConversationId"));
  // Quantas mensagens dessa conversa a consultora já viu — usado só pra
  // saber se tem resposta nova do atendente que ela ainda não abriu.
  const [hasUnread, setHasUnread] = useState(false);

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
    localStorage.setItem("chatHistory", JSON.stringify(messages));
  }, [messages]);

  useEffect(() => {
    if (isOpen) inputRef.current?.focus();
  }, [isOpen]);

  useEffect(() => {
    if (conversationId) localStorage.setItem("supportConversationId", conversationId);
    else localStorage.removeItem("supportConversationId");
  }, [conversationId]);

  // Ao abrir o chat, o que estava esperando resposta já foi visto.
  useEffect(() => {
    if (isOpen) setHasUnread(false);
  }, [isOpen]);

  // Ref auxiliar pra saber, DENTRO do polling abaixo, se o chat está
  // aberto no momento exato em que a resposta chega — sem isso, a closure
  // do useEffect de polling capturaria o valor de `isOpen` de quando o
  // efeito rodou (o polling só reinicia quando conversationId muda, não a
  // cada render), sempre desatualizado.
  const isOpenRef = useRef(isOpen);
  useEffect(() => {
    isOpenRef.current = isOpen;
  }, [isOpen]);

  // ── Notificação de resposta do atendente ──
  // Verifica periodicamente (só quando existe uma conversa escalada ativa)
  // se chegou mensagem nova da equipe desde a última vez que a consultora
  // olhou. Roda mesmo com o chat fechado — é exatamente aí que a
  // notificação faz diferença (senão ela só saberia abrindo por acaso).
  useEffect(() => {
    if (!conversationId) return;

    const verificarNovaResposta = async () => {
      try {
        const res = await api.get(`chat/support/conversations/${conversationId}/`);
        const conv = res.data;

        if (conv.status === "resolved" || conv.status === "closed") {
          // Conversa encerrada — a próxima dúvida começa uma conversa nova.
          setConversationId(null);
          localStorage.removeItem("supportLastSeenMsgId");
          return;
        }

        const ultimaMsg = conv.messages?.[conv.messages.length - 1];
        if (!ultimaMsg || ultimaMsg.sender !== "admin") return;

        const jaViuEssaResposta = localStorage.getItem("supportLastSeenMsgId") === String(ultimaMsg.id);
        if (jaViuEssaResposta) return;

        // Mensagem nova da equipe: adiciona ao histórico visível (se ainda
        // não estiver lá) e marca como não-lida se o chat estiver fechado.
        setMessages((prev) => {
          if (prev.some((m) => m.id === `admin-${ultimaMsg.id}`)) return prev;
          return [...prev, { id: `admin-${ultimaMsg.id}`, role: "assistant", content: ultimaMsg.content, timestamp: new Date(ultimaMsg.created_at) }];
        });
        localStorage.setItem("supportLastSeenMsgId", String(ultimaMsg.id));
        if (!isOpenRef.current) setHasUnread(true);
      } catch {
        // Falha de rede numa verificação de fundo não merece incomodar a
        // consultora com mensagem de erro — só tenta de novo no próximo ciclo.
      }
    };

    verificarNovaResposta();
    const intervalo = setInterval(verificarNovaResposta, 45000);
    return () => clearInterval(intervalo);
  }, [conversationId]);

  const handleSend = async (text?: string) => {
    const msg = text || input.trim();
    if (!msg || isLoading) return;

    const userMessage: ChatMessage = { id: crypto.randomUUID(), role: "user", content: msg, timestamp: new Date() };
    setMessages((prev) => [...prev, userMessage]);
    setInput("");
    setIsLoading(true);

    try {
      const historico: { question: string; answer: string }[] = [];
      for (let i = 0; i < messages.length - 1; i++) {
        if (messages[i].role === "user" && messages[i + 1].role === "assistant") {
          historico.push({ question: messages[i].content, answer: messages[i + 1].content });
        }
      }

      const res = await api.post("chat/unified/", {
        message: msg,
        history: historico.slice(-3),
        conversation_id: conversationId,
      });

      const dados = res.data;
      if (dados.tipo === "consulta") {
        setMessages((prev) => [...prev, { id: crypto.randomUUID(), role: "assistant", content: dados.resposta, timestamp: new Date() }]);
      } else if (dados.tipo === "ajuda_encontrada") {
        setMessages((prev) => [
          ...prev,
          { id: crypto.randomUUID(), role: "assistant", content: "Encontrei isso que pode ajudar:", timestamp: new Date(), resultados: dados.resultados },
        ]);
      } else if (dados.tipo === "escalado") {
        if (dados.conversation_id) setConversationId(dados.conversation_id);
        setMessages((prev) => [...prev, { id: crypto.randomUUID(), role: "assistant", content: dados.resposta, timestamp: new Date() }]);
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
      {/* ══════════════════════════════════════════
          BOTÃO FLUTUANTE
          ══════════════════════════════════════════ */}
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
                ainda não abriu o chat pra ver. */}
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

      {/* ══════════════════════════════════════════
          JANELA DO CHAT
          ══════════════════════════════════════════ */}
      <AnimatePresence>
        {isOpen && (
          <motion.div
            initial={{ opacity: 0, y: 20, scale: 0.95 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 20, scale: 0.95 }}
            transition={{ type: "spring", damping: 25, stiffness: 300 }}
            className="fixed bottom-4 right-4 left-4 z-50 flex h-[70vh] max-h-[520px] flex-col overflow-hidden rounded-2xl border border-brand/20 bg-card shadow-2xl sm:left-auto sm:bottom-6 sm:right-6 sm:h-[520px] sm:w-[380px]"
          >
            {/* ── Cabeçalho ── */}
            <div className="flex items-center justify-between bg-gradient-to-r from-brand to-brand-hover px-4 py-3">
              <div className="flex items-center gap-2">
                <div className="h-9 w-9 rounded-full overflow-hidden border-2 border-white/30 shrink-0">
                  <img src={amorinhaAvatar} alt="Amorinha" className="h-full w-full object-cover" />
                </div>
                <div>
                  <p className="text-sm font-semibold text-white">Amorinha</p>
                  <p className="text-xs text-white/70">
                    {conversationId ? "Encaminhado pra equipe" : "Estoque, vendas e dúvidas 💜"}
                  </p>
                </div>
              </div>
              <button onClick={() => setIsOpen(false)} className="rounded-full p-1 text-white/70 transition-colors hover:bg-white/20 hover:text-white">
                <X className="h-5 w-5" />
              </button>
            </div>

            {/* ── Mensagens ── */}
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

                  {/* Cards de sugestão da Central de Ajuda — até 3, cada um
                      com ícone por tipo, resumo curto e link. */}
                  {msg.resultados && msg.resultados.length > 0 && (
                    <div className="ml-8 w-full max-w-[85%] space-y-1.5">
                      {msg.resultados.map((r) => {
                        const Icon = TIPO_ICON[r.tipo] || HelpCircle;
                        return (
                          <a
                            key={r.id}
                            href="/support"
                            className="flex items-start gap-2 rounded-xl border border-brand/15 bg-card p-2.5 text-left transition-colors hover:border-brand/30"
                          >
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
                    <span className="h-2 w-2 animate-bounce rounded-full bg-brand-rose/50 animation-delay-[0ms]" />
                    <span className="h-2 w-2 animate-bounce rounded-full bg-brand-rose/50 animation-delay-[150ms]" />
                    <span className="h-2 w-2 animate-bounce rounded-full bg-brand-rose/50 animation-delay-[300ms]" />
                  </div>
                </motion.div>
              )}

              {messages.length === 1 && (
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

            {/* ── Campo de entrada ── */}
            <div className="border-t border-brand-peach/30 bg-card p-3">
              <div className="flex items-center gap-2 rounded-xl border border-brand/15 bg-brand-soft/50 px-3 py-2 focus-within:border-brand/30 focus-within:ring-1 focus-within:ring-brand/20">
                <input
                  ref={inputRef}
                  type="text"
                  placeholder={conversationId ? "Continue a conversa..." : "Pergunte ou tire uma dúvida..."}
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