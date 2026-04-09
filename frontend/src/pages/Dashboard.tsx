// components/Dashboard.tsx - VERSÃO CORRIGIDA COM FLUXO DE CAIXA

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
  Wallet
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
  Pie
} from 'recharts';
import { api } from '../services/api';

// Cores para gráficos
const CHART_COLORS = ['#8884d8', '#82ca9d', '#ffc658', '#ff7c7c', '#8dd1e1', '#d084d0'];

interface DashboardData {
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
      revenue: number;
      quantity: number;
    }>;
    weekly_sales: Array<{
      week: string;
      revenue: number;
      quantity: number;
      profit: number;
    }>;
    monthly_comparison: Array<{
      month: string;
      revenue: number;
      profit: number;
    }>;
  };
  charts: {
    by_category: Array<{
      category: string;
      total_products: number;
      total_quantity: number;
      total_value: number;
      percentage: number;
    }>;
    top_products: Array<{
      name: string;
      id: number;
      total_sold: number;
      revenue: number;
      profit: number;
    }>;
    performance_metrics: {
      turnover_rate: number;
      stock_rotation_days: number;
      sell_through_rate: number;
    };
  };
  alerts: {
    low_stock: Array<any>;
    expiring_soon: Array<any>;
  };
  // ✅ NOVO: Fluxo de caixa
  cash_flow: {
    total_income: number;
    total_expenses: number;
    net_flow: number;
    daily_average: number;
    growth_rate: number;
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
  const [selectedPeriod, setSelectedPeriod] = useState<'7d' | '30d' | '90d'>('30d');

  useEffect(() => {
    loadDashboardData();
    loadCashFlowData();
  }, [selectedPeriod]);

  const loadDashboardData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      const response = await api.get(`/dashboard/overview/?period=${selectedPeriod}`);
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
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (error || !data) {
    return (
      <div className="text-center p-8">
        <AlertTriangle className="h-12 w-12 text-destructive mx-auto mb-4" />
        <p className="text-destructive">{error}</p>
        <button onClick={loadDashboardData} className="mt-4 px-4 py-2 bg-primary text-primary-foreground rounded-md">
          Tentar Novamente
        </button>
      </div>
    );
  }

  const formatCurrency = (value: number) => 
    new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value || 0);

  const formatPercent = (value: number) => 
    `${(value || 0).toFixed(1)}%`;

  return (
    <div className="space-y-6 p-6">
      {/* Header com Seletor de Período */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-foreground">Dashboard</h1>
          <p className="text-muted-foreground">
            {data.store_info.name} • Plano {data.store_info.plan.toUpperCase()}
          </p>
        </div>
        
        {/* Seletor de Período */}
        <div className="flex gap-2">
          {[
            { key: '7d', label: '7 dias' },
            { key: '30d', label: '30 dias' },
            { key: '90d', label: '90 dias' }
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

      {/* KPIs Principais */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Receita ({selectedPeriod})</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">
              {formatCurrency(data.financial.total_revenue_30d)}
            </div>
            <p className="text-xs text-muted-foreground">
              {data.sales.total_sales_30d} vendas • Ticket médio: {formatCurrency(data.financial.avg_ticket)}
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Lucro Potencial</CardTitle>
            <Target className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-600">
              {formatCurrency(data.financial.profit_potential)}
            </div>
            <p className="text-xs text-muted-foreground">
              Margem: {formatPercent(data.financial.margin_percent || 0)}
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Giro de Estoque</CardTitle>
            <BarChart3 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-purple-600">
              {data.charts.performance_metrics?.turnover_rate?.toFixed(1) || '0.0'}x
            </div>
            <p className="text-xs text-muted-foreground">
              Rotação a cada {data.charts.performance_metrics?.stock_rotation_days || 0} dias
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Taxa de Conversão</CardTitle>
            <Percent className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-orange-600">
              {formatPercent(data.charts.performance_metrics?.sell_through_rate || 0)}
            </div>
            <p className="text-xs text-muted-foreground">
              Produtos vendidos vs estoque
            </p>
          </CardContent>
        </Card>

        {/* ✅ NOVO: Card de Fluxo de Caixa */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Fluxo de Caixa</CardTitle>
            <Wallet className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className={`text-2xl font-bold ${
              data.cash_flow.net_flow >= 0 ? 'text-green-600' : 'text-red-600'
            }`}>
              {formatCurrency(data.cash_flow.net_flow)}
            </div>
            <p className="text-xs text-muted-foreground">
              Média diária: {formatCurrency(data.cash_flow.daily_average)}
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
            <ResponsiveContainer width="100%" height={300}>
              <AreaChart data={cashFlowData.daily_flow}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="day_name" />
                <YAxis />
                <Tooltip formatter={(value: any) => [formatCurrency(value), '']} />
                <Area 
                  type="monotone" 
                  dataKey="income" 
                  stackId="1" 
                  stroke="#10B981" 
                  fill="#10B981" 
                  fillOpacity={0.6}
                  name="Receitas"
                />
                <Area 
                  type="monotone" 
                  dataKey="expenses" 
                  stackId="2" 
                  stroke="#EF4444" 
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
              </AreaChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      )}

      {/* Gráficos Principais */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* ✅ CORRIGIDO: Gráfico de Vendas por Semana */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <BarChart3 className="h-5 w-5" />
              Vendas por Semana
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={data.sales.weekly_sales || []}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="week" />
                <YAxis />
                <Tooltip 
                  formatter={(value: any, name: string) => [
                    name === 'revenue' ? formatCurrency(value) : 
                    name === 'profit' ? formatCurrency(value) : value,
                    name === 'revenue' ? 'Receita' : 
                    name === 'profit' ? 'Lucro' : 'Quantidade'
                  ]}
                />
                <Bar dataKey="revenue" fill="#8884d8" name="revenue" />
                <Bar dataKey="profit" fill="#82ca9d" name="profit" />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Gráfico de Pizza - Vendas por Categoria */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <PieChart className="h-5 w-5" />
              Vendas por Categoria
            </CardTitle>
          </CardHeader>
          <CardContent>
            <ResponsiveContainer width="100%" height={300}>
              <RechartsPieChart>
                <Pie
                  data={data.charts.by_category}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  label={({ category, percentage }) => `${category} (${percentage?.toFixed(1)}%)`}
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="total_value"
                >
                  {data.charts.by_category.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={CHART_COLORS[index % CHART_COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip formatter={(value: any) => [formatCurrency(value), 'Valor']} />
              </RechartsPieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Gráfico de Linha - Evolução Mensal */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <TrendingUp className="h-5 w-5" />
            Evolução de Receita e Lucro
          </CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={400}>
            <AreaChart data={data.sales.monthly_comparison}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip formatter={(value: any) => [formatCurrency(value), '']} />
              <Area 
                type="monotone" 
                dataKey="revenue" 
                stackId="1" 
                stroke="#8884d8" 
                fill="#8884d8" 
                fillOpacity={0.6}
                name="Receita"
              />
              <Area 
                type="monotone" 
                dataKey="profit" 
                stackId="1" 
                stroke="#82ca9d" 
                fill="#82ca9d" 
                fillOpacity={0.6}
                name="Lucro"
              />
            </AreaChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* Métricas Avançadas */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        {/* Análise Financeira */}
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
          </CardContent>
        </Card>

        {/* Performance de Estoque */}
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

        {/* Alertas e Riscos */}
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
          </CardContent>
        </Card>
      </div>

      {/* Gráfico de Vendas Diárias */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <LineChart className="h-5 w-5" />
            Vendas dos Últimos 7 Dias
          </CardTitle>
        </CardHeader>
        <CardContent>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={data.sales.daily_sales}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="day_name" />
              <YAxis />
              <Tooltip 
                formatter={(value: any, name: string) => [
                  name === 'revenue' ? formatCurrency(value) : `${value} itens`,
                  name === 'revenue' ? 'Receita' : 'Quantidade'
                ]}
              />
              <Line 
                type="monotone" 
                dataKey="revenue" 
                stroke="#8884d8" 
                strokeWidth={3}
                dot={{ fill: '#8884d8', strokeWidth: 2, r: 4 }}
                name="revenue"
              />
              <Line 
                type="monotone" 
                dataKey="quantity" 
                stroke="#82ca9d" 
                strokeWidth={2}
                dot={{ fill: '#82ca9d', strokeWidth: 2, r: 3 }}
                name="quantity"
              />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* Top Produtos com Gráfico de Barras Horizontal */}
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