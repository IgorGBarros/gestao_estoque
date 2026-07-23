import { useState, useRef } from "react";
import { useNavigate } from "react-router-dom";
import { AnimatePresence, motion } from "framer-motion";
import {
  ScanBarcode, Camera, RefreshCw, DollarSign, ChevronRight, ChevronLeft,
  Check, Loader2, X, Package, Search, ImageIcon
} from "lucide-react";
import BarcodeScanner from "../components/BarcodeScanner";
import { api } from "../services/api";
import { useToast } from '../components/ui/use-toast';
import { productService } from "../lib/productService";
import { processImageForData } from "../lib/ocrService";
// Certifique-se de que este componente existe em src/components/ProductSearchModal.tsx
import ProductSearchModal from "../components/ProductSearchModal"; 

const STEPS = [
  { id: "scan", label: "Código", icon: ScanBarcode },
  { id: "expiry", label: "Validade", icon: Camera },
  { id: "details", label: "Preço & Qtd", icon: DollarSign },
  { id: "confirm", label: "Confirmar", icon: Check },
];

interface ProductData {
  barcode: string;
  natura_sku?: string;
  product_name: string;
  category: string;
  expiry_date: string;
  batch_code: string;
  quantity: number;
  cost_price: number;
  sale_price: number;
  image_url?: string;
}

export default function AddProduct() {
  const [step, setStep] = useState(0);
  const [showScanner, setShowScanner] = useState(true);
  const [loading, setLoading] = useState(false);
  
  // Estados para Modal de Busca
  const [isSearchOpen, setIsSearchOpen] = useState(false);

  // OCR States
  const [ocrLoading, setOcrLoading] = useState(false);
  const [photo, setPhoto] = useState<string | null>(null);

  const [data, setData] = useState<ProductData>({
    barcode: "",
    product_name: "",
    category: "Geral",
    expiry_date: "",
    batch_code: "",
    quantity: 1,
    cost_price: 0,
    sale_price: 0
  });

  const fileInputRef = useRef<HTMLInputElement>(null);
  const navigate = useNavigate();
  const { toast } = useToast();

  // --- PREENCHIMENTO ---
  const fillProductData = (productData: any) => {
    setData(prev => ({
        ...prev,
        product_name: productData.name,
        category: productData.category || "Geral",
        sale_price: Number(productData.sale_price || productData.official_price || 0),
        natura_sku: productData.natura_sku,
        image_url: productData.image_url
    }));
  };

  // --- SELEÇÃO NO MODAL ---
  const selectSuggestion = (item: any) => {
      fillProductData(item);
      setIsSearchOpen(false); // Fecha o modal
      // Se a sugestão tiver barcode, usa. Se não, mantém o atual.
      if (item.bar_code) setData(prev => ({ ...prev, barcode: item.bar_code }));
      
      toast({ title: "Selecionado!", description: item.name });
      setStep(1); // Avança para Validade
  };

  // --- PASSO 1A: SCAN CÓDIGO DE BARRAS ---
  const handleBarcodeScan = async (barcode: string) => {
    setShowScanner(false);
    setData((prev) => ({ ...prev, barcode }));
    toast({ title: "Buscando...", description: "Identificando produto." });

    try {
      const response = await productService.lookupByEan(barcode);
      
      if (response.found) {
         const foundData = response.source === 'local' ? response.data : (response.data as any).remote || response.data;
         fillProductData(foundData);
         toast({ title: "Identificado!", description: foundData.name });
      } else {
        toast({ title: "Novo", description: "Produto não cadastrado." });
      }
    } catch (error) {
      console.error("Erro no lookup:", error);
    }
    setStep(1); 
  };

  // --- PASSO 2: OCR ---
  const handleNativeCamera = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const objectUrl = URL.createObjectURL(file);
    setPhoto(objectUrl);
    setOcrLoading(true);
    toast({ title: "Processando...", description: "Lendo validade na imagem." });

    const reader = new FileReader();
    reader.onloadend = async () => {
        const base64data = reader.result as string;
        const result = await processImageForData(base64data);
        setOcrLoading(false);

        if (result.date || result.batch) {
             setData(prev => ({
                ...prev,
                expiry_date: result.date || prev.expiry_date,
                batch_code: result.batch || prev.batch_code
             }));
             toast({ title: "Sucesso!", description: `Validade: ${result.date || '?'}` });
        } else {
             toast({ title: "Aviso", description: "Não consegui ler. Digite manualmente.", variant: "default" });
        }
    };
    reader.readAsDataURL(file);
  };

  // --- PASSO FINAL: SALVAR ---
  const handleSave = async () => {
    setLoading(true);
    try {
      await productService.addStock({
        bar_code: data.barcode,
        natura_sku: data.natura_sku,
        quantity: data.quantity,
        cost_price: data.cost_price,
        sale_price: data.sale_price,
        expiration_date: data.expiry_date || null,
        batch_code: data.batch_code,
        name: data.product_name,
        category: data.category
      });
      
      toast({ title: "Sucesso!", description: "Estoque atualizado." });
      navigate("/");
    } catch (err: any) {
      const msg = err.response?.data?.error || "Erro ao salvar.";
      toast({ title: "Erro", description: msg, variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  const canAdvance = () => {
    if (step === 0) return !!data.barcode || !!data.product_name; 
    if (step === 1) return true; 
    if (step === 2) return data.quantity > 0 && !!data.product_name; 
    return true;
  };

  return (
    <div className="min-h-screen bg-background pb-20">
      
      {/* Header */}
      <header className="border-b border-border bg-card">
        <div className="mx-auto flex max-w-lg items-center justify-between px-4 py-3">
          <button onClick={() => navigate("/")} className="rounded-lg p-2 text-muted-foreground hover:text-foreground">
            <X className="h-5 w-5" />
          </button>
          <h1 className="font-display text-base font-bold text-foreground">Entrada de Estoque</h1>
          <div className="w-9" />
        </div>
      </header>

      {/* Progress */}
      <div className="mx-auto max-w-lg px-4 pt-4">
        <div className="flex items-center gap-1">
          {STEPS.map((s, i) => (
            <div key={s.id} className="flex flex-1 flex-col items-center gap-1">
              <div className={`flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold transition-colors ${i <= step ? "bg-primary text-primary-foreground" : "bg-muted text-muted-foreground"}`}>
                {i < step ? <Check className="h-4 w-4" /> : i + 1}
              </div>
              <span className={`text-[10px] ${i <= step ? "text-primary font-medium" : "text-muted-foreground"}`}>{s.label}</span>
            </div>
          ))}
        </div>
      </div>

      <main className="mx-auto max-w-lg px-4 py-6">
        <AnimatePresence mode="wait">
          
          {/* Step 0: Scan ou Busca Manual */}
          {step === 0 && (
            <motion.div key="scan" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              {showScanner ? (
                <div className="space-y-4">
                    <BarcodeScanner onScan={handleBarcodeScan} onClose={() => setShowScanner(false)}/>
                    
                    {/* Botão para mudar para busca manual */}
                    <button 
                        onClick={() => setShowScanner(false)} 
                        className="w-full text-center text-sm text-muted-foreground underline mt-4"
                    >
                        Não tem código? Buscar por nome/SKU
                    </button>
                </div>
              ) : (
                <div className="space-y-6 rounded-xl border border-border bg-card p-5">
                   
                   {/* CARD DE BUSCA MANUAL */}
                   <button 
                        onClick={() => setIsSearchOpen(true)}
                        className="w-full flex items-center justify-between p-4 border rounded-xl hover:bg-gray-50 text-left group transition-all"
                    >
                        <div className="flex items-center gap-3">
                            <div className="p-2 bg-primary/10 text-primary rounded-lg">
                                <Search size={20} />
                            </div>
                            <div>
                                <p className="font-bold text-sm text-gray-700">Buscar Manualmente</p>
                                <p className="text-xs text-gray-500">Digite o nome ou código da revista</p>
                            </div>
                        </div>
                        <ChevronRight className="text-gray-300 group-hover:text-primary transition-colors" />
                   </button>

                   <div className="flex items-center gap-3 py-4 border-t border-border mt-4">
                      <div className="h-px flex-1 bg-border"></div>
                      <span className="text-xs text-muted-foreground">OU</span>
                      <div className="h-px flex-1 bg-border"></div>
                   </div>

                   {/* VOLTAR PARA SCANNER */}
                   <button onClick={() => setShowScanner(true)} className="w-full flex items-center justify-center gap-2 bg-primary text-white py-3 rounded-xl font-bold">
                        <ScanBarcode /> Abrir Câmera
                   </button>
                   
                   {data.product_name && (
                       <div className="mt-4 p-3 bg-green-50 text-green-800 rounded-lg text-center text-sm border border-green-200">
                           Produto selecionado: <b>{data.product_name}</b>
                       </div>
                   )}
                </div>
              )}
            </motion.div>
          )}

          {/* Step 1: Validade & OCR */}
          {step === 1 && (
            <motion.div key="expiry" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-6 rounded-xl border border-border bg-card p-5">
                <div className="text-center">
                    <h2 className="text-lg font-bold">Validade & Lote</h2>
                    <p className="text-xs text-muted-foreground">Tire uma foto para ler a data automaticamente.</p>
                </div>

                <div 
                    className="relative w-full aspect-video bg-secondary/30 rounded-xl overflow-hidden border-2 border-dashed border-border flex flex-col items-center justify-center cursor-pointer hover:bg-secondary/50 transition active:scale-95"
                    onClick={() => !photo && fileInputRef.current?.click()}
                >
                    {!photo ? (
                        <>
                            <Camera size={40} className="text-muted-foreground mb-2" />
                            <span className="text-sm font-medium text-foreground">Abrir Câmera</span>
                        </>
                    ) : (
                        <img src={photo} className="w-full h-full object-cover" />
                    )}

                    {ocrLoading && (
                        <div className="absolute inset-0 bg-background/80 flex flex-col items-center justify-center backdrop-blur-sm">
                            <Loader2 className="animate-spin text-primary mb-2" />
                            <span className="text-xs font-bold">Lendo imagem...</span>
                        </div>
                    )}

                    {photo && !ocrLoading && (
                        <button 
                            type="button"
                            onClick={(e) => { e.stopPropagation(); fileInputRef.current?.click(); }}
                            className="absolute bottom-2 right-2 bg-background p-2 rounded-full shadow-md border border-border"
                        >
                            <RefreshCw size={16} />
                        </button>
                    )}
                </div>

                <input 
                    ref={fileInputRef} 
                    type="file" 
                    accept="image/*" 
                    capture="environment" 
                    className="hidden" 
                    onChange={handleNativeCamera} 
                />

                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <label className="text-xs font-medium text-muted-foreground">Validade</label>
                        <input
                            type="date"
                            value={data.expiry_date}
                            onChange={(e) => setData({ ...data, expiry_date: e.target.value })}
                            className="w-full mt-1 rounded-lg border border-input bg-background px-3 py-2 text-sm"
                        />
                    </div>
                    <div>
                        <label className="text-xs font-medium text-muted-foreground">Lote</label>
                        <input
                            value={data.batch_code}
                            onChange={(e) => setData({ ...data, batch_code: e.target.value })}
                            placeholder="Ex: L.A600"
                            className="w-full mt-1 rounded-lg border border-input bg-background px-3 py-2 text-sm uppercase"
                        />
                    </div>
                </div>
              </div>
            </motion.div>
          )}

          {/* Step 2: Quantidade & Preço */}
          {step === 2 && (
            <motion.div key="details" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-5 rounded-xl border border-border bg-card p-5">
                 
                 <div className="bg-secondary/20 p-3 rounded-lg border border-border flex gap-3">
                    <div className="w-12 h-12 bg-white rounded border overflow-hidden">
                        {data.image_url ? <img src={data.image_url} className="w-full h-full object-cover"/> : <Package className="m-2 text-gray-400"/>}
                    </div>
                    <div>
                        <p className="text-xs text-muted-foreground font-bold uppercase">Produto</p>
                        <p className="font-medium text-sm line-clamp-1">{data.product_name}</p>
                        {data.natura_sku && <p className="text-xs text-muted-foreground">SKU: {data.natura_sku}</p>}
                    </div>
                 </div>

                 <div>
                    <label className="text-sm font-medium">Quantidade</label>
                    <input 
                        type="number" 
                        value={data.quantity} 
                        onChange={e=>setData({...data, quantity: parseInt(e.target.value)})} 
                        className="w-full border rounded-lg p-2 mt-1 text-center text-lg font-bold"
                    />
                 </div>
                 
                 <div className="grid grid-cols-2 gap-4">
                    <div>
                        <label className="text-sm font-medium">Custo</label>
                        <input type="number" value={data.cost_price} onChange={e=>setData({...data, cost_price: parseFloat(e.target.value)})} className="w-full border rounded-lg p-2 mt-1"/>
                    </div>
                    <div>
                        <label className="text-sm font-medium">Venda</label>
                        <input type="number" value={data.sale_price} onChange={e=>setData({...data, sale_price: parseFloat(e.target.value)})} className="w-full border rounded-lg p-2 mt-1"/>
                    </div>
                 </div>
              </div>
            </motion.div>
          )}

          {/* Step 3: Confirmar */}
          {step === 3 && (
            <motion.div key="confirm" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
               <div className="rounded-xl border border-border bg-card p-5 text-center space-y-4">
                  <div className="w-16 h-16 bg-green-100 text-green-600 rounded-full flex items-center justify-center mx-auto">
                      <Check size={32} />
                  </div>
                  <div>
                      <p className="font-bold text-lg text-green-700">Tudo Pronto!</p>
                      <p className="text-sm text-muted-foreground mt-2">
                        Você está adicionando <b>{data.quantity}x {data.product_name}</b> ao estoque.
                      </p>
                  </div>
                  <div className="p-3 bg-secondary/30 rounded-lg text-xs text-left space-y-1">
                      <p>📦 <b>Validade:</b> {data.expiry_date || "Não informada"}</p>
                      <p>🏷️ <b>Lote:</b> {data.batch_code || "N/A"}</p>
                      <p>💰 <b>Valor Venda:</b> R$ {data.sale_price}</p>
                  </div>
               </div>
            </motion.div>
          )}

        </AnimatePresence>

        {/* --- MODAL DE BUSCA (AQUI ESTÁ ELE!) --- */}
        <ProductSearchModal 
            isOpen={isSearchOpen} 
            onClose={() => setIsSearchOpen(false)} 
            onSelect={selectSuggestion} 
        />

        {/* NAVEGAÇÃO */}
        {(!showScanner || step > 0) && (
          <div className="mt-6 flex gap-3">
            {step > 0 && (
              <button onClick={() => setStep(s => s - 1)} className="flex-1 rounded-xl border border-border py-3 text-sm font-medium hover:bg-secondary">
                Voltar
              </button>
            )}
            
            {step < 3 ? (
              <button onClick={() => setStep(s => s + 1)} disabled={!canAdvance()} className="flex-1 rounded-xl bg-primary py-3 text-sm font-bold text-white hover:opacity-90 disabled:opacity-50">
                Próximo
              </button>
            ) : (
              <button onClick={handleSave} disabled={loading} className="flex-1 rounded-xl bg-green-600 py-3 text-sm font-bold text-white hover:bg-green-700">
                {loading ? <Loader2 className="animate-spin mx-auto"/> : "Confirmar Entrada"}
              </button>
            )}
          </div>
        )}
      </main>
    </div>
  );
}