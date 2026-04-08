import { useState, useEffect, useMemo } from "react";
import { useNavigate } from "react-router-dom";
import {
  ArrowLeft, Shield, Crown, User, Loader2, Check, Search,
  Users, ChevronUp, ChevronDown, ExternalLink, RefreshCw,
  AlertTriangle, Package, Calendar, Phone, Store, Mail, BarChart3,
  Settings2, ToggleLeft, ToggleRight, CreditCard, Clock, CalendarCheck, CalendarX,
  X,
} from "lucide-react";
// 🚀 Usa a API centralizada (Django) em vez de Supabase direto
import { profileApi, adminApi } from "../lib/api"; 
import { useToast } from "../hooks/use-toast";
import { Badge } from "../components/ui/badge";
import {
  Table, TableHeader, TableBody, TableRow, TableHead, TableCell,
} from "../components/ui/table";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "../components/ui/tabs";

// Opcional: Se não tiver ConsultantAnalyticsView, ele não quebra a tela (foi ocultado)
// import ConsultantAnalyticsView from "../components/ConsultantAnalyticsView";

const ADMIN_SECRET = "natura2024admin";

export interface AdminUser {
  id: string | number;
  email: string;
  display_name: string | null;
  plan: string;
  store_slug: string | null;
  storefront_enabled: boolean;
  whatsapp_number: string | null;
  product_count: number;
  created_at: string;
  last_sign_in: string | null;
  subscription_started_at: string | null;
  subscription_expires_at: string | null;
  payment_provider: string | null;
  payment_external_id: string | null;
}

type SortField = "display_name" | "email" | "plan" | "product_count" | "created_at" | "last_sign_in";
type SortDir = "asc" | "desc";

export default function AdminPanel() {
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [authenticated, setAuthenticated] = useState(false);
  const [secret, setSecret] = useState("");
  
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [loading, setLoading] = useState(false);
  const [search, setSearch] = useState("");
  const [planFilter, setPlanFilter] = useState<"all" | "free" | "pro">("all");
  
  const [sortField, setSortField] = useState<SortField>("created_at");
  const [sortDir, setSortDir] = useState<SortDir>("desc");
  
  const [updatingId, setUpdatingId] = useState<string | number | null>(null);
  const [selectedUser, setSelectedUser] = useState<AdminUser | null>(null);
  
  const [showSubForm, setShowSubForm] = useState(false);
  const [subForm, setSubForm] = useState({ external_id: "", started_at: "", expires_at: "" });
  const [subSaving, setSubSaving] = useState(false);
  
  const [globalProvider, setGlobalProvider] = useState(() => localStorage.getItem("admin_global_provider") || "");
  
  // Excluídos estados complexos de Feature Gates (que dependiam de Functions) por enquanto
  // Deixado apenas a lógica de Usuários, focando no essencial do Django
  
  const PROVIDERS = [
    { value: "stripe", label: "Stripe" },
    { value: "mercadopago", label: "Mercado Pago" },
    { value: "manual", label: "Manual" },
  ];

  const fetchUsers = async () => {
    setLoading(true);
    try {
      // 🚀 Chama o Django (via api.ts)
      const res = await adminApi.listUsers(); 
      setUsers(res || []);
    } catch (err: any) {
      console.error(err);
      
      // Se o erro for 403 (ou mensagem de permissão), avisa o usuário
      if (err.message.includes("403") || err.message.includes("permissão") || err.message.includes("privilege")) {
        toast({ 
          title: "Acesso Negado (403)", 
          description: "Sua conta não tem privilégios de Administrador (is_staff) no Banco de Dados.", 
          variant: "destructive" 
        });
        // Volta a trancar a tela localmente
        setAuthenticated(false);
      } else {
        toast({ title: "Erro ao carregar usuários", description: err.message, variant: "destructive" });
      }
    } finally {
      setLoading(false);
    }
  };
  

  const togglePlan = async (user: AdminUser) => {
    const newPlan = user.plan === "pro" ? "free" : "pro";
    setUpdatingId(user.id);
    try {
      // 🚀 Chama o Django
      await adminApi.updatePlan(user.id, newPlan);
      
      setUsers((prev) => prev.map((u) => (u.id === user.id ? { ...u, plan: newPlan } : u)));
      toast({ title: `${user.display_name || user.email} → ${newPlan.toUpperCase()}` });
    } catch (err: any) {
      toast({ title: "Erro", description: "Falha ao mudar plano", variant: "destructive" });
    } finally {
      setUpdatingId(null);
    }
  };

  const saveSubscription = async (userId: string | number) => {
    setSubSaving(true);
    try {
      // 🚀 Chama o Django
      await adminApi.updateSubscription(userId, {
          provider: globalProvider,
          external_id: subForm.external_id || null,
          started_at: subForm.started_at || new Date().toISOString(),
          expires_at: subForm.expires_at || null,
          plan: "pro",
      });
      
      setUsers((prev) => prev.map((u) => u.id === userId ? {
        ...u,
        plan: "pro",
        subscription_started_at: subForm.started_at || new Date().toISOString(),
        subscription_expires_at: subForm.expires_at || null,
        payment_provider: globalProvider,
      } : u));
      
      setShowSubForm(false);
      toast({ title: "Assinatura atualizada" });
    } catch (err: any) {
      toast({ title: "Erro", description: "Falha ao salvar assinatura", variant: "destructive" });
    } finally {
      setSubSaving(false);
    }
  };

  useEffect(() => {
    if (authenticated) {
      fetchUsers();
    }
  }, [authenticated]);

  const filtered = useMemo(() => {
    let list = users;
    if (planFilter !== "all") list = list.filter((u) => u.plan === planFilter);
    if (search.trim()) {
      const q = search.toLowerCase();
      list = list.filter(
        (u) =>
          (u.display_name || "").toLowerCase().includes(q) ||
          u.email.toLowerCase().includes(q) ||
          (u.store_slug || "").toLowerCase().includes(q)
      );
    }
    list = [...list].sort((a, b) => {
      let va: any = a[sortField] || "";
      let vb: any = b[sortField] || "";
      if (typeof va === "number" && typeof vb === "number") return sortDir === "asc" ? va - vb : vb - va;
      return sortDir === "asc" ? String(va).localeCompare(String(vb)) : String(vb).localeCompare(String(va));
    });
    return list;
  }, [users, planFilter, search, sortField, sortDir]);

  const stats = useMemo(() => {
    return {
      total: users.length,
      pro: users.filter((u) => u.plan === "pro").length,
      free: users.filter((u) => u.plan === "free").length,
      incomplete: users.filter((u) => !u.display_name || !u.whatsapp_number).length,
    };
  }, [users]);

  const handleSort = (field: SortField) => {
    if (sortField === field) setSortDir((d) => (d === "asc" ? "desc" : "asc"));
    else { setSortField(field); setSortDir("asc"); }
  };

  const SortIcon = ({ field }: { field: SortField }) => {
    if (sortField !== field) return null;
    return sortDir === "asc" ? <ChevronUp className="h-3 w-3" /> : <ChevronDown className="h-3 w-3" />;
  };

  const formatDate = (d: string | null) => {
    if (!d) return "—";
    return new Date(d).toLocaleDateString("pt-BR");
  };

  if (!authenticated) {
    return (
      <div className="flex min-h-screen items-center justify-center bg-background p-4">
        <div className="w-full max-w-sm rounded-xl border border-border bg-card p-6 space-y-4">
          <div className="flex items-center gap-3">
            <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-destructive/10">
              <Shield className="h-5 w-5 text-destructive" />
            </div>
            <div>
              <h1 className="font-display text-lg font-bold text-foreground">Painel Admin</h1>
              <p className="text-xs text-muted-foreground">Acesso restrito</p>
            </div>
          </div>
          <input
            type="password"
            value={secret}
            onChange={(e) => setSecret(e.target.value)}
            onKeyDown={(e) => { if (e.key === "Enter" && secret === ADMIN_SECRET) setAuthenticated(true); }}
            placeholder="Senha admin"
            className="w-full rounded-lg border border-input px-3 py-2 text-sm outline-none focus:border-primary"
          />
          <button
            onClick={() => secret === ADMIN_SECRET ? setAuthenticated(true) : toast({ title: "Senha incorreta", variant: "destructive" })}
            className="w-full bg-primary text-white py-2 rounded-lg font-bold"
          >
            Entrar
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      <header className="sticky top-0 z-30 border-b border-border bg-card/95 backdrop-blur-sm">
        <div className="mx-auto flex max-w-6xl items-center gap-3 px-4 py-3">
          <button onClick={() => navigate("/")} className="rounded-lg p-2 text-muted-foreground hover:text-foreground">
            <ArrowLeft className="h-5 w-5" />
          </button>
          <Shield className="h-5 w-5 text-destructive" />
          <h1 className="font-display text-lg font-bold text-foreground">Admin: Assinaturas</h1>
          <div className="flex-1" />
          <button
            onClick={fetchUsers}
            disabled={loading}
            className="flex items-center gap-1.5 border rounded-lg px-3 py-1.5 text-xs font-medium"
          >
            <RefreshCw className={`h-3.5 w-3.5 ${loading ? "animate-spin" : ""}`} /> Atualizar
          </button>
        </div>
      </header>
      
      <main className="mx-auto max-w-6xl px-4 py-6 space-y-6">
        {/* Stats Cards */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          {[
            { label: "Usuários", value: stats.total, icon: Users, color: "text-primary" },
            { label: "Plano PRO", value: stats.pro, icon: Crown, color: "text-amber-500" },
            { label: "Plano Free", value: stats.free, icon: User, color: "text-gray-500" },
            { label: "Dados Incompletos", value: stats.incomplete, icon: AlertTriangle, color: "text-destructive" },
          ].map((s) => (
            <div key={s.label} className="rounded-xl border border-border bg-card p-4">
              <div className="flex items-center gap-2 mb-1">
                <s.icon className={`h-4 w-4 ${s.color}`} />
                <span className="text-xs text-muted-foreground">{s.label}</span>
              </div>
              <p className={`text-2xl font-bold ${s.color}`}>{s.value}</p>
            </div>
          ))}
        </div>

        {/* Search & Filter */}
        <div className="flex flex-col sm:flex-row gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Buscar por nome, email ou slug..."
              className="w-full rounded-lg border border-input pl-9 pr-3 py-2 text-sm outline-none focus:border-primary"
            />
          </div>
          <div className="flex gap-2">
            {(["all", "free", "pro"] as const).map((f) => (
              <button
                key={f}
                onClick={() => setPlanFilter(f)}
                className={`rounded-lg px-3 py-2 text-xs font-semibold ${
                  planFilter === f ? "bg-primary text-white" : "bg-secondary text-gray-600"
                }`}
              >
                {f.toUpperCase()}
              </button>
            ))}
          </div>
        </div>

        {/* Tabela de Usuários */}
        <div className="rounded-xl border border-border bg-card overflow-hidden">
          <Table>
            <TableHeader className="bg-secondary/20">
              <TableRow>
                <TableHead onClick={() => handleSort("display_name")} className="cursor-pointer">Usuário <SortIcon field="display_name" /></TableHead>
                <TableHead onClick={() => handleSort("plan")} className="cursor-pointer">Plano <SortIcon field="plan" /></TableHead>
                <TableHead onClick={() => handleSort("product_count")} className="cursor-pointer hidden md:table-cell">Produtos <SortIcon field="product_count" /></TableHead>
                <TableHead className="text-right">Ações</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {loading ? (
                <TableRow><TableCell colSpan={4} className="text-center py-10">Carregando...</TableCell></TableRow>
              ) : filtered.length === 0 ? (
                <TableRow><TableCell colSpan={4} className="text-center py-10">Nenhum usuário.</TableCell></TableRow>
              ) : (
                filtered.map((u) => (
                  <TableRow key={u.id} className="cursor-pointer hover:bg-secondary/30" onClick={() => setSelectedUser(u)}>
                    <TableCell>
                      <p className="font-medium text-sm text-foreground">{u.display_name || 'Sem nome'}</p>
                      <p className="text-xs text-muted-foreground">{u.email}</p>
                    </TableCell>
                    <TableCell>
                      <Badge variant={u.plan === "pro" ? "default" : "secondary"}>{u.plan.toUpperCase()}</Badge>
                    </TableCell>
                    <TableCell className="hidden md:table-cell">{u.product_count}</TableCell>
                    <TableCell className="text-right">
                      <button
                        onClick={(e) => { e.stopPropagation(); togglePlan(u); }}
                        className={`text-xs px-3 py-1 rounded-full font-bold transition-colors ${u.plan === 'pro' ? 'bg-destructive/10 text-destructive' : 'bg-primary/10 text-primary'}`}
                      >
                        {u.plan === 'pro' ? 'Rebaixar' : 'Virar PRO'}
                      </button>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </div>

        {/* Detalhe do Usuário (Mostra ao clicar na linha) */}
        {selectedUser && (
          <div className="p-5 bg-card border rounded-xl shadow-lg animate-in slide-in-from-bottom-5 mt-4">
            <div className="flex justify-between items-center mb-4 border-b pb-2">
              <h3 className="font-bold text-lg flex items-center gap-2">
                <User className="h-5 w-5 text-primary"/> 
                Detalhes: {selectedUser.display_name || selectedUser.email}
              </h3>
              <button onClick={() => setSelectedUser(null)} className="p-2 hover:bg-secondary rounded-lg transition-colors"><X className="text-muted-foreground"/></button>
            </div>

            <div className="grid grid-cols-2 md:grid-cols-4 gap-6 text-sm mb-6">
              <div><p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Email</p><p className="font-medium">{selectedUser.email}</p></div>
              <div><p className="text-muted-foreground text-xs font-semibold uppercase mb-1">WhatsApp</p><p className="font-medium">{selectedUser.whatsapp_number || 'Não informado'}</p></div>
              <div><p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Vitrine</p><p className="font-medium">{selectedUser.store_slug || 'Não criada'}</p></div>
              <div><p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Conta criada em</p><p className="font-medium">{formatDate(selectedUser.created_at)}</p></div>
            </div>

            <div className="bg-secondary/20 p-4 rounded-xl border border-border">
              <h4 className="font-semibold mb-3 flex items-center gap-2"><CreditCard className="h-4 w-4"/> Assinatura Atual</h4>
              <div className="flex gap-4">
                 <div><p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Gateway</p><p className="font-medium capitalize">{selectedUser.payment_provider || 'Nenhum'}</p></div>
                 <div><p className="text-muted-foreground text-xs font-semibold uppercase mb-1">Expira em</p><p className="font-medium">{formatDate(selectedUser.subscription_expires_at)}</p></div>
              </div>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}