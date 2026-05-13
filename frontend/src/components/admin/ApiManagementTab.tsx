// src/components/admin/ApiManagementTab.tsx
import React from "react";
import { 
  Key, Server, Bell, DollarSign, Activity, Shield, 
  Copy, ExternalLink, Check, AlertCircle, RefreshCw,
  ToggleLeft, ToggleRight, Trash2, Edit2, Plus
} from "lucide-react";
import { Badge } from "../ui/badge";
import { Button } from "../ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "../ui/table";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "../ui/tabs";


// ✅ INTERFACE DE PROPS DEFINIDA
export interface ApiManagementTabProps {
  data?: {
    revenue_api_mrr?: number;
    active_keys?: number;
    total_requests_30d?: number;
    webhook_success_rate?: number;
    keys?: Array<{
      id: string;
      name: string;
      plan: 'starter' | 'pro' | 'enterprise';
      rate_limit: number;
      last_used?: string;
      active: boolean;
    }>;
    webhooks?: Array<{
      id: string;
      name: string;
      url: string;
      active: boolean;
      events: string[];
      delivered_24h: number;
      failed_24h: number;
      avg_latency_ms: number;
    }>;
    endpoints_catalog?: Array<{
      path: string;
      method: 'GET' | 'POST' | 'PUT' | 'DELETE';
      description?: string;
      rate_limit: string;
      pricing: string[];
    }>;
    pricing_tiers?: Record<string, {
      quota: string;
      price: number | string;
      features?: string[];
    }>;
  };
  formatCurrency: (value: number) => string;
  toast: (props: { title: string; description?: string; variant?: 'default' | 'destructive' }) => void;
}

export default function ApiManagementTab({ 
  data, 
  formatCurrency, 
  toast 
}: ApiManagementTabProps) {
  
  // Fallback para dados mock se backend ainda não retornar
  const mockData = {
    revenue_api_mrr: 1240.00,
    active_keys: 23,
    total_requests_30d: 847200,
    webhook_success_rate: 98.4,
    keys: [
      { id: 'pk_test_1', name: 'App Consultora V1', plan: 'starter' as const, rate_limit: 20, last_used: new Date(Date.now() - 2*3600000).toISOString(), active: true },
      { id: 'pk_live_2', name: 'Integração ERP Loja', plan: 'pro' as const, rate_limit: 100, last_used: new Date(Date.now() - 15*60000).toISOString(), active: true },
    ],
    webhooks: [
      { id: 'wh_1', name: 'Sincronização Estoque', url: 'https://api.erp-cliente.com.br/hooks', active: true, events: ['product.updated', 'stock.changed'], delivered_24h: 142, failed_24h: 1, avg_latency_ms: 210 },
      { id: 'wh_2', name: 'Notificações WhatsApp', url: 'https://wa.bot.internal/api', active: false, events: ['sale.created'], delivered_24h: 0, failed_24h: 0, avg_latency_ms: 0 }
    ],
    endpoints_catalog: [
      { path: '/api/v1/products/search', method: 'GET' as const, description: 'Busca produtos por barcode, nome ou marca', rate_limit: '100 req/min', pricing: ['pro', 'enterprise'] },
      { path: '/api/v1/webhooks/delivery', method: 'POST' as const, description: 'Receba notificações em tempo real', rate_limit: 'unlimited', pricing: ['pro', 'enterprise'] }
    ],
    pricing_tiers: {
      starter: { quota: '1K req/mês', price: 0, features: ['Busca básica'] },
      pro: { quota: '50K req/mês', price: 199.00, features: ['Preços atualizados', 'Webhooks'] },
      enterprise: { quota: 'Ilimitado', price: 'Sob consulta', features: ['Dados anonimizados', 'SLA 99.99%'] }
    }
  };

  const apiData = data || mockData;

  const copyToClipboard = (text: string) => {
    navigator.clipboard.writeText(text);
    toast({ title: "Copiado!", description: "Chave copiada para a área de transferência" });
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-bold flex items-center gap-2">
            <Server className="h-6 w-6 text-primary" />
            API & Webhooks — Monitoramento Interno
          </h2>
          <p className="text-muted-foreground">
            Dados para futura comercialização do banco de dados de produtos
          </p>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm">
            <ExternalLink className="h-4 w-4 mr-2" />
            Documentação
          </Button>
          <Button size="sm">
            <Plus className="h-4 w-4 mr-2" />
            Nova API Key
          </Button>
        </div>
      </div>

      {/* Métricas Principais */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {[
          { label: 'Receita API (MRR)', value: formatCurrency(apiData.revenue_api_mrr || 0), icon: DollarSign, color: 'text-emerald-600' },
          { label: 'Chaves Ativas', value: apiData.active_keys || 0, icon: Key, color: 'text-blue-600' },
          { label: 'Requisições (30d)', value: (apiData.total_requests_30d || 0).toLocaleString('pt-BR'), icon: Activity, color: 'text-purple-600' },
          { label: 'Webhooks Entregues', value: `${apiData.webhook_success_rate || 0}%`, icon: Bell, color: 'text-amber-600' },
        ].map((stat, i) => (
          <Card key={i}>
            <CardContent className="p-4">
              <div className="flex items-center gap-2 mb-2">
                <stat.icon className={`h-4 w-4 ${stat.color}`} />
                <span className="text-xs text-muted-foreground font-medium">{stat.label}</span>
              </div>
              <p className={`text-2xl font-bold ${stat.color}`}>{stat.value}</p>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Tabs Internas */}
      <Tabs defaultValue="keys" className="space-y-4">
        <TabsList className="grid w-full grid-cols-4">
          <TabsTrigger value="keys">API Keys</TabsTrigger>
          <TabsTrigger value="webhooks">Webhooks</TabsTrigger>
          <TabsTrigger value="endpoints">Endpoints</TabsTrigger>
          <TabsTrigger value="pricing">Preços</TabsTrigger>
        </TabsList>

        {/* API Keys */}
        <TabsContent value="keys" className="space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle className="text-lg">Chaves de API Ativas</CardTitle>
              <Badge variant="outline">{apiData.keys?.length || 0} chaves</Badge>
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
                  {(apiData.keys || []).map((key) => (
                    <TableRow key={key.id}>
                      <TableCell>
                        <div>
                          <p className="font-medium text-sm">{key.name}</p>
                          <div className="flex items-center gap-2 mt-1">
                            <code className="text-xs bg-secondary px-1.5 py-0.5 rounded">
                              {key.id.slice(0, 12)}•••
                            </code>
                            <button 
                              onClick={() => copyToClipboard(key.id)}
                              className="p-1 hover:bg-secondary rounded transition-colors"
                              title="Copiar chave"
                            >
                              <Copy className="h-3 w-3" />
                            </button>
                          </div>
                        </div>
                      </TableCell>
                      <TableCell>
                        <Badge variant={key.plan === 'enterprise' ? 'default' : 'secondary'} className="text-xs capitalize">
                          {key.plan}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-sm">{key.rate_limit} req/min</TableCell>
                      <TableCell className="text-xs text-muted-foreground">
                        {key.last_used ? new Date(key.last_used).toLocaleString('pt-BR') : 'Nunca'}
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex items-center justify-end gap-1">
                          <button className="p-1.5 hover:bg-secondary rounded transition-colors">
                            <Edit2 className="h-4 w-4" />
                          </button>
                          <button className="p-1.5 text-destructive hover:bg-destructive/10 rounded transition-colors">
                            <Trash2 className="h-4 w-4" />
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

        {/* Webhooks */}
        <TabsContent value="webhooks" className="space-y-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between">
              <CardTitle className="text-lg">Webhooks Configurados</CardTitle>
              <Button variant="outline" size="sm">
                <Plus className="h-4 w-4 mr-2" />
                Novo Webhook
              </Button>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {(apiData.webhooks || []).map((webhook) => (
                  <div key={webhook.id} className="p-4 border border-border rounded-lg">
                    <div className="flex justify-between items-start mb-3">
                      <div>
                        <p className="font-medium text-sm">{webhook.name}</p>
                        <p className="text-xs text-muted-foreground font-mono break-all">{webhook.url}</p>
                      </div>
                      <div className="flex items-center gap-2">
                        <Badge variant={webhook.active ? 'default' : 'secondary'} className="text-xs">
                          {webhook.active ? 'Ativo' : 'Inativo'}
                        </Badge>
                        <button className="p-1 hover:bg-secondary rounded">
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
                        <p className="font-medium text-emerald-600">{webhook.delivered_24h}</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Falhas</p>
                        <p className="font-medium text-destructive">{webhook.failed_24h}</p>
                      </div>
                      <div>
                        <p className="text-muted-foreground">Latência</p>
                        <p className="font-medium">{webhook.avg_latency_ms}ms</p>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Endpoints Catalog */}
        <TabsContent value="endpoints" className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">Catálogo de Endpoints Comerciais</CardTitle>
            </CardHeader>
            <CardContent>
              <div className="space-y-3">
                {(apiData.endpoints_catalog || []).map((endpoint, i) => (
                  <div key={i} className="p-4 border border-border rounded-lg">
                    <div className="flex items-start justify-between mb-2">
                      <div className="flex items-center gap-2">
                        <Badge variant="outline" className={`text-xs font-mono ${
                          endpoint.method === 'GET' ? 'text-blue-600' : 'text-green-600'
                        }`}>
                          {endpoint.method}
                        </Badge>
                        <code className="text-xs font-mono text-primary">{endpoint.path}</code>
                      </div>
                      <Badge variant="secondary" className="text-[10px]">{endpoint.rate_limit}</Badge>
                    </div>
                    {endpoint.description && (
                      <p className="text-sm text-muted-foreground mb-2">{endpoint.description}</p>
                    )}
                    <div className="flex items-center gap-2">
                      <Shield className="h-3 w-3 text-muted-foreground" />
                      <span className="text-xs text-muted-foreground">
                        Planos: {endpoint.pricing.map(p => p.toUpperCase()).join(', ')}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        {/* Pricing Tiers */}
        <TabsContent value="pricing" className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {Object.entries(apiData.pricing_tiers || {}).map(([tier, config]) => (
              <Card key={tier} className={tier === 'pro' ? 'border-primary shadow-lg shadow-primary/10' : ''}>
                <CardHeader>
                  <CardTitle className="text-lg capitalize">{tier}</CardTitle>
                  {tier === 'pro' && <Badge className="w-fit">Mais Popular</Badge>}
                </CardHeader>
                <CardContent className="space-y-4">
                  <div>
                    <p className="text-3xl font-bold text-primary">
                      {typeof config.price === 'number' ? formatCurrency(config.price) : config.price}
                    </p>
                    <p className="text-xs text-muted-foreground">{config.quota}</p>
                  </div>
                  <ul className="space-y-2 text-sm">
                    {(config.features || []).map((feature, i) => (
                      <li key={i} className="flex items-center gap-2">
                        <Check className="h-4 w-4 text-green-500 flex-shrink-0" />
                        <span>{feature}</span>
                      </li>
                    ))}
                  </ul>
                  <Button variant={tier === 'pro' ? 'default' : 'outline'} className="w-full">
                    {tier === 'enterprise' ? 'Falar com Vendas' : 'Selecionar'}
                  </Button>
                </CardContent>
              </Card>
            ))}
          </div>
        </TabsContent>
      </Tabs>

      {/* LGPD Notice */}
      <div className="p-4 bg-amber-50 border border-amber-200 rounded-lg">
        <div className="flex items-start gap-2">
          <AlertCircle className="h-4 w-4 text-amber-600 mt-0.5 flex-shrink-0" />
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
    </div>
  );
}