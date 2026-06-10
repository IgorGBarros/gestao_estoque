import { useState, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { AnimatePresence, motion } from "framer-motion";
import {
  ScanBarcode, Camera, Hash, DollarSign, ChevronRight, ChevronLeft,
  Check, Loader2, X, Package
} from "lucide-react";
import BarcodeScanner from "../components/BarcodeScanner";
import { api } from "../services/api"; // ✅ Usa sua API
import { useToast } from '../components/ui/use-toast';

const STEPS = [
  { id: "scan", label: "Código", icon: ScanBarcode },
  { id: "expiry", label: "Validade", icon: Camera },
  { id: "details", label: "Preço & Qtd", icon: DollarSign },
  { id: "confirm", label: "Confirmar", icon: Check },
];

interface ProductData {
  barcode: string;
  product_name: string;
  category: string;
  expiry_date: string;
  quantity: number;
  cost_price: number;
  sale_price: number; // Adicionado para sugestão
}

export default function AddProduct() {
  const [step, setStep] = useState(0);
  const [showScanner, setShowScanner] = useState(true);
  const [loading, setLoading] = useState(false);
  
  const [data, setData] = useState<ProductData>({
    barcode: "",
    product_name: "",
    category: "Geral",
    expiry_date: "",
    quantity: 1,
    cost_price: 0,
    sale_price: 0
  });

  const fileInputRef = useRef<HTMLInputElement>(null);
  const navigate = useNavigate();
  const { toast } = useToast();

  // Passo 1: Código Escaneado -> Busca na API
  const handleBarcodeScan = async (barcode: string) => {
    setShowScanner(false);
    setData((prev) => ({ ...prev, barcode }));

    try {
      // 1. Busca informações do produto (Local ou Remoto)
      const { data: response } = await api.get(`/products/lookup/?ean=${barcode}`);

      if (response.found && response.data) {
        setData((prev) => ({
          ...prev,
          product_name: response.data.name || prev.product_name,
          category: response.data.category || prev.category,
          // Se tiver preço oficial, sugerimos como venda (opcional)
          sale_price: response.data.official_price || 0 
        }));
        
        toast({ 
          title: "Produto Identificado!", 
          description: response.data.name 
        });
      } else {
        toast({ 
          title: "Novo Código", 
          description: "Preencha os dados do produto." 
        });
      }
    } catch (error) {
      console.error("Erro no lookup:", error);
      // Não bloqueia, apenas deixa o usuário preencher manual
    }

    setStep(1);
  };

  // Passo Final: Salvar no Backend
  const handleSave = async () => {
    setLoading(true);
    try {
      // Payload para o endpoint /stock/entry/
      const payload = {
        bar_code: data.barcode,
        quantity: data.quantity,
        cost_price: data.cost_price,
        sale_price: data.sale_price, // Envia também o preço de venda se quiser já definir
        expiration_date: data.expiry_date || null,
        // batch_code: "LOTE-X" // Pode adicionar campo de lote se quiser
      };

      await api.post("/stock/entry/", payload);

      toast({ 
        title: "Sucesso!", 
        description: `${data.quantity}x ${data.product_name} adicionado ao estoque.` 
      });
      
      navigate("/");
    } catch (err: any) {
      const msg = err.response?.data?.error || "Erro ao salvar estoque.";
      toast({ title: "Erro", description: msg, variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  const canAdvance = () => {
    if (step === 0) return !!data.barcode;
    if (step === 1) return true; // Validade é opcional
    if (step === 2) return data.quantity > 0 && !!data.product_name; // Nome é obrigatório no passo 2
    return true;
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b border-border bg-card">
        <div className="mx-auto flex max-w-lg items-center justify-between px-4 py-3">
          <button onClick={() => navigate("/")} className="rounded-lg p-2 text-muted-foreground hover:text-foreground">
            <X className="h-5 w-5" />
          </button>
          <h1 className="font-display text-base font-bold text-foreground">Cadastrar Produto</h1>
          <div className="w-9" />
        </div>
      </header>

      {/* Progress */}
      <div className="mx-auto max-w-lg px-4 pt-4">
        <div className="flex items-center gap-1">
          {STEPS.map((s, i) => (
            <div key={s.id} className="flex flex-1 flex-col items-center gap-1">
              <div
                className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold transition-colors ${
                  i <= step
                    ? "bg-primary text-primary-foreground"
                    : "bg-muted text-muted-foreground"
                }`}
              >
                {i < step ? <Check className="h-4 w-4" /> : i + 1}
              </div>
              <span className={`text-[10px] ${i <= step ? "text-primary font-medium" : "text-muted-foreground"}`}>
                {s.label}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Step Content */}
      <main className="mx-auto max-w-lg px-4 py-6">
        <AnimatePresence mode="wait">
          
          {/* Step 0: Barcode */}
          {step === 0 && (
            <motion.div key="scan" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              {showScanner ? (
                <BarcodeScanner onScan={handleBarcodeScan} onClose={() => navigate("/")} />
              ) : (
                <div className="space-y-4 rounded-xl border border-border bg-card p-5">
                  <div className="flex items-center gap-3">
                    <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
                      <ScanBarcode className="h-5 w-5 text-primary" />
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-foreground">Código Lido</p>
                      <p className="font-mono text-lg font-bold text-primary">{data.barcode}</p>
                    </div>
                  </div>
                  
                  {data.product_name && (
                    <div className="rounded-lg bg-primary/5 px-3 py-2 border border-primary/20">
                      <p className="text-xs text-primary font-medium">Produto identificado no sistema</p>
                      <p className="text-sm font-bold text-foreground mt-0.5">{data.product_name}</p>
                    </div>
                  )}

                  {!data.product_name && (
                    <div className="p-3 bg-secondary/30 rounded-lg text-xs text-muted-foreground">
                      Produto novo. Vamos preencher os dados nos próximos passos.
                    </div>
                  )}

                  <button
                    type="button"
                    onClick={() => setShowScanner(true)}
                    className="text-xs text-primary hover:underline"
                  >
                    Escanear outro código
                  </button>
                </div>
              )}
            </motion.div>
          )}

          {/* Step 1: Validade */}
          {step === 1 && (
            <motion.div key="expiry" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-6 rounded-xl border border-border bg-card p-5">
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
                    <Camera className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <p className="text-sm font-semibold text-foreground">Controle de Validade</p>
                    <p className="text-xs text-muted-foreground">Evite perdas controlando as datas</p>
                  </div>
                </div>

                {/* Input Manual de Data */}
                <div>
                  <label className="text-sm font-medium text-foreground">Data de Validade (Lote)</label>
                  <input
                    type="date"
                    value={data.expiry_date}
                    onChange={(e) => setData((p) => ({ ...p, expiry_date: e.target.value }))}
                    className="mt-2 w-full rounded-lg border border-input bg-background px-3 py-3 text-base outline-none focus:border-primary"
                  />
                  <p className="mt-2 text-xs text-muted-foreground">
                    {data.expiry_date 
                      ? "✅ Data registrada para controle FIFO" 
                      : "⚠️ Opcional, mas recomendado para cosméticos"}
                  </p>
                </div>

                {/* Placeholder Visual da Câmera (Para futuro OCR) */}
                <div className="border-t pt-4">
                    <p className="text-xs text-muted-foreground mb-3 text-center">Ou capture da embalagem (Em breve)</p>
                    <button
                        type="button"
                        disabled
                        className="flex w-full flex-col items-center justify-center gap-2 rounded-xl border-2 border-dashed border-border py-6 text-muted-foreground/50 cursor-not-allowed"
                    >
                        <Camera className="h-6 w-6" />
                        <span className="text-xs">Foto indisponível no momento</span>
                    </button>
                </div>
              </div>
            </motion.div>
          )}

          {/* Step 2: Quantity & Price */}
          {step === 2 && (
            <motion.div key="details" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-5 rounded-xl border border-border bg-card p-5">
                
                {/* Nome do Produto (Editável se não achou no lookup) */}
                <div>
                    <label className="text-sm font-medium text-foreground">Nome do Produto *</label>
                    <input
                      type="text"
                      value={data.product_name}
                      onChange={(e) => setData((p) => ({ ...p, product_name: e.target.value }))}
                      placeholder="Ex: Kaiak Aventura 100ml"
                      className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-primary"
                    />
                </div>

                {/* Quantidade */}
                <div>
                  <label className="text-sm font-medium text-foreground">Quantidade de Entrada *</label>
                  <div className="mt-2 flex items-center gap-3">
                    <button
                      type="button"
                      onClick={() => setData((p) => ({ ...p, quantity: Math.max(1, p.quantity - 1) }))}
                      className="flex h-12 w-12 items-center justify-center rounded-xl border border-border bg-secondary text-xl font-bold active:scale-95 transition-transform"
                    >
                      −
                    </button>
                    <input
                      type="number"
                      min={1}
                      value={data.quantity}
                      onChange={(e) => setData((p) => ({ ...p, quantity: Math.max(1, parseInt(e.target.value) || 1) }))}
                      className="h-12 flex-1 rounded-xl border border-input bg-background text-center font-mono text-xl font-bold outline-none focus:border-primary"
                    />
                    <button
                      type="button"
                      onClick={() => setData((p) => ({ ...p, quantity: p.quantity + 1 }))}
                      className="flex h-12 w-12 items-center justify-center rounded-xl border border-border bg-secondary text-xl font-bold active:scale-95 transition-transform"
                    >
                      +
                    </button>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                    {/* Preço de Custo */}
                    <div>
                    <label className="text-sm font-medium text-foreground">Custo Unit. (R$)</label>
                    <div className="relative mt-2">
                        <DollarSign className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                        <input
                        type="number"
                        step="0.01"
                        min="0"
                        value={data.cost_price || ""}
                        onChange={(e) => setData((p) => ({ ...p, cost_price: parseFloat(e.target.value) || 0 }))}
                        placeholder="0.00"
                        className="w-full rounded-lg border border-input bg-background py-2.5 pl-9 pr-2 text-sm outline-none focus:border-primary"
                        />
                    </div>
                    </div>

                    {/* Preço de Venda (Opcional) */}
                    <div>
                    <label className="text-sm font-medium text-foreground">Venda (Opcional)</label>
                    <div className="relative mt-2">
                        <DollarSign className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                        <input
                        type="number"
                        step="0.01"
                        min="0"
                        value={data.sale_price || ""}
                        onChange={(e) => setData((p) => ({ ...p, sale_price: parseFloat(e.target.value) || 0 }))}
                        placeholder="0.00"
                        className="w-full rounded-lg border border-input bg-background py-2.5 pl-9 pr-2 text-sm outline-none focus:border-primary"
                        />
                    </div>
                    </div>
                </div>

              </div>
            </motion.div>
          )}

          {/* Step 3: Confirm */}
          {step === 3 && (
            <motion.div key="confirm" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-4 rounded-xl border border-border bg-card p-5">
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
                    <Package className="h-5 w-5 text-primary" />
                  </div>
                  <p className="text-sm font-semibold text-foreground">Resumo do Cadastro</p>
                </div>
                
                <div className="space-y-2 rounded-lg bg-secondary/50 p-4 border border-border">
                  <Row label="Produto" value={data.product_name || "—"} />
                  <Row label="Código" value={data.barcode} />
                  <Row label="Quantidade" value={`${data.quantity} un.`} />
                  <div className="border-t border-border/50 my-2" />
                  <Row label="Validade" value={data.expiry_date ? new Date(data.expiry_date).toLocaleDateString('pt-BR') : "—"} />
                  <Row label="Custo Total" value={`R$ ${(data.cost_price * data.quantity).toFixed(2)}`} />
                </div>
                
                <div className="text-center">
                    <p className="text-xs text-muted-foreground">
                        Ao confirmar, o estoque será atualizado imediatamente.
                    </p>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Navigation Buttons */}
        {(!showScanner || step > 0) && (
          <div className="mt-6 flex gap-3">
            {step > 0 && (
              <button
                type="button"
                onClick={() => setStep((s) => s - 1)}
                className="flex flex-1 items-center justify-center gap-2 rounded-xl border border-border bg-card py-3 text-sm font-medium text-foreground hover:bg-secondary"
              >
                <ChevronLeft className="h-4 w-4" /> Voltar
              </button>
            )}
            {step < 3 ? (
              <button
                type="button"
                onClick={() => setStep((s) => s + 1)}
                disabled={!canAdvance()}
                className="flex flex-1 items-center justify-center gap-2 rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground disabled:opacity-50 transition-transform active:scale-95"
              >
                Próximo <ChevronRight className="h-4 w-4" />
              </button>
            ) : (
              <button
                type="button"
                onClick={handleSave}
                disabled={loading}
                className="flex flex-1 items-center justify-center gap-2 rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground disabled:opacity-50 transition-transform active:scale-95"
              >
                {loading ? <Loader2 className="h-4 w-4 animate-spin" /> : <Check className="h-4 w-4" />}
                Confirmar
              </button>
            )}
          </div>
        )}
      </main>
    </div>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center justify-between">
      <span className="text-xs text-muted-foreground">{label}</span>
      <span className="text-sm font-medium text-foreground">{value}</span>
    </div>
  );
}