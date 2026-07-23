// src/pages/ApiPricing.tsx
import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { ArrowLeft, Check, Shield, Star, AlertCircle } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle, CardDescription, CardFooter } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

const plans = [
  {
    name: 'Starter',
    price: 'Grátis',
    period: '',
    description: 'Para testes e projetos pequenos',
    features: [
      '1.000 requisições/mês',
      '20 req/min rate limit',
      'Catálogo básico de produtos',
      'Lookup por barcode',
      'Suporte por e-mail',
      'Dados públicos apenas',
    ],
    cta: 'Começar Grátis',
    popular: false,
    highlight: false,
    planKey: 'starter',
  },
  {
    name: 'Pro',
    price: 'R$ 199',
    period: '/mês',
    description: 'Para aplicações em produção',
    features: [
      '50.000 requisições/mês',
      '100 req/min rate limit',
      '✅ Tudo do Starter',
      'Preços atualizados em tempo real',
      'Webhooks para notificações',
      'Analytics básico',
      'Suporte prioritário',
    ],
    cta: 'Assinar Pro',
    popular: true,
    highlight: true,
    planKey: 'pro',
  },
  {
    name: 'Enterprise',
    price: 'Sob consulta',
    period: '',
    description: 'Para grandes volumes e necessidades customizadas',
    features: [
      'Requisições ilimitadas',
      '500+ req/min (configurável)',
      '✅ Tudo do Pro',
      'Analytics avançado (dados anonimizados)',
      'Webhooks com retry e DLQ',
      'SLA 99.99% garantido',
      'Suporte dedicado 24/7',
      'Endpoints customizados',
      'Conformidade LGPD avançada',
    ],
    cta: 'Falar com Vendas',
    popular: false,
    highlight: false,
    planKey: 'enterprise',
  },
];

export default function ApiPricing() {
  const navigate = useNavigate();
  const [selectedPlan, setSelectedPlan] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleSubscribe = async (planKey: string) => {
    setSelectedPlan(planKey);
    setLoading(true);
    
    try {
      // Em produção: integrar com Stripe/Asaas
      // await subscriptionApi.createCheckout(planKey);
      
      // Demo: redirecionar para dashboard
      setTimeout(() => {
        navigate('/api/dashboard');
      }, 1000);
    } catch (err) {
      console.error('Erro ao assinar:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="border-b border-border bg-card/95 backdrop-blur sticky top-0 z-50">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Button variant="ghost" size="sm" className="gap-1" onClick={() => navigate('/api')}>
              <ArrowLeft className="h-4 w-4" /> Voltar
            </Button>
            <div className="flex items-center gap-2 font-bold text-lg">
              <span className="text-primary">Minha Amora</span> API
            </div>
          </div>
          <nav className="flex items-center gap-4 text-sm">
            <button onClick={() => navigate('/api')} className="hover:text-primary">Início</button>
            <button onClick={() => navigate('/api/docs')} className="hover:text-primary">Documentação</button>
            <span className="text-primary font-medium">Preços</span>
          </nav>
        </div>
      </header>

      {/* Conteúdo */}
      <main className="container mx-auto px-4 py-12">
        <div className="text-center mb-12">
          <Badge variant="outline" className="mb-4">💰 Planos</Badge>
          <h1 className="text-3xl md:text-4xl font-bold mb-4">
            Escolha o plano ideal para seu projeto
          </h1>
          <p className="text-muted-foreground max-w-2xl mx-auto mb-8">
            Todos os planos incluem criptografia ponta-a-ponta, conformidade LGPD e monitoramento 24/7.
          </p>
          
          {/* Toggle Mensal/Anual */}
          <div className="flex items-center justify-center gap-4 mb-8">
            <span className="text-sm text-muted-foreground">Mensal</span>
            <label className="relative inline-flex items-center cursor-pointer">
              <input type="checkbox" className="sr-only peer" />
              <div className="w-11 h-6 bg-secondary peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
            </label>
            <span className="text-sm text-muted-foreground">
              Anual <Badge variant="secondary" className="ml-1 text-[10px]">-20%</Badge>
            </span>
          </div>
        </div>

        {/* Cards de Preços */}
        <div className="grid md:grid-cols-3 gap-6 max-w-6xl mx-auto">
          {plans.map((plan) => (
            <Card 
              key={plan.name} 
              className={`relative ${plan.highlight ? 'border-primary shadow-lg shadow-primary/10' : ''}`}
            >
              {plan.popular && (
                <Badge className="absolute -top-3 left-1/2 -translate-x-1/2 bg-primary text-primary-foreground">
                  <Star className="h-3 w-3 mr-1" /> Mais Popular
                </Badge>
              )}
              
              <CardHeader>
                <CardTitle className="text-xl">{plan.name}</CardTitle>
                <CardDescription>{plan.description}</CardDescription>
                <div className="mt-4">
                  <span className="text-4xl font-bold">{plan.price}</span>
                  <span className="text-muted-foreground">{plan.period}</span>
                </div>
              </CardHeader>
              
              <CardContent className="space-y-3 text-left">
                {plan.features.map((feature, i) => (
                  <div key={i} className="flex items-start gap-2 text-sm">
                    <Check className="h-4 w-4 text-green-500 mt-0.5 flex-shrink-0" />
                    <span>{feature}</span>
                  </div>
                ))}
              </CardContent>
              
              <CardFooter>
                <Button 
                  className={`w-full ${plan.highlight ? 'bg-primary hover:bg-primary/90' : ''}`}
                  variant={plan.highlight ? 'default' : 'outline'}
                  onClick={() => handleSubscribe(plan.planKey)}
                  disabled={loading && selectedPlan === plan.planKey}
                >
                  {loading && selectedPlan === plan.planKey ? (
                    <span className="flex items-center gap-2">
                      <span className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
                      Processando...
                    </span>
                  ) : (
                    plan.cta
                  )}
                </Button>
              </CardFooter>
            </Card>
          ))}
        </div>

        {/* Aviso LGPD */}
        <div className="mt-12 p-6 bg-amber-50 border border-amber-200 rounded-lg max-w-3xl mx-auto">
          <div className="flex items-start gap-3">
            <Shield className="h-5 w-5 text-amber-600 mt-0.5" />
            <div className="text-left">
              <p className="font-medium text-amber-800">Conformidade LGPD em todos os planos</p>
              <p className="text-sm text-amber-700 mt-1">
                Todos os dados comercializados são agregados e anonimizados. 
                Consentimento registrado, direito ao esquecimento garantido, 
                e relatórios de auditoria disponíveis para planos Pro+.
              </p>
            </div>
          </div>
        </div>

        {/* FAQ */}
        <section className="mt-20 max-w-3xl mx-auto">
          <h2 className="text-2xl font-bold mb-6 text-center">Perguntas Frequentes</h2>
          <div className="space-y-4">
            {[
              {
                q: 'Posso mudar de plano depois?',
                a: 'Sim! Você pode fazer upgrade ou downgrade a qualquer momento. As alterações são aplicadas no próximo ciclo de faturamento.',
              },
              {
                q: 'O que acontece se eu exceder minha quota?',
                a: 'Requisições excedentes são retornadas com HTTP 429. Você pode comprar pacotes extras ou fazer upgrade de plano.',
              },
              {
                q: 'Como funciona a conformidade LGPD?',
                a: 'Todos os dados são agregados e anonimizados antes da comercialização. Consentimento é registrado e auditável.',
              },
              {
                q: 'Posso cancelar a qualquer momento?',
                a: 'Sim, sem multas. Seu acesso permanece ativo até o fim do período pago.',
              },
            ].map((faq, i) => (
              <details key={i} className="group p-4 border border-border rounded-lg">
                <summary className="font-medium cursor-pointer list-none flex items-center justify-between">
                  {faq.q}
                  <span className="transition-transform group-open:rotate-180">▼</span>
                </summary>
                <p className="text-sm text-muted-foreground mt-2">{faq.a}</p>
              </details>
            ))}
          </div>
        </section>
      </main>

      {/* Footer */}
      <footer className="border-t border-border py-8 text-center text-sm text-muted-foreground mt-20">
        <div className="container mx-auto px-4">
          <p>© {new Date().getFullYear()} Minha Amora API. Todos os direitos reservados.</p>
          <div className="flex justify-center gap-4 mt-2">
            <button onClick={() => navigate('/api/terms')} className="hover:text-foreground">Termos</button>
            <button onClick={() => navigate('/api/privacy')} className="hover:text-foreground">Privacidade (LGPD)</button>
            <button onClick={() => navigate('/api/status')} className="hover:text-foreground">Status</button>
            <a href="mailto:suporte@minhaamora.com.br" className="hover:text-foreground">Suporte</a>
          </div>
        </div>
      </footer>
    </div>
  );
}