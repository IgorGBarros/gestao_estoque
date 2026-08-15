import { useState, useEffect, useMemo } from "react";
import { movementsApi, Movement, formatMoney } from "../lib/api";
import { useAuth } from "../../src/hooks/useAuth";

export interface SalesMilestone {
  id: string;
  type: "milestone";
  title: string;
  description: string;
  value: number;
  icon: "trophy" | "star" | "flame";
}

export interface TopProduct {
  product_name: string;
  totalQty: number;
  totalRevenue: number;
}

export interface WeeklyInsight {
  id: string;
  type: "weekly_top";
  title: string;
  description: string;
  products: TopProduct[];
}

export type Notification = SalesMilestone | WeeklyInsight;

const MILESTONES = [
  { threshold: 500, label: "R$ 500", icon: "star" as const },
  { threshold: 1000, label: "R$ 1.000", icon: "trophy" as const },
  { threshold: 2500, label: "R$ 2.500", icon: "trophy" as const },
  { threshold: 5000, label: "R$ 5.000", icon: "flame" as const },
  { threshold: 10000, label: "R$ 10.000", icon: "flame" as const },
];

function getWeekStart(): Date {
  const now = new Date();
  const day = now.getDay();
  const diff = now.getDate() - day + (day === 0 ? -6 : 1);
  const monday = new Date(now.setDate(diff));
  monday.setHours(0, 0, 0, 0);
  return monday;
}

function getMonthStart(): Date {
  const now = new Date();
  return new Date(now.getFullYear(), now.getMonth(), 1);
}

export function useSalesNotifications() {
  const { user } = useAuth();
  const [movements, setMovements] = useState<Movement[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) { setLoading(false); return; }
    movementsApi.list()
      .then(setMovements)
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [user]);

  const { milestones, weeklyInsight, topProducts, totalSalesMonth, totalSalesWeek } = useMemo(() => {
    // ⚠️ CORREÇÃO: filtrava por m.movement_type === "saida" && m.sale_type
    // === "venda" — NENHUM dos dois campos existe no Movement retornado
    // pela API (o serializer real usa "transaction_type", com valores
    // MAIÚSCULOS: "VENDA", "PRESENTE", etc). Isso fazia o filtro retornar
    // SEMPRE vazio — a notificação de meta de venda nunca aparecia, não
    // importa quanto a consultora vendesse.
    const sales = movements.filter((m) => m.transaction_type === "VENDA");

    // ⚠️ CORREÇÃO: quantity é armazenado NEGATIVO numa saída (confirmado no
    // backend: quantity=-batch_info['quantity_used']) — sem Math.abs, os
    // totais de venda vinham negativos.
    const monthStart = getMonthStart();
    const monthlySales = sales.filter((m) => new Date(m.created_at) >= monthStart);
    const totalSalesMonth = monthlySales.reduce((sum, m) => sum + (m.unit_price || 0) * Math.abs(m.quantity), 0);

    const weekStart = getWeekStart();
    const weeklySales = sales.filter((m) => new Date(m.created_at) >= weekStart);
    const totalSalesWeek = weeklySales.reduce((sum, m) => sum + (m.unit_price || 0) * Math.abs(m.quantity), 0);

    const allTimeSales = sales.reduce((sum, m) => sum + (m.unit_price || 0) * Math.abs(m.quantity), 0);

    // ⚠️ CORREÇÃO: antes filtrava aqui dentro por "dismissed_milestones"
    // (localStorage próprio, separado) — isso REMOVIA o marco da lista
    // pra sempre assim que dispensado, diferente do padrão "marca como
    // lido" que promoções/novidades já usavam (mantém visível, só sai do
    // contador). Agora devolve todos os marcos atingidos; quem decide
    // "visto" ou não é o NotificationBell, com o mesmo mecanismo unificado
    // usado pros outros tipos de notificação.
    const milestones: SalesMilestone[] = MILESTONES
      .filter((m) => allTimeSales >= m.threshold)
      .map((m) => ({
        id: `milestone-${m.threshold}`,
        type: "milestone" as const,
        title: `🎉 Meta de ${m.label} atingida!`,
        description: `Você já vendeu ${formatMoney(allTimeSales)} no total. Parabéns!`,
        value: m.threshold,
        icon: m.icon,
      }));

    // ⚠️ CORREÇÃO: mesma causa — m.movement_type nunca existe. "Saída" de
    // qualquer tipo (venda, presente, brinde, perda, uso próprio) sempre
    // tem quantity negativo — é um jeito confiável de identificar saída
    // sem depender de um campo que a API nunca manda.
    const weeklyExits = movements.filter(
      (m) => m.quantity < 0 && new Date(m.created_at) >= weekStart
    );

    const productMap = new Map<string, TopProduct>();
    for (const m of weeklyExits) {
      // ⚠️ CORREÇÃO: usava m.barcode, que também não existe — sempre
      // undefined, fazendo produtos diferentes colidirem na mesma chave
      // do Map (e depois virarem key={p.barcode} duplicada no React, na
      // tela do sino). Nome do produto é o único identificador real
      // disponível nesse dado.
      const key = m.product_name;
      const existing = productMap.get(key);
      const qtd = Math.abs(m.quantity);
      if (existing) {
        existing.totalQty += qtd;
        existing.totalRevenue += (m.unit_price || 0) * qtd;
      } else {
        productMap.set(key, {
          product_name: m.product_name,
          totalQty: qtd,
          totalRevenue: (m.unit_price || 0) * qtd,
        });
      }
    }

    const topProducts = Array.from(productMap.values())
      .sort((a, b) => b.totalQty - a.totalQty)
      .slice(0, 5);

    const weeklyInsight: WeeklyInsight | null = topProducts.length > 0
      ? {
          id: "weekly-top",
          type: "weekly_top",
          title: "📊 Mais vendidos da semana",
          description: `${topProducts.length} produto${topProducts.length > 1 ? "s" : ""} com saída esta semana`,
          products: topProducts,
        }
      : null;

    return { milestones, weeklyInsight, topProducts, totalSalesMonth, totalSalesWeek };
  }, [movements]);

  return {
    milestones,
    weeklyInsight,
    topProducts,
    totalSalesMonth,
    totalSalesWeek,
    loading,
    notificationCount: milestones.length + (weeklyInsight ? 1 : 0),
  };
}