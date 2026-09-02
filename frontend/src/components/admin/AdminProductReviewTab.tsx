// src/components/admin/AdminProductReviewTab.tsx
//
// Fila de revisão de produtos criados pelas consultoras — entram como
// 'aguardando', ficam invisíveis no catálogo global até o admin
// aprovar aqui, corrigindo o nome e adicionando o SKU de uma vez só.
import { useState, useEffect } from "react";
import { Check, X, RefreshCw, Loader2, ChevronDown, ChevronUp } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { Badge } from "../ui/badge";
import { adminApi } from "../../lib/api";
import { LoadingSpinner } from "../ui/loading-spinner";

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

interface ProdutoAguardando {
  id: number; name: string; brand: string | null; bar_code: string | null;
  natura_sku: string | null; category: string; image_url: string | null;
  official_price: number | null; created_at: string; cadastrada_por: string;
}

export default function AdminProductReviewTab({ toast }: Props) {
  const [produtos, setProdutos] = useState<ProdutoAguardando[]>([]);
  const [loading, setLoading] = useState(true);
  const [aberto, setAberto] = useState<number | null>(null);
  const [editando, setEditando] = useState<Record<string, string>>({});
  const [processando, setProcessando] = useState<number | null>(null);

  const carregar = async () => {
    setLoading(true);
    try { setProdutos(await adminApi.produtosAguardando()); }
    catch { toast({ title: "Erro ao carregar", variant: "destructive" }); }
    finally { setLoading(false); }
  };

  useEffect(() => { carregar(); }, []);

  const abrirEdicao = (p: ProdutoAguardando) => {
    setAberto(p.id);
    setEditando({
      name: p.name || "",
      natura_sku: p.natura_sku || "",
      category: p.category || "",
      brand: p.brand || "",
      official_price: p.official_price != null ? String(p.official_price) : "",
    });
  };

  const aprovar = async (p: ProdutoAguardando) => {
    setProcessando(p.id);
    try {
      await adminApi.revisarProduto(p.id, {
        acao: "aprovar",
        name: editando.name || p.name,
        natura_sku: editando.natura_sku || undefined,
        category: editando.category || p.category,
        brand: editando.brand || undefined,
        official_price: editando.official_price ? Number(editando.official_price) : undefined,
      });
      toast({ title: "Produto aprovado e publicado no catálogo!" });
      setProdutos((prev) => prev.filter((x) => x.id !== p.id));
      setAberto(null);
    } catch (err: any) {
      toast({ title: "Erro", description: err?.response?.data?.error, variant: "destructive" });
    } finally { setProcessando(null); }
  };

  const rejeitar = async (p: ProdutoAguardando) => {
    setProcessando(p.id);
    try {
      await adminApi.revisarProduto(p.id, { acao: "rejeitar" });
      toast({ title: "Produto rejeitado" });
      setProdutos((prev) => prev.filter((x) => x.id !== p.id));
    } catch { toast({ title: "Erro", variant: "destructive" }); }
    finally { setProcessando(null); }
  };

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between">
        <div>
          <CardTitle className="text-base flex items-center gap-2">
            🕵️ Revisão de Produtos
            {produtos.length > 0 && (
              <span className="rounded-full bg-brand px-2 py-0.5 text-[10px] font-semibold text-white">
                {produtos.length}
              </span>
            )}
          </CardTitle>
          <CardDescription>
            Criados pelas consultoras — corrija o nome e adicione o SKU antes de aprovar
          </CardDescription>
        </div>
        <button onClick={carregar} className="rounded-lg border border-border p-1.5 hover:bg-secondary">
          <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} />
        </button>
      </CardHeader>
      <CardContent>
        {loading ? (
          <div className="flex justify-center py-8"><LoadingSpinner size="page" color="brand" /></div>
        ) : produtos.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">
            Nenhum produto aguardando revisão — a fila está vazia.
          </p>
        ) : (
          <div className="space-y-2">
            {produtos.map((p) => (
              <div key={p.id} className="rounded-lg border border-border">
                {/* Linha resumida */}
                <div
                  className="flex cursor-pointer items-center gap-3 p-3"
                  onClick={() => aberto === p.id ? setAberto(null) : abrirEdicao(p)}
                >
                  {p.image_url ? (
                    <img src={p.image_url} alt="" className="h-10 w-10 shrink-0 rounded-lg object-cover" />
                  ) : (
                    <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-secondary text-muted-foreground text-xs">?</div>
                  )}
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-medium">{p.name}</p>
                    <p className="text-xs text-muted-foreground">
                      {p.bar_code && <span className="font-mono">{p.bar_code} · </span>}
                      {p.brand && <span>{p.brand} · </span>}
                      <span>{p.category}</span>
                    </p>
                    <p className="text-[10px] text-muted-foreground/70 mt-0.5">por {p.cadastrada_por}</p>
                  </div>
                  <div className="flex shrink-0 items-center gap-1">
                    {aberto === p.id ? <ChevronUp className="h-4 w-4 text-muted-foreground" /> : <ChevronDown className="h-4 w-4 text-muted-foreground" />}
                  </div>
                </div>

                {/* Formulário expandido */}
                {aberto === p.id && (
                  <div className="border-t border-border p-3 space-y-3">
                    <div className="grid grid-cols-2 gap-2">
                      <div className="col-span-2">
                        <label className="text-xs font-medium text-muted-foreground">Nome (corrija se necessário)</label>
                        <input
                          value={editando.name}
                          onChange={(e) => setEditando((prev) => ({ ...prev, name: e.target.value }))}
                          className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-medium text-muted-foreground">SKU</label>
                        <input
                          value={editando.natura_sku}
                          onChange={(e) => setEditando((prev) => ({ ...prev, natura_sku: e.target.value }))}
                          placeholder="Ex: 12345"
                          className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm font-mono outline-none focus:border-brand"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-medium text-muted-foreground">Categoria</label>
                        <input
                          value={editando.category}
                          onChange={(e) => setEditando((prev) => ({ ...prev, category: e.target.value }))}
                          className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-medium text-muted-foreground">Marca</label>
                        <input
                          value={editando.brand}
                          onChange={(e) => setEditando((prev) => ({ ...prev, brand: e.target.value }))}
                          className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                        />
                      </div>
                      <div>
                        <label className="text-xs font-medium text-muted-foreground">Preço oficial</label>
                        <input
                          type="number" step="0.01"
                          value={editando.official_price}
                          onChange={(e) => setEditando((prev) => ({ ...prev, official_price: e.target.value }))}
                          className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                        />
                      </div>
                    </div>

                    <div className="flex gap-2 pt-1">
                      <button
                        onClick={() => rejeitar(p)}
                        disabled={processando === p.id}
                        className="flex items-center gap-1.5 rounded-lg border border-destructive/30 px-3 py-2 text-xs text-destructive hover:bg-destructive/10 disabled:opacity-50"
                      >
                        {processando === p.id ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <X className="h-3.5 w-3.5" />}
                        Rejeitar
                      </button>
                      <button
                        onClick={() => aprovar(p)}
                        disabled={processando === p.id}
                        className="flex flex-1 items-center justify-center gap-1.5 rounded-lg bg-emerald-600 px-3 py-2 text-xs font-semibold text-white hover:opacity-90 disabled:opacity-50"
                      >
                        {processando === p.id ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : <Check className="h-3.5 w-3.5" />}
                        Aprovar e publicar no catálogo
                      </button>
                    </div>
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
