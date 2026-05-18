// src/hooks/useFeatureGates.tsx
import { createContext, useContext, useState, useEffect, useCallback, ReactNode } from "react";
import { api } from "../services/api"; // ✅ Usa a instância Axios configurada com interceptors
import { usePlan } from "./usePlan"; // Hook que verifica se o usuário é PRO

export type FeatureKey =
  | "barcode_scanner"
  | "ocr_expiry"
  | "dashboard_charts"
  | "dashboard_kpi_advanced"
  | "ai_insights"
  | "storefront"
  | "chat_assistant"
  | "unlimited_products";

interface FeatureGate {
  feature_key: string;
  label: string;
  description: string | null;
  requires_pro: boolean;
}

interface FeatureGatesCtx {
  gates: FeatureGate[];
  loading: boolean;
  /** Returns true if the feature is locked (requires pro and user is free) */
  isLocked: (key: FeatureKey) => boolean;
  /** Returns true if the feature requires pro plan */
  requiresPro: (key: FeatureKey) => boolean;
  refresh: () => void;
}

const FeatureGatesContext = createContext<FeatureGatesCtx>({
  gates: [],
  loading: true,
  isLocked: () => true,
  requiresPro: () => true,
  refresh: () => {},
});

// Fallback estático caso a API do Django ainda não tenha a rota /feature-gates/
// Isso garante que o app não quebre se o backend estiver em deploy ou offline
const DEFAULT_GATES: FeatureGate[] = [
  { feature_key: "barcode_scanner", label: "Scanner de Código", description: null, requires_pro: true },
  { feature_key: "ocr_expiry", label: "Leitor de Validade (IA)", description: null, requires_pro: true },
  { feature_key: "dashboard_charts", label: "Gráficos Avançados", description: null, requires_pro: true },
  { feature_key: "dashboard_kpi_advanced", label: "Lucro e Rentabilidade", description: null, requires_pro: true },
  { feature_key: "ai_insights", label: "Insights com Inteligência Artificial", description: null, requires_pro: true },
  { feature_key: "storefront", label: "Vitrine Digital", description: null, requires_pro: true },
  { feature_key: "chat_assistant", label: "Assistente de Estoque", description: null, requires_pro: true },
  { feature_key: "unlimited_products", label: "Produtos Ilimitados", description: null, requires_pro: true },
];

export function FeatureGatesProvider({ children }: { children: ReactNode }) {
  const { isPro } = usePlan();
  const [gates, setGates] = useState<FeatureGate[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchGates = useCallback(async () => {
    setLoading(true);
    try {
      // 🚨 MUDANÇA: Chama a API do Render (Django)
      // O interceptor do Axios já injeta o token JWT se existir
      const response = await api.get<FeatureGate[]>("/admin/feature-gates/");
      
      if (Array.isArray(response.data)) {
         setGates(response.data);
      } else {
         console.warn("Formato inesperado da resposta de feature-gates");
         setGates(DEFAULT_GATES);
      }
    } catch (err: any) {
      // Se der 401, o interceptor já limpou o token.
      // Se der 404 ou 500, usamos o fallback.
      if (err.response?.status !== 401) {
        console.warn("Rota /admin/feature-gates/ não encontrada ou falhou. Usando padrão local.");
      }
      setGates(DEFAULT_GATES);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchGates();
  }, [fetchGates]);

  const requiresPro = useCallback(
    (key: FeatureKey): boolean => {
      const gate = gates.find((g) => g.feature_key === key);
      // Se não encontrar a gate no array (ex: nova feature não listada no backend),
      // assumimos que requer PRO por segurança, ou false se quiser ser permissivo.
      // Aqui assumimos true para evitar vazamento de features pagas.
      return gate ? gate.requires_pro : true;
    },
    [gates]
  );

  const isLocked = useCallback(
    (key: FeatureKey): boolean => {
      // Se for PRO, nada está travado
      if (isPro) return false;
      
      // Se for FREE, verifica se a feature exige PRO
      return requiresPro(key);
    },
    [isPro, requiresPro]
  );

  return (
    <FeatureGatesContext.Provider value={{ gates, loading, isLocked, requiresPro, refresh: fetchGates }}>
      {children}
    </FeatureGatesContext.Provider>
  );
}

export const useFeatureGates = () => {
  const context = useContext(FeatureGatesContext);
  if (!context) {
    throw new Error("useFeatureGates must be used within a FeatureGatesProvider");
  }
  return context;
};