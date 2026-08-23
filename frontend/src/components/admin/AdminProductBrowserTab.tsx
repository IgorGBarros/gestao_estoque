// src/components/admin/AdminProductBrowserTab.tsx
//
// Navegação pelo catálogo global de produtos — paginada de verdade
// (nunca carrega tudo de uma vez, é por isso que o carregamento não
// fica pesado mesmo com o catálogo crescendo toda semana via crawler).
import { useState, useEffect } from "react";
import { Package, Search, ChevronLeft, ChevronRight } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { adminApi } from "../../lib/api";
import { LoadingSpinner } from "../ui/loading-spinner";

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

export default function AdminProductBrowserTab({ toast }: Props) {
  const [marcas, setMarcas] = useState<string[]>([]);
  const [marcaSelecionada, setMarcaSelecionada] = useState("");
  const [busca, setBusca] = useState("");
  const [produtos, setProdutos] = useState<any[]>([]);
  const [pagina, setPagina] = useState(1);
  const [totalPaginas, setTotalPaginas] = useState(1);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    adminApi.marcasDisponiveis().then(setMarcas).catch(() => {});
  }, []);

  const carregar = async () => {
    setLoading(true);
    try {
      const r = await adminApi.produtosCatalogo({ brand: marcaSelecionada, busca, page: pagina, page_size: 50 });
      setProdutos(r.produtos);
      setTotalPaginas(r.total_paginas);
      setTotal(r.total);
    } catch {
      toast({ title: "Erro", description: "Não deu pra carregar o catálogo", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { carregar(); }, [marcaSelecionada, pagina]);

  const buscar = () => {
    setPagina(1);
    carregar();
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-base flex items-center gap-2">
          <Package className="h-4 w-4" /> Produtos por Marca
        </CardTitle>
        <CardDescription>
          {total > 0 ? `${total} produto${total !== 1 ? "s" : ""} no total` : "Navegue pelo catálogo completo"}
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="mb-4 flex flex-wrap gap-2">
          <select
            value={marcaSelecionada}
            onChange={(e) => { setMarcaSelecionada(e.target.value); setPagina(1); }}
            className="rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
          >
            <option value="">Todas as marcas</option>
            {marcas.map((m) => <option key={m} value={m}>{m}</option>)}
          </select>
          <div className="flex flex-1 min-w-[200px] gap-2">
            <input
              value={busca}
              onChange={(e) => setBusca(e.target.value)}
              onKeyDown={(e) => e.key === "Enter" && buscar()}
              placeholder="Buscar por nome..."
              className="flex-1 rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
            />
            <button onClick={buscar} className="rounded-lg border border-border px-3 py-2 hover:bg-secondary">
              <Search className="h-4 w-4" />
            </button>
          </div>
        </div>

        {loading ? (
          <div className="flex justify-center py-8"><LoadingSpinner size="page" color="brand" /></div>
        ) : produtos.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">Nenhum produto encontrado.</p>
        ) : (
          <>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-border text-left text-xs text-muted-foreground">
                    <th className="pb-2 pr-3">Nome</th>
                    <th className="pb-2 pr-3">Marca</th>
                    <th className="pb-2 pr-3">Código de barras</th>
                    <th className="pb-2 pr-3">Categoria</th>
                    <th className="pb-2">Preço</th>
                  </tr>
                </thead>
                <tbody>
                  {produtos.map((p) => (
                    <tr key={p.id} className="border-b border-border/50">
                      <td className="py-2 pr-3">{p.name}</td>
                      <td className="py-2 pr-3">{p.brand}</td>
                      <td className="py-2 pr-3 font-mono text-xs">{p.bar_code || "—"}</td>
                      <td className="py-2 pr-3">{p.category || "—"}</td>
                      <td className="py-2">{p.official_price != null ? `R$ ${p.official_price.toFixed(2)}` : "—"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <div className="mt-4 flex items-center justify-between text-xs text-muted-foreground">
              <span>Página {pagina} de {totalPaginas}</span>
              <div className="flex gap-2">
                <button
                  onClick={() => setPagina((p) => Math.max(1, p - 1))}
                  disabled={pagina <= 1}
                  className="rounded-lg border border-border p-1.5 disabled:opacity-40"
                >
                  <ChevronLeft className="h-3.5 w-3.5" />
                </button>
                <button
                  onClick={() => setPagina((p) => Math.min(totalPaginas, p + 1))}
                  disabled={pagina >= totalPaginas}
                  className="rounded-lg border border-border p-1.5 disabled:opacity-40"
                >
                  <ChevronRight className="h-3.5 w-3.5" />
                </button>
              </div>
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
}
