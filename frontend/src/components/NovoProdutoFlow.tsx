// src/components/NovoProdutoFlow.tsx
//
// Tela guiada que aparece quando a consultora escaneia um código de
// barras que não existe no catálogo — antes do cadastro, ela passa
// por 3 passos simples pra evitar duplicatas e garantir que realmente
// é um produto novo: verificar, preencher informações, e confirmar.
import { useState } from "react";
import { Search, PackagePlus, AlertTriangle, Loader2, CheckCircle, Sparkles } from "lucide-react";
import { api } from "../services/api";

interface Props {
  barCode: string;
  onCancelar: () => void;
  onConcluido: (produto: { name: string; category: string; brand: string; image_url: string }) => void;
}

export default function NovoProdutoFlow({ barCode, onCancelar, onConcluido }: Props) {
  const [passo, setPasso] = useState<"verificar" | "preencher" | "confirmar">("verificar");
  const [buscaNome, setBuscaNome] = useState("");
  const [resultadosBusca, setResultadosBusca] = useState<any[]>([]);
  const [buscando, setBuscando] = useState(false);
  const [verificado, setVerificado] = useState(false);
  const [form, setForm] = useState({ name: "", category: "Geral", brand: "", image_url: "" });
  const [salvando, setSalvando] = useState(false);
  // ⚠️ NOVO: busca automática pelo Cosmo — quando a consultora confirma
  // que é produto novo, o sistema tenta achar info do produto pelo código
  // de barras antes de exibir o formulário, pra pré-preencher o que
  // estiver disponível. Se não achar nada, o formulário fica em branco
  // normalmente — a consultora preenche igual a antes.
  const [buscandoCosmo, setBuscandoCosmo] = useState(false);
  const [fontePreencher, setFontePreencher] = useState<string | null>(null);

  const buscarPorNome = async () => {
    if (!buscaNome.trim()) return;
    setBuscando(true);
    try {
      const r = await api.get(`products/lookup/?q=${encodeURIComponent(buscaNome)}`);
      setResultadosBusca(r.data?.candidates || []);
    } catch {
      setResultadosBusca([]);
    } finally {
      setBuscando(false);
    }
  };

  const confirmarQueNaoExiste = async () => {
    setVerificado(true);
    setBuscandoCosmo(true);
    setPasso("preencher");

    // Tenta buscar pelo código de barras no Cosmo/Google Shopping — se
    // achar, pré-preenche o formulário. A consultora ainda pode corrigir
    // qualquer campo antes de enviar.
    try {
      const r = await api.get(`products/lookup/?ean=${encodeURIComponent(barCode)}&force_remote=true`);
      const dado = r.data;

      if (dado?.found && dado?.data) {
        const d = dado.data;
        setForm({
          name: d.name || d.product_name || "",
          category: d.category || "Geral",
          brand: d.brand || "",
          image_url: d.image_url || d.thumbnail || "",
        });
        setFontePreencher(dado.source === "remote_unconfirmed" ? "Cosmo / Internet" : "Catálogo");
      }
    } catch {
      // Se falhar, deixa o formulário em branco — sem drama
    } finally {
      setBuscandoCosmo(false);
    }
  };

  const preencher = (campo: string, valor: string) => {
    setForm((prev) => ({ ...prev, [campo]: valor }));
  };

  const enviar = async () => {
    if (!form.name.trim()) return;
    setSalvando(true);
    try {
      await api.post("stock/entry/", {
        bar_code: barCode,
        name: form.name.trim(),
        category: form.category,
        brand: form.brand,
        image_url: form.image_url,
        quantity: 1,
        cost_price: "0",
        sale_price: "0",
        confirmado_novo: true,
      });
      setPasso("confirmar");
    } catch (err: any) {
      alert(err?.response?.data?.error || "Não deu pra cadastrar. Tente de novo.");
    } finally {
      setSalvando(false);
    }
  };

  if (passo === "confirmar") {
    return (
      <div className="flex flex-col items-center gap-4 p-6 text-center">
        <CheckCircle className="h-12 w-12 text-emerald-500" />
        <div>
          <p className="font-semibold text-foreground">Produto enviado para revisão!</p>
          <p className="mt-1 text-sm text-muted-foreground">
            Ele já aparece no seu estoque, mas fica em revisão antes de entrar no catálogo geral.
          </p>
        </div>
        <button
          onClick={() => onConcluido(form)}
          className="w-full rounded-xl bg-brand py-3 text-sm font-semibold text-white"
        >
          Continuar
        </button>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-4 p-4">
      {/* Cabeçalho */}
      <div className="flex items-start gap-3 rounded-xl bg-amber-50 p-3">
        <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0 text-amber-500" />
        <div>
          <p className="text-sm font-semibold text-amber-800">Código de barras novo</p>
          <p className="text-xs text-amber-700 mt-0.5">
            <span className="font-mono">{barCode}</span> não está no catálogo ainda.
          </p>
        </div>
      </div>

      {passo === "verificar" && (
        <>
          <div>
            <p className="text-sm font-semibold text-foreground mb-1">
              1️⃣ Verifique se o produto já existe
            </p>
            <p className="text-xs text-muted-foreground mb-3">
              Busque pelo nome antes de cadastrar — talvez o mesmo produto exista com outro código.
            </p>
            <div className="flex gap-2">
              <input
                value={buscaNome}
                onChange={(e) => setBuscaNome(e.target.value)}
                onKeyDown={(e) => e.key === "Enter" && buscarPorNome()}
                placeholder="Ex: Kaiak Tradicional"
                className="flex-1 rounded-xl border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
              <button
                onClick={buscarPorNome}
                disabled={buscando}
                className="rounded-xl border border-border px-3 py-2"
              >
                {buscando ? <Loader2 className="h-4 w-4 animate-spin" /> : <Search className="h-4 w-4" />}
              </button>
            </div>

            {resultadosBusca.length > 0 && (
              <div className="mt-2 space-y-1 rounded-xl border border-border bg-card p-2">
                <p className="text-xs font-medium text-muted-foreground mb-1">Encontrados no catálogo:</p>
                {resultadosBusca.map((r: any) => (
                  <div key={r.id} className="flex items-center gap-2 rounded-lg bg-emerald-50 p-2 text-xs">
                    <CheckCircle className="h-4 w-4 shrink-0 text-emerald-600" />
                    <span className="font-medium text-emerald-800">{r.name}</span>
                    {r.bar_code && <span className="font-mono text-emerald-600">{r.bar_code}</span>}
                  </div>
                ))}
                <p className="text-[10px] text-muted-foreground pt-1">
                  Se o produto que você quer já aparece aí, use o código dele pra adicionar ao estoque.
                </p>
              </div>
            )}

            {resultadosBusca.length === 0 && buscaNome && !buscando && (
              <p className="mt-2 text-xs text-muted-foreground">Nenhum resultado — pode cadastrar como novo.</p>
            )}
          </div>

          <button
            onClick={confirmarQueNaoExiste}
            className="w-full rounded-xl border border-border bg-secondary py-3 text-sm font-medium"
          >
            Não encontrei — é um produto novo
          </button>
          <button onClick={onCancelar} className="text-center text-xs text-muted-foreground hover:underline">
            Cancelar
          </button>
        </>
      )}

      {passo === "preencher" && (
        <>
          <div>
            <p className="text-sm font-semibold text-foreground mb-1">
              2️⃣ Informações do produto
            </p>

            {buscandoCosmo ? (
              <div className="flex items-center gap-2 rounded-xl bg-brand/5 px-3 py-2 text-xs text-brand">
                <Loader2 className="h-3.5 w-3.5 animate-spin" />
                Buscando informações automaticamente...
              </div>
            ) : fontePreencher ? (
              <div className="flex items-center gap-2 rounded-xl bg-emerald-50 px-3 py-2 text-xs text-emerald-700">
                <Sparkles className="h-3.5 w-3.5 shrink-0" />
                Preenchido automaticamente pelo {fontePreencher} — confira e corrija se precisar.
              </div>
            ) : (
              <p className="text-xs text-muted-foreground mb-1">
                Coloque o que estiver na embalagem — o catálogo vai ser revisado depois.
              </p>
            )}
          </div>

          <div className="space-y-2">
            <div>
              <label className="text-xs font-medium text-muted-foreground">Nome do produto *</label>
              <input
                value={form.name}
                onChange={(e) => preencher("name", e.target.value)}
                placeholder="Ex: Desodorante Kaiak Tradicional 75ml"
                className="mt-1 w-full rounded-xl border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
            <div className="grid grid-cols-2 gap-2">
              <div>
                <label className="text-xs font-medium text-muted-foreground">Marca</label>
                <select
                  value={form.brand}
                  onChange={(e) => preencher("brand", e.target.value)}
                  className="mt-1 w-full rounded-xl border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                >
                  <option value="">Selecione</option>
                  {["Natura", "Avon", "O Boticário", "Eudora", "Mary Kay", "Quem Disse Berenice"].map((m) => (
                    <option key={m} value={m}>{m}</option>
                  ))}
                  <option value="Outra">Outra</option>
                </select>
              </div>
              <div>
                <label className="text-xs font-medium text-muted-foreground">Categoria</label>
                <select
                  value={form.category}
                  onChange={(e) => preencher("category", e.target.value)}
                  className="mt-1 w-full rounded-xl border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
                >
                  {["Perfumaria", "Maquiagem", "Skin Care", "Cabelos", "Corpo e Banho", "Geral"].map((c) => (
                    <option key={c} value={c}>{c}</option>
                  ))}
                </select>
              </div>
            </div>
            <div>
              <label className="text-xs font-medium text-muted-foreground">Link da foto (opcional)</label>
              {form.image_url && (
                <img src={form.image_url} alt="" className="mt-1 h-16 w-16 rounded-lg object-cover border border-border" onError={(e) => (e.currentTarget.style.display = "none")} />
              )}
              <input
                value={form.image_url}
                onChange={(e) => preencher("image_url", e.target.value)}
                placeholder="https://..."
                className="mt-1 w-full rounded-xl border border-input bg-background px-3 py-2 text-sm outline-none focus:border-brand"
              />
            </div>
          </div>

          <button
            onClick={enviar}
            disabled={!form.name.trim() || salvando || buscandoCosmo}
            className="flex w-full items-center justify-center gap-2 rounded-xl bg-brand py-3 text-sm font-semibold text-white disabled:opacity-50"
          >
            {salvando ? <Loader2 className="h-4 w-4 animate-spin" /> : <PackagePlus className="h-4 w-4" />}
            Enviar para revisão
          </button>
          <button onClick={onCancelar} className="text-center text-xs text-muted-foreground hover:underline">
            Cancelar
          </button>
        </>
      )}
    </div>
  );
}


interface Props {
  barCode: string;
  onCancelar: () => void;
  onConcluido: (produto: { name: string; category: string; brand: string; image_url: string }) => void;
}

