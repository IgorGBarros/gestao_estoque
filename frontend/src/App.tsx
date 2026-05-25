// src/App.tsx - Versão Final Integrada e Corrigida
import { Toaster } from "./components/ui/toaster";
// ✅ REMOVIDO: Sonner duplicado para evitar conflitos
// import { Toaster as Sonner } from "./components/ui/sonner";
import { TooltipProvider } from "./components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";

// Providers
import { AuthProvider } from "./hooks/useAuth";
import { PlanProvider } from "./hooks/usePlan";
import { FeatureGatesProvider } from "./hooks/useFeatureGates";
import { ThemeProvider } from "./hooks/useTheme";

// Components
import ProtectedRoute from "./components/ProtectedRoute";
import { SessionHeader } from "./components/SessionHeader";
import { ErrorBoundary } from "./components/ErrorBoundary";

// Pages - Public
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
      refetchOnWindowFocus: false,
      retry: 1,
      staleTime: 1000 * 60 * 5, // Cache válido por 5 min
      // ✅ LGPD: Não enviar dados pessoais em analytics
      meta: {
        anonymize: true,
      },
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
        <div className="min-h-screen flex flex-col items-center justify-center bg-background p-4">
          <div className="text-center space-y-4">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto" />
            <p className="text-muted-foreground">Carregando aplicação...</p>
            <p className="text-xs text-muted-foreground/60">
              Se o erro persistir, limpe o cache do navegador
            </p>
          </div>
        </div>
      }
    >
      <QueryClientProvider client={queryClient}>
        <ThemeProvider>
          <TooltipProvider>
            {/* ✅ ESCOLHA APENAS UM: Toaster (shadcn) OU Sonner */}
            <Toaster />
            
            <AuthProvider>
              <PlanProvider>
                <FeatureGatesProvider>
                  <BrowserRouter>
                    <Routes>
                      {/* ==========================================
                          ROTAS PÚBLICAS (Sem Header de Sessão)
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
                          ROTAS PROTEGIDAS (Com Header de Sessão)
                          ========================================== */}
                      
                      {/* Home / Dashboard Principal */}
                      <Route 
                        path="/" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <Index />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />

                      {/* Gestão de Produtos */}
                      <Route 
                        path="/products" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <ProductList />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />
                      <Route 
                        path="/products/new" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <ProductForm />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />
                      <Route 
                        path="/products/:id/edit" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <ProductForm />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />

                      {/* Estoque (Entrada/Saída) */}
                      <Route 
                        path="/stock/entry" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <StockWizard />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />
                      <Route 
                        path="/add" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <AddProduct />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />
                      <Route 
                        path="/withdraw" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <WithdrawProduct />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />

                      {/* Analytics & Histórico */}
                      <Route 
                        path="/dashboard" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <Dashboard />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />
                      <Route 
                        path="/history" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <MovementHistory />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />

                      {/* Configurações & Perfil */}
                      <Route 
                        path="/settings" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <Settings />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />
                      <Route 
                        path="/profile" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <Profile />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />
                      <Route 
                        path="/plans" 
                        element={
                          <ProtectedRoute>
                            <ProtectedLayout>
                              <Plans />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />

                      {/* Admin Panel - com requireAdmin */}
                      <Route 
                        path="/admin-panel" 
                        element={
                          <ProtectedRoute requireAdmin>
                            <ProtectedLayout>
                              <AdminPanel />
                            </ProtectedLayout>
                          </ProtectedRoute>
                        } 
                      />

                      {/* Rota Catch-All */}
                      <Route path="*" element={<NotFound />} />
                    </Routes>
                  </BrowserRouter>
                </FeatureGatesProvider>
              </PlanProvider>
            </AuthProvider>
          </TooltipProvider>
        </ThemeProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  );
};

export default App;