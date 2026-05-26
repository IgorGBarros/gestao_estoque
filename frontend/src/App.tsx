// src/App.tsx - VERSÃO CORRIGIDA
import { Toaster } from "./components/ui/toaster";
import { TooltipProvider } from "./components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";

// Providers
import { AuthProvider } from "./hooks/useAuth";
import { PlanProvider } from "./hooks/usePlan";
import * as FeatureGatesModule from "./hooks/useFeatureGates";
// Support either a named export `FeatureGatesProvider` or a default export.
const FeatureGatesProvider: React.FC<{ children: React.ReactNode }> =
  (FeatureGatesModule as any).FeatureGatesProvider ||
  (FeatureGatesModule as any).default ||
  (({ children }: { children: React.ReactNode }) => <>{children}</>);
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

// ✅ QueryClient FORA do componente
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
      staleTime: 1000 * 60 * 5,
    },
  },
});

// ✅ Layout Wrapper para Rotas Protegidas
const ProtectedLayout = ({ children }: { children: React.ReactNode }) => (
  <div className="min-h-screen bg-background">
    <SessionHeader />
    <main>{children}</main>
  </div>
);

const App = () => {
  return (
    <ErrorBoundary 
      fallback={
        <div className="min-h-screen flex items-center justify-center bg-background p-4">
          <div className="text-center">
            <h2 className="text-xl font-bold text-destructive mb-2">⚠️ Algo deu errado</h2>
            <p className="text-muted-foreground mb-4">Tente recarregar a página</p>
            <button 
              onClick={() => window.location.reload()}
              className="bg-primary text-primary-foreground px-4 py-2 rounded-lg"
            >
              Recarregar
            </button>
          </div>
        </div>
      }
    >
      <QueryClientProvider client={queryClient}>
        <ThemeProvider>
          <TooltipProvider>
            <Toaster />
            
            {/* ✅ CORREÇÃO: BrowserRouter DEVE envolver AuthProvider */}
            <BrowserRouter>
              <AuthProvider>          {/* ← Agora useNavigate() funciona! */}
                <PlanProvider>
                  <FeatureGatesProvider>
                    <Routes>
                      {/* Rotas públicas */}
                      <Route path="/lp" element={<LandingPage />} />
                      <Route path="/auth" element={<Auth />} />
                      
                      {/* Vitrine Pública */}
                      <Route path="/vitrine/:slug" element={<Storefront />} />
                      <Route path="/vitrine" element={<Storefront />} />

                      {/* Rotas de API / Dev */}
                      <Route path="/api" element={<ApiLanding />} />
                      <Route path="/api/docs" element={<ApiDocs />} />
                      <Route path="/api/pricing" element={<ApiPricing />} />
                      <Route path="/api/sandbox" element={<ApiSandbox />} />
                      <Route path="/api/dashboard" element={<ApiDashboard />} />

                      {/* Rotas protegidas */}
                      <Route path="/" element={
                        <ProtectedRoute>
                          <ProtectedLayout>
                            <Index />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />
                      
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

                      <Route path="/admin-panel" element={
                        <ProtectedRoute requireAdmin>
                          <ProtectedLayout>
                            <AdminPanel />
                          </ProtectedLayout>
                        </ProtectedRoute>
                      } />

                      {/* Catch-all */}
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