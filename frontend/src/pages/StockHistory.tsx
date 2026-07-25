import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { 
  ArrowLeft, ArrowUpCircle, ArrowDownCircle, Search, Package, 
  ChevronDown, ChevronUp, Calendar, Gift, ShoppingCart, 
  AlertTriangle, User, Settings2, Calculator, Download, Loader2 } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { movementsApi, Movement, formatMoney, movementsReportApi } from "../lib/api";
import { useAuth } from "../hooks/useAuth";

const TYPE_LABELS: Record<string, { label: string; emoji: string }> = {
  venda: { label: "Venda", emoji: "💰" },
  uso_proprio: { label: "Uso Próprio", emoji: "👤" },
  presente: { label: "Presente", emoji: "🎁" },
  brinde: { label: "Brinde", emoji: "🤝" },
  perda: { label: "Perda", emoji: "⚠️" },
  ajuste: { label: "Ajuste", emoji: "⚖️" },
};

export default function MovementHistory() {
  const [baixando, setBaixando] = useState(false);

  // Relatório de movimentação em CSV — abre no Excel e no Google Sheets.
  const baixarRelatorio = async () => {
    setBaixando(true);
    try {
      await movementsReportApi.download("tudo");
    } catch {
      /* silencioso: o extrato na tela continua disponível */
    } finally {
      setBaixando(false);
    }
  };

  const navigate = useNavigate();
  const { user } = useAuth();
  
  const [movements, setMovements] = useState<any[]>([]);
  const [search, setSearch] = useState("");
  const [filterType, setFilterType] = useState<string>("TODOS");
  const [loading, setLoading] = useState(true);
  const [expandedId, setExpandedId] = useState<string | null>(null);

  // 🚀 FUNÇÃO CENTRAL DE VALIDAÇÃO: Define o que é Entrada e o que é Saída
  const checkIsEntry = (m: any) => {
    const tType = (m.transaction_type || "").toLowerCase();
    const mType = (m.movement_type || "").toLowerCase();
    return tType === "entrada" || mType === "entrada";
  };

  useEffect(() => {
    if (!user) return;
    
    movementsApi.list().then((data: any[]) => {
      const normalizedData = data.map(m => {
        let tType = (m.sale_type || m.transaction_type || m.movement_type || "saida").toLowerCase();
        return {
          ...m,
          movement_type: tType,
          product_name: m.product?.name || m.product_name || "Produto Desconhecido",
          barcode: m.product?.bar_code || m.barcode || "",
        };
      });
      
      setMovements(normalizedData);
      setLoading(false);
    }).catch(() => setLoading(false));
  }, [user]);

  const filtered = movements.filter((m) => {
    const matchSearch = m.product_name.toLowerCase().includes(search.toLowerCase()) || m.barcode.includes(search);
    const matchFilter = filterType === "TODOS" || m.movement_type === filterType.toLowerCase() || m.transaction_type?.toLowerCase() === filterType.toLowerCase();
    return matchSearch && matchFilter;
  });

  // 🚀 CORREÇÃO: Os placares agora usam a função central para nunca errar a contagem!
  const totalEntradas = filtered.filter(m => checkIsEntry(m)).reduce((s, m) => s + Math.abs(m.quantity), 0);
  const totalSaidas = filtered.filter(m => !checkIsEntry(m)).reduce((s, m) => s + Math.abs(m.quantity), 0);
  
  const totalReceita = filtered
    .filter(m => !checkIsEntry(m) && (m.sale_type === "venda" || m.transaction_type === "VENDA"))
    .reduce((s, m) => s + (Number(m.unit_price) || Number(m.unit_price_sold) || 0) * Math.abs(m.quantity), 0);
    
  const totalLucro = filtered.filter((m) => m.profit != null).reduce((s, m) => s + (m.profit || 0), 0);

  const formatDate = (iso: string) => {
    return new Date(iso).toLocaleDateString("pt-BR", { 
      day: "2-digit", month: "2-digit", year: "2-digit", 
      hour: "2-digit", minute: "2-digit" 
    });
  };

  if (loading) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-gray-50">
        <div className="flex flex-col items-center gap-3 text-primary">
          <div className="h-8 w-8 animate-spin rounded-full border-4 border-primary border-t-transparent" />
          <p className="text-sm font-medium">Carregando extrato...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <header className="sticky top-0 z-10 bg-white border-b border-gray-200 px-4 py-4 shadow-sm">
        <div className="max-w-4xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <button onClick={() => navigate("/")} className="p-2 rounded-full hover:bg-gray-100 text-gray-600 transition-colors">
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <h1 className="text-lg font-bold text-gray-900">Extrato de Movimentações</h1>
              <p className="text-xs text-gray-500">{movements.length} operações registradas</p>
            </div>
          </div>

          <button
            onClick={baixarRelatorio}
            disabled={baixando}
            className="flex items-center gap-1.5 rounded-lg border border-brand/30 bg-brand/5 px-3 py-2 text-xs font-semibold text-brand transition-colors hover:bg-brand/10 disabled:opacity-60"
          >
            {baixando ? (
              <Loader2 className="h-3.5 w-3.5 animate-spin" />
            ) : (
              <Download className="h-3.5 w-3.5" />
            )}
            <span className="hidden sm:inline">Baixar relatório</span>
          </button>
        </div>
      </header>

      <main className="max-w-4xl mx-auto px-4 py-6 space-y-4">
        {/* ── Placares Corrigidos ── */}
        <div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
          <div className="rounded-xl border border-gray-200 bg-white p-3 shadow-sm">
            <p className="text-[10px] text-gray-500 font-semibold uppercase">Entradas</p>
            <p className="font-display text-xl font-bold text-green-600">+{totalEntradas}</p>
          </div>
          <div className="rounded-xl border border-gray-200 bg-white p-3 shadow-sm">
            <p className="text-[10px] text-gray-500 font-semibold uppercase">Saídas</p>
            <p className="font-display text-xl font-bold text-red-600">-{totalSaidas}</p>
          </div>
          <div className="rounded-xl border border-gray-200 bg-white p-3 shadow-sm">
            <p className="text-[10px] text-gray-500 font-semibold uppercase">Receita (Vendas)</p>
            <p className="font-display text-xl font-bold text-gray-900">{formatMoney(totalReceita)}</p>
          </div>
          <div className="rounded-xl border border-gray-200 bg-white p-3 shadow-sm">
            <p className="text-[10px] text-gray-500 font-semibold uppercase">Lucro Bruto</p>
            <p className={`font-display text-xl font-bold ${totalLucro >= 0 ? "text-green-600" : "text-red-600"}`}>{formatMoney(totalLucro)}</p>
          </div>
        </div>

        {/* ── Filtros e Busca ── */}
        <div className="flex flex-col gap-3 sm:flex-row">
          <div className="flex items-center gap-2 rounded-xl border border-gray-200 bg-white px-3 py-2.5 shadow-sm focus-within:ring-2 focus-within:ring-primary/20 transition-all flex-1">
            <Search className="h-4 w-4 text-gray-400" />
            <input 
              type="text" 
              placeholder="Buscar por nome ou código..." 
              value={search} 
              onChange={(e) => setSearch(e.target.value)} 
              className="flex-1 bg-transparent text-sm outline-none placeholder:text-gray-400" 
            />
          </div>
          <div className="flex gap-2 overflow-x-auto pb-1 scrollbar-hide">
            {["TODOS", "ENTRADA", "SAIDA"].map((type) => (
              <button
                key={type}
                onClick={() => setFilterType(type)}
                className={`px-4 py-2 rounded-xl text-xs font-semibold whitespace-nowrap transition-colors border ${
                  filterType === type
                    ? "bg-gray-900 text-white border-gray-900 shadow-sm"
                    : "bg-white text-gray-600 border-gray-200 hover:bg-gray-50"
                }`}
              >
                {type === "SAIDA" ? "Saídas (Geral)" : type === "TODOS" ? "Todos" : "Entradas"}
              </button>
            ))}
          </div>
        </div>

        {/* ── Lista de Transações ── */}
        {filtered.length === 0 ? (
          <div className="text-center py-20">
            <div className="bg-gray-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
              <Calendar className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="text-lg font-semibold text-gray-600">Nenhuma movimentação</h3>
            <p className="text-gray-400 text-sm mt-1">Nenhum resultado para os filtros atuais.</p>
          </div>
        ) : (
          <div className="space-y-3">
            {filtered.map((item, i) => {
              const isEntry = checkIsEntry(item); // 🚀 Usa a função segura
              
              // Define as cores baseadas em Entrada vs Saída
              const config = isEntry 
                ? { icon: ArrowUpCircle, color: "text-green-600", bg: "bg-green-100" }
                : { icon: ArrowDownCircle, color: "text-red-600", bg: "bg-red-50" };

              const Icon = config.icon;
              const displayQuantity = Math.abs(item.quantity);
              const isExpanded = expandedId === item.id;
              const typeInfo = item.sale_type ? TYPE_LABELS[item.sale_type] : null;

              // Calcula o total financeiro da operação
              const operacaoTotal = isEntry 
                ? displayQuantity * (Number(item.unit_cost) || 0) 
                : displayQuantity * (Number(item.unit_price) || 0);

              return (
                <motion.div 
                  key={item.id} 
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.03 }}
                  onClick={() => setExpandedId(isExpanded ? null : item.id)}
                  className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 flex flex-col gap-4 cursor-pointer hover:shadow-md transition-shadow relative overflow-hidden"
                >
                  {/* Data no Topo (Direita) */}
                  <div className="absolute top-2 right-3 text-[9px] text-gray-400 font-medium flex items-center gap-1">
                    <Calendar className="h-3 w-3" />
                    {formatDate(item.created_at)}
                  </div>

                  {/* Informação Principal */}
                  <div className="flex items-start gap-3 mt-3">
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center shrink-0 ${config.bg}`}>
                      <Icon className={`w-5 h-5 ${config.color}`} />
                    </div>

                    <div className="flex-1 min-w-0 pr-4">
                      <div className="flex justify-between items-start mb-1">
                        <p className="font-bold text-gray-800 truncate text-sm leading-tight">
                          {item.product_name}
                        </p>
                        <span className={`text-sm font-mono font-bold shrink-0 ml-2 ${isEntry ? 'text-green-600' : 'text-red-600'}`}>
                          {isEntry ? '+' : '-'}{displayQuantity} un.
                        </span>
                      </div>
                      
                      <div className="mt-1 flex flex-wrap items-center gap-1.5 text-[10px] text-gray-500">
                        <span className={`shrink-0 rounded-full px-2 py-0.5 font-semibold ${isEntry ? 'bg-green-100 text-green-700' : 'bg-red-50 text-red-700'}`}>
                          {isEntry ? "Entrada" : "Saída"}
                        </span>
                        {typeInfo && <span className="bg-gray-100 px-1.5 py-0.5 rounded text-gray-700">{typeInfo.emoji} {typeInfo.label}</span>}
                        {item.transaction_type === "AJUSTE" && <span className="bg-gray-100 px-1.5 py-0.5 rounded text-gray-700">⚖️ Ajuste</span>}
                      </div>
                    </div>
                  </div>

                  {/* Resumo Base */}
                  <div className="flex items-center justify-between border-t border-gray-100 pt-3">
                    <div className="flex gap-4 text-xs text-gray-500">
                      <p>Custo: <strong className="text-gray-700">{formatMoney(item.unit_cost)}</strong></p>
                      <p>Venda: <strong className="text-gray-700">{formatMoney(item.unit_price)}</strong></p>
                    </div>
                    <div className="p-1 rounded-full bg-gray-50 text-gray-400">
                      {isExpanded ? <ChevronUp className="h-4 w-4" /> : <ChevronDown className="h-4 w-4" />}
                    </div>
                  </div>

                  {/* 🚀 DETALHAMENTO (ACORDEÃO) */}
                  <AnimatePresence>
                    {isExpanded && (
                      <motion.div
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: "auto", opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        className="overflow-hidden"
                      >
                        <div className="mt-2 pt-3 border-t border-gray-100 grid grid-cols-2 gap-y-4 gap-x-4">
                          
                          {/* Novos Indicadores de Total e Lucro */}
                          <div className="bg-gray-50 p-2.5 rounded-lg border border-gray-100">
                            <p className="text-[10px] uppercase font-semibold text-gray-400 flex items-center gap-1 mb-0.5">
                              <Calculator className="h-3 w-3" /> Total da Operação
                            </p>
                            <p className={`font-mono font-bold ${isEntry ? "text-gray-800" : "text-gray-800"}`}>
                              {formatMoney(operacaoTotal)} <span className="text-[10px] font-normal text-gray-400">({displayQuantity}x)</span>
                            </p>
                          </div>

                          {item.profit != null && (
                            <div className="bg-gray-50 p-2.5 rounded-lg border border-gray-100">
                              <p className="text-[10px] uppercase font-semibold text-gray-400 mb-0.5">Lucro da Venda</p>
                              <p className={`font-mono font-bold ${item.profit >= 0 ? "text-green-600" : "text-red-600"}`}>
                                {formatMoney(item.profit)}
                              </p>
                            </div>
                          )}

                          {/* Detalhes de Lote e Descrição */}
                          <div className="col-span-2 space-y-2">
                            <div className="flex gap-2">
                              <p className="text-[10px] font-mono bg-gray-100 px-2 py-1 rounded text-gray-500 flex-1">
                                EAN: {item.barcode}
                              </p>
                              {item.batch_code && (
                                <p className="text-[10px] font-mono bg-indigo-50 px-2 py-1 rounded text-indigo-600 flex-1 border border-indigo-100">
                                  LOTE: {item.batch_code}
                                </p>
                              )}
                            </div>

                            {(item.description || item.notes) && (
                              <div className="rounded-lg bg-orange-50 p-2.5 border border-orange-100/50">
                                <p className="text-[10px] uppercase font-semibold text-orange-800/60 mb-0.5">Observações do Registro</p>
                                <p className="text-xs text-orange-900 font-medium">{item.description || item.notes}</p>
                              </div>
                            )}
                          </div>

                        </div>
                      </motion.div>
                    )}
                  </AnimatePresence>

                </motion.div>
              );
            })}
          </div>
        )}
      </main>
    </div>
  );
}