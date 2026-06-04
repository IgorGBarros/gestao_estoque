// lib/leads.ts
import { api } from "../services/api";

export interface LeadInput {
  tenant_id: string;
  name: string;
  phone: string; // formato E.164: 5571999999999
  whatsapp_opt_in: boolean;
  source?: "storefront" | "dashboard";
  consent_version?: string;
}

export interface Lead {
  id: string;
  tenant_id: string;
  name: string;
  phone: string;
  whatsapp_opt_in: boolean;
  created_at: string;
  last_seen: string;
  total_orders: number;
  total_spent: number;
}

// 🔹 Upsert: cria ou atualiza lead por telefone (deduplicação)
export async function upsertLead(input: LeadInput): Promise<Lead> {
  const response = await api.post("/api/crm/leads/upsert", {
    ...input,
    phone: input.phone.replace(/\D/g, ""), // normaliza
    consent_timestamp: new Date().toISOString(),
  });
  return response.data;
}

// 🔹 LGPD: Exportar dados do lead (portabilidade)
export async function exportLeadData(leadId: string): Promise<Blob> {
  const response = await api.get(`/api/crm/leads/${leadId}/export`, { responseType: 'blob' });
  return response.data;
}

// 🔹 LGPD: Anonimizar lead (direito ao esquecimento)
export async function anonymizeLead(leadId: string): Promise<void> {
  await api.post(`/api/crm/leads/${leadId}/anonymize`);
}