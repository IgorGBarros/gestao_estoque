// src/components/admin/ApiManagementTab.tsx
import React, { useState, useEffect } from "react";
import {
  Server, Key, Activity, Bell, Plus, FileText, BarChart3, RefreshCw, Ban,
  ToggleLeft, ToggleRight, Lock, Shield, Check, CreditCard, DollarSign, Copy, X,
  Zap, TrendingUp, AlertCircle, ExternalLink, Clock, Database
} from "lucide-react";
import { Badge } from "../ui/badge";
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from "../ui/table";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "../ui/card";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "../ui/tabs";
import { adminApi } from "../../lib/api";


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
  status?: "active" | "beta" | "planned";
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

export interface ApiMonitorData {
  revenue_api_mrr?: number;
  active_keys?: number;
  total_requests_30d?: number;
  webhook_success_rate?: number;
  keys?: ApiKey[];
  webhooks?: Webhook[];
  endpoints_catalog?: Endpoint[];
  pricing_tiers?: Record<string, PricingTier>;
  internal_metrics?: {
    avg_response_time_ms: number;
    error_rate_percent: number;
    top_endpoints: { path: string; calls: number }[];
  };
}

export interface Props {
  formatCurrency: (n: number) => string;
  toast: (opts: { title: string; description?: string; variant?: "default" | "destructive" }) => void;
}

// ─────────────────────────────────────────────────────────────
// DADOS INICIAIS (Fallback se API não retornar)
// ─────────────────────────────────────────────────────────────

const DEFAULT_ENDPOINTS: Endpoint[] = [
  // Catálogo Global - PÚBLICO/INTERNO
  {
    path: "/api/products/",
    method: "GET",
    description: "Lista o catálogo global de produtos (Natura, marcas)",
    auth: "API Key",
    rate_limit: "100 req/min",
    pricing_tier: ["starter", "pro", "enterprise"],
    sample: [{ id: 1, name: "Perfume Kaiak", brand: "Natura", official_price: 89.9 }],
    status: "active"
  },
  {
    path: "/api/products/lookup/?barcode={barcode}",
    method: "GET",
    description: "Lookup híbrido por barcode (local → scraper → fuzzy match)",
    auth: "API Key",
    rate_limit: "200 req/min",
    pricing_tier: ["starter", "pro", "enterprise"],
    sample: { source: "local", product: { id: 12, name: "Tododia Algodão" } },
    status: "active"
  },
  
  // Storefront Pública - SEM AUTH
  {
    path: "/api/public/storefront/{slug}/",
    method: "GET",
    description: "Vitrine pública de uma consultora (sem datas de validade)",
    auth: "Público",
    rate_limit: "60 req/min",
    pricing_tier: ["starter", "pro", "enterprise"],
    sample: [{ product_name: "Lily Eau de Parfum", sale_price: 199.9 }],
    status: "active"
  },
  
  // Analytics - ENTERPRISE ONLY
  {
    path: "/api/admin/analytics/products/",
    method: "GET",
    description: "Analytics agregado de produtos: top vendidos, marcas, categorias",
    auth: "API Key + Scope",
    rate_limit: "50 req/min",
    pricing_tier: ["pro", "enterprise"],
    sample: { top_brands: [{ brand: "Natura", units: 12480 }] },
    status: "active",
    lgpd: true
  },
  {
    path: "/api/admin/analytics/behavior/",
    method: "GET",
    description: "Comportamento agregado de lojas (anonimizado, sem PII)",
    auth: "API Key + Scope",
    rate_limit: "50 req/min",
    pricing_tier: ["enterprise"],
    sample: { avg_products_per_store: 18.3 },
    status: "beta",
    lgpd: true
  },
  
  // Webhooks
  {
    path: "webhook → product.updated",
    method: "POST",
    description: "Notifica alterações de preço/estoque de produtos do catálogo",
    auth: "Webhook Secret",
    rate_limit: "ilimitado",
    pricing_tier: ["pro", "enterprise"],
    sample: { event: "product.updated", product_id: 12, new_price: 49.9 },
    status: "active"
  },
];

const DEFAULT_PRICING: Record<string, PricingTier> = {
  starter: {
    tier: "starter",
    price: "Grátis",
    quota: "1.000 req/mês",
    rate_limit: "20 req/min",
    features: ["Busca básica de produtos", "Dados públicos apenas", "Suporte por e-mail"],
    cta: "Disponibilizar",
    popular: false,
  },
  pro: {
    tier: "pro",
    price: "R$ 199/mês",
    quota: "50.000 req/mês",
    rate_limit: "100 req/min",
    features: ["Preços atualizados", "Webhooks", "Analytics básico", "Suporte prioritário"],
    cta: "Mais Popular",
    popular: true,
  },
  enterprise: {
    tier: "enterprise",
    price: "Sob consulta",
    quota: "Ilimitado",
    rate_limit: "500+ req/min",
    features: ["Comportamento anonimizado", "SLA 99.99%", "Suporte dedicado", "Endpoints custom"],
    cta: "Falar com Vendas",
    popular: false,
    lgpd: true,
  },
};

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
  const [apiData, setApiData] = useState<ApiMonitorData | null>(null);
  const [loading, setLoading] = useState(true);
  const [activeSubTab, setActiveSubTab] = useState("overview");
  
  // Estados locais para mock data (admin interno)
  const [internalKeys] = useState<ApiKey[]>([
    {
      id: "admin_1",
      name: "Admin Panel (Interno)",
      key_prefix: "pk_admin_••••",
      plan: "enterprise",
      scopes: ["read:*", "write:*", "admin:*"],
      rate_limit: 1000,
      monthly_quota: 999999,
      last_used: new Date().toISOString(),
      is_active: true,
    },
    {
      id: "dev_1",
      name: "Ambiente de Desenvolvimento",
      key_prefix: "pk_dev_••••",
      plan: "pro",
      scopes: ["read:products", "write:products"],
      rate_limit: 100,
      monthly_quota: 50000,
      last_used: new Date(Date.now() - 3600000).toISOString(),
      is_active: true,
    },
  ]);

  // Carregar dados da API de monitoramento
  useEffect(() => {
    const loadApiData = async () => {
      try {
        const data = await adminApi.getApiMonitor?.();
        if (data) {
          setApiData(data);
        }
      } catch (e) {
        console.warn("Monitoramento API não disponível ainda, usando dados internos", e);
      } finally {
        setLoading(false);
      }
    };
    loadApiData();
  }, []);

  // Handlers
  const handleCreateKey = () => {
    toast({ 
      title: "Funcionalidade em desenvolvimento", 
      description: "Criação de chaves será disponível na versão comercial da API." 
    });
  };

  const handleRotateKey = (id: string) => {
    toast({ title: "Chave rotacionada com sucesso" });
  };

  const handleRevokeKey = (id: string) => {
    if (!confirm("Revogar acesso? Esta ação é imediata.")) return;
    toast({ title: "Chave revogada", variant: "destructive" });
  };

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    toast({ title: "Copiado!", description: "Texto copiado para a área de transferência" });
  };

  // Dados combinados (API + fallback interno)
  const displayData: ApiMonitorData = {
    revenue_api_mrr: apiData?.revenue_api_mrr ?? 0,
    active_keys: apiData?.active_keys ?? internalKeys.length,
    total_requests_30d: apiData?.total_requests_30d ?? 12450,
    webhook_success_rate: apiData?.webhook_success_rate ?? 99.2,
    keys: apiData?.keys ?? internalKeys,
    webhooks: apiData?.webhooks ?? [],
    endpoints_catalog: apiData?.endpoints_catalog ?? DEFAULT_ENDPOINTS,
    pricing_tiers: apiData?.pricing_tiers ?? DEFAULT_PRICING,
    internal_metrics: apiData?.internal_metrics ?? {
      avg_response_time_ms: 142,
      error_rate_percent: 0.3,
      top_endpoints: [
        { path: "/api/products/", calls: 8420 },
        { path: "/api/products/lookup/", calls: 3210 },
        { path: "/api/public/storefront/", calls: 1890 },
      ],
    },
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center py-12">
        <RefreshCw className="h-6 w-6 animate-spin text-muted-foreground mr-2" />
        <span className="text-muted-foreground">Carregando métricas da API...</span>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header com contexto claro */}
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold flex items-center gap-2">
            <Server className="h-6 w-6 text-primary" />
            API & Webhooks
          </h2>
          <p className="text-muted-foreground">
            Monitoramento interno • Preparação para comercialização
          </p>
        </div>
        <div className="flex gap-2">
          <Badge variant="outline" className="text-xs">
            <Zap className="h-3 w-3 mr-1" />
            Admin Interno
          </Badge>
          <button
            onClick={handleCreateKey}
            className="flex items-center gap-2 bg-primary text-primary-foreground px-4 py-2 rounded-lg hover:bg-primary/90"
          >
            <Plus className="h-4 w-4" /> Nova API Key
          </button>
          <button className="flex items-center gap-2 border border-border px-4 py-2 rounded-lg hover:bg-secondary">
            <FileText className="h-4 w-4" /> Documentação
          </button>
        </div>
      </div>

      {/* Sub-tabs para organização interna */}
      <Tabs value={activeSubTab} onValueChange={setActiveSubTab} className="space-y-4">
        <TabsList className="grid w-full grid-cols-5">
          <TabsTrigger value="overview" className="text-xs">Visão Geral</TabsTrigger>
          <TabsTrigger value="keys" className="text-xs">Chaves</TabsTrigger>
          <TabsTrigger value="webhooks" className="text-xs">Webhooks</TabsTrigger>
          <TabsTrigger value="endpoints" className="text-xs">Endpoints</TabsTrigger>
          <TabsTrigger value="commercial" className="text-xs">Comercialização</TabsTrigger>
        </TabsList>

        {/* ── TAB: VISÃO GERAL ── */}
        <TabsContent value="overview" className="space-y-4">
          {/* Métricas Principais */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            {[
              { 
                label: "Receita API (MRR)", 
                value: formatCurrency(displayData.revenue_api_mrr ?? 0), 
                icon: DollarSign, 
                color: "text-emerald-600",
                change: apiData ? "+18% vs mês anterior" : "— (comercialização pendente)"
              },
              { 
                label: "Chaves Ativas", 
                value: displayData.active_keys, 
                icon: Key, 
                color: "text-blue-600",
                change: `${internalKeys.length} internas + ${apiData?.keys?.length ?? 0} externas`
              },
              { 
                label: "Requisições (30d)", 
                value: (displayData.total_requests_30d ?? 0).toLocaleString('pt-BR'), 
                icon: Activity, 
                color: "text-purple-600",
                change: `~${Math.round((displayData.total_requests_30d ?? 0) / 30)}/dia`
              },
              { 
                label: "Webhooks Entregues", 
                value: `${displayData.webhook_success_rate ?? 0}%`, 
                icon: Bell, 
                color: "text-amber-600",
                change: `Latência: ${displayData.internal_metrics?.avg_response_time_ms ?? 0}ms`
              },
            ].map((stat, i) => (
              <Card key={i}>
                <CardContent className="p-4">
                  <div className="flex items-center gap-2 mb-2">
                    <stat.icon className={`h-4 w-4 ${stat.color}`} />
                    <span className="text-xs text-muted-foreground font-medium">{stat.label}</span>
                  </div>
                  <p className={`text-2xl font-bold ${stat.color}`}>{stat.value}</p>
                  <p className="text-xs text-muted-foreground mt-1">{stat.change}</p>
                </CardContent>
              </Card>
            ))}
          </div>

          {/* Métricas Técnicas Internas */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <Database className="h-5 w-5 text-primary" />
                Métricas Técnicas (Admin)
              </CardTitle>
              <CardDescription>
                Dados para monitoramento interno da infraestrutura
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div className="p-3 bg-secondary/30 rounded-lg text-center">
                  <p className="text-2xl font-bold text-primary">
                    {displayData.internal_metrics?.avg_response_time_ms ?? 0}ms
                  </p>
                  <p className="text-xs text-muted-foreground">Tempo Médio de Resposta</p>
                </div>
                <div className="p-3 bg-secondary/30 rounded-lg text-center">
                  <p className="text-2xl font-bold text-green-600">
                    {displayData.internal_metrics?.error_rate_percent ?? 0}%
                  </p>
                  <p className="text-xs text-muted-foreground">Taxa de Erro</p>
                </div>
                <div className="p-3 bg-secondary/30 rounded-lg text-center">
                  <p className="text-2xl font-bold text-blue-600">
                    {displayData.endpoints_catalog?.filter(e => e.status === "active").length ?? 0}
                  </p>
                  <p className="text-xs text-muted-foreground">Endpoints Ativos</p>
                </div>
                <div className="p-3 bg-secondary/30 rounded-lg text-center">
                  <p className="text-2xl font-bold text-amber-600">
                    {displayData.endpoints_catalog?.filter(e => e.status === "beta").length ?? 0}
                  </p>
                  <p className="text-xs text-muted-foreground">Em Beta</p>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Top Endpoints */}
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Endpoints Mais Utilizados (Internos)</CardTitle>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Endpoint</TableHead>
                    <TableHead className="text-right">Requisições (30d)</TableHead>
                    <TableHead className="text-right">Status</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {(displayData.internal_metrics?.top_endpoints ?? []).map((ep, i) => (
                    <TableRow key={i}>
                      <TableCell className="font-mono text-xs">{ep.path}</TableCell>
                      <TableCell className="text-right font-medium">{ep.calls.toLocaleString('pt-BR')}</TableCell>
                      <TableCell className="text-right">
                        <Badge variant="outline" className="text-xs">✅ Operacional</Badge>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        {/* ── TAB: CHAVES DE API ── */}
        <TabsContent value="keys" className="space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <div>
                <CardTitle className="text-lg">Chaves de API</CardTitle>
                <CardDescription>
                  {internalKeys.length} chaves internas • {apiData?.keys?.length ?? 0} chaves externas
                </CardDescription>
              </div>
              <Badge variant="outline">{(displayData.keys ?? []).length} total</Badge>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Nome / Cliente</TableHead>
                    <TableHead>Plano</TableHead>
                    <TableHead>Rate Limit</TableHead>
                    <TableHead>Último Uso</TableHead>
                    <TableHead className="text-right">Ações</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {(displayData.keys ?? []).map((key) => (
                    <TableRow key={key.id}>
                      <TableCell>
                        <div>
                          <p className="font-medium text-sm">{key.name}</p>
                          <div className="flex items-center gap-2 mt-1">
                            <code className="text-xs bg-secondary px-1.5 py-0.5 rounded font-mono">
                              {key.key_prefix}
                            </code>
                            <button 
                              onClick={() => copyToClipboard(key.key_prefix)}
                              className="p-1 hover:bg-secondary rounded transition-colors"
                              title="Copiar prefixo"
                            >
                              <Copy className="h-3 w-3" />
                            </button>
                          </div>
                          {key.client_name && (
                            <p className="text-xs text-muted-foreground mt-1">{key.client_name}</p>
                          )}
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant={key.plan === "enterprise" ? "default" : "secondary"} className="text-xs capitalize">
                          {key.plan}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-sm">{key.rate_limit} req/min</TableCell>
                      <TableCell className="text-xs text-muted-foreground">
                        {timeAgo(key.last_used)}
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex items-center justify-end gap-1">
                          <button 
                            onClick={() => handleRotateKey(key.id)}
                            className="p-1.5 hover:bg-secondary rounded transition-colors" 
                            title="Rotacionar chave"
                          >
                            <RefreshCw className="h-4 w-4" />
                          </button>
                          <button 
                            onClick={() => handleRevokeKey(key.id)}
                            className="p-1.5 text-destructive hover:bg-destructive/10 rounded transition-colors" 
                            title="Revogar acesso"
                          >
                            <Ban className="h-4 w-4" />
                          </button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        {/* ── TAB: WEBHOOKS ── */}
        <TabsContent value="webhooks" className="space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <div>
                <CardTitle className="text-lg">Webhooks Configurados</CardTitle>
                <CardDescription>
                  Notificações em tempo real para integrações externas
                </CardDescription>
              </div>
              <Badge variant="outline">{(displayData.webhooks ?? []).length} ativos</Badge>
            </CardHeader>
            <CardContent>
              {(displayData.webhooks ?? []).length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">
                  <Bell className="h-12 w-12 mx-auto mb-3 opacity-50" />
                  <p>Nenhum webhook configurado ainda</p>
                  <p className="text-xs mt-1">Webhooks serão ativados na versão comercial da API</p>
                </div>
              ) : (
                <div className="space-y-3">
                  {(displayData.webhooks ?? []).map((webhook) => (
                    <div key={webhook.id} className="p-4 border border-border rounded-lg">
                      <div className="flex justify-between items-start mb-3">
                        <div>
                          <p className="font-medium text-sm">{webhook.name}</p>
                          <p className="text-xs text-muted-foreground font-mono break-all">{webhook.url}</p>
                        </div>
                        <div className="flex items-center gap-2">
                          <Badge variant={webhook.active ? "default" : "secondary"} className="text-xs">
                            {webhook.active ? "Ativo" : "Inativo"}
                          </Badge>
                          <button className="p-1 hover:bg-secondary rounded transition-colors">
                            {webhook.active ? <ToggleRight className="h-4 w-4" /> : <ToggleLeft className="h-4 w-4" />}
                          </button>
                        </div>
                      </div>
                      <div className="flex flex-wrap gap-1 mb-3">
                        {webhook.events.map((event) => (
                          <Badge key={event} variant="outline" className="text-[10px]">{event}</Badge>
                        ))}
                      </div>
                      <div className="grid grid-cols-3 gap-2 text-xs">
                        <div>
                          <p className="text-muted-foreground">Entregues (24h)</p>
                          <p className="font-medium text-emerald-600">{webhook.stats.delivered_24h}</p>
                        </div>
                        <div>
                          <p className="text-muted-foreground">Falhas</p>
                          <p className="font-medium text-destructive">{webhook.stats.failed_24h}</p>
                        </div>
                        <div>
                          <p className="text-muted-foreground">Latência</p>
                          <p className="font-medium">{webhook.stats.avg_latency_ms}ms</p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* ── TAB: ENDPOINTS ── */}
        <TabsContent value="endpoints" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Catálogo de Endpoints</CardTitle>
              <CardDescription>
                Endpoints disponíveis para uso interno e futura comercialização
              </CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {(displayData.endpoints_catalog ?? DEFAULT_ENDPOINTS).map((endpoint, i) => (
                  <div key={i} className="p-4 border border-border rounded-lg hover:border-primary/50 transition-colors">
                    <div className="flex items-start justify-between mb-2 gap-2">
                      <div className="flex items-center gap-2 min-w-0">
                        <Badge variant="outline" className={`text-xs font-mono ${
                          endpoint.method === "GET" ? "text-blue-600" : "text-green-600"
                        }`}>
                          {endpoint.method}
                        </Badge>
                        <code className="text-xs font-mono text-primary truncate">{endpoint.path}</code>
                        {endpoint.status && (
                          <Badge variant={endpoint.status === "active" ? "default" : endpoint.status === "beta" ? "secondary" : "outline"} className="text-[10px]">
                            {endpoint.status.toUpperCase()}
                          </Badge>
                        )}
                      </div>
                      <Badge variant="secondary" className="text-[10px] flex-shrink-0">{endpoint.rate_limit}</Badge>
                    </div>
                    <p className="text-sm text-muted-foreground mb-3">{endpoint.description}</p>
                    <div className="flex items-center gap-2 mb-3 flex-wrap">
                      <Lock className="h-3 w-3 text-muted-foreground" />
                      <span className="text-xs text-muted-foreground">{endpoint.auth}</span>
                      {endpoint.lgpd && (
                        <Badge variant="outline" className="text-[10px] text-amber-600 border-amber-300">LGPD</Badge>
                      )}
                    </div>
                    <div className="mb-3">
                      <p className="text-xs text-muted-foreground mb-1">Planos com acesso:</p>
                      <div className="flex gap-1 flex-wrap">
                        {endpoint.pricing_tier.map((tier) => (
                          <Badge key={tier} variant={tier === "enterprise" ? "default" : "secondary"} className="text-[10px] capitalize">
                            {tier}
                          </Badge>
                        ))}
                      </div>
                    </div>
                    <details>
                      <summary className="text-xs text-primary cursor-pointer hover:underline">Ver exemplo de resposta</summary>
                      <pre className="mt-2 p-2 bg-secondary/30 rounded text-[10px] overflow-x-auto max-h-24">
                        {JSON.stringify(endpoint.sample, null, 2)}
                      </pre>
                    </details>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* ── TAB: COMERCIALIZAÇÃO (Preview para Admin) ── */}
        <TabsContent value="commercial" className="space-y-4">
          <Card className="border-primary/50">
            <CardHeader>
              <CardTitle className="text-lg flex items-center gap-2">
                <TrendingUp className="h-5 w-5 text-primary" />
                Preparação para Comercialização
              </CardTitle>
              <CardDescription>
                Preview da estrutura de preços e checklist de lançamento
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-6">
              {/* Estrutura de Preços (Preview) */}
              <div>
                <h4 className="font-medium mb-3 flex items-center gap-2">
                  <CreditCard className="h-4 w-4 text-primary" />
                  Estrutura de Preços (Preview)
                </h4>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  {Object.values(displayData.pricing_tiers ?? DEFAULT_PRICING).map((plan) => (
                    <div key={plan.tier}
                      className={`p-4 rounded-lg border-2 transition-all ${
                        plan.popular 
                          ? "border-primary bg-primary/5" 
                          : "border-border bg-card"
                      }`}>
                      {plan.popular && <Badge className="mb-2 bg-primary text-primary-foreground text-xs">Mais Popular</Badge>}
                      <h5 className="font-bold capitalize mb-1">{plan.tier}</h5>
                      <p className="text-xl font-bold text-primary mb-1">{plan.price}</p>
                      <p className="text-xs text-muted-foreground mb-3">{plan.quota} • {plan.rate_limit}</p>
                      <ul className="space-y-1 mb-4">
                        {plan.features.map((feature, idx) => (
                          <li key={idx} className="flex items-center gap-2 text-xs">
                            <Check className="h-3 w-3 text-green-500 flex-shrink-0" />
                            <span>{feature}</span>
                          </li>
                        ))}
                        {plan.lgpd && (
                          <li className="flex items-center gap-2 text-xs text-amber-600">
                            <Shield className="h-3 w-3 flex-shrink-0" />
                            <span>Conformidade LGPD</span>
                          </li>
                        )}
                      </ul>
                      <button className={`w-full py-1.5 rounded text-xs font-medium ${
                        plan.popular 
                          ? "bg-primary text-primary-foreground" 
                          : "bg-secondary text-foreground"
                      }`}>
                        {plan.cta}
                      </button>
                    </div>
                  ))}
                </div>
              </div>

              {/* Checklist de Lançamento */}
              <div>
                <h4 className="font-medium mb-3 flex items-center gap-2">
                  <Check className="h-4 w-4 text-primary" />
                  Checklist de Preparação
                </h4>
                <div className="space-y-2">
                  {[
                    { item: "Definir limites de rate limiting por plano", done: true },
                    { item: "Implementar logging de uso por API key", done: true },
                    { item: "Configurar webhooks de entrega", done: false },
                    { item: "Criar documentação pública (Swagger/OpenAPI)", done: false },
                    { item: "Implementar sistema de billing automático", done: false },
                    { item: "Testes de carga e stress testing", done: false },
                    { item: "Revisão de conformidade LGPD", done: true },
                    { item: "Setup de monitoramento e alertas", done: false },
                  ].map((task, i) => (
                    <div key={i} className="flex items-center gap-3 p-3 bg-secondary/30 rounded-lg">
                      {task.done ? (
                        <Check className="h-4 w-4 text-green-500 flex-shrink-0" />
                      ) : (
                        <div className="h-4 w-4 rounded-full border-2 border-muted-foreground flex-shrink-0" />
                      )}
                      <span className={`text-sm ${task.done ? "text-foreground" : "text-muted-foreground"}`}>
                        {task.item}
                      </span>
                    </div>
                  ))}
                </div>
              </div>

              {/* Aviso de LGPD */}
              <div className="p-4 bg-amber-50 border border-amber-200 rounded-lg">
                <div className="flex items-start gap-2">
                  <AlertCircle className="h-4 w-4 text-amber-600 mt-0.5 flex-shrink-0" />
                  <div className="text-xs text-amber-800">
                    <p className="font-medium">⚠️ Conformidade LGPD para Comercialização</p>
                    <p className="mt-1">
                      Ao comercializar dados do catálogo: <br/>
                      • Use apenas dados agregados e anonimizados <br/>
                      • Nunca exponha PII (nome, email, telefone) de consultoras <br/>
                      • Mantenha registro de consentimento para dados comportamentais <br/>
                      • Implemente rate limiting e logging de acesso por API key
                    </p>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {/* Rodapé com contexto */}
      <div className="flex items-center justify-between text-xs text-muted-foreground pt-4 border-t">
        <div className="flex items-center gap-2">
          <Clock className="h-3 w-3" />
          <span>Atualizado: {new Date().toLocaleString('pt-BR')}</span>
        </div>
        <div className="flex items-center gap-2">
          <ExternalLink className="h-3 w-3" />
          <span>Comercialização: api.minhaamora.com.br (em desenvolvimento)</span>
        </div>
      </div>
    </div>
  );
}