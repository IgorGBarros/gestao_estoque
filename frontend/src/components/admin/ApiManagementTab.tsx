// src/components/admin/ApiManagementTab.tsx
import { useState } from "react";
import {
  Server, Key, Activity, Bell, Plus, FileText, BarChart3, RefreshCw, Ban,
  ToggleLeft, ToggleRight, Lock, Shield, Check, CreditCard, DollarSign, Copy, X
} from "lucide-react";
import { Badge } from "../ui/badge";
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from "../ui/table";

// ─────────────────────────────────────────────────────────────
// INTERFACES
// ─────────────────────────────────────────────────────────────

export interface ApiKey {
  id: string;
  name: string;
  key_prefix: string;
  client_name?: string;
  plan: "starter" | "pro" | "enterprise";
  scopes: string[];
  rate_limit: number;
  monthly_quota: number;
  last_used: string | null;
  is_active: boolean;
}

export interface Webhook {
  id: string;
  name: string;
  url: string;
  events: string[];
  active: boolean;
  stats: { delivered_24h: number; failed_24h: number; avg_latency_ms: number };
  last_delivery?: { event: string; payload: any };
}

export interface Endpoint {
  path: string;
  method: "GET" | "POST" | "PUT" | "DELETE" | "PATCH";
  description: string;
  auth: string;
  rate_limit: string;
  pricing_tier: string[];
  lgpd?: boolean;
  sample: any;
}

export interface PricingTier {
  tier: string;
  price: string;
  quota: string;
  rate_limit: string;
  features: string[];
  cta: string;
  popular: boolean;
  lgpd?: boolean;
}

export interface Props {
  formatCurrency: (n: number) => string;
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

// ─────────────────────────────────────────────────────────────
// DADOS INICIAIS (MOCK — serão substituídos por API real depois)
// ─────────────────────────────────────────────────────────────

const SEED_KEYS: ApiKey[] = [
  {
    id: "1", name: "Beauty Insights Co.", key_prefix: "pk_live_a8f2c91",
    client_name: "Beauty Insights LTDA", plan: "enterprise",
    scopes: ["read:products", "read:analytics", "write:webhooks"],
    rate_limit: 500, monthly_quota: 1000000,
    last_used: new Date(Date.now() - 1000 * 60 * 12).toISOString(), is_active: true,
  },
  {
    id: "2", name: "App Consultora Pro", key_prefix: "pk_live_b3d7e44",
    client_name: "ConsultoraApp", plan: "pro",
    scopes: ["read:products"],
    rate_limit: 100, monthly_quota: 50000,
    last_used: new Date(Date.now() - 1000 * 60 * 60 * 3).toISOString(), is_active: true,
  },
  {
    id: "3", name: "Dev Sandbox", key_prefix: "pk_test_c9a1f08",
    plan: "starter", scopes: ["read:products"],
    rate_limit: 20, monthly_quota: 1000,
    last_used: null, is_active: true,
  },
];

const SEED_WEBHOOKS: Webhook[] = [
  {
    id: "wh_1", name: "Atualizações de Preço",
    url: "https://api.beautyinsights.com/hooks/natura-prices",
    events: ["price.changed", "product.updated"], active: true,
    stats: { delivered_24h: 1284, failed_24h: 3, avg_latency_ms: 142 },
    last_delivery: { event: "price.changed", payload: { product_id: "abc123", old: 89.9, new: 92.5 } },
  },
  {
    id: "wh_2", name: "Comportamento Anônimo",
    url: "https://analytics.consultoraapp.com/ingest",
    events: ["consultant.anonymized_behavior"], active: false,
    stats: { delivered_24h: 0, failed_24h: 0, avg_latency_ms: 0 },
  },
];

const ENDPOINTS: Endpoint[] = [
  // Catálogo Global
  {
    path: "/api/products/", method: "GET",
    description: "Lista o catálogo global de produtos (Natura, marcas)",
    auth: "API Key", rate_limit: "100 req/min",
    pricing_tier: ["starter", "pro", "enterprise"],
    sample: [{ id: 1, name: "Perfume Kaiak", brand: "Natura", official_price: 89.9, barcode: "7891234567890" }],
  },
  {
    path: "/api/products/lookup/?barcode={barcode}", method: "GET",
    description: "Lookup híbrido por barcode (local → scraper → fuzzy match)",
    auth: "API Key", rate_limit: "200 req/min",
    pricing_tier: ["starter", "pro", "enterprise"],
    sample: { source: "local", product: { id: 12, name: "Tododia Algodão", official_price: 45.9 } },
  },
  // Storefront Pública
  {
    path: "/api/public/storefront/{slug}/", method: "GET",
    description: "Vitrine pública de uma consultora (sem datas de validade)",
    auth: "Público", rate_limit: "60 req/min",
    pricing_tier: ["starter", "pro", "enterprise"],
    sample: [{ product_name: "Lily Eau de Parfum", sale_price: 199.9, image_url: "..." }],
  },
  {
    path: "/api/public/storefront/{slug}/marca/{brand}/", method: "GET",
    description: "Vitrine pública filtrada por marca",
    auth: "Público", rate_limit: "60 req/min",
    pricing_tier: ["starter", "pro", "enterprise"],
    sample: [{ product_name: "Kaiak Aero", brand: "Natura", sale_price: 129.9 }],
  },
  // Analytics Agregados (Enterprise)
  {
    path: "/api/admin/analytics/products/", method: "GET",
    description: "Analytics agregado de produtos: top vendidos, marcas, categorias",
    auth: "API Key + Scope", rate_limit: "50 req/min",
    pricing_tier: ["pro", "enterprise"],
    sample: { top_brands: [{ brand: "Natura", units: 12480, avg_price: 78.5 }] },
  },
  {
    path: "/api/admin/analytics/behavior/", method: "GET",
    description: "Comportamento agregado de lojas (anonimizado, sem PII)",
    auth: "API Key + Scope", rate_limit: "50 req/min",
    pricing_tier: ["enterprise"], lgpd: true,
    sample: { avg_products_per_store: 18.3, avg_monthly_revenue: 2840 },
  },
  // Webhooks
  {
    path: "webhook → product.updated", method: "POST",
    description: "Notifica alterações de preço/estoque de produtos do catálogo",
    auth: "Webhook Secret", rate_limit: "ilimitado",
    pricing_tier: ["pro", "enterprise"],
    sample: { event: "product.updated", product_id: 12, new_price: 49.9, changed_at: "2026-05-13T10:00:00Z" },
  },
];

const PRICING_TIERS: PricingTier[] = [
  {
    tier: "starter", price: "Grátis", quota: "1.000 req/mês", rate_limit: "20 req/min",
    features: ["Busca básica de produtos", "Dados públicos apenas", "Suporte por e-mail"],
    cta: "Disponibilizar", popular: false,
  },
  {
    tier: "pro", price: "R$ 199/mês", quota: "50.000 req/mês", rate_limit: "100 req/min",
    features: ["Preços atualizados", "Webhooks", "Analytics básico", "Suporte prioritário"],
    cta: "Mais Popular", popular: true,
  },
  {
    tier: "enterprise", price: "Sob consulta", quota: "Ilimitado", rate_limit: "500+ req/min",
    features: ["Comportamento anonimizado", "SLA 99.99%", "Suporte dedicado", "Endpoints custom"],
    cta: "Falar com Vendas", popular: false, lgpd: true,
  },
];

// ─────────────────────────────────────────────────────────────
// UTILITÁRIOS
// ─────────────────────────────────────────────────────────────

function timeAgo(iso: string | null): string {
  if (!iso) return "Nunca";
  const diff = Date.now() - new Date(iso).getTime();
  const min = Math.floor(diff / 60000);
  if (min < 1) return "agora";
  if (min < 60) return `${min}min atrás`;
  const h = Math.floor(min / 60);
  if (h < 24) return `${h}h atrás`;
  return `${Math.floor(h / 24)}d atrás`;
}

function generateSecret(): string {
  return "pk_live_" + Array.from({ length: 32 }, () => 
    Math.random().toString(36).charAt(2)
  ).join("");
}

// ─────────────────────────────────────────────────────────────
// COMPONENTE PRINCIPAL
// ─────────────────────────────────────────────────────────────

export default function ApiManagementTab({ formatCurrency, toast }: Props) {
  const [apiKeys, setApiKeys] = useState<ApiKey[]>(SEED_KEYS);
  const [webhooks, setWebhooks] = useState<Webhook[]>(SEED_WEBHOOKS);
  
  // Modals
  const [showKeyModal, setShowKeyModal] = useState(false);
  const [showWebhookModal, setShowWebhookModal] = useState(false);
  
  // Form states
  const [newKey, setNewKey] = useState({ name: "", client: "", plan: "starter" as ApiKey["plan"] });
  const [newWebhook, setNewWebhook] = useState({ name: "", url: "", events: ["price.changed"] as string[] });
  const [createdSecret, setCreatedSecret] = useState<string | null>(null);

  // ── Handlers ──

  const handleCreateKey = () => {
    if (!newKey.name) {
      toast({ title: "Nome obrigatório", variant: "destructive" });
      return;
    }
    const secret = generateSecret();
    const scopes = newKey.plan === "enterprise"
      ? ["read:products", "read:analytics", "write:webhooks"]
      : newKey.plan === "pro" ? ["read:products", "write:webhooks"] : ["read:products"];
    
    const key: ApiKey = {
      id: String(Date.now()),
      name: newKey.name,
      client_name: newKey.client || undefined,
      key_prefix: secret.slice(0, 16),
      plan: newKey.plan,
      scopes,
      rate_limit: newKey.plan === "enterprise" ? 500 : newKey.plan === "pro" ? 100 : 20,
      monthly_quota: newKey.plan === "enterprise" ? 1000000 : newKey.plan === "pro" ? 50000 : 1000,
      last_used: null,
      is_active: true,
    };
    
    setApiKeys([key, ...apiKeys]);
    setCreatedSecret(secret);
    toast({ title: "API Key criada", description: "Copie a chave agora — ela não será exibida novamente." });
  };

  const handleRotate = (id: string) => {
    setApiKeys(apiKeys.map(k => 
      k.id === id ? { ...k, key_prefix: generateSecret().slice(0, 16) } : k
    ));
    toast({ title: "Chave rotacionada com sucesso" });
  };

  const handleRevoke = (id: string) => {
    if (!confirm("Revogar acesso? Esta ação é imediata.")) return;
    setApiKeys(apiKeys.filter(k => k.id !== id));
    toast({ title: "Chave revogada", variant: "destructive" });
  };

  const toggleWebhook = (id: string) => {
    setWebhooks(webhooks.map(w => w.id === id ? { ...w, active: !w.active } : w));
  };

  const handleCreateWebhook = () => {
    if (!newWebhook.name || !newWebhook.url) {
      toast({ title: "Nome e URL obrigatórios", variant: "destructive" });
      return;
    }
    const webhook: Webhook = {
      id: "wh_" + Date.now(),
      name: newWebhook.name,
      url: newWebhook.url,
      events: newWebhook.events,
      active: true,
      stats: { delivered_24h: 0, failed_24h: 0, avg_latency_ms: 0 },
    };
    setWebhooks([...webhooks, webhook]);
    setNewWebhook({ name: "", url: "", events: ["price.changed"] });
    setShowWebhookModal(false);
    toast({ title: "Webhook criado" });
  };

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    toast({ title: "Copiado!", description: "Chave copiada para a área de transferência" });
  };

  // ── Render ──

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold flex items-center gap-2">
            <Server className="h-6 w-6 text-primary" />
            API Comercial
          </h2>
          <p className="text-muted-foreground">
            Monetize o banco de dados de produtos com acesso programático
          </p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => { setCreatedSecret(null); setShowKeyModal(true); }}
            className="flex items-center gap-2 bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:bg-primary/90"
          >
            <Plus className="h-4 w-4" /> Nova API Key
          </button>
          <button className="flex items-center gap-2 border border-border px-4 py-2 rounded-lg hover:bg-secondary">
            <FileText className="h-4 w-4" /> Documentação
          </button>
        </div>
      </div>

      {/* Overview Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: "Receita API (MRR)", value: formatCurrency(1240), change: "+18% vs mês anterior", icon: DollarSign, color: "text-emerald-600" },
          { label: "Chaves Ativas", value: String(apiKeys.length), change: `${new Set(apiKeys.map(k => k.client_name).filter(Boolean)).size} empresas`, icon: Key, color: "text-blue-600" },
          { label: "Requisições (30d)", value: "847.2K", change: "99.97% uptime", icon: Activity, color: "text-purple-600" },
          { label: "Webhooks Entregues", value: "98.4%", change: "0.2s latência média", icon: Bell, color: "text-amber-600" },
        ].map((s, i) => (
          <div key={i} className="rounded-xl border border-border bg-card p-4">
            <div className="flex items-center gap-2 mb-2">
              <s.icon className={`h-4 w-4 ${s.color}`} />
              <span className="text-xs text-muted-foreground font-medium">{s.label}</span>
            </div>
            <p className={`text-2xl font-bold ${s.color}`}>{s.value}</p>
            <p className="text-xs text-muted-foreground mt-1">{s.change}</p>
          </div>
        ))}
      </div>

      {/* API Keys Table */}
      <div className="rounded-xl border border-border bg-card overflow-hidden">
        <div className="flex justify-between items-center p-4 border-b border-border">
          <h3 className="font-semibold flex items-center gap-2">
            <Key className="h-5 w-5 text-primary" /> Chaves de API Ativas
          </h3>
          <Badge variant="outline">{apiKeys.length} chaves</Badge>
        </div>
        <Table>
          <TableHeader className="bg-secondary/20">
            <TableRow>
              <TableHead>Nome / Cliente</TableHead>
              <TableHead>Plano / Limites</TableHead>
              <TableHead className="hidden md:table-cell">Scopes</TableHead>
              <TableHead className="hidden md:table-cell">Último Uso</TableHead>
              <TableHead className="text-right">Ações</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {apiKeys.map((key) => (
              <TableRow key={key.id}>
                <TableCell>
                  <p className="font-medium text-sm">{key.name}</p>
                  <p className="text-xs text-muted-foreground font-mono">{key.key_prefix}••••••••</p>
                  {key.client_name && <p className="text-xs text-primary mt-1">{key.client_name}</p>}
                </TableCell>
                <TableCell>
                  <Badge variant={key.plan === "enterprise" ? "default" : "secondary"} className="text-xs">
                    {key.plan.toUpperCase()}
                  </Badge>
                  <p className="text-xs text-muted-foreground mt-1">
                    {key.rate_limit} req/min • {key.monthly_quota.toLocaleString()}/mês
                  </p>
                </TableCell>
                <TableCell className="hidden md:table-cell">
                  <div className="flex flex-wrap gap-1">
                    {key.scopes.map(scope => (
                      <Badge key={scope} variant="outline" className="text-[10px]">{scope}</Badge>
                    ))}
                  </div>
                </TableCell>
                <TableCell className="hidden md:table-cell text-xs text-muted-foreground">
                  {timeAgo(key.last_used)}
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex items-center justify-end gap-1">
                    <button onClick={() => toast({ title: "Analytics em breve" })}
                      className="p-1.5 hover:bg-secondary rounded transition-colors" title="Ver uso">
                      <BarChart3 className="h-4 w-4" />
                    </button>
                    <button onClick={() => handleRotate(key.id)}
                      className="p-1.5 hover:bg-secondary rounded transition-colors" title="Rotacionar">
                      <RefreshCw className="h-4 w-4" />
                    </button>
                    <button onClick={() => handleRevoke(key.id)}
                      className="p-1.5 text-destructive hover:bg-destructive/10 rounded transition-colors" title="Revogar">
                      <Ban className="h-4 w-4" />
                    </button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {/* Webhooks Section */}
      <div className="rounded-xl border border-border bg-card p-6">
        <div className="flex justify-between items-center mb-4">
          <h3 className="font-semibold flex items-center gap-2">
            <Bell className="h-5 w-5 text-primary" /> Webhooks Ativos
          </h3>
          <button onClick={() => setShowWebhookModal(true)}
            className="text-sm text-primary hover:underline flex items-center gap-1">
            <Plus className="h-4 w-4" /> Novo Webhook
          </button>
        </div>
        <div className="space-y-3">
          {webhooks.map(w => (
            <div key={w.id} className="p-4 border border-border rounded-lg hover:border-primary/50 transition-colors">
              <div className="flex justify-between items-start mb-3">
                <div className="min-w-0 flex-1">
                  <p className="font-medium text-sm">{w.name}</p>
                  <p className="text-xs text-muted-foreground font-mono break-all">{w.url}</p>
                </div>
                <div className="flex items-center gap-2 ml-2">
                  <Badge variant={w.active ? "default" : "secondary"} className="text-xs">
                    {w.active ? "Ativo" : "Inativo"}
                  </Badge>
                  <button onClick={() => toggleWebhook(w.id)} className="p-1 hover:bg-secondary rounded transition-colors">
                    {w.active ? <ToggleRight className="h-4 w-4" /> : <ToggleLeft className="h-4 w-4" />}
                  </button>
                </div>
              </div>
              <div className="flex flex-wrap gap-1 mb-3">
                {w.events.map(e => (
                  <Badge key={e} variant="outline" className="text-[10px] bg-secondary/50">{e}</Badge>
                ))}
              </div>
              <div className="grid grid-cols-3 gap-2 text-xs">
                <div>
                  <p className="text-muted-foreground">Entregues (24h)</p>
                  <p className="font-medium text-emerald-600">{w.stats.delivered_24h}</p>
                </div>
                <div>
                  <p className="text-muted-foreground">Falhas</p>
                  <p className="font-medium text-destructive">{w.stats.failed_24h}</p>
                </div>
                <div>
                  <p className="text-muted-foreground">Latência</p>
                  <p className="font-medium">{w.stats.avg_latency_ms}ms</p>
                </div>
              </div>
              {w.last_delivery && (
                <details className="mt-3">
                  <summary className="text-xs text-primary cursor-pointer hover:underline">
                    Ver último payload
                  </summary>
                  <pre className="mt-2 p-2 bg-secondary/30 rounded text-[10px] overflow-x-auto max-h-32">
                    {JSON.stringify(w.last_delivery.payload, null, 2)}
                  </pre>
                </details>
              )}
            </div>
          ))}
        </div>
      </div>

      {/* Endpoints Catalog */}
      <div className="rounded-xl border border-border bg-card p-6">
        <h3 className="font-semibold text-lg mb-4 flex items-center gap-2">
          <FileText className="h-5 w-5 text-primary" /> Catálogo de Endpoints
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {ENDPOINTS.map((ep, i) => (
            <div key={i} className="p-4 border border-border rounded-lg hover:border-primary/50 transition-colors">
              <div className="flex items-start justify-between mb-2 gap-2">
                <div className="flex items-center gap-2 min-w-0">
                  <Badge variant="outline" className={`text-xs font-mono ${ep.method === "GET" ? "text-blue-600" : "text-green-600"}`}>
                    {ep.method}
                  </Badge>
                  <code className="text-xs font-mono text-primary truncate">{ep.path}</code>
                </div>
                <Badge variant="secondary" className="text-[10px] flex-shrink-0">{ep.rate_limit}</Badge>
              </div>
              <p className="text-sm text-muted-foreground mb-3">{ep.description}</p>
              <div className="flex items-center gap-2 mb-3">
                <Lock className="h-3 w-3 text-muted-foreground" />
                <span className="text-xs text-muted-foreground">{ep.auth}</span>
                {ep.lgpd && (
                  <Badge variant="outline" className="text-[10px] text-amber-600 border-amber-300">LGPD</Badge>
                )}
              </div>
              <div className="mb-3">
                <p className="text-xs text-muted-foreground mb-1">Planos:</p>
                <div className="flex gap-1 flex-wrap">
                  {ep.pricing_tier.map(t => (
                    <Badge key={t} variant={t === "enterprise" ? "default" : "secondary"} className="text-[10px] capitalize">{t}</Badge>
                  ))}
                </div>
              </div>
              <details>
                <summary className="text-xs text-primary cursor-pointer hover:underline">Exemplo de resposta</summary>
                <pre className="mt-2 p-2 bg-secondary/30 rounded text-[10px] overflow-x-auto max-h-24">
                  {JSON.stringify(ep.sample, null, 2)}
                </pre>
              </details>
            </div>
          ))}
        </div>
      </div>

      {/* Pricing Tiers */}
      <div className="rounded-xl border border-border bg-card p-6">
        <h3 className="font-semibold text-lg mb-4 flex items-center gap-2">
          <CreditCard className="h-5 w-5 text-primary" /> Estrutura de Preços da API
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {PRICING_TIERS.map(plan => (
            <div key={plan.tier}
              className={`p-5 rounded-xl border-2 transition-all ${plan.popular ? "border-primary bg-primary/5 shadow-lg shadow-primary/10" : "border-border bg-card hover:border-primary/50"}`}>
              {plan.popular && <Badge className="mb-3 bg-primary text-primary-foreground">Mais Popular</Badge>}
              <h4 className="text-lg font-bold capitalize mb-1">{plan.tier}</h4>
              <p className="text-3xl font-bold text-primary mb-1">{plan.price}</p>
              <p className="text-xs text-muted-foreground mb-4">{plan.quota} • {plan.rate_limit}</p>
              <ul className="space-y-2 mb-6">
                {plan.features.map((f, idx) => (
                  <li key={idx} className="flex items-center gap-2 text-sm">
                    <Check className="h-4 w-4 text-green-500 flex-shrink-0" /> <span>{f}</span>
                  </li>
                ))}
                {plan.lgpd && (
                  <li className="flex items-center gap-2 text-sm text-amber-600">
                    <Shield className="h-4 w-4 flex-shrink-0" /> <span>Conformidade LGPD personalizada</span>
                  </li>
                )}
              </ul>
              <button className={`w-full py-2 rounded-lg font-medium transition-colors ${plan.popular ? "bg-primary text-primary-foreground hover:bg-primary/90" : "bg-secondary text-foreground hover:bg-secondary/80"}`}>
                {plan.cta}
              </button>
            </div>
          ))}
        </div>
      </div>

      {/* LGPD Notice */}
      <div className="p-4 bg-amber-50 border border-amber-200 rounded-lg">
        <div className="flex items-start gap-2">
          <Shield className="h-4 w-4 text-amber-600 mt-0.5 flex-shrink-0" />
          <div className="text-xs text-amber-800">
            <p className="font-medium">⚠️ Conformidade LGPD para Comercialização</p>
            <p className="mt-1">
              Ao comercializar dados do catálogo: <br/>
              • Use apenas dados agregados e anonimizados <br/>
              • Nunca exponha PII (nome, email, telefone) de consultoras <br/>
              • Mantenha registro de consentimento para uso de dados comportamentais <br/>
              • Implemente rate limiting e logging de acesso por API key
            </p>
          </div>
        </div>
      </div>

      {/* Modal: Nova API Key */}
      {showKeyModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50">
          <div className="bg-card border border-border rounded-xl p-6 w-full max-w-md">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-xl font-bold">{createdSecret ? "Chave Criada" : "Nova API Key"}</h2>
              <button onClick={() => { setShowKeyModal(false); setCreatedSecret(null); }} className="p-2 hover:bg-secondary rounded-lg transition-colors">
                <X className="h-4 w-4" />
              </button>
            </div>
            {createdSecret ? (
              <div className="space-y-4">
                <div className="p-3 bg-amber-50 border border-amber-200 rounded-lg text-xs text-amber-800">
                  ⚠️ Copie a chave agora. Por segurança, ela não será exibida novamente.
                </div>
                <div className="flex gap-2">
                  <code className="flex-1 p-2 bg-secondary rounded text-xs font-mono break-all">{createdSecret}</code>
                  <button
                    onClick={() => { copyToClipboard(createdSecret); }}
                    className="p-2 bg-primary text-primary-foreground rounded transition-colors hover:bg-primary/90">
                    <Copy className="h-4 w-4" />
                  </button>
                </div>
                <button onClick={() => { setShowKeyModal(false); setCreatedSecret(null); }}
                  className="w-full py-2 bg-primary text-primary-foreground rounded-lg hover:bg-primary/90">Concluir</button>
              </div>
            ) : (
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium mb-1">Nome da Chave</label>
                  <input value={newKey.name} onChange={e => setNewKey({ ...newKey, name: e.target.value })}
                    className="w-full border border-input rounded-lg px-3 py-2 text-sm" placeholder="Ex: Beauty Insights Co." />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Cliente / Empresa</label>
                  <input value={newKey.client} onChange={e => setNewKey({ ...newKey, client: e.target.value })}
                    className="w-full border border-input rounded-lg px-3 py-2 text-sm" placeholder="Opcional" />
                </div>
                <div>
                  <label className="block text-sm font-medium mb-1">Plano</label>
                  <select value={newKey.plan} onChange={e => setNewKey({ ...newKey, plan: e.target.value as any })}
                    className="w-full border border-input rounded-lg px-3 py-2 text-sm">
                    <option value="starter">Starter (Grátis)</option>
                    <option value="pro">Pro (R$ 199/mês)</option>
                    <option value="enterprise">Enterprise</option>
                  </select>
                </div>
                <button onClick={handleCreateKey}
                  className="w-full py-2 bg-primary text-primary-foreground rounded-lg font-medium hover:bg-primary/90">
                  Gerar Chave
                </button>
              </div>
            )}
          </div>
        </div>
      )}

      {/* Modal: Novo Webhook */}
      {showWebhookModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50">
          <div className="bg-card border border-border rounded-xl p-6 w-full max-w-md">
            <div className="flex justify-between items-center mb-6">
              <h2 className="text-xl font-bold">Novo Webhook</h2>
              <button onClick={() => setShowWebhookModal(false)} className="p-2 hover:bg-secondary rounded-lg transition-colors">
                <X className="h-4 w-4" />
              </button>
            </div>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1">Nome</label>
                <input value={newWebhook.name} onChange={e => setNewWebhook({ ...newWebhook, name: e.target.value })}
                  className="w-full border border-input rounded-lg px-3 py-2 text-sm" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">URL de Destino</label>
                <input type="url" value={newWebhook.url} onChange={e => setNewWebhook({ ...newWebhook, url: e.target.value })}
                  className="w-full border border-input rounded-lg px-3 py-2 text-sm font-mono" placeholder="https://..." />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">Eventos</label>
                <div className="space-y-1">
                  {["price.changed", "product.updated", "consultant.anonymized_behavior"].map(ev => (
                    <label key={ev} className="flex items-center gap-2 text-sm">
                      <input type="checkbox" checked={newWebhook.events.includes(ev)}
                        onChange={e => setNewWebhook({
                          ...newWebhook,
                          events: e.target.checked
                            ? [...newWebhook.events, ev]
                            : newWebhook.events.filter(x => x !== ev),
                        })} />
                      <code className="text-xs">{ev}</code>
                    </label>
                  ))}
                </div>
              </div>
              <button onClick={handleCreateWebhook}
                className="w-full py-2 bg-primary text-primary-foreground rounded-lg font-medium hover:bg-primary/90">
                Criar Webhook
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}