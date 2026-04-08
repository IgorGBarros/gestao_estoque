import { useState, useRef, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { AnimatePresence, motion } from "framer-motion";
import {
  ScanBarcode, Camera, Hash, DollarSign, ChevronRight, ChevronLeft,
  Check, Loader2, X, Package, Search, Lock, ImageIcon, Clock, CreditCard
} from "lucide-react";
import BarcodeScanner from "../components/BarcodeScanner";
import ProductSearchModal from "../components/ProductSearchModal";
import UpgradeModal from "../components/UpgradeModal";
import ProBadge from "../components/ProBadge";
import { ocrApi, GlobalProduct, formatMoney } from "../lib/api";
import { productService } from "../lib/productService";
import { useAuth } from "../hooks/useAuth";
import { usePlan } from "../../src/hooks/usePlan";
import { useFeatureGates } from "../../src/hooks/useFeatureGates";
import { useToast } from "../hooks/use-toast";
import { useStockEntry } from "../hooks/useStockEntry";

const STEPS = [
  { id: "scan", label: "Código", icon: ScanBarcode },
  { id: "expiry", label: "Validade", icon: Camera },
  { id: "details", label: "Detalhes", icon: DollarSign },
  { id: "confirm", label: "Confirmar", icon: Check },

  
];

const CATEGORIES = ["Perfumaria", "Corpo", "Rosto", "Cabelos", "Maquiagem", "Infantil", "Casa", "Outro"];

interface EntryData {
  bar_code: string;
  name: string;
  category: string;
  natura_sku: string;
  image_url: string;
  official_price: number;
  sale_price: number;
  cost_price: number;
  quantity: number;
  batch_code: string;
  expiry_date: string;
  expiry_photo_url: string;
  brand?: string;
}

interface SessionStatus {
  has_session: boolean;
  session_id?: number;
  products_count?: number;
  total_estimated_cost?: number;
  duration_minutes?: number;
}

// ✅ NOVO: API de sessão
const sessionApi = {
  getStatus: async (): Promise<SessionStatus> => {
    const response = await fetch('/api/session-control/');
    return response.json();
  },
  
  finish: async () => {
    const response = await fetch('/api/session-control/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ action: 'finish' })
    });
    return response.json();
  },
  
  confirmInvestment: async (sessionId: number, data: any) => {
    const response = await fetch('/api/session-summary/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ session_id: sessionId, ...data })
    });
    return response.json();
  }
};

export default function AddProduct() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { isLocked } = useFeatureGates();
  const { toast } = useToast();
  const { loading, saveEntry } = useStockEntry();
  
  const [step, setStep] = useState(0);
  const [showScanner, setShowScanner] = useState(false);
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const [showUpgrade, setShowUpgrade] = useState(false);
  const [upgradeFeature, setUpgradeFeature] = useState({ feature: "", description: "" });
  
  const [ocrLoading, setOcrLoading] = useState(false);
  const [lookupLoading, setLookupLoading] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  
  // ✅ NOVOS ESTADOS: Controle de sessão
  const [sessionStatus, setSessionStatus] = useState<SessionStatus>({ has_session: false });
  const [showSessionSummary, setShowSessionSummary] = useState(false);
  const [sessionSummaryData, setSessionSummaryData] = useState<any>(null);
  const [showInvestmentModal, setShowInvestmentModal] = useState(false);
  
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [data, setData] = useState<EntryData>({
    bar_code: "", name: "", category: "Perfumaria", natura_sku: "",
    image_url: "", official_price: 0, sale_price: 0, cost_price: 0,
    quantity: 1, batch_code: "", expiry_date: "", expiry_photo_url: "",brand: "",
  });

  // ✅ NOVO: Verificar status da sessão ao carregar
  useEffect(() => {
    checkSessionStatus();
  }, []);

  const checkSessionStatus = async () => {
    try {
      const status = await sessionApi.getStatus();
      setSessionStatus(status);
    } catch (error) {
      console.error('Erro ao verificar sessão:', error);
    }
  };

  // ✅ NOVO: Finalizar sessão
  const finishSession = async () => {
    try {
      const result = await sessionApi.finish();
      setSessionStatus({ has_session: false });
      
      if (result.session_summary && result.session_summary.products_count > 0) {
        setSessionSummaryData(result.session_summary);
        setShowSessionSummary(true);
      } else {
        toast({ title: "Sessão finalizada", description: "Nenhum produto foi cadastrado." });
      }
    } catch (error) {
      console.error('Erro ao finalizar sessão:', error);
      toast({ title: "Erro", description: "Falha ao finalizar sessão.", variant: "destructive" });
    }
  };

  // ✅ NOVO: Confirmar investimento
  const confirmInvestment = async (paymentData: any) => {
    try {
      await sessionApi.confirmInvestment(sessionSummaryData.session_id, paymentData);
      setShowInvestmentModal(false);
      setShowSessionSummary(false);
      toast({ title: "Sucesso!", description: "Investimento registrado com sucesso." });
    } catch (error) {
      console.error('Erro ao confirmar investimento:', error);
      toast({ title: "Erro", description: "Falha ao registrar investimento.", variant: "destructive" });
    }
  };

  const triggerProGate = (feature: string, description: string) => {
    setUpgradeFeature({ feature, description });
    setShowUpgrade(true);
  };

  const handleScannerClick = () => {
    if (isLocked("barcode_scanner")) {
      triggerProGate("Scanner de Código de Barras", "Mais rápido e preciso! O Scanner é exclusivo PRO.");
      return;
    }
    setShowScanner(true);
  };

const handleLookup = async (barcode: string) => {
  if (!barcode.trim()) return;
  setLookupLoading(true);
  try {
    const result = await productService.lookupByEan(barcode);
    if (result.found) {
      const resData = result.data as any;
      const remote = resData.remote || resData;
      setData(prev => ({
        ...prev,
        bar_code: barcode,
        name: remote?.name || resData?.name || prev.name,
        sale_price: remote?.sale_price || resData?.sale_price || prev.sale_price,
        cost_price: prev.cost_price,
        natura_sku: remote?.natura_sku || resData?.natura_sku || prev.natura_sku,
        image_url: remote?.image_url || resData?.image_url || prev.image_url,
        category: remote?.category || resData?.category || prev.category,
        official_price: remote?.official_price || resData?.official_price || 0,
        brand: remote?.brand || resData?.brand || prev.brand || "" // ✅ ADICIONAR - do crawler
      }));
      toast({ title: "Produto Identificado!", description: "Dados carregados com sucesso." });
    } else {
      toast({ title: "Novo Código", description: "Preencha os dados no próximo passo." });
    }
  } catch {
    toast({ title: "Aviso", description: "Falha na busca remota. Preencha manualmente." });
  } finally {
    setLookupLoading(false);
  }
};
  const handleBarcodeScan = async (barcode: string) => {
    setShowScanner(false);
    setData(prev => ({ ...prev, bar_code: barcode }));
    await handleLookup(barcode);
    setStep(1); 
  };

const selectSuggestion = (product: any) => {
  setData((prev) => ({
    ...prev,
    bar_code: product.bar_code || product.barcode || prev.bar_code,
    name: product.name,
    category: product.category || prev.category,
    natura_sku: product.natura_sku || product.sku || "",
    image_url: product.image_url || "",
    official_price: product.official_price || 0,
    sale_price: product.official_price || prev.sale_price,
    brand: product.brand || prev.brand || "", // ✅ ADICIONAR - do catálogo
  }));
  setIsSearchOpen(false);
  setStep(1);
};

  const handleExpiryPhoto = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    setOcrLoading(true);
    try {
      const result = await ocrApi.uploadAndExtract(file);
      if (result.photo_url) setData((prev) => ({ ...prev, expiry_photo_url: result.photo_url! }));
      if (result.expiry_date) {
        setData((prev) => ({ ...prev, expiry_date: result.expiry_date! }));
        toast({ title: "Validade detectada!", description: result.expiry_date });
      } else {
        toast({ title: "OCR falhou", description: "Insira a validade manualmente.", variant: "destructive" });
      }
    } catch {
      toast({ title: "Erro ao processar foto", variant: "destructive" });
    } finally {
      setOcrLoading(false);
    }
  };

const handleSave = async () => {
  if (!data.bar_code?.trim()) {
    toast({ title: "Código obrigatório", description: "Digite ou escaneie o EAN.", variant: "destructive" });
    return;
  }
  
  try {
    // ✅ CORREÇÃO: Construir payload dinamicamente
    const payload: any = {
      bar_code: data.bar_code.trim(),
      name: data.name || "Produto sem nome",
      category: data.category,
      natura_sku: data.natura_sku,
      expiration_date: data.expiry_date,
      expiry_photo_url: data.expiry_photo_url,
      quantity: data.quantity,
      cost_price: data.cost_price,
      sale_price: data.sale_price,
      batch_code: data.batch_code,
    };
    
    // ✅ ADICIONAR brand apenas se existir e não for vazio
    if (data.brand && data.brand.trim() !== "") {
      payload.brand = data.brand.trim();
    }
    
    await saveEntry(payload);
    
    setIsSuccess(true);
    setTimeout(() => {
      navigate("/");
    }, 2000);
  } catch (error) {
    console.error('Erro ao salvar:', error);
    // O Toast de erro já vem do useStockEntry
  }
};
  const canAdvance = () => {
    if (step === 0) return !!data.bar_code?.trim() && !lookupLoading;
    if (step === 1) return true;
    if (step === 2) return data.quantity > 0 && data.name.trim() !== "";
    return true;
  };
    return (
    <div className="min-h-screen bg-background">
      {/* ✅ NOVO: Header com status da sessão */}
      {sessionStatus.has_session && (
        <motion.div 
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-blue-600 text-white px-4 py-2 flex items-center justify-between"
        >
          <div className="flex items-center gap-3">
            <Package size={16} />
            <span className="text-sm font-medium">
              Cadastrando... {sessionStatus.products_count} produtos
            </span>
            <div className="flex items-center gap-1 text-blue-200">
              <Clock size={12} />
              <span className="text-xs">{sessionStatus.duration_minutes}min</span>
            </div>
          </div>
          
          <button 
            onClick={finishSession}
            className="bg-green-600 hover:bg-green-700 px-3 py-1 rounded text-sm font-medium flex items-center gap-1 transition-colors"
          >
            <Check size={14} />
            Finalizar
          </button>
        </motion.div>
      )}

      <header className="border-b border-border bg-card">
        <div className="mx-auto flex max-w-lg items-center justify-between px-4 py-3">
          <button onClick={() => navigate("/")} className="rounded-lg p-2 text-muted-foreground hover:text-foreground">
            <X className="h-5 w-5" />
          </button>
          <h1 className="font-display text-base font-bold text-foreground">Entrada Mágica</h1>
          <div className="w-9" />
        </div>
      </header>

      {/* STEPS HEADER */}
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
          
          {/* STEP 0: SCAN & IDENTIFICAÇÃO */}
          {step === 0 && (
            <motion.div key="scan" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              {showScanner && !isLocked("barcode_scanner") ? (
                <div className="space-y-4">
                  <BarcodeScanner 
                    onScan={handleBarcodeScan} 
                    onClose={() => {
                        setShowScanner(false);
                        setIsSearchOpen(true);
                    }} 
                  />
                  <button onClick={() => setShowScanner(false)} className="w-full text-center text-sm text-muted-foreground underline mt-2">
                    Cancelar Câmera
                  </button>
                </div>
              ) : (
                <div className="space-y-6 rounded-xl border border-border bg-card p-5">
                  <div>
                    <label className="text-sm font-medium text-foreground">Código de Barras (EAN) *</label>
                    <input
                      type="text"
                      value={data.bar_code}
                      onChange={(e) => setData((p) => ({ ...p, bar_code: e.target.value }))}
                      onBlur={(e) => handleLookup(e.target.value)}
                      placeholder="Escaneie ou digite..."
                      className="mt-2 w-full rounded-lg border border-input bg-background px-3 py-2 font-mono text-sm outline-none focus:border-primary"
                    />
                    {lookupLoading && <p className="text-xs text-primary mt-1 animate-pulse">Buscando informações...</p>}
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="h-px flex-1 bg-border" />
                    <span className="text-xs text-muted-foreground">OU</span>
                    <div className="h-px flex-1 bg-border" />
                  </div>
                  <button onClick={handleScannerClick} className={`w-full flex items-center justify-between p-4 border border-border rounded-xl hover:bg-secondary text-left group transition-all ${isLocked("barcode_scanner") ? "opacity-80" : ""}`}>
                    <div className="flex items-center gap-3">
                      <div className={`p-2 rounded-lg ${!isLocked("barcode_scanner") ? "bg-primary/10 text-primary" : "bg-muted text-muted-foreground"}`}>
                        {!isLocked("barcode_scanner") ? <ScanBarcode size={20} /> : <Lock size={20} />}
                      </div>
                      <div>
                        <p className="font-bold text-sm text-foreground flex items-center gap-2">
                          Escanear com Câmera {isLocked("barcode_scanner") && <ProBadge />}
                        </p>
                      </div>
                    </div>
                    <ChevronRight className="text-muted-foreground/30 group-hover:text-primary transition-colors" />
                  </button>
                  <button onClick={() => setIsSearchOpen(true)} className="w-full flex items-center justify-between p-4 border border-border rounded-xl hover:bg-secondary text-left group transition-all">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-primary/10 text-primary rounded-lg"><Search size={20} /></div>
                      <div>
                        <p className="font-bold text-sm text-foreground">Buscar por Nome</p>
                        <p className="text-xs text-muted-foreground">Catálogo Global</p>
                      </div>
                    </div>
                    <ChevronRight className="text-muted-foreground/30 group-hover:text-primary transition-colors" />
                  </button>
                </div>
              )}
            </motion.div>
          )}

          {/* STEP 1: VALIDADE */}
          {step === 1 && (
            <motion.div key="expiry" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-4 rounded-xl border border-border bg-card p-5">
                <div className="flex items-center gap-3">
                  <div className="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10"><Camera className="h-5 w-5 text-primary" /></div>
                  <div><p className="text-sm font-semibold text-foreground">Foto da Validade</p></div>
                </div>
                {data.expiry_photo_url ? (
                  <div className="space-y-3">
                    <img src={data.expiry_photo_url} alt="Validade" className="w-full rounded-lg object-cover" style={{ maxHeight: 200 }} />
                    <button type="button" onClick={() => { setData(p => ({ ...p, expiry_photo_url: "" })); fileInputRef.current?.click(); }} className="text-xs text-primary underline">Tirar outra</button>
                  </div>
                ) : (
                  <button type="button" onClick={() => fileInputRef.current?.click()} className="flex w-full flex-col items-center justify-center gap-2 rounded-xl border-2 border-dashed border-border py-10 text-muted-foreground hover:border-primary hover:text-primary">
                    <Camera className="h-8 w-8" />
                    <span className="text-sm">Tirar foto da validade (Opcional)</span>
                  </button>
                )}
                <input ref={fileInputRef} type="file" accept="image/*" capture="environment" onChange={handleExpiryPhoto} className="hidden" />
                <div>
                  <label className="text-sm text-muted-foreground">Mês/Ano de Validade</label>
                  <input type="month" value={data.expiry_date} onChange={(e) => setData((p) => ({ ...p, expiry_date: e.target.value }))} className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-primary" />
                </div>
              </div>
            </motion.div>
          )}

          {/* STEP 2: DETALHES GERAIS */}
          
          {step === 2 && (
            <motion.div key="details" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-5 rounded-xl border border-border bg-card p-5">
                <div className="flex gap-4 items-start">
                  <div className="flex-1">
                      <label className="text-sm font-medium text-foreground">Nome do Produto *</label>
                      <input required type="text" value={data.name} onChange={(e) => setData((p) => ({ ...p, name: e.target.value }))} className="mt-1 w-full rounded-lg border border-input bg-background px-3 py-2 text-sm outline-none focus:border-primary" />
                  </div>
                  {data.image_url ? (
                      <img src={data.image_url} alt="" className="w-16 h-16 rounded-lg object-cover border mt-6" />
                  ) : (
                      <div className="w-16 h-16 bg-muted rounded-lg border mt-6 flex items-center justify-center"><ImageIcon className="text-muted-foreground" size={20}/></div>
                  )}
                </div>
                
                {/* ✅ NOVO: Campo Brand SOMENTE LEITURA */}
                {data.brand && (
                  <div>
                    <label className="text-sm font-medium text-foreground">Marca</label>
                    <div className="mt-1 w-full rounded-lg border border-input bg-muted px-3 py-2 text-sm text-muted-foreground">
                      {data.brand}
                    </div>
                    <p className="text-xs text-muted-foreground mt-1">
                      ℹ️ A marca é identificada automaticamente e não pode ser alterada
                    </p>
                  </div>
                )}
                
                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <label className="text-sm font-medium text-foreground">Categoria</label>
                        <select value={data.category} onChange={(e) => setData(p => ({ ...p, category: e.target.value }))} className="mt-1 w-full rounded-lg border px-3 py-2 text-sm outline-none bg-background">
                            {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
                        </select>
                    </div>
                    <div>
                        <label className="text-sm font-medium text-foreground">SKU Natura</label>
                        <input value={data.natura_sku} onChange={(e) => setData(p => ({...p, natura_sku: e.target.value}))} className="mt-1 w-full rounded-lg border px-3 py-2 text-sm outline-none" placeholder="Opcional" />
                    </div>
                </div>
                
                 <div className="grid grid-cols-2 gap-4 p-4 border rounded-lg bg-primary/5">
                    <div>
                        <label className="text-sm font-bold text-primary">Qtd Entrada *</label>
                        <div className="mt-1 flex items-center gap-2">
                            <button type="button" onClick={() => setData(p => ({ ...p, quantity: Math.max(1, p.quantity - 1) }))} className="h-8 w-8 rounded bg-background border font-bold">-</button>
                            <input type="number" min={1} value={data.quantity} onChange={(e) => setData(p => ({ ...p, quantity: parseInt(e.target.value)||1 }))} className="h-8 w-12 rounded border text-center font-bold outline-none" />
                            <button type="button" onClick={() => setData(p => ({ ...p, quantity: p.quantity + 1 }))} className="h-8 w-8 rounded bg-background border font-bold">+</button>
                        </div>
                    </div>
                    <div>
                        <label className="text-sm font-medium text-foreground">Lote</label>
                        <input value={data.batch_code} onChange={(e) => setData(p => ({...p, batch_code: e.target.value}))} className="mt-1 w-full rounded-lg border px-3 py-2 text-sm outline-none" placeholder="Opcional" />
                    </div>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="text-sm font-medium text-foreground">Preço de Custo</label>
                    <input type="number" step="0.01" value={data.cost_price || ""} onChange={(e) => setData((p) => ({ ...p, cost_price: parseFloat(e.target.value)||0 }))} className="mt-1 w-full rounded-lg border px-3 py-2 text-sm outline-none" />
                  </div>
                  <div>
                    <label className="text-sm font-medium text-foreground">Preço Venda</label>
                    <input type="number" step="0.01" value={data.sale_price || ""} onChange={(e) => setData((p) => ({ ...p, sale_price: parseFloat(e.target.value)||0 }))} className="mt-1 w-full rounded-lg border px-3 py-2 text-sm outline-none" />
                  </div>
                </div>
            
              </div>
            </motion.div>
          )}

          {/* STEP 3: CONFIRMAR COM RESUMO DA SESSÃO */}
          {step === 3 && (
            <motion.div key="confirm" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }}>
              <div className="space-y-4 rounded-xl border border-border bg-card p-5 overflow-hidden">
                <AnimatePresence mode="wait">
                  {!isSuccess ? (
                    <motion.div key="summary" exit={{ opacity: 0, scale: 0.9 }}>
                      <div className="flex items-center gap-3 mb-4">
                        {data.image_url ? (
                          <img src={data.image_url} alt="Produto" className="h-12 w-12 rounded-lg object-cover border" />
                        ) : (
                          <div className="flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10"><Package className="text-primary" /></div>
                        )}
                        <div>
                          <p className="text-sm font-semibold text-foreground">Confirmar Entrada</p>
                          <p className="text-xs text-muted-foreground">{data.name || "Sem Nome"}</p>
                        </div>
                      </div>
                      
                      <div className="space-y-2 rounded-lg bg-secondary/50 p-4 mb-4">
                        <Row label="EAN" value={data.bar_code} />
                        <Row label="SKU" value={data.natura_sku || "—"} />
                        {data.brand && <Row label="Marca" value={data.brand} />} {/* ✅ NOVO */}
                        <Row label="Lote" value={data.batch_code || "—"} />
                        <Row label="Validade" value={data.expiry_date || "Não informada"} />
                        <Row label="Qtd Entrada" value={`${data.quantity} un.`} />
                        <Row label="Custo" value={formatMoney(data.cost_price)} />
                        <Row label="Venda" value={formatMoney(data.sale_price)} />
                      </div>

                      {/* ✅ NOVO: Resumo da sessão */}
                      {sessionStatus.has_session && (
                        <div className="rounded-lg bg-blue-50 border border-blue-200 p-4">
                          <div className="flex items-center gap-2 mb-2">
                            <Package className="text-blue-600" size={16} />
                            <span className="text-sm font-semibold text-blue-900">Resumo da Sessão</span>
                          </div>
                          <div className="text-xs text-blue-700 space-y-1">
                            <p>• Total de produtos: {sessionStatus.products_count}</p>
                            <p>• Valor estimado: {formatMoney(sessionStatus.total_estimated_cost || 0)}</p>
                            <p>• Tempo de cadastro: {sessionStatus.duration_minutes}min</p>
                          </div>
                          <p className="text-xs text-blue-600 mt-2">
                            💡 Após confirmar, você pode finalizar e registrar o investimento
                          </p>
                        </div>
                      )}
                    </motion.div>
                  ) : (
                    <motion.div
                      key="success"
                      initial={{ opacity: 0, scale: 0.8 }}
                      animate={{ opacity: 1, scale: 1 }}
                      className="flex flex-col items-center justify-center py-10 space-y-4"
                    >
                      <motion.div
                        initial={{ scale: 0 }}
                        animate={{ scale: 1 }}
                        transition={{ type: "spring", stiffness: 200, damping: 10, delay: 0.1 }}
                        className="flex h-24 w-24 items-center justify-center rounded-full bg-emerald-500 text-white shadow-lg"
                      >
                        <Check size={48} strokeWidth={3} />
                      </motion.div>
                      <motion.div
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        transition={{ delay: 0.3 }}
                        className="text-center space-y-1"
                      >
                        <h3 className="text-xl font-bold text-foreground">Sucesso!</h3>
                        <p className="text-sm text-muted-foreground">Produto adicionado ao estoque.</p>
                      </motion.div>
                    </motion.div>
                  )}
                </AnimatePresence>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        {/* NAVIGATION BUTTONS */}
        {(!showScanner || step > 0) && !isSuccess && (
          <div className="mt-6 flex gap-3">
            {step > 0 && (
              <button onClick={() => setStep((s) => s - 1)} disabled={loading} className="flex flex-1 items-center justify-center gap-2 rounded-xl border bg-card py-3 text-sm font-medium disabled:opacity-50">
                <ChevronLeft className="h-4 w-4" /> Voltar
              </button>
            )}
            {step < 3 ? (
              <button onClick={() => setStep((s) => s + 1)} disabled={!canAdvance()} className="flex flex-1 items-center justify-center gap-2 rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground disabled:opacity-50">
                Próximo <ChevronRight className="h-4 w-4" />
              </button>
            ) : (
              <button onClick={handleSave} disabled={loading} className="flex flex-1 items-center justify-center gap-2 rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground disabled:opacity-50 transition-all active:scale-95">
                {loading ? <Loader2 className="animate-spin" /> : <Check />} Confirmar
              </button>
            )}
          </div>
        )}
      </main>

      {/* ✅ NOVO: Modal de Resumo da Sessão */}
      {showSessionSummary && sessionSummaryData && (
        <SessionSummaryModal 
          summary={sessionSummaryData}
          onClose={() => setShowSessionSummary(false)}
          onConfirmInvestment={(_paymentData: any) => {
            setShowInvestmentModal(true);
            setShowSessionSummary(false);
          }}
        />
      )}

      {/* ✅ NOVO: Modal de Investimento */}
      {showInvestmentModal && (
        <InvestmentModal 
          estimatedCost={sessionSummaryData?.total_estimated_cost || 0}
          onClose={() => setShowInvestmentModal(false)}
          onConfirm={confirmInvestment}
        />
      )}

      <ProductSearchModal
        isOpen={isSearchOpen}
        onClose={() => setIsSearchOpen(false)}
        onSelect={(p) => selectSuggestion(p)}
      />
      
      <UpgradeModal
        isOpen={showUpgrade}
        onClose={() => setShowUpgrade(false)}
        feature={upgradeFeature.feature}
        description={upgradeFeature.description}
      />
    </div>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-center justify-between border-b border-border/50 pb-1 last:border-0">
      <span className="text-xs text-muted-foreground">{label}</span>
      <span className="text-sm font-medium text-foreground">{value}</span>
    </div>
  );
}

// ✅ NOVO: Componentes dos modais (você precisa criar estes)
function SessionSummaryModal({ summary, onClose, onConfirmInvestment }: any) {
  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg p-6 max-w-md w-full">
        <h3 className="text-lg font-bold mb-4">📦 Resumo da Sessão</h3>
        <div className="space-y-2 mb-6">
          <p>Produtos cadastrados: {summary.products_count}</p>
          <p>Valor estimado: {formatMoney(summary.total_estimated_cost)}</p>
        </div>
        <div className="flex gap-3">
          <button onClick={onClose} className="flex-1 border rounded-lg py-2">
            Depois
          </button>
          <button onClick={onConfirmInvestment} className="flex-1 bg-blue-600 text-white rounded-lg py-2">
            Registrar Investimento
          </button>
        </div>
      </div>
    </div>
  );
}

function InvestmentModal({ estimatedCost, onClose, onConfirm }: any)  {
  const [paymentMethod, setPaymentMethod] = useState('credit_card');
  const [totalPaid, setTotalPaid] = useState(estimatedCost);
  const [installments, setInstallments] = useState(1);

  const handleConfirm = () => {
    onConfirm({ payment_method: paymentMethod, total_paid: totalPaid, installments });
  };

  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg p-6 max-w-md w-full">
        <h3 className="text-lg font-bold mb-4">💳 Registrar Investimento</h3>
        
        <div className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1">Como você pagou?</label>
            <select 
              value={paymentMethod} 
              onChange={(e) => setPaymentMethod(e.target.value)}
              className="w-full border rounded-lg px-3 py-2"
            >
              <option value="credit_card">Cartão de Crédito</option>
              <option value="pix">PIX</option>
              <option value="cash">Dinheiro</option>
            </select>
          </div>
          
          <div>
            <label className="block text-sm font-medium mb-1">Valor total pago</label>
            <input 
              type="number" 
              step="0.01"
              value={totalPaid} 
              onChange={(e) => setTotalPaid(parseFloat(e.target.value))}
              className="w-full border rounded-lg px-3 py-2"
            />
          </div>
          
          {paymentMethod === 'credit_card' && (
            <div>
              <label className="block text-sm font-medium mb-1">Parcelas</label>
              <input 
                type="number" 
                min="1"
                value={installments} 
                onChange={(e) => setInstallments(parseInt(e.target.value))}
                className="w-full border rounded-lg px-3 py-2"
              />
            </div>
          )}
        </div>
        
        <div className="flex gap-3 mt-6">
          <button onClick={onClose} className="flex-1 border rounded-lg py-2">
            Cancelar
          </button>
          <button onClick={handleConfirm} className="flex-1 bg-green-600 text-white rounded-lg py-2">
            Confirmar
          </button>
        </div>
      </div>
    </div>
  );
}