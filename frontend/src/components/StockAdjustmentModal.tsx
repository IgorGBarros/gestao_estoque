// components/StockAdjustmentModal.tsx — VERSÃO REFATORADA COM PALETA DA MARCA
//
// ⚠️ REGRA DE NEGÓCIO (definida pelo Igor): entrada de estoque é sempre
// pelo CADASTRO, nunca pelo ajuste. Se a consultora errou a quantidade pra
// MENOS no cadastro, ela simplesmente cadastra a diferença de novo — não
// precisa "ajustar". O botão Ajustar Saldo existe só pra corrigir pra
// BAIXO (errou pra mais no cadastro), e exige justificativa — senão vira
// uma porta aberta pra qualquer mudança de saldo sem motivo registrado.
import { useState, useEffect } from "react";
import { X, Loader2, Scale, Minus, AlertTriangle, Info } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { movementsApi, InventoryItem } from "../lib/api";
import { useToast } from '../components/ui/use-toast'; // ✅ Importar useToast original para evitar dependência circular

interface StockAdjustmentModalProps {
  isOpen: boolean;
  onClose: () => void;
  item: InventoryItem | null;
  onAdjusted: () => void;
}

export default function StockAdjustmentModal({
  isOpen,
  onClose,
  item,
  onAdjusted,
}: StockAdjustmentModalProps) {
  const [realQty, setRealQty] = useState<number | "">(0);
  const [notes, setNotes] = useState("");
  const [loading, setLoading] = useState(false);
  const { toast } = useToast();

  const systemQty = item?.total_quantity ?? item?.quantity ?? 0;
  const productName =
    item?.product?.name || item?.product_name || "Produto Desconhecido";
  const barcode = item?.product?.bar_code || item?.barcode || "";
  const productId = item?.product?.id || item?.id;

  useEffect(() => {
    if (isOpen && item) {
      setRealQty(systemQty);
      setNotes("");
    }
  }, [isOpen, item, systemQty]);

  const diff = typeof realQty === "number" ? realQty - systemQty : 0;
  const justificativaVazia = notes.trim().length === 0;

  const handleSave = async () => {
    if (!item || typeof realQty !== "number") return;

    if (realQty === systemQty) {
      toast({
        title: "Sem alteração",
        description: "A quantidade real é igual ao sistema.",
      });
      return;
    }

    // ⚠️ Ajuste é só pra corrigir pra BAIXO — a UI já impede digitar acima
    // do saldo atual (ver input abaixo), mas essa checagem garante que uma
    // tentativa não passa mesmo que algo escape da validação visual.
    if (diff > 0) {
      toast({
        title: "Isso não é um ajuste",
        description: "Pra aumentar o estoque, cadastre a quantidade que faltou na tela de Cadastro — não pelo Ajustar Saldo.",
        variant: "destructive",
      });
      return;
    }

    if (justificativaVazia) {
      toast({
        title: "Justificativa obrigatória",
        description: "Todo ajuste de saldo precisa de um motivo registrado.",
        variant: "destructive",
      });
      return;
    }

    setLoading(true);
    try {
      const adjustmentQty = Math.abs(diff);

      const transactionData = {
        product: productId,
        product_id: productId,
        quantity: adjustmentQty,
        transaction_type: "AJUSTE",
        unit_price: 0,
        unit_cost: item.cost_price || 0,
        description: notes.trim(),
        product_name: productName,
        barcode: barcode,
        movement_type: "saida",
        sale_type: "ajuste",
        notes: notes.trim(),
      };

      await movementsApi.create(transactionData);

      toast({
        title: "Estoque ajustado com sucesso!",
        description: `${productName}: ${systemQty} → ${realQty} unidades`,
      });

      onAdjusted();
      onClose();
    } catch (err: any) {
      let errorMessage = "Erro desconhecido";
      if (err.response?.data?.error) {
        errorMessage = err.response.data.error;
      } else if (err.message) {
        errorMessage = err.message;
      }
      toast({
        title: "Erro ao ajustar estoque",
        description: errorMessage,
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  if (!isOpen || !item) return null;

  return (
    <AnimatePresence>
      <div
        className="fixed inset-0 z-[60] flex items-center justify-center bg-foreground/60 backdrop-blur-sm p-4"
        onClick={onClose}
      >
        <motion.div
          initial={{ scale: 0.95, y: 20 }}
          animate={{ scale: 1, y: 0 }}
          exit={{ scale: 0.95, y: 20 }}
          onClick={(e) => e.stopPropagation()}
          className="w-full max-w-md rounded-2xl bg-card shadow-2xl overflow-hidden border border-brand/15"
        >
          {/* Header */}
          <div className="p-4 border-b border-brand-peach/30 flex items-center justify-between bg-card">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-brand/10 rounded-lg">
                <Scale className="h-5 w-5 text-brand" />
              </div>
              <div>
                <h2 className="text-sm font-bold text-foreground">
                  Ajustar Saldo
                </h2>
                <p className="text-xs text-brand-rose/70">
                  Correção manual de inventário — só pra baixo
                </p>
              </div>
            </div>
            <button
              onClick={onClose}
              className="p-2 hover:bg-brand-soft rounded-full transition-colors"
            >
              <X className="text-brand-rose/50" size={18} />
            </button>
          </div>

          {/* Content */}
          <div className="p-5 space-y-5">
            {/* Product info */}
            <div className="rounded-lg bg-brand-soft p-3 border border-brand-peach/30">
              <p className="text-sm font-semibold text-foreground line-clamp-2 leading-tight">
                {productName}
              </p>
              <p className="text-xs text-brand-rose/60 mt-1 font-mono">
                {barcode}
              </p>
            </div>

            {/* Aviso: pra que serve o ajuste */}
            <div className="flex items-start gap-2 rounded-lg bg-brand/5 border border-brand/15 p-2.5">
              <Info className="h-3.5 w-3.5 text-brand mt-0.5 shrink-0" />
              <p className="text-[11px] text-brand-rose/80 leading-snug">
                Errou a quantidade pra <strong>mais</strong> no cadastro? Corrija aqui.
                Errou pra <strong>menos</strong>? Não precisa ajustar — só cadastre a
                unidade que faltou normalmente.
              </p>
            </div>

            {/* System says */}
            <div className="text-center bg-brand-soft/50 py-4 rounded-xl border border-dashed border-brand-peach">
              <p className="text-xs text-brand-rose/60 uppercase font-bold tracking-wider mb-1">
                Saldo Atual (Sistema)
              </p>
              <p className="text-4xl font-bold text-foreground font-mono">
                {systemQty}{" "}
                <span className="text-base font-normal text-brand-rose/50">
                  un.
                </span>
              </p>
            </div>

            {/* Real quantity input — nunca permite ir acima do saldo atual */}
            <div>
              <label className="text-sm font-medium text-foreground block text-center mb-3">
                Qual a quantidade real física? (só pra corrigir pra baixo)
              </label>
              <div className="flex items-center justify-center gap-4">
                <button
                  type="button"
                  onClick={() =>
                    setRealQty((v) =>
                      Math.max(0, (typeof v === "number" ? v : 0) - 1)
                    )
                  }
                  className="flex h-14 w-14 items-center justify-center rounded-xl border-2 border-brand-peach bg-brand-soft text-xl font-bold hover:border-brand/50 hover:text-brand transition-colors"
                >
                  <Minus className="h-6 w-6" />
                </button>

                <input
                  type="number"
                  min={0}
                  max={systemQty}
                  value={realQty}
                  onChange={(e) => {
                    const v = e.target.value;
                    // ⚠️ Trava aqui: nunca aceita um valor maior que o saldo
                    // do sistema — é o que impede o "ajuste pra aumentar" de
                    // sequer ser digitado, não só bloqueado depois no save.
                    const num = v === "" ? "" : Math.max(0, Math.min(systemQty, parseInt(v) || 0));
                    setRealQty(num);
                  }}
                  className="h-14 w-28 rounded-xl border-2 border-brand bg-brand/5 text-center font-mono text-3xl font-bold text-brand outline-none focus:ring-2 focus:ring-brand/20"
                />

                {/* Sem botão "+": aumentar não é um ajuste, é cadastro. */}
                <div className="flex h-14 w-14 items-center justify-center rounded-xl border-2 border-dashed border-brand-peach/40 text-brand-rose/30 text-[10px] text-center leading-tight px-1">
                  cadastre p/ aumentar
                </div>
              </div>
            </div>

            {/* Difference indicator */}
            <div className="h-16 flex items-center justify-center">
              {typeof realQty === "number" && realQty !== systemQty && (
                <div className="w-full rounded-xl p-3 text-center border bg-destructive/10 border-destructive/20">
                  <div className="flex items-center justify-center gap-2">
                    <AlertTriangle className="h-4 w-4 text-destructive" />
                    <span className="text-sm font-bold text-destructive">
                      Diferença: {diff} unidade{Math.abs(diff) !== 1 ? "s" : ""}
                    </span>
                  </div>
                  <p className="text-[10px] mt-0.5 font-medium text-destructive/70">
                    🤖 FIFO será aplicado automaticamente nos lotes mais antigos
                  </p>
                </div>
              )}
            </div>

            {/* Notes — agora OBRIGATÓRIA */}
            <div>
              <label className="text-xs font-semibold uppercase text-brand-rose/60">
                Justificativa do ajuste <span className="text-destructive">*</span>
              </label>
              <input
                type="text"
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                placeholder="Ex: Contagem de inventário mensal apontou 2 a menos"
                className={`mt-1.5 w-full rounded-lg border px-3 py-2.5 text-sm outline-none focus:ring-1 placeholder:text-brand-rose/40 ${
                  justificativaVazia
                    ? "border-destructive/40 bg-destructive/5 focus:border-destructive/60 focus:ring-destructive/20"
                    : "border-brand/15 bg-brand-soft/50 focus:border-brand/30 focus:ring-brand/20"
                }`}
              />
              {justificativaVazia && (
                <p className="mt-1 text-[10px] text-destructive">
                  Obrigatória — todo ajuste precisa de um motivo registrado.
                </p>
              )}
            </div>
          </div>

          {/* Footer */}
          <div className="p-4 border-t border-brand-peach/30 flex gap-3 bg-brand-soft/30">
            <button
              onClick={onClose}
              className="flex-1 rounded-xl border border-brand-peach/50 bg-card py-3 text-sm font-medium text-foreground hover:bg-brand-soft transition-colors"
            >
              Cancelar
            </button>
            <button
              onClick={handleSave}
              disabled={
                loading ||
                typeof realQty !== "number" ||
                realQty === systemQty ||
                justificativaVazia
              }
              className="flex-1 rounded-xl bg-brand py-3 text-sm font-bold text-white hover:opacity-90 transition-opacity disabled:opacity-50 flex items-center justify-center gap-2"
            >
              {loading ? (
                <Loader2 className="h-4 w-4 animate-spin" />
              ) : (
                "Confirmar Ajuste"
              )}
            </button>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}