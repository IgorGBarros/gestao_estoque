// pages/ApiDevAuth.tsx
//
// Login/cadastro do produto de API — completamente separado de /auth (que
// é da consultora). Ninguém que loga aqui vira consultora, e vice-versa.
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, Loader2, Eye, EyeOff, Copy, Check } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from '../components/ui/use-toast'; // ✅ Importar useToast original para evitar dependência circular
import { devApi, setDevTokens } from "../lib/devApi";

export default function ApiDevAuth() {
  const navigate = useNavigate();
  const { toast } = useToast();
  const [modo, setModo] = useState<"login" | "cadastro">("login");
  const [carregando, setCarregando] = useState(false);
  const [mostrarSenha, setMostrarSenha] = useState(false);

  const [email, setEmail] = useState("");
  const [senha, setSenha] = useState("");
  const [nome, setNome] = useState("");
  const [empresa, setEmpresa] = useState("");

  // Depois do cadastro, a chave completa só aparece UMA VEZ — este estado
  // segura ela na tela até a pessoa confirmar que copiou.
  const [chaveGerada, setChaveGerada] = useState<string | null>(null);
  const [copiada, setCopiada] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setCarregando(true);
    try {
      if (modo === "login") {
        const res = await devApi.login({ email, password: senha });
        setDevTokens(res.access, res.refresh);
        navigate("/api/dashboard");
      } else {
        const res = await devApi.register({ email, password: senha, name: nome, company_name: empresa });
        setDevTokens(res.access, res.refresh);
        setChaveGerada(res.api_key); // segura na tela antes de navegar
      }
    } catch (err: any) {
      toast({ title: "Erro", description: err.message || "Tente novamente.", variant: "destructive" });
    } finally {
      setCarregando(false);
    }
  };

  const copiarChave = () => {
    if (!chaveGerada) return;
    navigator.clipboard.writeText(chaveGerada);
    setCopiada(true);
    setTimeout(() => setCopiada(false), 2000);
  };

  // 🔑 Tela intermediária: mostra a chave uma única vez antes de seguir pro
  // painel. Sem isso, ela sairia do cadastro sem nunca ter visto a chave
  // completa (dali em diante, só o prefixo aparece).
  if (chaveGerada) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background p-4">
        <div className="w-full max-w-md rounded-2xl border border-border bg-card p-6">
          <h1 className="font-display text-lg font-bold text-foreground">Conta criada! 🎉</h1>
          <p className="mt-1 text-sm text-muted-foreground">
            Esta é a única vez que sua chave completa aparece. Guarde agora — depois só o prefixo fica visível.
          </p>
          <div className="mt-4 flex items-center gap-2 rounded-lg border border-border bg-secondary/30 p-3">
            <code className="flex-1 overflow-x-auto text-xs">{chaveGerada}</code>
            <button onClick={copiarChave} className="shrink-0 rounded-lg p-1.5 hover:bg-secondary" title="Copiar">
              {copiada ? <Check className="h-4 w-4 text-success" /> : <Copy className="h-4 w-4" />}
            </button>
          </div>
          <Button className="mt-5 w-full" onClick={() => navigate("/api/dashboard")}>
            Já guardei, ir para o painel
          </Button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <div className="w-full max-w-md">
        <button
          onClick={() => navigate("/api")}
          className="mb-4 flex items-center gap-1.5 text-sm text-muted-foreground hover:text-foreground"
        >
          <ArrowLeft className="h-4 w-4" /> Voltar
        </button>

        <div className="rounded-2xl border border-border bg-card p-6">
          <h1 className="font-display text-xl font-bold text-foreground">
            {modo === "login" ? "Entrar" : "Criar conta de desenvolvedor"}
          </h1>
          <p className="mt-1 text-sm text-muted-foreground">
            {modo === "login" ? "Acesse seu painel de API." : "Ganhe uma chave gratuita na hora."}
          </p>

          <form onSubmit={handleSubmit} className="mt-5 space-y-4">
            {modo === "cadastro" && (
              <>
                <div className="space-y-1.5">
                  <Label htmlFor="nome">Nome</Label>
                  <Input id="nome" value={nome} onChange={(e) => setNome(e.target.value)} required />
                </div>
                <div className="space-y-1.5">
                  <Label htmlFor="empresa">Empresa (opcional)</Label>
                  <Input id="empresa" value={empresa} onChange={(e) => setEmpresa(e.target.value)} />
                </div>
              </>
            )}
            <div className="space-y-1.5">
              <Label htmlFor="email">E-mail</Label>
              <Input id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required />
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="senha">Senha</Label>
              <div className="relative">
                <Input
                  id="senha"
                  type={mostrarSenha ? "text" : "password"}
                  value={senha}
                  onChange={(e) => setSenha(e.target.value)}
                  required
                  minLength={modo === "cadastro" ? 8 : undefined}
                />
                <button
                  type="button"
                  onClick={() => setMostrarSenha((v) => !v)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground"
                >
                  {mostrarSenha ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                </button>
              </div>
              {modo === "cadastro" && (
                <p className="text-xs text-muted-foreground">Mínimo 8 caracteres.</p>
              )}
            </div>

            <Button type="submit" className="w-full" disabled={carregando}>
              {carregando ? <Loader2 className="h-4 w-4 animate-spin" /> : modo === "login" ? "Entrar" : "Criar conta"}
            </Button>
          </form>

          <button
            onClick={() => setModo(modo === "login" ? "cadastro" : "login")}
            className="mt-4 w-full text-center text-sm text-muted-foreground hover:text-foreground"
          >
            {modo === "login" ? "Não tem conta? Cadastre-se" : "Já tem conta? Entrar"}
          </button>
        </div>
      </div>
    </div>
  );
}