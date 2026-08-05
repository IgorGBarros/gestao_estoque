// src/lib/dateUtils.ts
//
// ⚠️ O bug que isto resolve: new Date("2028-01-01") — uma string só de
// data, sem hora — é interpretada pelo JavaScript como MEIA-NOITE UTC. Ao
// formatar com .toLocaleDateString() (que usa o fuso do navegador), num
// fuso atrás de UTC (Brasil, UTC-3), meia-noite UTC de 1º de janeiro vira
// 21h do dia 31 de dezembro — o dia ANTERIOR. É por isso que uma validade
// cadastrada como Jan/2028 aparecia como 31/12/2027.
//
// A causa raiz: strings SÓ com data (sem "T horário") são parseadas como
// UTC pelo spec do JavaScript; strings com hora são parseadas como local.
// Essa inconsistência é uma pegadinha clássica do JS, não bug do backend
// — o Django manda a data certa, o problema é só como o navegador lê essa
// string de volta.
//
// A correção: extrai ano/mês/dia manualmente da string e constrói o Date
// com o construtor (ano, mês, dia), que SEMPRE interpreta como horário
// local — nunca faz conversão de fuso nenhuma.

/**
 * Faz parse de uma string de data (YYYY-MM-DD, vinda do backend) como
 * horário LOCAL, evitando o bug de fuso do `new Date(string)` padrão.
 * Use esta função em vez de `new Date(x.expiration_date)` sempre que for
 * exibir, comparar ou ordenar uma data-only vinda da API.
 */
export function parseDateLocal(dateString: string | null | undefined): Date | null {
  if (!dateString) return null;
  const [ano, mes, dia] = dateString.split("-").map(Number);
  if (!ano || !mes || !dia) return null;
  return new Date(ano, mes - 1, dia);
}

/** Formata uma data-only da API direto em dd/mm/aaaa, sem o bug de fuso. */
export function formatDateLocal(dateString: string | null | undefined): string {
  const d = parseDateLocal(dateString);
  return d ? d.toLocaleDateString("pt-BR") : "";
}

/** Compara duas datas-only da API (retorna diferença em ms, tipo a.getTime() - b.getTime()). */
export function compareDateLocal(a: string | null | undefined, b: string | null | undefined): number {
  const da = parseDateLocal(a);
  const db = parseDateLocal(b);
  if (!da && !db) return 0;
  if (!da) return 1; // sem validade vai por último
  if (!db) return -1;
  return da.getTime() - db.getTime();
}
