// pages/Auth.tsx — VERSÃO REFATORADA COM TEMA DINÂMICO
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Mail, Lock, User, Loader2, Eye, EyeOff } from "lucide-react";
import { useAuth } from "../hooks/useAuth";
import { useToast } from "../hooks/use-toast";
import logoMinhaAmora from "../assets/logo-minhaamora.png";

export default function Auth() {
  const [isLogin, setIsLogin] = useState(true);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const { toast } = useToast();
  const navigate = useNavigate();
  const { signIn, signUp, signInWithGoogle } = useAuth();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      if (isLogin) {
        await signIn(email, password);
        navigate("/");
      } else {
        await signUp(email, password, name);
        toast({ title: "Conta criada!", description: "Bem-vindo ao Minha Amora 🍇" });
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
    <div className="flex min-h-screen items-center justify-center bg-brand-soft px-4">
      <div className="w-full max-w-sm space-y-6">
        {/* ─── Logo + Branding ─── */}
        <div className="flex flex-col items-center gap-3">
          <img
            src={logoMinhaAmora}
            alt="Minha Amora"
            className="h-20 w-20 rounded-2xl object-contain shadow-md"
          />
          <div className="text-center">
            <h1 className="font-display text-2xl font-bold text-foreground">
              Minha Amora
            </h1>
            <p className="mt-1 text-sm text-muted-foreground">
              {isLogin ? "Entre na sua conta" : "Crie sua conta gratuita"}
            </p>
          </div>
        </div>

        {/* ─── Google Sign-In ─── */}
        <button
          type="button"
          onClick={handleGoogleSignIn}
          disabled={googleLoading}
          className="flex w-full items-center justify-center gap-3 rounded-xl border border-border bg-white py-3 text-sm font-medium text-foreground shadow-sm transition-all hover:shadow-md active:scale-[0.98] disabled:opacity-50"
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

        {/* ─── Divider ─── */}
        <div className="relative">
          <div className="absolute inset-0 flex items-center">
            <span className="w-full border-t border-border" />
          </div>
          <div className="relative flex justify-center text-xs uppercase">
            <span className="bg-brand-soft px-2 text-muted-foreground">ou</span>
          </div>
        </div>

        {/* ─── Form ─── */}
        <form onSubmit={handleSubmit} className="space-y-4">
          {!isLogin && (
            <div className="relative">
              <User className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-brand/50" />
              <input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Seu nome"
                required={!isLogin}
                className="w-full rounded-xl border border-brand/15 bg-white py-3 pl-10 pr-4 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:border-brand focus:ring-2 focus:ring-brand/20"
              />
            </div>
          )}

          <div className="relative">
            <Mail className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-brand/50" />
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Email"
              required
              className="w-full rounded-xl border border-brand/15 bg-white py-3 pl-10 pr-4 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:border-brand focus:ring-2 focus:ring-brand/20"
            />
          </div>

          <div className="relative">
            <Lock className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-brand/50" />
            <input
              type={showPassword ? "text" : "password"}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Senha"
              required
              minLength={6}
              className="w-full rounded-xl border border-brand/15 bg-white py-3 pl-10 pr-10 text-sm text-foreground outline-none placeholder:text-muted-foreground focus:border-brand focus:ring-2 focus:ring-brand/20"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-brand"
            >
              {showPassword ? (
                <EyeOff className="h-4 w-4" />
              ) : (
                <Eye className="h-4 w-4" />
              )}
            </button>
          </div>

          {/* ─── Botão Principal ─── */}
          <button
            type="submit"
            disabled={loading}
            className="flex w-full items-center justify-center gap-2 rounded-xl bg-brand py-3 text-sm font-bold text-white shadow-lg shadow-brand/25 transition-all hover:opacity-90 hover:shadow-brand/40 active:scale-[0.98] disabled:opacity-50"
          >
            {loading && <Loader2 className="h-4 w-4 animate-spin" />}
            {isLogin ? "Entrar" : "Criar Conta"}
          </button>
        </form>

        {/* ─── Toggle Login/Cadastro ─── */}
        <p className="text-center text-sm text-muted-foreground">
          {isLogin ? "Não tem conta?" : "Já tem conta?"}{" "}
          <button
            onClick={() => setIsLogin(!isLogin)}
            className="font-semibold text-brand hover:underline"
          >
            {isLogin ? "Criar conta" : "Fazer login"}
          </button>
        </p>

        {/* ─── Footer sutil ─── */}
        <p className="text-center text-[10px] text-muted-foreground/50">
          100% gratuito para começar · Sem cartão de crédito
        </p>
      </div>
    </div>
  );
}