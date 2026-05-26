// src/App.tsx - VERSÃO FINAL COM ORDEM DE PROVIDERS CORRIGIDA
import { Toaster } from "./components/ui/toaster";
import { TooltipProvider } from "./components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import type { ComponentType } from "react";

// ✅ Providers - ORDEM IMPORTANTE:
// 1. Auth primeiro (dependências básicas)
// 2. Plan (depende de Auth para saber o usuário)
// 3. FeatureGates (depende de Auth/Plan para liberar features)
import { AuthProvider } from "./hooks/useAuth";
import { PlanProvider } from "./hooks/usePlan";
import { FeatureGatesProvider } from "./hooks/useFeatureGates";
import { ThemeProvider } from "./hooks/useTheme";

// Components
import ProtectedRoute from "./components/ProtectedRoute";
import { SessionHeader } from "./components/SessionHeader";
import { ErrorBoundary } from "./components/ErrorBoundary";

// Pages - Public (não requerem auth)
import LandingPage from "./pages/LandingPage";
import Auth from "./pages/Auth";
import Storefront from "./pages/Storefront";
import NotFound from "./pages/NotFound";

// Pages - API / Dev
import ApiLanding from "./pages/ApiLanding";
import ApiDocs from "./pages/ApiDocs";
import ApiPricing from "./pages/ApiPricing";
import ApiSandbox from "./pages/ApiSandbox";
import ApiDashboard from "./pages/ApiDashboard";

// Pages - Protected (App Core)
import Index from "./pages/Index";
import ProductList from "./pages/ProductList";
import ProductForm from "./pages/ProductForm";
import AddProduct from "./pages/AddProduct";
import WithdrawProduct from "./pages/WithdrawProduct";
import StockWizard from "./pages/StockWizard";
import Dashboard from "./pages/Dashboard";
import Settings from "./pages/Settings";
import MovementHistory from "./pages/MovementHistory";
import AdminPanel from "./pages/AdminPanel";
import Profile from "./pages/Profile";
import Plans from "./pages/Plans";

// ✅ QueryClient FORA do componente (evita recriação a cada render)
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false, // Evita requisições desnecessárias
      retry: 1, // Tenta 1 vez antes de falhar
      staleTime: 1000 * 60 * 5, // Cache válido por 5 minutos
    },
  },
});

// ✅ Layout Wrapper para Rotas Protegidas
const ProtectedLayout = ({ children }: { children: React.ReactNode }) => (
  <div className="min-h-screen bg-background flex flex-col">
    <SessionHeader />
    <main className="flex-1">{children}</main>
  </div>
);

const App = () => {
  return (
    <ErrorBoundary 
      fallback={
        <div className="min-h-screen flex items-center justify-center bg-background p-4">
          <div className="text-center space-y-4">
            <h2 className="text-xl font-bold text-destructive">⚠️ Algo deu errado</h2>
            <p className="text-muted-foreground">Tente recarregar a página</p>
            <button 
              onClick={() => window.location.reload()}
              className="bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:opacity-90 transition-opacity"
            >
              Recarregar
            </button>
          </div>
        </div>
      }
    >
      {/* 
        ✅ ORDEM DOS PROVIDERS (CRÍTICO):
        1. QueryClientProvider: Cache de dados (independente)
        2. ThemeProvider: Tema visual (independente)
        3. TooltipProvider: UI components (independente)
        4. Toaster: Notificações (independente)
        5. BrowserRouter: Rotas (deve envolver Auth para useNavigate)
        6. AuthProvider: Autenticação (usa useNavigate, precisa de BrowserRouter)
        7. PlanProvider: Planos (depende de Auth para saber o usuário)
        8. FeatureGatesProvider: Features (depende de Auth/Plan)
      */}
      <QueryClientProvider client={queryClient}>
        <ThemeProvider>
          <TooltipProvider>
            <Toaster />
            
            {/* ✅ BrowserRouter DEVE envolver AuthProvider para useNavigate funcionar */}
            <BrowserRouter>
              <AuthProvider>
                <PlanProvider>
                  <FeatureGatesProvider>
                    <Routes>
                      {/* ==========================================
                          ROTAS PÚBLICAS (Sem autenticação)
                          ========================================== */}
                      <Route path="/lp" element={<LandingPage />} />
                      <Route path="/auth" element={<Auth />} />
                      
                      {/* Vitrine Pública da Consultora */}
                      <Route path="/vitrine/:slug" element={<Storefront />} />
                      <Route path="/vitrine" element={<Storefront />} />

                      {/* Rotas de API / Desenvolvedores */}
                      <Route path="/api" element={<ApiLanding />} />
                      <Route path="/api/docs" element={<ApiDocs />} />
                      <Route path="/api/pricing" element={<ApiPricing />} />
                      <Route path="/api/sandbox" element={<ApiSandbox />} />
                      <Route path="/api/dashboard" element={<ApiDashboard />} />

                      {/* ==========================================
                          ROTAS PROTEGIDAS (Requer autenticação)
                          ========================================== */}
                      
                      {/* Home / Dashboard Principal */}
                      <Route path="/" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <Index />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />

                      {/* Gestão de Produtos */}
                      <Route path="/products" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <ProductList />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      <Route path="/products/new" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <ProductForm />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      <Route path="/products/:id/edit" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <ProductForm />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />

                      {/* Estoque (Entrada/Saída) */}
                      <Route path="/stock/entry" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <StockWizard />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      <Route path="/add" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <AddProduct />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      <Route path="/withdraw" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <WithdrawProduct />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />

                      {/* Analytics & Histórico */}
                      <Route path="/dashboard" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <Dashboard />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      <Route path="/history" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <MovementHistory />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />

                      {/* Configurações & Perfil */}
                      <Route path="/settings" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <Settings />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      <Route path="/profile" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <Profile />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      <Route path="/plans" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <Plans />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />

                      {/* Admin Panel (requer permissão de staff) */}
                      <Route path="/admin-panel" element={
                        <ProtectedRoute requireAdmin>
                          <ProtectedLayout>
                            <AdminPanel />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />

                      {/* Catch-all para 404 */}
                      <Route path="*" element={<NotFound />} />
                    </Routes>
                  </FeatureGatesProvider>
                </PlanProvider>
              </AuthProvider>
            </BrowserRouter>
            
          </TooltipProvider>
        </ThemeProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  );
};

export default App;