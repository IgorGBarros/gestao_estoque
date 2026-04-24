// App.tsx - Versão integrada com seus providers existentes
import { Toaster } from "../src/components/ui/toaster";
import { Toaster as Sonner } from "../src/components/ui/sonner";
import { TooltipProvider } from "../src/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "../src/hooks/useAuth";
import { PlanProvider } from "../src/hooks/usePlan";
import { FeatureGatesProvider } from "../src/hooks/useFeatureGates";
import { ThemeProvider } from "../src/hooks/useTheme";
import ProtectedRoute from "../src/components/ProtectedRoute";

// ✅ NOVO IMPORT
import { SessionHeader } from "../src/components/SessionHeader";

// Suas páginas existentes
import Index from "./pages/Index";
import Auth from "./pages/Auth";
import ProductList from "./pages/ProductList";
import ProductForm from "./pages/ProductForm";
import AddProduct from "./pages/AddProduct";
import WithdrawProduct from "./pages/WithdrawProduct";
import StockWizard from "./pages/StockWizard";
import Dashboard from "./pages/Dashboard";
import Storefront from "./pages/Storefront";
import Settings from "./pages/Settings";
import MovementHistory from "./pages/MovementHistory";
import AdminPanel from "./pages/AdminPanel";
import Profile from "./pages/Profile";
import Plans from "./pages/Plans";
import LandingPage from "./pages/LandingPage";
import NotFound from "./pages/NotFound";
import PGBA from "./pages/pgba/PGBA";
// Nova página PGBA Neural Canvas
import PGBANeural from "./pages/pgba/PGBANeural";
import PGBASite from "./pages/pgba/PGBASite";



const queryClient = new QueryClient();

// ✅ NOVO: Componente Layout com SessionHeader
const AppLayout = ({ children }: { children: React.ReactNode }) => (
  <div className="min-h-screen">
    <SessionHeader /> {/* ← Header da sessão aparece em todas as páginas protegidas */}
    {children}
  </div>
);

const App = () => (
  <QueryClientProvider client={queryClient}>
    <ThemeProvider>
      <TooltipProvider>
        <Toaster />
        <Sonner />
        <AuthProvider>
          <PlanProvider>
            <FeatureGatesProvider>
              <BrowserRouter>
                <Routes>
                  {/* Rotas públicas (SEM SessionHeader) */}
                  <Route path="/neural" element={<PGBANeural />} />
                  <Route path="/site" element={<PGBASite />} />
                  <Route path="/pgba" element={<PGBA />} />
                  <Route path="/auth" element={<Auth />} />
                  <Route path="/vitrine/:slug" element={<Storefront />} />
                  <Route path="/vitrine" element={<Storefront />} />
                  <Route path="/lp" element={<LandingPage />} />
                  
                  {/* ✅ Rotas protegidas (COM SessionHeader) */}
                  <Route path="/" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <Index />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/products" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <ProductList />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/products/new" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <ProductForm />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/products/:id/edit" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <ProductForm />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/stock/entry" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <StockWizard />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/add" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <AddProduct />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/withdraw" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <WithdrawProduct />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/dashboard" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <Dashboard />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/history" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <MovementHistory />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/settings" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <Settings />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/profile" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <Profile />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/plans" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <Plans />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  <Route path="/admin-panel" element={
                    <ProtectedRoute>
                      <AppLayout>
                        <AdminPanel />
                      </AppLayout>
                    </ProtectedRoute>
                  } />
                  
                  <Route path="*" element={<NotFound />} />
                </Routes>
              </BrowserRouter>
            </FeatureGatesProvider>
          </PlanProvider>
        </AuthProvider>
      </TooltipProvider>
    </ThemeProvider>
  </QueryClientProvider>
);

export default App;