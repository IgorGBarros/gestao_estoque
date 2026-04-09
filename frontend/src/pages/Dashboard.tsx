// components/Dashboard.tsx - VERSÃO MELHORADA COM GRÁFICOS AVANÇADOS

import { useState, useEffect } from 'react';
import { 
  TrendingUp, 
  Package, 
  AlertTriangle, 
  Calendar,
  DollarSign,
  ShoppingCart,
  BarChart3,
  PieChart,
  Target,
  Percent,
  ArrowUpDown,
  Wallet,
  TrendingDown,
  Activity,
  Zap,
  Loader2
} from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { 
  BarChart, 
  Bar, 
  XAxis, 
  YAxis, 
  CartesianGrid, 
  Tooltip, 
  ResponsiveContainer,
  PieChart as RechartsPieChart,
  Cell,
  LineChart,
  Line,
  Area,
  AreaChart,
  Pie,
  ComposedChart,
  RadialBarChart,
  RadialBar,
  Legend
} from 'recharts';
import { api } from '../services/api';

// ✅ CORES EXPANDIDAS PARA GRÁFICOS
const CHART_COLORS = ['#8884d8', '#82ca9d', '#ffc658', '#ff7c7c', '#8dd1e1', '#d084d0', '#ffb347', '#87ceeb'];

// ✅ INTERFACE EXPANDIDA COM NOVOS INDICADORES
interface DashboardData {
  period_info?: {
    selected: string;
    days: number;
    start_date: string;
    end_date: string;
  };
  store_info: {
    name: string;
    plan: string;
    created_at: string;
  };
  financial: {
    total_invested: number;
    total_potential: number;
    profit_potential: number;
    total_revenue_30d: number;
    avg_ticket: number;
    margin_percent: number;
    real_profit?: number;
    cost_of_goods_sold?: number;
  };
  inventory: {
    total_products: number;
    total_stock: number;
    low_stock_count: number;
  };
  sales: {
    total_sales_30d: number;
    total_items_sold_30d: number;
    daily_sales: Array<{
      date: string;
      day_name: string;
      day_full?: string;
      revenue: number;
      quantity: number;
      profit?: number;
      cost?: number;
    }>;
    weekly_sales?: Array<{
      week: string;
      week_label?: string;
      revenue: number;
      quantity: number;
      profit: number;
      cost?: number;
    }>;
    monthly_comparison?: Array<{
      month: string;
      month_short?: string;
      revenue: number;
      profit: number;
      cost?: number;
      quantity?: number;
    }>;
  };
  charts: {
    by_category: Array<{
      category: string;
      total_products: number;
      total_quantity: number;
      total_value: number;
      percentage?: number;
      sales_revenue?: number;
      sales_quantity?: number;
      sales_percentage?: number;
    }>;
    top_products: Array<{
      name: string;
      id: number;
      total_sold: number;
      revenue: number;
      profit?: number;
      margin?: number;
    }>;
    performance_metrics?: {
      turnover_rate: number;
      stock_rotation_days: number;
      sell_through_rate: number;
      inventory_value?: number;
      inventory_cost?: number;
    };
  };
  alerts: {
    low_stock: Array<any>;
    expiring_soon: Array<any>;
  };
  // ✅ FLUXO DE CAIXA INTEGRADO
  cash_flow?: {
    total_income: number;
    total_expenses: number;
    net_flow: number;
    daily_average: number;
    growth_rate?: number;
    margin_percent?: number;
  };
}

interface CashFlowData {
  period: {
    selected: string;
    days: number;
    start_date: string;
    end_date: string;
  };
  summary: {
    total_income: number;
    total_expenses: number;
    net_flow: number;
    total_transactions: number;
    daily_average: number;
  };
  daily_flow: Array<{
    date: string;
    day_name: string;
    income: number;
    expenses: number;
    net_flow: number;
  }>;
}

export default function Dashboard() {
  const [data, setData] = useState<DashboardData | null>(null);
  const [cashFlowData, setCashFlowData] = useState<CashFlowData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedPeriod, setSelectedPeriod] = useState<'7d' | '30d' | '90d' | '180d'>('30d');

  useEffect(() => {
    loadDashboardData();
    loadCashFlowData();
  }, [selectedPeriod]);

  const loadDashboardData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      console.log('🔄 Carregando dashboard...');
      const response = await api.get(`/dashboard/overview/?period=${selectedPeriod}`);
      console.log('✅ Dados recebidos:', response.data);
      setData(response.data);
      
    } catch (err: any) {
      console.error('❌ Erro ao carregar dashboard:', err);
      setError(err.response?.data?.error || 'Erro ao carregar dados');
    } finally {
      setLoading(false);
    }
  };

  const loadCashFlowData = async () => {
    try {
      const response = await api.get(`/cash-flow/detailed/?period=${selectedPeriod}`);
      setCashFlowData(response.data);
    } catch (err: any) {
      console.error('❌ Erro ao carregar fluxo de caixa:', err);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="flex flex-col items-center gap-4">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
          <p className="text-sm text-muted-foreground">Carregando dashboard...</p>
        </div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="text-center p-8">
        <AlertTriangle className="h-12 w-12 text-destructive mx-auto mb-4" />
        <h3 className="text-lg font-semibold text-foreground mb-2">Erro ao carregar dashboard</h3>
        <p className="text-destructive mb-4">{error}</p>
        <button 
          onClick={loadDashboardData}
          className="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors"
        >
          Tentar Novamente
        </button>
      </div>
    );
  }

  const formatCurrency = (value: number) => 
    new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value || 0);

  const formatPercent = (value: number) => 
    `${(value || 0).toFixed(1)}%`;

  const formatNumber = (value: number) => 
    new Intl.NumberFormat('pt-BR').format(value || 0);

  return (
    <div className="space-y-6 p-6">
      {/* Header com Seletor de Período */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Dashboard Financeiro</h1>
          <p className="text-muted-foreground">
            {data.store_info.name} • Plano {data.store_info.plan.toUpperCase()}
            {data.period_info && ` • ${data.period_info.days} dias`}
          </p>
        </div>
        
        {/* ✅ SELETOR DE PERÍODO EXPANDIDO */}
        <div className="flex gap-2">
          {[
            { key: '7d', label: '7 dias' },
            { key: '30d', label: '30 dias' },
            { key: '90d', label: '90 dias' },
            { key: '180d', label: '6 meses' }
          ].map((period) => (
            <button
              key={period.key}
              onClick={() => setSelectedPeriod(period.key as any)}
              className={`px-3 py-1 rounded-md text-sm font-medium transition-colors ${
                selectedPeriod === period.key
                  ? 'bg-primary text-primary-foreground'
                  : 'bg-secondary text-secondary-foreground hover:bg-secondary/80'
              }`}
            >
              {period.label}
            </button>
          ))}
        </div>
      </div>

      {/* ✅ KPIs PRINCIPAIS - EXPANDIDO PARA 6 COLUNAS */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-6 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Receita Total</CardTitle>
            <DollarSign className="h-4 w-4 text-green-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">
              {formatCurrency(data.financial.total_revenue_30d)}
            </div>
            <p className="text-xs text-muted-foreground">
              {formatNumber(data.sales.total_sales_30d)} vendas
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Lucro Real</CardTitle>
            <TrendingUp className="h-4 w-4 text-blue-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-600">
              {formatCurrency(data.financial.real_profit || data.financial.profit_potential)}
            </div>
            <p className="text-xs text-muted-foreground">
              Margem: {formatPercent(data.financial.margin_percent || 0)}
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Investido</CardTitle>
            <TrendingDown className="h-4 w-4 text-red-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">
              {formatCurrency(data.financial.total_invested)}
            </div>
            <p className="text-xs text-muted-foreground">
              Custo dos produtos
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Ticket Médio</CardTitle>
            <Target className="h-4 w-4 text-purple-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-purple-600">
              {formatCurrency(data.financial.avg_ticket)}
            </div>
            <p className="text-xs text-muted-foreground">
              Por venda
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Giro Estoque</CardTitle>
            <Activity className="h-4 w-4 text-orange-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-orange-600">
              {data.charts.performance_metrics?.turnover_rate?.toFixed(1) || '0.0'}x
            </div>
            <p className="text-xs text-muted-foreground">
              Taxa de rotação
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Itens Vendidos</CardTitle>
            <Package className="h-4 w-4 text-teal-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-teal-600">
              {formatNumber(data.sales.total_items_sold_30d)}
            </div>
            <p className="text-xs text-muted-foreground">
              Unidades no período
            </p>
          </CardContent>
        </Card>
      </div>

      {/* ✅ NOVO: Gráfico de Fluxo de Caixa */}
      {cashFlowData && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <ArrowUpDown className="h-5 w-5" />
              Fluxo de Caixa Diário
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={320}>
              <ComposedChart data={cashFlowData.daily_flow}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="day_name" />
                <YAxis />
                <Tooltip formatter={(value: any) => [formatCurrency(value), '']} />
                <Area 
                  type="monotone" 
                  dataKey="income" 
                  fill="#10B981" 
                  fillOpacity={0.6}
                  name="Receitas"
                />
                <Area 
                  type="monotone" 
                  dataKey="expenses" 
                  fill="#EF4444" 
                  fillOpacity={0.6}
                  name="Despesas"
                />
                <Line 
                  type="monotone" 
                  dataKey="net_flow" 
                  stroke="#3B82F6" 
                  strokeWidth={3}
                  name="Fluxo Líquido"
                />
              </ComposedChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      )}

      {/* ✅ GRÁFICOS PRINCIPAIS MELHORADOS - 2 COLUNAS */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        
        {/* ✅ Gráfico de Vendas por Semana - MELHORADO */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <BarChart3 className="h-5 w-5" />
              Vendas por Semana
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={320}>
              <ComposedChart data={data.sales.weekly_sales || []}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="week" />
                <YAxis yAxisId="left" />
                <YAxis yAxisId="right" orientation="right" />
                <Tooltip 
                  formatter={(value: any, name: string) => [
                    name === 'revenue' ? formatCurrency(value) : 
                    name === 'profit' ? formatCurrency(value) : 
                    name === 'cost' ? formatCurrency(value) : formatNumber(value),
                    name === 'revenue' ? 'Receita' : 
                    name === 'profit' ? 'Lucro' : 
                    name === 'cost' ? 'Custo' : 'Quantidade'
                  ]}
                />
                <Bar yAxisId="left" dataKey="revenue" fill="#10B981" name="revenue" />
                <Bar yAxisId="left" dataKey="cost" fill="#EF4444" name="cost" />
                <Line yAxisId="right" type="monotone" dataKey="quantity" stroke="#8B5CF6" strokeWidth={3} name="quantity" />
              </ComposedChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* ✅ Gráfico de Rosca - Vendas por Categoria */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <PieChart className="h-5 w-5" />
              Vendas por Categoria
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={320}>
              <RechartsPieChart>
                <Pie
                  data={data.charts.by_category.filter(cat => cat.total_value > 0)}
                  cx="50%"
                  cy="50%"
                  innerRadius={60}
                  outerRadius={120}
                  paddingAngle={5}
                  dataKey="total_value"
                >
                  {data.charts.by_category.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={CHART_COLORS[index % CHART_COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip 
                  formatter={(value: any) => [formatCurrency(value), 'Valor']}
                  labelFormatter={(label) => `${label}`}
                />
              </RechartsPieChart>
            </ResponsiveContainer>
            {/* ✅ LEGENDA PERSONALIZADA */}
            <div className="mt-4 grid grid-cols-2 gap-2 text-sm">
              {data.charts.by_category.slice(0, 6).map((cat, index) => (
                <div key={cat.category} className="flex items-center gap-2">
                  <div 
                    className="w-3 h-3 rounded-full" 
                    style={{ backgroundColor: CHART_COLORS[index % CHART_COLORS.length] }}
                  />
                  <span className="truncate">{cat.category}</span>
                  <span className="text-muted-foreground">
                    {formatPercent(cat.percentage || 0)}
                  </span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ✅ GRÁFICO DE EVOLUÇÃO MENSAL - LARGURA COMPLETA */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <TrendingUp className="h-5 w-5" />
            Evolução Mensal - Receita vs Lucro vs Custos
          </CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={400}>
            <ComposedChart data={data.sales.monthly_comparison || []}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month_short" />
              <YAxis yAxisId="left" />
              <YAxis yAxisId="right" orientation="right" />
              <Tooltip 
                formatter={(value: any, name: string) => [
                  name === 'quantity' ? formatNumber(value) : formatCurrency(value),
                  name === 'revenue' ? 'Receita' : 
                  name === 'profit' ? 'Lucro' : 
                  name === 'cost' ? 'Custo' : 'Quantidade'
                ]}
              />
              <Area 
                yAxisId="left"
                type="monotone" 
                dataKey="revenue" 
                fill="#10B981" 
                fillOpacity={0.3}
                name="revenue"
              />
              <Area 
                yAxisId="left"
                type="monotone" 
                dataKey="cost" 
                fill="#EF4444" 
                fillOpacity={0.3}
                name="cost"
              />
              <Line 
                yAxisId="left"
                type="monotone" 
                dataKey="profit" 
                stroke="#3B82F6" 
                strokeWidth={3}
                name="profit"
              />
              <Line 
                yAxisId="right"
                type="monotone" 
                dataKey="quantity" 
                stroke="#8B5CF6" 
                strokeWidth={2}
                strokeDasharray="5 5"
                name="quantity"
              />
            </ComposedChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* ✅ MÉTRICAS AVANÇADAS - 3 COLUNAS */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* ✅ Análise Financeira Expandida */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <DollarSign className="h-5 w-5" />
              Análise Financeira
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Capital Investido</span>
              <span className="font-bold text-red-600">{formatCurrency(data.financial.total_invested)}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Receita Potencial</span>
              <span className="font-bold text-green-600">{formatCurrency(data.financial.total_potential)}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Lucro Potencial</span>
              <span className="font-bold text-blue-600">{formatCurrency(data.financial.profit_potential)}</span>
            </div>
            <div className="pt-2 border-t">
              <div className="flex justify-between items-center">
                <span className="text-sm font-medium">ROI Potencial</span>
                <span className="font-bold text-purple-600">
                  {formatPercent((data.financial.profit_potential / Math.max(data.financial.total_invested, 1)) * 100)}
                </span>
              </div>
            </div>
            {/* ✅ NOVO: Fluxo de Caixa Resumido */}
            {data.cash_flow && (
              <div className="pt-2 border-t">
                <div className="flex justify-between items-center">
                  <span className="text-sm font-medium">Fluxo Líquido</span>
                  <span className={`font-bold ${data.cash_flow.net_flow >= 0 ? 'text-green-600' : 'text-red-600'}`}>
                    {formatCurrency(data.cash_flow.net_flow)}
                  </span>
                </div>
              </div>
            )}
          </CardContent>
        </Card>

        {/* ✅ Performance de Estoque Expandida */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Package className="h-5 w-5" />
              Performance de Estoque
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Produtos Ativos</span>
              <span className="font-bold">{data.inventory.total_products}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Unidades Totais</span>
              <span className="font-bold">{data.inventory.total_stock}</span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Giro Médio</span>
              <span className="font-bold text-blue-600">
                {data.charts.performance_metrics?.turnover_rate?.toFixed(1) || '0.0'}x/mês
              </span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Taxa de Conversão</span>
              <span className="font-bold text-orange-600">
                {formatPercent(data.charts.performance_metrics?.sell_through_rate || 0)}
              </span>
            </div>
            <div className="pt-2 border-t">
              <div className="flex justify-between items-center">
                <span className="text-sm font-medium">Eficiência</span>
                <span className="font-bold text-green-600">
                  {formatPercent(((data.inventory.total_products - data.inventory.low_stock_count) / Math.max(data.inventory.total_products, 1)) * 100)}
                </span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* ✅ Gestão de Riscos */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <AlertTriangle className="h-5 w-5" />
              Gestão de Riscos
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Estoque Baixo</span>
              <span className={`font-bold ${data.alerts.low_stock.length > 0 ? 'text-orange-600' : 'text-green-600'}`}>
                {data.alerts.low_stock.length}
              </span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Vencendo em Breve</span>
              <span className={`font-bold ${data.alerts.expiring_soon.length > 0 ? 'text-red-600' : 'text-green-600'}`}>
                {data.alerts.expiring_soon.length}
              </span>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">Risco Total</span>
              <span className="font-bold text-purple-600">
                {data.alerts.low_stock.length + data.alerts.expiring_soon.length > 5 ? 'Alto' : 
                 data.alerts.low_stock.length + data.alerts.expiring_soon.length > 2 ? 'Médio' : 'Baixo'}
              </span>
            </div>
            {/* ✅ NOVO: Indicador de Saúde Geral */}
            <div className="pt-2 border-t">
              <div className="flex justify-between items-center">
                <span className="text-sm font-medium">Saúde Geral</span>
                <span className="font-bold text-blue-600">
                  {data.financial.margin_percent && data.financial.margin_percent > 20 ? 'Excelente' :
                   data.financial.margin_percent && data.financial.margin_percent > 10 ? 'Boa' : 'Regular'}
                </span>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* ✅ GRÁFICO DE VENDAS DIÁRIAS - MELHORADO */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <LineChart className="h-5 w-5" />
            Vendas dos Últimos 7 Dias
          </CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <ComposedChart data={data.sales.daily_sales}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="day_name" />
              <YAxis yAxisId="left" />
              <YAxis yAxisId="right" orientation="right" />
              <Tooltip 
                formatter={(value: any, name: string) => [
                  name === 'revenue' || name === 'profit' ? formatCurrency(value) : `${value} itens`,
                  name === 'revenue' ? 'Receita' : 
                  name === 'profit' ? 'Lucro' : 'Quantidade'
                ]}
              />
              <Bar yAxisId="left" dataKey="revenue" fill="#10B981" name="revenue" />
              {data.sales.daily_sales[0]?.profit !== undefined && (
                <Bar yAxisId="left" dataKey="profit" fill="#3B82F6" name="profit" />
              )}
              <Line 
                yAxisId="right"
                type="monotone" 
                dataKey="quantity" 
                stroke="#8B5CF6" 
                strokeWidth={3}
                dot={{ fill: '#8B5CF6', strokeWidth: 2, r: 4 }}
                name="quantity"
              />
            </ComposedChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* ✅ TOP PRODUTOS COM GRÁFICO HORIZONTAL MELHORADO */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <TrendingUp className="h-5 w-5" />
            Top 5 Produtos Mais Vendidos
          </CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart 
              data={data.charts.top_products.slice(0, 5)} 
              layout="horizontal"
              margin={{ top: 5, right: 30, left: 20, bottom: 5 }}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis type="number" />
              <YAxis dataKey="name" type="category" width={150} />
              <Tooltip 
                formatter={(value: any, name: string) => [
                  name === 'revenue' ? formatCurrency(value) : `${value} vendidos`,
                  name === 'revenue' ? 'Receita' : 'Quantidade'
                ]}
              />
              <Bar dataKey="revenue" fill="#8884d8" name="revenue" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* Alertas Visuais */}
      {(data.alerts.low_stock.length > 0 || data.alerts.expiring_soon.length > 0) && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Estoque Baixo */}
          {data.alerts.low_stock.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-orange-600">
                  <AlertTriangle className="h-5 w-5" />
                  Estoque Baixo ({data.alerts.low_stock.length})
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {data.alerts.low_stock.slice(0, 5).map((item: any) => (
                    <div key={item.id} className="flex items-center justify-between p-3 rounded-lg bg-orange-50 border border-orange-200">
                      <div>
                        <div className="font-medium text-sm">{item.product_name}</div>
                        <div className="text-xs text-muted-foreground">
                          Mín: {item.min_stock} • Atual: {item.current_stock}
                        </div>
                      </div>
                      <div className={`px-2 py-1 rounded-full text-xs font-medium ${
                        item.status === 'critical' 
                          ? 'bg-red-100 text-red-800' 
                          : 'bg-orange-100 text-orange-800'
                      }`}>
                        {item.status === 'critical' ? 'Crítico' : 'Atenção'}
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {/* Produtos Vencendo */}
          {data.alerts.expiring_soon.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2 text-red-600">
                  <Calendar className="h-5 w-5" />
                  Vencendo em Breve ({data.alerts.expiring_soon.length})
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {data.alerts.expiring_soon.slice(0, 5).map((item: any) => (
                    <div key={item.id} className="flex items-center justify-between p-3 rounded-lg bg-red-50 border border-red-200">
                      <div>
                        <div className="font-medium text-sm">{item.product_name}</div>
                        <div className="text-xs text-muted-foreground">
                          Lote: {item.batch_code} • {item.quantity} unidades
                        </div>
                      </div>
                      <div className="text-right">
                        <div className="text-sm font-medium text-red-600">
                          {item.days_to_expire} dias
                        </div>
                        <div className="text-xs text-muted-foreground">
                          {new Date(item.expiration_date).toLocaleDateString('pt-BR')}
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}
        </div>
      )}
    </div>
  );
}