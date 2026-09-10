// src/lib/utm.ts
//
// Captura parâmetros UTM da URL e persiste no localStorage —
// sobrevive ao redirect de auth, enviado pro backend após o login.
const KEY = 'ma_utm';
const CAMPOS = ['utm_source', 'utm_medium', 'utm_campaign', 'utm_content'] as const;
type UTM = Partial<Record<typeof CAMPOS[number], string>>;

/** Lê UTMs da URL e salva no localStorage (first-touch, não sobrescreve). */
export function captureUTM(): void {
  if (localStorage.getItem(KEY)) return;
  const p = new URLSearchParams(window.location.search);
  const utm: UTM = {};
  for (const k of CAMPOS) { const v = p.get(k); if (v) utm[k] = v.slice(0, 100); }
  if (Object.keys(utm).length > 0) localStorage.setItem(KEY, JSON.stringify(utm));
}

export function getStoredUTM(): UTM | null {
  try { return JSON.parse(localStorage.getItem(KEY) || 'null'); } catch { return null; }
}

/** Envia UTMs ao backend logo após o login e limpa o storage. */
export async function sendUTMToBackend(post: (url: string, d: unknown) => Promise<unknown>): Promise<void> {
  const utm = getStoredUTM();
  if (!utm || Object.keys(utm).length === 0) return;
  try { await post('/growth/utm/', utm); localStorage.removeItem(KEY); } catch { /* silencioso */ }
}
