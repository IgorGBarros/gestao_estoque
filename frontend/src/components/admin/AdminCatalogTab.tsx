// src/components/admin/AdminCatalogTab.tsx
//
// Contêiner do grupo "Catálogo" — 3 sub-abas: revisão de código de
// barras (existia antes, só movida pra cá), navegação por marca (novo,
// paginado de verdade) e consulta SQL (novo, restrito a leitura).
import { Tabs, TabsList, TabsTrigger, TabsContent } from "../ui/tabs";
import { Barcode, Package, Terminal, ChevronRight, ClipboardCheck } from "lucide-react";
import AdminBarcodeReviewTab from "./AdminBarcodeReviewTab";
import AdminProductBrowserTab from "./AdminProductBrowserTab";
import AdminSQLConsoleTab from "./AdminSQLConsoleTab";
import AdminProductReviewTab from "./AdminProductReviewTab";

interface Props {
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
  // ⚠️ NOVO: dois níveis de volta — "Sistema" volta só pras sub-abas
  // dele (Saúde/Config/etc); "Painel" volta pro nível principal de
  // verdade (Dashboard/Loja/Sistema/Analytics), que fica escondido
  // enquanto estiver dentro do grupo Sistema, com ou sem Catálogo.
  onVoltar?: () => void;
  onPainel?: () => void;
}

export default function AdminCatalogTab({ toast, onVoltar, onPainel }: Props) {
  return (
    <Tabs defaultValue="revisao" className="space-y-4">
      <TabsList className="scrollbar-hide flex w-full items-center gap-1 overflow-x-auto">
        {onVoltar && (
          <div className="mr-1 flex shrink-0 items-center gap-1 border-r border-border pr-2 text-xs font-medium">
            {onPainel && (
              <>
                <button onClick={onPainel} className="text-muted-foreground hover:text-foreground hover:underline">
                  Painel
                </button>
                <ChevronRight className="h-3 w-3 text-muted-foreground/50" />
              </>
            )}
            <button onClick={onVoltar} className="text-muted-foreground hover:text-foreground hover:underline">
              Sistema
            </button>
            <ChevronRight className="h-3 w-3 text-muted-foreground/50" />
            <span className="text-foreground">Catálogo</span>
          </div>
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
        <TabsTrigger value="revisao_produtos" className="flex shrink-0 items-center gap-2">
          <ClipboardCheck className="h-4 w-4" /> Revisão de Produtos
        </TabsTrigger>
      </TabsList>

      <TabsContent value="revisao"><AdminBarcodeReviewTab toast={toast} /></TabsContent>
      <TabsContent value="produtos"><AdminProductBrowserTab toast={toast} /></TabsContent>
      <TabsContent value="sql"><AdminSQLConsoleTab toast={toast} /></TabsContent>
      <TabsContent value="revisao_produtos"><AdminProductReviewTab toast={toast} /></TabsContent>
    </Tabs>
  );
}