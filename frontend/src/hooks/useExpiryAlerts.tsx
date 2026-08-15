import { useState, useEffect, useMemo } from "react";
import { inventoryApi, InventoryItem } from "../lib/api";
import { useAuth } from "../../src/hooks/useAuth";

export interface ExpiryAlert {
  id: string;
  product_name: string;
  barcode: string;
  expiry_date: string;
  daysLeft: number;
  severity: "critical" | "warning" | "info";
  quantity: number;
}

function getConfig() {
  const enabled = localStorage.getItem("expiry_alert_enabled") !== "false";
  const days = parseInt(localStorage.getItem("expiry_alert_days") || "30", 10);
  return { enabled, days };
}

export function useExpiryAlerts() {
  const { user } = useAuth();
  const [items, setItems] = useState<InventoryItem[]>([]);
  const [loading, setLoading] = useState(true);
  const config = getConfig();

  useEffect(() => {
    if (!user || !config.enabled) {
      setLoading(false);
      return;
    }
    inventoryApi.list().then(setItems).catch(() => {}).finally(() => setLoading(false));
  }, [user]);

  const alerts = useMemo<ExpiryAlert[]>(() => {
    if (!config.enabled) return [];

    const now = new Date();
    now.setHours(0, 0, 0, 0);

    // ⚠️ CORREÇÃO CRÍTICA: o item da API real NUNCA tem expiry_date,
    // barcode, product_name nem quantity no nível raiz — o serializer
    // real (InventoryItemSerializer) só retorna 'id', 'product',
    // 'sale_price', 'cost_price', 'total_quantity', 'min_quantity',
    // 'batches', 'display_price', 'total_cost', 'potential_profit'. A
    // validade e a quantidade de verdade vivem em CADA LOTE
    // (item.batches[].expiration_date / .quantity), e nome/código de
    // barras vivem em item.product. O filtro antigo (item.expiry_date &&
    // item.quantity > 0) era sempre falso pros dois lados — o alerta de
    // validade nunca aparecia, pra ninguém, desde sempre.
    const alertasPorLote: ExpiryAlert[] = [];

    for (const item of items) {
      for (const batch of item.batches || []) {
        if (!batch.expiration_date || batch.quantity <= 0) continue;

        // Mesma proteção de fuso horário aplicada em toda a sessão —
        // "YYYY-MM-DD" sem hora explícita parseia como UTC, podendo
        // mostrar um dia a menos em fuso negativo (Brasil).
        const expiry = new Date(batch.expiration_date + "T00:00:00");
        expiry.setHours(0, 0, 0, 0);
        const diffMs = expiry.getTime() - now.getTime();
        const daysLeft = Math.ceil(diffMs / (1000 * 60 * 60 * 24));

        if (daysLeft > config.days) continue;

        let severity: ExpiryAlert["severity"] = "info";
        if (daysLeft <= 0) severity = "critical";
        else if (daysLeft <= 7) severity = "critical";
        else if (daysLeft <= config.days) severity = "warning";

        alertasPorLote.push({
          id: batch.id,
          product_name: item.product?.name || item.product_name || "Produto",
          barcode: item.product?.bar_code || item.barcode || "",
          expiry_date: batch.expiration_date,
          daysLeft,
          severity,
          quantity: batch.quantity,
        });
      }
    }

    return alertasPorLote.sort((a, b) => a.daysLeft - b.daysLeft);
  }, [items, config.enabled, config.days]);

  const criticalCount = alerts.filter((a) => a.severity === "critical").length;
  const warningCount = alerts.filter((a) => a.severity === "warning").length;

  return {
    alerts,
    loading,
    enabled: config.enabled,
    alertDays: config.days,
    criticalCount,
    warningCount,
    totalCount: alerts.length,
  };
}