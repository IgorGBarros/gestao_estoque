import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Package, Mail, Lock, User, Loader2, Eye, EyeOff, Shield, X } from "lucide-react";
import { AnimatePresence, motion } from "framer-motion";
import { useAuth } from "../hooks/useAuth";
import { usePlan } from "../hooks/usePlan";
import { useToast } from "../hooks/use-toast"; // ✅ Importar useToast original para evitar dependência circular
import { api } from "../services/api";

export default function Auth() {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [showAdminModal, setShowAdminModal] = useState(false);
  const [adminSecret, setAdminSecret] = useState("");
  const { toast } = useToast();
  const navigate = useNavigate();
  const { signIn, signUp, signInWithGoogle, signInDemo } = useAuth();
  const { setAdminOverride } = usePlan();

  const handleAdminAccess = () => {
    if (adminSecret === "natura2024admin") {
      signInDemo();
      setAdminOverride(true);
      setShowAdminModal(false);
      setAdminSecret("");
      toast({ title: "🔓 Acesso Admin PRO ativado!" });
      navigate("/");
    } else {
      toast({ title: "Senha incorreta", variant: "destructive" });
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      if (isLogin) {
        await signIn(email, password);
        navigate("/");
      } else {
          await api.post("/auth/register/", {
          username: email, 
          email: email,
          password: password,
          first_name: name,
        });
        toast({ title: "Conta criada!", description: "Bem-vindo ao sistema." });
        navigate("/");
      }
    } catch (err: any) {
      toast({
        title: "Erro",
        description: err.message || "Falha na autenticação",
        variant: "destructive",
      });
    } finally {
      setLoading(false);
    }
  };

  const handleGoogleSignIn = async () => {
    setGoogleLoading(true);
    try {
      await signInWithGoogle();
      navigate("/");
    } catch (err: any) {
      toast({
        title: "Erro no Google Sign-In",
        description: err.message || "Falha ao entrar com Google",
        variant: "destructive",
      });
    } finally {
      setGoogleLoading(false);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4">
      <div className="w-full max-w-sm space-y-6">
        {/* Logo */}
        <div className="flex flex-col items-center gap-2">
          <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-primary">
            <Package className="h-7 w-7 text-primary-foreground" />
          </div>
          <h1 className="font-display text-xl font-bold text-foreground">Estoque Natura</h1>
          <p className="text-sm text-muted-foreground">
            {isLogin ? "Entre na sua conta" : "Crie sua conta"}
          </p>
        </div>

        {/* Google Sign-In */}
        <button
          type="button"
          onClick={handleGoogleSignIn}
          disabled={googleLoading}
          className="flex w-full items-center justify-center gap-3 rounded-xl border border-input bg-background py-3 text-sm font-medium text-foreground transition-colors hover:bg-muted disabled:opacity-50"
        >
          {googleLoading ? (
            <Loader2 className="h-4 w-4 animate-spin" />
          ) : (
            <svg className="h-5 w-5" viewBox="0 0 24 24">
              <path
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"
                fill="#4285F4"
              />
              <path
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                fill="#34A853"
              />
              <path
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                fill="#FBBC05"
              />
              <path
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                fill="#EA4335"
              />
            </svg>
          )}
          Continuar com Google
        </button>

        {/* Divider */}
        <div className="relative">
          <div className="absolute inset-0 flex items-center">
            <span className="w-full border-t border-border" />
          </div>
          <div className="relative flex justify-center text-xs uppercase">
            <span className="bg-background px-2 text-muted-foreground">ou</span>
          </div>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          {!isLogin && (
            <div className="relative">
              <User className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Seu nome"
                required={!isLogin}
                className="w-full rounded-xl border border-input bg-background py-3 pl-10 pr-4 text-sm outline-none focus:border-primary focus:ring-1 focus:ring-primary/20"
              />
            </div>
          )}
          <div className="relative">
            <Mail className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Email"
              required
              className="w-full rounded-xl border border-input bg-background py-3 pl-10 pr-4 text-sm outline-none focus:border-primary focus:ring-1 focus:ring-primary/20"
            />
          </div>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
            <input
              type={showPassword ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Senha"
              required
              minLength={6}
              className="w-full rounded-xl border border-input bg-background py-3 pl-10 pr-10 text-sm outline-none focus:border-primary focus:ring-1 focus:ring-primary/20"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground"
            >
              {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
            </button>
          </div>

          <button
            type="submit"
            disabled={loading}
            className="flex w-full items-center justify-center gap-2 rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90 disabled:opacity-50"
          >
            {loading && <Loader2 className="h-4 w-4 animate-spin" />}
            {isLogin ? "Entrar" : "Criar Conta"}
          </button>
        </form>

        {/* Demo Login */}
        <button
          type="button"
          onClick={() => { signInDemo(); navigate("/"); }}
          className="flex w-full items-center justify-center gap-2 rounded-xl border border-dashed border-muted-foreground/40 py-3 text-sm text-muted-foreground transition-colors hover:bg-muted"
        >
          🧪 Entrar com conta teste
        </button>

        <p className="text-center text-sm text-muted-foreground">
          {isLogin ? "Não tem conta?" : "Já tem conta?"}{" "}
          <button
            onClick={() => setIsLogin(!isLogin)}
            className="font-medium text-primary hover:underline"
          >
            {isLogin ? "Criar conta" : "Fazer login"}
          </button>
        </p>

        {/* Admin link */}
        <button
          onClick={() => setShowAdminModal(true)}
          className="mt-2 w-full text-center text-[10px] text-muted-foreground/30 hover:text-muted-foreground transition-colors"
        >
          ⚙️ Admin
        </button>
      </div>

      {/* Admin Modal */}
      <AnimatePresence>
        {showAdminModal && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4"
            onClick={() => setShowAdminModal(false)}
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="w-full max-w-sm rounded-2xl border border-border bg-card overflow-hidden"
              onClick={(e) => e.stopPropagation()}
            >
              {/* Header */}
              <div className="flex items-center justify-between border-b border-border px-5 py-4">
                <div className="flex items-center gap-3">
                  <div className="flex h-9 w-9 items-center justify-center rounded-lg bg-destructive/10">
                    <Shield className="h-4 w-4 text-destructive" />
                  </div>
                  <div>
                    <h2 className="font-display text-sm font-bold text-foreground">Acesso ao Sistema</h2>
                    <p className="text-[10px] text-muted-foreground">Painel administrativo</p>
                  </div>
                </div>
                <button onClick={() => setShowAdminModal(false)} className="rounded-lg p-1.5 text-muted-foreground hover:text-foreground hover:bg-secondary">
                  <X className="h-4 w-4" />
                </button>
              </div>

              {/* Body */}
              <div className="px-5 py-5 space-y-4">
                <div>
                  <label className="text-xs font-medium text-muted-foreground">Senha de acesso</label>
                  <div className="relative mt-1.5">
                    <Lock className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
                    <input
                      type="password"
                      value={adminSecret}
                      onChange={(e) => setAdminSecret(e.target.value)}
                      onKeyDown={(e) => { if (e.key === "Enter") handleAdminAccess(); }}
                      placeholder="••••••••••"
                      className="w-full rounded-lg border border-input bg-background py-2.5 pl-10 pr-4 text-sm outline-none focus:border-primary focus:ring-1 focus:ring-primary/20"
                      autoFocus
                    />
                  </div>
                </div>

                <button
                  onClick={handleAdminAccess}
                  className="flex w-full items-center justify-center gap-2 rounded-xl bg-primary py-3 text-sm font-semibold text-primary-foreground transition-opacity hover:opacity-90"
                >
                  <Shield className="h-4 w-4" /> Acessar com PRO
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
