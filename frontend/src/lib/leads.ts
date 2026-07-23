// lib/leads.ts
import { api } from "../services/api";

// 🔹 Interface Lead completa com todos os campos usados no CRM
export interface Lead {
  id: string;
  tenant_id: string;
  name: string;
  phone: string;
  email?: string | null;              // ✅ Campo adicionado
  whatsapp_opt_in: boolean;
  created_at: string;
  last_seen: string;
  total_orders: number;
  total_spent: number;
  anonymized_at?: string | null;      // ✅ Campo adicionado para LGPD
  tags?: string[];
  source?: "storefront" | "dashboard";
  consent_version?: string;
  consent_timestamp?: string;
}

export interface LeadInput {
  tenant_id: string;
  name: string;
  phone: string;
  whatsapp_opt_in: boolean;
  email?: string;
  source?: "storefront" | "dashboard";
  consent_version?: string;
}

export interface CartItemInput {
  inventory_id: string;
  product_name: string;
  quantity: number;
  price_snapshot: number;
}

export interface PersistCartInput {
  tenant_id: string;
  session_id: string;
  lead_id?: string;
  checked_out: boolean;
  items: CartItemInput[];
}

// 🔹 LISTAR LEADS por tenant
export async function listLeads(tenantId: string): Promise<Lead[]> {
  const response = await api.get(`/api/crm/leads`, {
    params: { tenant_id: tenantId },
  });
  return response.data;
}

// 🔹 OBTER UM LEAD por ID
export async function getLead(leadId: string): Promise<Lead> {
  const response = await api.get(`/api/crm/leads/${leadId}`);
  return response.data;
}

// 🔹 UPSERT LEAD (cria ou atualiza por phone + tenant_id)
export async function upsertLead(input: LeadInput): Promise<Lead> {
  const response = await api.post("/api/crm/leads/upsert", {
    ...input,
    phone: input.phone.replace(/\D/g, ""),
    consent_timestamp: new Date().toISOString(),
  });
  return response.data;
}

// 🔹 ANONIMIZAR LEAD (LGPD - Direito ao Esquecimento)
export async function anonymizeLead(leadId: string): Promise<void> {
  await api.post(`/api/crm/leads/${leadId}/anonymize`);
}

// 🔹 EXCLUIR LEAD (exclusão lógica ou física, conforme política)
export async function deleteLead(leadId: string): Promise<void> {
  await api.delete(`/api/crm/leads/${leadId}`);
}

// 🔹 EXPORTAR LEADS PARA CSV (portabilidade de dados - LGPD)
export function exportLeadsCsv(leads: Lead[]): string {
  const headers = [
    "ID",
    "Nome",
    "Telefone",
    "Email",
    "Opt-in WhatsApp",
    "Criado em",
    "Última Visita",
    "Pedidos",
    "Total Gasto",
    "Anonimizado em",
    "Tags",
  ];

  const rows = leads.map((l) => [
    l.id,
    `"${l.name.replace(/"/g, '""')}"`, // escape aspas para CSV
    l.phone,
    l.email || "",
    l.whatsapp_opt_in ? "Sim" : "Não",
    new Date(l.created_at).toLocaleDateString("pt-BR"),
    new Date(l.last_seen).toLocaleDateString("pt-BR"),
    l.total_orders,
    (Number(l.total_spent) || 0).toFixed(2),
    l.anonymized_at ? new Date(l.anonymized_at).toLocaleDateString("pt-BR") : "",
    l.tags?.join(", ") || "",
  ]);

  return [headers.join(","), ...rows.map((r) => r.join(","))].join("\n");
}

// 🔹 DOWNLOAD DE ARQUIVO CSV (utilitário genérico)
export function downloadCsv(filename: string, content: string): void {
  const blob = new Blob([content], { type: "text/csv;charset=utf-8;" });
  const link = document.createElement("a");
  const url = URL.createObjectURL(blob);
  link.setAttribute("href", url);
  link.setAttribute("download", filename);
  link.style.visibility = "hidden";
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}

// 🔹 PERSISTIR CARRINHO (vincula sessão/lead ao carrinho)
export async function persistCart(input: PersistCartInput): Promise<void> {
  await api.post("/api/crm/carts/persist", input);
}

// 🔹 UTILITÁRIO: Gerar session_id único por loja/visitante
export function getOrCreateSessionId(storeSlug: string): string {
  const key = `session_${storeSlug}`;
  let sessionId = localStorage.getItem(key);
  if (!sessionId) {
    sessionId = `${storeSlug}_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
    localStorage.setItem(key, sessionId);
  }
  return sessionId;
}