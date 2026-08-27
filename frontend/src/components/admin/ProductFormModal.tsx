// src/components/admin/ProductFormModal.tsx
//
// Formulário de produto reutilizável — cria produto novo (quando
// "produto" vem null) ou edita um existente. Usado tanto na tela
// "Produtos por Marca" quanto na "Revisão de Código de Barras" (corrigir
// o produto vinculado ao candidato, não só aprovar/recusar o código).
import { useState, useEffect } from "react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "../ui/dialog";
import { Loader2, Trash2 } from "lucide-react";
import { adminApi } from "../../lib/api";

export interface ProdutoEditavel {
  id?: number;
  name: string;
  brand: string;
  bar_code: string | null;
  natura_sku: string | null;
  category: string;
  description?: string | null;
  image_url?: string | null;
  official_price: number | null;
  min_quantity?: number;
}

interface Props {
  produto: ProdutoEditavel | null; // null = criando um novo
  open: boolean;
  onClose: () => void;
  onSaved: (produto: any) => void;
  onDeleted?: (id: number) => void;
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

const VAZIO: ProdutoEditavel = {
  name: "", brand: "", bar_code: "", natura_sku: "", category: "",
  description: "", image_url: "", official_price: null, min_quantity: 5,
};

export default function ProductFormModal({ produto, open, onClose, onSaved, onDeleted, toast }: Props) {
  const [form, setForm] = useState<ProdutoEditavel>(VAZIO);
  const [salvando, setSalvando] = useState(false);
  const [deletando, setDeletando] = useState(false);
  const [confirmandoExclusao, setConfirmandoExclusao] = useState(false);

  useEffect(() => {
    if (open) {
      setForm(produto ? { ...produto } : { ...VAZIO });
      setConfirmandoExclusao(false);
    }
  }, [open, produto]);

  const salvar = async () => {
    if (!form.name.trim()) {
      toast({ title: "Nome é obrigatório", variant: "destructive" });
      return;
    }
    setSalvando(true);
    try {
      const payload = {
        name: form.name.trim(),
        brand: form.brand || "",
        bar_code: form.bar_code || "",
        natura_sku: form.natura_sku || "",
        category: form.category || "",
        description: form.description || "",
        image_url: form.image_url || "",
        official_price: form.official_price,
        min_quantity: form.min_quantity,
      };
      const resultado = form.id
        ? await adminApi.atualizarProduto(form.id, payload)
        : await adminApi.criarProduto(payload);
      toast({ title: form.id ? "Produto atualizado!" : "Produto cadastrado!" });
      onSaved(resultado);
      onClose();
    } catch (err: any) {
      toast({ title: "Não deu pra salvar", description: err?.response?.data?.error, variant: "destructive" });
    } finally {
      setSalvando(false);
    }
  };

  const deletar = async () => {
    if (!form.id) return;
    setDeletando(true);
    try {
      await adminApi.deletarProduto(form.id);
      toast({ title: "Produto apagado" });
      onDeleted?.(form.id);
      onClose();
    } catch (err: any) {
      toast({ title: "Não deu pra apagar", description: err?.response?.data?.error, variant: "destructive" });
    } finally {
      setDeletando(false);
    }
  };

  return (
    <Dialog open={open} onOpenChange={(v) => !v && onClose()}>
      <DialogContent className="max-w-lg max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{form.id ? "Editar produto" : "Novo produto"}</DialogTitle>
        </DialogHeader>

        <div className="space-y-3">
          <div>
            <label className="text-xs font-medium text-muted-foreground">Nome *</label>
            <input
              value={form.name}
              onChange={(e) => setForm((p) => ({ ...p, name: e.target.value }))}
              className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
            />
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-xs font-medium text-muted-foreground">Marca</label>
              <input
                value={form.brand || ""}
                onChange={(e) => setForm((p) => ({ ...p, brand: e.target.value }))}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">Categoria</label>
              <input
                value={form.category || ""}
                onChange={(e) => setForm((p) => ({ ...p, category: e.target.value }))}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-xs font-medium text-muted-foreground">Código de barras</label>
              <input
                value={form.bar_code || ""}
                onChange={(e) => setForm((p) => ({ ...p, bar_code: e.target.value }))}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm font-mono outline-none focus:border-brand"
              />
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">SKU</label>
              <input
                value={form.natura_sku || ""}
                onChange={(e) => setForm((p) => ({ ...p, natura_sku: e.target.value }))}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm font-mono outline-none focus:border-brand"
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-3">
            <div>
              <label className="text-xs font-medium text-muted-foreground">Preço oficial</label>
              <input
                type="number" step="0.01"
                value={form.official_price ?? ""}
                onChange={(e) => setForm((p) => ({ ...p, official_price: e.target.value ? Number(e.target.value) : null }))}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">Estoque mínimo</label>
              <input
                type="number"
                value={form.min_quantity ?? 5}
                onChange={(e) => setForm((p) => ({ ...p, min_quantity: Number(e.target.value) }))}
                className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
          </div>

          <div>
            <label className="text-xs font-medium text-muted-foreground">Link da foto</label>
            <input
              value={form.image_url || ""}
              onChange={(e) => setForm((p) => ({ ...p, image_url: e.target.value }))}
              placeholder="https://..."
              className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
            />
          </div>

          <div>
            <label className="text-xs font-medium text-muted-foreground">Descrição</label>
            <textarea
              value={form.description || ""}
              onChange={(e) => setForm((p) => ({ ...p, description: e.target.value }))}
              rows={2}
              className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand resize-none"
            />
          </div>

          <div className="flex items-center justify-between gap-2 pt-2">
            {form.id ? (
              confirmandoExclusao ? (
                <div className="flex items-center gap-2 text-xs">
                  <span className="text-muted-foreground">Apagar de vez?</span>
                  <button onClick={deletar} disabled={deletando} className="font-medium text-destructive hover:underline disabled:opacity-50">
                    {deletando ? "Apagando..." : "Sim, apagar"}
                  </button>
                  <button onClick={() => setConfirmandoExclusao(false)} className="text-muted-foreground hover:underline">
                    Cancelar
                  </button>
                </div>
              ) : (
                <button
                  onClick={() => setConfirmandoExclusao(true)}
                  className="flex items-center gap-1.5 text-xs text-destructive hover:underline"
                >
                  <Trash2 className="h-3.5 w-3.5" /> Apagar produto
                </button>
              )
            ) : <span />}

            <div className="flex gap-2">
              <button onClick={onClose} className="rounded-lg border border-border px-3 py-2 text-sm hover:bg-secondary">
                Cancelar
              </button>
              <button
                onClick={salvar}
                disabled={salvando}
                className="flex items-center gap-2 rounded-lg bg-brand px-4 py-2 text-sm font-semibold text-white hover:opacity-90 disabled:opacity-50"
              >
                {salvando && <Loader2 className="h-4 w-4 animate-spin" />}
                {form.id ? "Salvar" : "Cadastrar"}
              </button>
            </div>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
