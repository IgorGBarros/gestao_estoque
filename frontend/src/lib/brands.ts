// src/lib/brands.ts
//
// Lista central de marcas — arquivo único pra não precisar atualizar
// em vários lugares quando uma marca nova é adicionada.
// Usada nos formulários de cadastro, filtros e dropdowns.
export const MARCAS_PADRAO = [
  "Avatim",
  "Avon",
  "Eudora",
  "Mary Kay",
  "Natura",
  "O Boticário",
  "Quem Disse Berenice",
  "Outra",
] as const;

export type MarcaPadrao = typeof MARCAS_PADRAO[number];

/**
 * Mescla as marcas padrão com marcas extras que já estão nos dados
 * (ex: estoque da consultora, catálogo carregado). Garante que uma
 * marca nova adicionada no banco apareça no dropdown mesmo antes de
 * estar na lista estática, sem duplicatas, em ordem alfabética.
 */
export function buildBrandList(extrasFromData: (string | null | undefined)[] = []): string[] {
  const todas = new Set<string>([...MARCAS_PADRAO]);
  for (const m of extrasFromData) {
    if (m && m.trim() && m !== "Outra") todas.add(m.trim());
  }
  // "Outra" sempre fica por último
  const sem_outra = [...todas].filter((m) => m !== "Outra").sort();
  return [...sem_outra, "Outra"];
}
