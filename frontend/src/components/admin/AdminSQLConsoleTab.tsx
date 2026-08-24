// src/components/admin/AdminSQLConsoleTab.tsx
//
// Console de consulta — igual o "Query Generator" do SAP Business One,
// mas travado no backend: só SELECT, uma instrução por vez, limite de
// 500 linhas forçado, 5 segundos de tempo máximo. Não é acesso livre
// ao banco, é uma ferramenta de relatório rápido pra não precisar abrir
// o Supabase toda vez que quiser ver algo específico.
import { useState } from "react";
import { Terminal, Play, Loader2, AlertTriangle } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { adminApi } from "../../lib/api";

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

const EXEMPLOS = [
  "SELECT name, brand, official_price FROM inventory_product WHERE brand = 'Mary Kay' ORDER BY name",
  "SELECT brand, COUNT(*) as total FROM inventory_product GROUP BY brand ORDER BY total DESC",
  "SELECT name FROM inventory_store ORDER BY created_at DESC LIMIT 20",
];

export default function AdminSQLConsoleTab({ toast }: Props) {
  const [query, setQuery] = useState("");
  const [executando, setExecutando] = useState(false);
  const [resultado, setResultado] = useState<{ colunas: string[]; linhas: any[][]; total_retornado: number } | null>(null);
  const [erro, setErro] = useState<string | null>(null);

  const executar = async () => {
    if (!query.trim()) return;
    setExecutando(true);
    setErro(null);
    setResultado(null);
    try {
      const r = await adminApi.sqlConsole(query);
      setResultado(r);
    } catch (err: any) {
      setErro(err?.response?.data?.error || "Erro ao executar a consulta.");
    } finally {
      setExecutando(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-base flex items-center gap-2">
          <Terminal className="h-4 w-4" /> Consulta SQL
        </CardTitle>
        <CardDescription>
          Somente leitura — só SELECT, uma consulta por vez, limite de 500 linhas
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="mb-3 flex items-start gap-2 rounded-lg bg-amber-50 p-3 text-xs text-amber-800">
          <AlertTriangle className="h-4 w-4 shrink-0" />
          <p>Não é acesso livre ao banco — comandos que alterem dado (INSERT, UPDATE, DELETE, DROP...) são sempre recusados, mesmo pra admin.</p>
        </div>

        <textarea
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="SELECT * FROM inventory_product WHERE brand = 'Natura'"
          rows={5}
          className="w-full rounded-lg border border-input bg-background p-3 font-mono text-sm outline-none focus:border-brand resize-none"
        />

        <div className="mt-2 flex flex-wrap gap-1.5">
          {EXEMPLOS.map((ex, i) => (
            <button
              key={i}
              onClick={() => setQuery(ex)}
              className="rounded-full border border-border px-2.5 py-1 text-[10px] text-muted-foreground hover:bg-secondary"
            >
              Exemplo {i + 1}
            </button>
          ))}
        </div>

        <button
          onClick={executar}
          disabled={executando || !query.trim()}
          className="mt-3 flex items-center gap-2 rounded-lg bg-brand px-4 py-2 text-sm font-semibold text-white hover:opacity-90 disabled:opacity-50"
        >
          {executando ? <Loader2 className="h-4 w-4 animate-spin" /> : <Play className="h-4 w-4" />}
          Executar
        </button>

        {erro && (
          <div className="mt-4 rounded-lg bg-destructive/10 p-3 text-sm text-destructive">{erro}</div>
        )}

        {resultado && (
          <div className="mt-4">
            <p className="mb-2 text-xs text-muted-foreground">{resultado.total_retornado} linha(s)</p>
            <div className="overflow-x-auto rounded-lg border border-border">
              <table className="w-full text-xs">
                <thead>
                  <tr className="border-b border-border bg-secondary/40 text-left">
                    {resultado.colunas.map((c) => <th key={c} className="px-3 py-2 font-medium">{c}</th>)}
                  </tr>
                </thead>
                <tbody>
                  {resultado.linhas.map((linha, i) => (
                    <tr key={i} className="border-b border-border/50">
                      {linha.map((valor, j) => (
                        <td key={j} className="px-3 py-1.5 font-mono">{valor === null ? "—" : String(valor)}</td>
                      ))}
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  );
}