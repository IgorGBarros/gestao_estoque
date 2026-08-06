// lib/supportSeen.ts
//
// Rastreamento único de "já vi essa conversa até quando" — usado pelo
// balão de chat (ChatAssistant), pelo sino (NotificationBell) e pela
// página de suporte (Support.tsx > Minhas Conversas). Os três leem e
// escrevem NA MESMA chave, pra nunca discordar entre si sobre o que já
// foi visto (antes, cada um tinha seu próprio jeito de rastrear isso).
const KEY = "supportSeenPerConv";

function lerTudo(): Record<string, string> {
  try {
    return JSON.parse(localStorage.getItem(KEY) || "{}");
  } catch {
    return {};
  }
}

/** A conversa tem resposta da equipe mais nova do que a última vez vista? */
export function temRespostaNaoVista(conversationId: string, updatedAt: string, lastMessageSender?: string): boolean {
  if (lastMessageSender !== "admin") return false;
  const vistos = lerTudo();
  const ultimoVisto = vistos[conversationId];
  return !ultimoVisto || new Date(updatedAt) > new Date(ultimoVisto);
}

/** Marca a conversa como vista até este momento (updated_at do que foi carregado). */
export function marcarComoVista(conversationId: string, updatedAt: string) {
  try {
    const vistos = lerTudo();
    vistos[conversationId] = updatedAt;
    // Limita o tamanho — não deixa crescer pra sempre com conversa antiga.
    const entradas = Object.entries(vistos);
    const limitado = entradas.length > 50 ? Object.fromEntries(entradas.slice(-50)) : vistos;
    localStorage.setItem(KEY, JSON.stringify(limitado));
  } catch { /* localStorage indisponível não é motivo pra quebrar a tela */ }
}