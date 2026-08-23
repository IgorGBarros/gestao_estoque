// src/components/admin/AdminCatalogTab.tsx
//
// Fila de revisão dos candidatos de código de barras que o
// cosmos_barcode_finder encontra mas não tem confiança suficiente pra
// aplicar sozinho (só "muito alta" vira bar_code automaticamente — ver
// admin_views.py). Aqui o admin confirma ou recusa cada um, rápido.
import { useState, useEffect } from "react";
import { Barcode, Check, X, RefreshCw } from "lucide-react";
import { Badge } from "../ui/badge";
import { Button } from "../ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { adminApi } from "../../lib/api";
import { LoadingSpinner } from "../ui/loading-spinner";

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

interface Candidato {
  id: number;
  gtin: string;
  brand: string;
  description: string;
  confidence_level: string;
  searched_product_sku: string | null;
  searched_product_name: string | null;
  search_term_used: string | null;
  created_at: string;
  produto_id: number | null;
  image_url: string | null;
}

const CONFIANCA_COR: Record<string, string> = {
  high: "bg-blue-50 text-blue-700 border-blue-200",
  medium: "bg-amber-50 text-amber-700 border-amber-200",
  low: "bg-orange-50 text-orange-700 border-orange-200",
  very_low: "bg-red-50 text-red-700 border-red-200",
};
const CONFIANCA_LABEL: Record<string, string> = {
  high: "Alta",
  medium: "Média",
  low: "Baixa",
  very_low: "Muito baixa",
};

export default function AdminBarcodeReviewTab({ toast }: Props) {
  const [candidatos, setCandidatos] = useState<Candidato[]>([]);
  const [loading, setLoading] = useState(true);
  const [filtroBrand, setFiltroBrand] = useState("");
  const [filtroConfianca, setFiltroConfianca] = useState("");
  const [processando, setProcessando] = useState<number | null>(null);
  // ⚠️ NOVO: qual linha está com o campo de "colar link da foto" aberto,
  // e o texto digitado ali — só um por vez, mais simples de acompanhar.
  const [editandoFoto, setEditandoFoto] = useState<number | null>(null);
  const [urlFoto, setUrlFoto] = useState("");
  const [salvandoFoto, setSalvandoFoto] = useState(false);

  const carregar = async () => {
    setLoading(true);
    try {
      const dados = await adminApi.listBarcodeCandidates({
        brand: filtroBrand || undefined,
        confidence: filtroConfianca || undefined,
      });
      setCandidatos(dados);
    } catch {
      toast({ title: "Erro", description: "Não deu pra carregar os candidatos", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { carregar(); }, [filtroBrand, filtroConfianca]);

  const aprovar = async (c: Candidato) => {
    setProcessando(c.id);
    try {
      const resultado = await adminApi.approveBarcodeCandidate(c.id);
      toast({ title: "Código aplicado", description: `${resultado.produto} → ${resultado.gtin}` });
      setCandidatos((prev) => prev.filter((x) => x.id !== c.id));
    } catch (err: any) {
      toast({
        title: "Não deu pra aplicar",
        description: err?.response?.data?.error || "Esse produto pode já ter outro código de barras.",
        variant: "destructive",
      });
    } finally {
      setProcessando(null);
    }
  };

  const recusar = async (c: Candidato) => {
    setProcessando(c.id);
    try {
      await adminApi.rejectBarcodeCandidate(c.id);
      toast({ title: "Candidato recusado" });
      setCandidatos((prev) => prev.filter((x) => x.id !== c.id));
    } catch {
      toast({ title: "Erro", description: "Não deu pra recusar", variant: "destructive" });
    } finally {
      setProcessando(null);
    }
  };

  const salvarFoto = async (c: Candidato) => {
    if (!urlFoto.trim()) return;
    setSalvandoFoto(true);
    try {
      await adminApi.setBarcodeCandidateImage(c.id, urlFoto.trim());
      setCandidatos((prev) => prev.map((x) => (x.id === c.id ? { ...x, image_url: urlFoto.trim() } : x)));
      toast({ title: "Foto salva no produto" });
      setEditandoFoto(null);
      setUrlFoto("");
    } catch (err: any) {
      toast({ title: "Não deu pra salvar", description: err?.response?.data?.error, variant: "destructive" });
    } finally {
      setSalvandoFoto(false);
    }
  };

  // Marcas já presentes na fila, pro filtro — não é lista fixa.
  const marcasExistentes = Array.from(new Set(candidatos.map((c) => c.brand).filter(Boolean)));

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-base flex items-center gap-2">
            <Barcode className="h-4 w-4" /> Revisão de Códigos de Barras
          </CardTitle>
          <CardDescription>
            Candidatos que o crawler encontrou mas não teve confiança suficiente pra aplicar sozinho
          </CardDescription>
        </div>
        <button onClick={carregar} className="rounded-lg border border-border p-1.5 hover:bg-secondary">
          <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
        </button>
      </CardHeader>
      <CardContent>
        <div className="mb-4 flex flex-wrap gap-2">
          <select value={filtroBrand} onChange={(e) => setFiltroBrand(e.target.value)} className="rounded-lg border border-input px-2 py-1.5 text-xs">
            <option value="">Todas as marcas</option>
            {marcasExistentes.map((b) => <option key={b} value={b}>{b}</option>)}
          </select>
          <select value={filtroConfianca} onChange={(e) => setFiltroConfianca(e.target.value)} className="rounded-lg border border-input px-2 py-1.5 text-xs">
            <option value="">Todas as confianças</option>
            <option value="high">Alta</option>
            <option value="medium">Média</option>
            <option value="low">Baixa</option>
            <option value="very_low">Muito baixa</option>
          </select>
        </div>

        {loading ? (
          <div className="flex justify-center py-8"><LoadingSpinner color="brand" /></div>
        ) : candidatos.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">
            Nenhum candidato esperando revisão — a fila está vazia.
          </p>
        ) : (
          <div className="space-y-2">
            {candidatos.map((c) => (
              <div key={c.id} className="rounded-lg border border-border p-3">
                <div className="flex items-center justify-between gap-3">
                  {/* ⚠️ NOVO: foto do produto vinculado — se o crawler já
                      tiver achado uma, mostra direto; se não, oferece
                      preencher na hora, sem precisar ir em outra tela. */}
                  <div className="h-12 w-12 shrink-0 overflow-hidden rounded-lg bg-secondary/50">
                    {c.image_url ? (
                      <img src={c.image_url} alt="" className="h-full w-full object-cover" />
                    ) : (
                      <div className="flex h-full w-full items-center justify-center text-muted-foreground">
                        <Barcode className="h-5 w-5 opacity-40" />
                      </div>
                    )}
                  </div>

                  <div className="min-w-0 flex-1">
                    <div className="flex flex-wrap items-center gap-2">
                      <p className="truncate text-sm font-medium text-foreground">
                        {c.searched_product_name || c.description}
                      </p>
                      <span className={`rounded-full border px-2 py-0.5 text-[10px] font-medium ${CONFIANCA_COR[c.confidence_level] || ""}`}>
                        {CONFIANCA_LABEL[c.confidence_level] || c.confidence_level}
                      </span>
                      {c.brand && <Badge variant="outline" className="text-[10px]">{c.brand}</Badge>}
                    </div>
                    <p className="mt-0.5 font-mono text-xs text-muted-foreground">
                      GTIN {c.gtin}
                      {c.searched_product_sku && ` · SKU ${c.searched_product_sku}`}
                    </p>
                    {!c.image_url && c.produto_id && editandoFoto !== c.id && (
                      <button
                        onClick={() => { setEditandoFoto(c.id); setUrlFoto(""); }}
                        className="mt-1 text-[10px] text-brand hover:underline"
                      >
                        + Adicionar foto
                      </button>
                    )}
                  </div>
                  <div className="flex shrink-0 gap-1.5">
                    <button
                      onClick={() => recusar(c)}
                      disabled={processando === c.id}
                      className="flex h-8 w-8 items-center justify-center rounded-lg border border-destructive/30 text-destructive hover:bg-destructive/10 disabled:opacity-50"
                      title="Recusar"
                    >
                      <X className="h-4 w-4" />
                    </button>
                    <button
                      onClick={() => aprovar(c)}
                      disabled={processando === c.id}
                      className="flex h-8 w-8 items-center justify-center rounded-lg border border-emerald-300 text-emerald-600 hover:bg-emerald-50 disabled:opacity-50"
                      title="Aprovar e aplicar no produto"
                    >
                      {processando === c.id ? <LoadingSpinner /> : <Check className="h-4 w-4" />}
                    </button>
                  </div>
                </div>

                {editandoFoto === c.id && (
                  <div className="mt-2 flex gap-2 pl-[60px]">
                    <input
                      value={urlFoto}
                      onChange={(e) => setUrlFoto(e.target.value)}
                      placeholder="Cole o link da foto (https://...)"
                      className="flex-1 rounded-lg border border-input bg-background px-3 py-1.5 text-xs outline-none focus:border-brand"
                    />
                    <button
                      onClick={() => setEditandoFoto(null)}
                      className="rounded-lg border border-border px-2.5 py-1.5 text-xs hover:bg-secondary"
                    >
                      Cancelar
                    </button>
                    <button
                      onClick={() => salvarFoto(c)}
                      disabled={salvandoFoto || !urlFoto.trim()}
                      className="rounded-lg bg-brand px-2.5 py-1.5 text-xs font-medium text-white hover:opacity-90 disabled:opacity-50"
                    >
                      {salvandoFoto ? <LoadingSpinner size="sm" /> : "Salvar"}
                    </button>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  );
}