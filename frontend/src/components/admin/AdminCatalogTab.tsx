// src/components/admin/AdminCatalogTab.tsx
//
// Contêiner do grupo "Catálogo" — 3 sub-abas: revisão de código de
// barras (existia antes, só movida pra cá), navegação por marca (novo,
// paginado de verdade) e consulta SQL (novo, restrito a leitura).
import { Tabs, TabsList, TabsTrigger, TabsContent } from "../ui/tabs";
import { Barcode, Package, Terminal, ArrowLeft } from "lucide-react";
import AdminBarcodeReviewTab from "./AdminBarcodeReviewTab";
import AdminProductBrowserTab from "./AdminProductBrowserTab";
import AdminSQLConsoleTab from "./AdminSQLConsoleTab";

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
  // ⚠️ NOVO: opcional de propósito — quando informado, mostra um botão
  // de voltar na MESMA linha das sub-abas, substituindo a fileira de
  // cima (Saúde/Config/etc) em vez de empilhar mais uma barra.
  onVoltar?: () => void;
}

export default function AdminCatalogTab({ toast, onVoltar }: Props) {
  return (
    <Tabs defaultValue="revisao" className="space-y-4">
      <TabsList className="scrollbar-hide flex w-full items-center gap-1 overflow-x-auto">
        {onVoltar && (
          <button
            onClick={onVoltar}
            className="flex shrink-0 items-center gap-1.5 rounded-md px-2.5 py-1.5 text-xs text-muted-foreground hover:bg-secondary hover:text-foreground"
            title="Voltar pra Sistema"
          >
            <ArrowLeft className="h-3.5 w-3.5" /> Sistema
          </button>
        )}
        <TabsTrigger value="revisao" className="flex shrink-0 items-center gap-2">
          <Barcode className="h-4 w-4" /> Revisão de Código de Barras
        </TabsTrigger>
        <TabsTrigger value="produtos" className="flex shrink-0 items-center gap-2">
          <Package className="h-4 w-4" /> Produtos por Marca
        </TabsTrigger>
        <TabsTrigger value="sql" className="flex shrink-0 items-center gap-2">
          <Terminal className="h-4 w-4" /> Consulta SQL
        </TabsTrigger>
      </TabsList>

      <TabsContent value="revisao"><AdminBarcodeReviewTab toast={toast} /></TabsContent>
      <TabsContent value="produtos"><AdminProductBrowserTab toast={toast} /></TabsContent>
      <TabsContent value="sql"><AdminSQLConsoleTab toast={toast} /></TabsContent>
    </Tabs>
  );
}