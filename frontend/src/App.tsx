// src/App.tsx - VERSÃO FINAL LGPD NÃO BLOQUEANTE
import { Toaster } from "./components/ui/toaster";
import { TooltipProvider } from "./components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route, useLocation } from "react-router-dom";

// ✅ Providers - ORDEM CRÍTICA:
// 1. QueryClientProvider: Cache de dados (independente)
// 2. ThemeProvider: Tema visual (independente)  
// 3. TooltipProvider/Toaster: UI components (independentes)
// 4. BrowserRouter: Rotas (deve envolver Auth para useNavigate)
// 5. AuthProvider: Autenticação (usa useNavigate, precisa de BrowserRouter)
// 6. PlanProvider: Planos (depende de Auth)
// 7. FeatureGatesProvider: Features (depende de Auth/Plan)
import { AuthProvider, useAuth } from "./hooks/useAuth";
import { PlanProvider } from "./hooks/usePlan";
import { FeatureGatesProvider } from "./hooks/useFeatureGates";
import { ThemeProvider } from "./hooks/useTheme";

// Components
import ProtectedRoute from "./components/ProtectedRoute";
import { SessionHeader } from "./components/SessionHeader";
import { ErrorBoundary } from "./components/ErrorBoundary";
import { CookieConsentBanner } from "./components/CookieConsentBanner";
import { PostAuthConsentModal } from "./components/PostAuthConsentModal";
// ✅ ConsentBlockingOverlay removido (modal não é mais bloqueante)

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
import { useEffect, useState } from "react";

// ✅ QueryClient FORA do componente (evita recriação a cada render)
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      retry: 1,
      staleTime: 1000 * 60 * 5, // 5 minutos
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
// src/App.tsx - AuthConsentWrapper com delay para não bloquear

function AuthConsentWrapper({ children }: { children: React.ReactNode }) {
  const { isAuthenticated, loading: authLoading } = useAuth();
  const location = useLocation();
  const [systemLoaded, setSystemLoaded] = useState(false);
  
  // ✅ Rotas onde modal NUNCA aparece
  const neverShowModalRoutes = ['/auth', '/lp', '/', '/admin-panel'];
  const isNeverShowRoute = neverShowModalRoutes.includes(location.pathname) || 
                          location.pathname.startsWith('/vitrine') ||
                          location.pathname.startsWith('/api');
  
  // ✅ Sistema carregou - agora pode mostrar modal se necessário
  useEffect(() => {
    if (isAuthenticated && !authLoading && !isNeverShowRoute) {
      // ✅ Delay para sistema carregar primeiro
      const timer = setTimeout(() => {
        console.log("✅ System loaded, consent modal can appear if needed");
        setSystemLoaded(true);
      }, 500); // 500ms delay
      
      return () => clearTimeout(timer);
    }
  }, [isAuthenticated, authLoading, isNeverShowRoute]);
  
  // ✅ NÃO renderizar nada se:
  if (
    authLoading ||                    // 1. Auth carregando
    !isAuthenticated ||               // 2. Não autenticado
    isNeverShowRoute ||               // 3. Rota proibida
    !systemLoaded                     // 4. Sistema ainda não carregou ← NOVO!
  ) {
    return <>{children}</>;
  }
  
  // ✅ Sistema carregado: renderizar modal discreto
  console.log("✅ AuthConsentWrapper: Rendering modal (system loaded)");
  return (
    <>
      <PostAuthConsentModal />
      {children}
    </>
  );
}
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
        QueryClient → Theme → UI → Router → Auth → Plan → Features
      */}
      <QueryClientProvider client={queryClient}>
        <ThemeProvider>
          <TooltipProvider>
            <Toaster />
            
            {/* ✅ BrowserRouter DEVE envolver AuthProvider para useNavigate funcionar */}
            <BrowserRouter>
              {/* ✅ 1. Banner de cookies básico (pré-auth, para TODOS os visitantes) */}
              <CookieConsentBanner />
              
              <AuthProvider>
                {/* ✅ 2. Wrapper que só renderiza modal discreto APÓS auth em rotas protegidas */}
                <AuthConsentWrapper>
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
                </AuthConsentWrapper>
              </AuthProvider>
            </BrowserRouter>
            
          </TooltipProvider>
        </ThemeProvider>
      </QueryClientProvider>
    </ErrorBoundary>
  );
};

export default App;