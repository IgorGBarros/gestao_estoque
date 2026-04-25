// components/admin/PaymentGatewaysTab.tsx

import { useState } from "react";

import { useToast } from "../../hooks/use-toast";

// ==========================================
// COMPONENTE: ABA DE GATEWAYS DE PAGAMENTO
// ==========================================

import { AlertTriangle, Badge, Bell, Check, CreditCard, Plus, Save, Settings2, ToggleLeft, ToggleRight,  Trash2 } from "lucide-react";

interface GatewayConfig {
  id: string;
  name: string;
  enabled: boolean;
  mode: 'sandbox' | 'production';
  publicKey: string;
  secretKey: string;
  webhookUrl: string;
  webhookSecret: string;
  supportedMethods: string[];
  notes: string;
}

const DEFAULT_GATEWAYS: GatewayConfig[] = [
  {
    id: 'stripe',
    name: 'Stripe',
    enabled: false,
    mode: 'sandbox',
    publicKey: '',
    secretKey: '',
    webhookUrl: '',
    webhookSecret: '',
    supportedMethods: ['card', 'pix'],
    notes: '',
  },
  {
    id: 'mercadopago',
    name: 'Mercado Pago',
    enabled: false,
    mode: 'sandbox',
    publicKey: '',
    secretKey: '',
    webhookUrl: '',
    webhookSecret: '',
    supportedMethods: ['card', 'pix', 'boleto'],
    notes: '',
  },
  {
    id: 'asaas',
    name: 'Asaas',
    enabled: false,
    mode: 'sandbox',
    publicKey: '',
    secretKey: '',
    webhookUrl: '',
    webhookSecret: '',
    supportedMethods: ['card', 'pix', 'boleto'],
    notes: '',
  },
];

const PAYMENT_METHODS_OPTIONS = [
  { value: 'card', label: 'Cartão de Crédito' },
  { value: 'pix', label: 'PIX' },
  { value: 'boleto', label: 'Boleto' },
  { value: 'debit', label: 'Débito' },
];
export default function PaymentGatewaysTab() {
  const { toast } = useToast();
  const [gateways, setGateways] = useState<GatewayConfig[]>(() => {
    const saved = localStorage.getItem('admin_payment_gateways');
    return saved ? JSON.parse(saved) : DEFAULT_GATEWAYS;
  });
  const [editingGateway, setEditingGateway] = useState<string | null>(null);
  const [showAddCustom, setShowAddCustom] = useState(false);
  const [customName, setCustomName] = useState('');

  const saveGateways = (updated: GatewayConfig[]) => {
    setGateways(updated);
    localStorage.setItem('admin_payment_gateways', JSON.stringify(updated));
    toast({ title: "Configurações salvas" });
  };

  const toggleGateway = (id: string) => {
    const updated = gateways.map(g =>
      g.id === id ? { ...g, enabled: !g.enabled } : g
    );
    saveGateways(updated);
  };

  const updateGateway = (id: string, field: keyof GatewayConfig, value: any) => {
    setGateways(prev => prev.map(g =>
      g.id === id ? { ...g, [field]: value } : g
    ));
  };

  const saveGateway = (id: string) => {
    localStorage.setItem('admin_payment_gateways', JSON.stringify(gateways));
    setEditingGateway(null);
    toast({ title: "Gateway atualizado" });
  };

  const toggleMethod = (gatewayId: string, method: string) => {
    setGateways(prev => prev.map(g => {
      if (g.id !== gatewayId) return g;
      const methods = g.supportedMethods.includes(method)
        ? g.supportedMethods.filter(m => m !== method)
        : [...g.supportedMethods, method];
      return { ...g, supportedMethods: methods };
    }));
  };

  const addCustomGateway = () => {
    if (!customName.trim()) return;
    const id = customName.toLowerCase().replace(/\s+/g, '_');
    if (gateways.find(g => g.id === id)) {
      toast({ title: "Gateway já existe", variant: "destructive" });
      return;
    }
    const newGateway: GatewayConfig = {
      id,
      name: customName.trim(),
      enabled: false,
      mode: 'sandbox',
      publicKey: '',
      secretKey: '',
      webhookUrl: '',
      webhookSecret: '',
      supportedMethods: ['card', 'pix'],
      notes: '',
    };
    saveGateways([...gateways, newGateway]);
    setCustomName('');
    setShowAddCustom(false);
  };

  const removeGateway = (id: string) => {
    if (!confirm(`Remover gateway "${gateways.find(g => g.id === id)?.name}"?`)) return;
    saveGateways(gateways.filter(g => g.id !== id));
  };

  const API_BASE = ((import.meta as any).env?.VITE_API_BASE_URL || "https://gestao-estoque-k5vy.onrender.com")
    .replace(/\/$/, "");

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-2xl font-bold">Gateways de Pagamento</h2>
          <p className="text-muted-foreground">
            Configure provedores de pagamento e webhooks
          </p>
        </div>
        <button
          onClick={() => setShowAddCustom(true)}
          className="flex items-center gap-2 bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary/90"
        >
          <Plus className="h-4 w-4" />
          Adicionar Gateway
        </button>
      </div>

      {/* Webhook URLs de referência */}
      <div className="rounded-xl border border-border bg-card p-4">
        <h3 className="font-semibold text-sm mb-3 flex items-center gap-2">
          <Bell className="h-4 w-4 text-primary" />
          URLs de Webhook (copie e cole no painel do gateway)
        </h3>
        <div className="space-y-2">
          {gateways.filter(g => g.enabled).map(g => (
            <div key={g.id} className="flex items-center gap-3 text-xs bg-secondary/30 p-2 rounded-lg">
              <span className="font-medium w-28">{g.name}:</span>
              <code className="flex-1 bg-background px-2 py-1 rounded font-mono text-xs break-all">
                {`${API_BASE}/api/webhooks/${g.id}/`}
              </code>
              <button
                onClick={() => {
                  navigator.clipboard.writeText(`${API_BASE}/api/webhooks/${g.id}/`);
                  toast({ title: "URL copiada!" });
                }}
                className="text-primary hover:text-primary/80 text-xs font-medium shrink-0"
              >
                Copiar
              </button>
            </div>
          ))}
          {gateways.filter(g => g.enabled).length === 0 && (
            <p className="text-xs text-muted-foreground">
              Ative um gateway para ver a URL de webhook
            </p>
          )}
        </div>
      </div>

      {/* Modal adicionar gateway customizado */}
      {showAddCustom && (
        <div className="rounded-xl border border-primary/30 bg-primary/5 p-4">
          <h4 className="font-medium text-sm mb-3">Adicionar Gateway Customizado</h4>
          <div className="flex gap-3">
            <input
              type="text"
              value={customName}
              onChange={(e) => setCustomName(e.target.value)}
              placeholder="Nome do gateway (ex: Iugu, PagSeguro)"
              className="flex-1 border border-input rounded-lg px-3 py-2 text-sm"
              onKeyDown={(e) => e.key === 'Enter' && addCustomGateway()}
            />
            <button
              onClick={addCustomGateway}
              className="bg-primary text-white px-4 py-2 rounded-lg text-sm hover:bg-primary/90"
            >
              Adicionar
            </button>
            <button
              onClick={() => { setShowAddCustom(false); setCustomName(''); }}
              className="px-4 py-2 border border-border rounded-lg text-sm hover:bg-secondary"
            >
              Cancelar
            </button>
          </div>
        </div>
      )}

      {/* Lista de Gateways */}
      <div className="space-y-4">
        {gateways.map((gateway) => (
          <div
            key={gateway.id}
            className={`border rounded-xl p-5 bg-card transition-colors ${
              gateway.enabled ? 'border-primary/30' : 'border-border'
            }`}
          >
            {/* Header do gateway */}
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-3">
                <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${
                  gateway.enabled ? 'bg-primary/10' : 'bg-secondary'
                }`}>
                  <CreditCard className={`h-5 w-5 ${
                    gateway.enabled ? 'text-primary' : 'text-muted-foreground'
                  }`} />
                </div>
                  <div>
                  <h3 className="font-bold text-base">{gateway.name}</h3>
                  <div className="flex items-center gap-2">
                    <span className={`text-xs px-2.5 py-0.5 rounded-full font-medium ${
                      gateway.enabled
                        ? 'bg-primary/10 text-primary border border-primary/30'
                        : 'bg-secondary text-muted-foreground border border-border'
                    }`}>
                      {gateway.enabled ? "Ativo" : "Inativo"}
                    </span>
                    <span className="text-xs px-2.5 py-0.5 rounded-full border border-border text-muted-foreground">
                      {gateway.mode === 'production' ? '🟢 Produção' : '🟡 Sandbox'}
                    </span>
                  </div>
                </div>
              </div>

              <div className="flex items-center gap-2">
                <button
                  onClick={() => toggleGateway(gateway.id)}
                  className={`p-2 rounded-lg transition-colors ${
                    gateway.enabled
                      ? 'bg-green-100 text-green-700 hover:bg-green-200'
                      : 'bg-gray-100 text-gray-500 hover:bg-gray-200'
                  }`}
                >
                  {gateway.enabled ? (
                    <ToggleRight className="h-5 w-5" />
                  ) : (
                    <ToggleLeft className="h-5 w-5" />
                  )}
                </button>
                <button
                  onClick={() => setEditingGateway(
                    editingGateway === gateway.id ? null : gateway.id
                  )}
                  className="p-2 rounded-lg border border-border hover:bg-secondary"
                >
                  <Settings2 className="h-4 w-4" />
                </button>
                {!['stripe', 'mercadopago', 'asaas'].includes(gateway.id) && (
                  <button
                    onClick={() => removeGateway(gateway.id)}
                    className="p-2 rounded-lg text-destructive hover:bg-destructive/10"
                  >
                    <Trash2 className="h-4 w-4" />
                  </button>
                )}
              </div>
            </div>

            {/* Métodos aceitos (sempre visível) */}
            <div className="flex flex-wrap gap-2 mb-2">
              {PAYMENT_METHODS_OPTIONS.map(method => (
                <button
                  key={method.value}
                  onClick={() => toggleMethod(gateway.id, method.value)}
                  className={`text-xs px-2.5 py-1 rounded-full border transition-colors ${
                    gateway.supportedMethods.includes(method.value)
                      ? 'bg-primary/10 border-primary/30 text-primary font-medium'
                      : 'bg-secondary border-border text-muted-foreground'
                  }`}
                >
                  {gateway.supportedMethods.includes(method.value) && (
                    <Check className="h-3 w-3 inline mr-1" />
                  )}
                  {method.label}
                </button>
              ))}
            </div>

            {/* Formulário expandido */}
            {editingGateway === gateway.id && (
              <div className="mt-4 pt-4 border-t border-border space-y-4 animate-in slide-in-from-top-2">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-medium mb-1">
                      Modo
                    </label>
                    <select
                      value={gateway.mode}
                      onChange={(e) => updateGateway(
                        gateway.id, 'mode', e.target.value
                      )}
                      className="w-full border border-input rounded-lg px-3 py-2 text-sm"
                    >
                      <option value="sandbox">🟡 Sandbox (Teste)</option>
                      <option value="production">🟢 Produção</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs font-medium mb-1">
                      Webhook URL
                    </label>
                    <div className="flex gap-2">
                      <input
                        type="text"
                        value={`${API_BASE}/api/webhooks/${gateway.id}/`}
                        readOnly
                        className="flex-1 border border-input rounded-lg px-3 py-2 text-sm bg-secondary/30 font-mono text-xs"
                      />
                      <button
                        onClick={() => {
                          navigator.clipboard.writeText(
                            `${API_BASE}/api/webhooks/${gateway.id}/`
                          );
                          toast({ title: "Copiado!" });
                        }}
                        className="px-3 py-2 border border-border rounded-lg text-xs hover:bg-secondary"
                      >
                        Copiar
                      </button>
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-medium mb-1">
                      Chave Pública (Public Key)
                    </label>
                    <input
                      type="text"
                      value={gateway.publicKey}
                      onChange={(e) => updateGateway(
                        gateway.id, 'publicKey', e.target.value
                      )}
                      className="w-full border border-input rounded-lg px-3 py-2 text-sm font-mono"
                      placeholder="pk_live_..."
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-medium mb-1">
                      Chave Secreta (Secret Key)
                    </label>
                    <input
                      type="password"
                      value={gateway.secretKey}
                      onChange={(e) => updateGateway(
                        gateway.id, 'secretKey', e.target.value
                      )}
                      className="w-full border border-input rounded-lg px-3 py-2 text-sm font-mono"
                      placeholder="sk_live_..."
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-xs font-medium mb-1">
                    Webhook Secret (para validação)
                  </label>
                  <input
                    type="password"
                    value={gateway.webhookSecret}
                    onChange={(e) => updateGateway(
                      gateway.id, 'webhookSecret', e.target.value
                    )}
                    className="w-full border border-input rounded-lg px-3 py-2 text-sm font-mono"
                    placeholder="whsec_..."
                  />
                </div>

                <div>
                  <label className="block text-xs font-medium mb-1">
                    Notas / Observações
                  </label>
                  <textarea
                    value={gateway.notes}
                    onChange={(e) => updateGateway(
                      gateway.id, 'notes', e.target.value
                    )}
                    className="w-full border border-input rounded-lg px-3 py-2 text-sm"
                    rows={2}
                    placeholder="Anotações internas..."
                  />
                </div>

                <div className="flex gap-3">
                  <button
                    onClick={() => saveGateway(gateway.id)}
                    className="flex items-center gap-2 bg-primary text-white px-4 py-2 rounded-lg text-sm hover:bg-primary/90"
                  >
                    <Save className="h-4 w-4" />
                    Salvar Configuração
                  </button>
                  <button
                    onClick={() => setEditingGateway(null)}
                    className="px-4 py-2 border border-border rounded-lg text-sm hover:bg-secondary"
                  >
                    Cancelar
                  </button>
                </div>
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Dica */}
      <div className="rounded-xl border border-amber-200 bg-amber-50 p-4">
        <h4 className="font-medium text-sm text-amber-800 mb-2 flex items-center gap-2">
          <AlertTriangle className="h-4 w-4" />
          Como configurar webhooks
        </h4>
        <ol className="text-xs text-amber-700 space-y-1 list-decimal list-inside">
          <li>Ative o gateway desejado clicando no botão de toggle</li>
          <li>Copie a URL de webhook gerada automaticamente</li>
          <li>Cole a URL no painel do gateway (Stripe Dashboard, MercadoPago, etc.)</li>
          <li>Preencha as chaves pública e secreta do gateway</li>
          <li>Mude para modo "Produção" quando estiver pronto</li>
        </ol>
      </div>
    </div>
  );
}