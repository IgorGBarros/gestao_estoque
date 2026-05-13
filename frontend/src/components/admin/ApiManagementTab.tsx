// src/components/admin/ApiManagementTab.tsx
import { useState } from "react"; // ✅ Import explícito do React + hooks
import { Server, Bell } from "lucide-react";


export interface Props {
  formatCurrency: (n: number) => string;
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

// ✅ Export default CORRETA
export default function ApiManagementTab({ formatCurrency, toast }: Props) {
  // ✅ Hooks APENAS dentro do componente
  const [mockData] = useState({
    revenue_api_mrr: 1240.00,
    active_keys: 23,
    webhook_success_rate: 98.4,
  });

  return (
    <div className="space-y-6">
      <div>
        <h2 className="text-2xl font-bold flex items-center gap-2">
          <Server className="h-6 w-6 text-primary" />
          API & Webhooks
        </h2>
        <p className="text-muted-foreground">Monitoramento interno</p>
      </div>

      <div className="grid grid-cols-3 gap-4">
        <div className="p-4 border rounded-lg">
          <p className="text-xs text-muted-foreground">Receita API</p>
          <p className="text-xl font-bold text-emerald-600">
            {formatCurrency(mockData.revenue_api_mrr)}
          </p>
        </div>
        <div className="p-4 border rounded-lg">
          <p className="text-xs text-muted-foreground">Chaves Ativas</p>
          <p className="text-xl font-bold text-blue-600">{mockData.active_keys}</p>
        </div>
        <div className="p-4 border rounded-lg">
          <p className="text-xs text-muted-foreground">Webhooks</p>
          <p className="text-xl font-bold text-amber-600">{mockData.webhook_success_rate}%</p>
        </div>
      </div>

      <div className="p-8 border border-dashed rounded-lg text-center text-muted-foreground">
        <Bell className="h-8 w-8 mx-auto mb-2" />
        Funcionalidades completas serão ativadas na versão comercial.
      </div>
    </div>
  );
}