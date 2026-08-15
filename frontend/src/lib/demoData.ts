/**
 * Demo/mock data for the test account (demo-token).
 * Provides realistic Natura product examples so all pages render with content.
 */

import type { InventoryItem, Movement, Profile, InventoryBatch } from "../lib/api";

// ── Inventory Items ──
export const DEMO_INVENTORY: InventoryItem[] = [
  {
    id: "d1", barcode: "7891033784561", product_name: "Kaiak Tradicional Masculino 100ml", custom_name: null, category: "Perfumaria",
    quantity: 12, min_quantity: 5, cost_price: 78.90, sale_price: 134.90, official_price: 134.90,
    sale_type: null, expiry_date: "2026-08-15", expiry_photo_url: null, image_url: null, sku: "83451",
    is_available_storefront: true, created_at: "2025-11-01T10:00:00Z", updated_at: "2026-02-20T14:00:00Z",
  },
  {
    id: "d2", barcode: "7891033619283", product_name: "Luna Intenso Feminino 50ml", custom_name: null, category: "Perfumaria",
    quantity: 8, min_quantity: 3, cost_price: 115.00, sale_price: 189.90, official_price: 189.90,
    sale_type: null, expiry_date: "2027-01-10", expiry_photo_url: null, image_url: null, sku: "74320",
    is_available_storefront: true, created_at: "2025-12-05T09:30:00Z", updated_at: "2026-03-01T11:00:00Z",
  },
  {
    id: "d3", barcode: "7891033055012", product_name: "Tododia Cereja e Avelã 400ml", custom_name: null, category: "Corpo",
    quantity: 3, min_quantity: 5, cost_price: 22.50, sale_price: 39.90, official_price: 39.90,
    sale_type: null, expiry_date: "2026-06-20", expiry_photo_url: null, image_url: null, sku: "41256",
    is_available_storefront: true, created_at: "2025-10-15T08:00:00Z", updated_at: "2026-02-28T16:00:00Z",
  },
  {
    id: "d4", barcode: "7891033032891", product_name: "Chronos Antissinais 30+ 30ml", custom_name: null, category: "Rosto",
    quantity: 6, min_quantity: 3, cost_price: 55.00, sale_price: 94.90, official_price: 94.90,
    sale_type: null, expiry_date: "2026-05-30", expiry_photo_url: null, image_url: null, sku: "62104",
    is_available_storefront: true, created_at: "2025-11-20T07:15:00Z", updated_at: "2026-01-15T10:00:00Z",
  },
  {
    id: "d5", barcode: "7891033047210", product_name: "Lumina Shampoo Cabelos Lisos 300ml", custom_name: null, category: "Cabelos",
    quantity: 15, min_quantity: 8, cost_price: 18.00, sale_price: 32.90, official_price: 32.90,
    sale_type: null, expiry_date: "2026-12-01", expiry_photo_url: null, image_url: null, sku: "50312",
    is_available_storefront: false, created_at: "2026-01-10T13:00:00Z", updated_at: "2026-03-05T09:00:00Z",
  },
  {
    id: "d6", barcode: "7891033091205", product_name: "Faces Batom Hidratante Rosa Natural", custom_name: null, category: "Maquiagem",
    quantity: 2, min_quantity: 4, cost_price: 12.50, sale_price: 21.90, official_price: 21.90,
    sale_type: null, expiry_date: "2026-04-10", expiry_photo_url: null, image_url: null, sku: "33087",
    is_available_storefront: true, created_at: "2025-09-08T11:00:00Z", updated_at: "2026-02-10T08:00:00Z",
  },
  {
    id: "d7", barcode: "7891033102301", product_name: "Ekos Castanha Sabonete Líquido 250ml", custom_name: null, category: "Corpo",
    quantity: 20, min_quantity: 10, cost_price: 15.90, sale_price: 28.90, official_price: 28.90,
    sale_type: null, expiry_date: "2027-03-15", expiry_photo_url: null, image_url: null, sku: "80145",
    is_available_storefront: true, created_at: "2026-01-20T10:30:00Z", updated_at: "2026-03-06T14:30:00Z",
  },
  {
    id: "d8", barcode: "7891033088901", product_name: "Essencial Exclusivo Masculino 100ml", custom_name: null, category: "Perfumaria",
    quantity: 4, min_quantity: 3, cost_price: 95.00, sale_price: 159.90, official_price: 159.90,
    sale_type: null, expiry_date: "2027-06-01", expiry_photo_url: null, image_url: null, sku: "71503",
    is_available_storefront: true, created_at: "2025-12-12T15:00:00Z", updated_at: "2026-02-25T12:00:00Z",
  },
  {
    id: "d9", barcode: "7891033076543", product_name: "Plant Gel de Limpeza Facial 150ml", custom_name: null, category: "Rosto",
    quantity: 1, min_quantity: 3, cost_price: 25.00, sale_price: 44.90, official_price: 44.90,
    sale_type: null, expiry_date: "2026-04-25", expiry_photo_url: null, image_url: null, sku: "59821",
    is_available_storefront: false, created_at: "2025-10-01T09:00:00Z", updated_at: "2026-03-02T11:00:00Z",
  },
  {
    id: "d10", barcode: "7891033065432", product_name: "Natura Homem Desodorante Spray 100ml", custom_name: null, category: "Corpo",
    quantity: 25, min_quantity: 10, cost_price: 14.00, sale_price: 24.90, official_price: 24.90,
    sale_type: null, expiry_date: "2027-02-28", expiry_photo_url: null, image_url: null, sku: "44890",
    is_available_storefront: true, created_at: "2026-02-01T08:00:00Z", updated_at: "2026-03-07T16:00:00Z",
  },
  {
    id: "d11", barcode: "7891033054321", product_name: "Aquarela Shine Gloss Labial 5ml", custom_name: null, category: "Maquiagem",
    quantity: 10, min_quantity: 5, cost_price: 16.00, sale_price: 29.90, official_price: 29.90,
    sale_type: null, expiry_date: "2026-09-15", expiry_photo_url: null, image_url: null, sku: "28756",
    is_available_storefront: true, created_at: "2026-01-05T14:00:00Z", updated_at: "2026-03-04T10:00:00Z",
  },
  {
    id: "d12", barcode: "7891033043210", product_name: "Ekos Maracujá Óleo Trifásico 150ml", custom_name: null, category: "Corpo",
    quantity: 7, min_quantity: 4, cost_price: 32.00, sale_price: 54.90, official_price: 54.90,
    sale_type: null, expiry_date: "2026-11-20", expiry_photo_url: null, image_url: null, sku: "67203",
    is_available_storefront: true, created_at: "2025-11-28T12:00:00Z", updated_at: "2026-02-18T09:00:00Z",
  },
];

// ── Movements ──
export const DEMO_MOVEMENTS: Movement[] = [
  // Entradas (últimos meses)
  { id: "m1", product_name: "Kaiak Tradicional Masculino 100ml", transaction_type: "ENTRADA", quantity: 10, unit_price: 78.90, notes: "Pedido ciclo 01/2026", created_at: "2026-01-05T10:00:00Z" },
  { id: "m2", product_name: "Luna Intenso Feminino 50ml", transaction_type: "ENTRADA", quantity: 5, unit_price: 115.00, notes: "Pedido ciclo 01/2026", created_at: "2026-01-05T10:05:00Z" },
  { id: "m3", product_name: "Lumina Shampoo Cabelos Lisos 300ml", transaction_type: "ENTRADA", quantity: 15, unit_price: 18.00, notes: "Pedido ciclo 02/2026", created_at: "2026-02-03T09:00:00Z" },
  { id: "m4", product_name: "Ekos Castanha Sabonete Líquido 250ml", transaction_type: "ENTRADA", quantity: 20, unit_price: 15.90, notes: "Reposição", created_at: "2026-02-10T11:00:00Z" },
  { id: "m5", product_name: "Natura Homem Desodorante Spray 100ml", transaction_type: "ENTRADA", quantity: 30, unit_price: 14.00, notes: "Pedido ciclo 03/2026", created_at: "2026-03-01T08:30:00Z" },
  { id: "m6", product_name: "Kaiak Tradicional Masculino 100ml", transaction_type: "ENTRADA", quantity: 5, unit_price: 78.90, notes: "Reposição", created_at: "2026-02-15T14:00:00Z" },

  // Saídas — vendas
  { id: "m10", product_name: "Kaiak Tradicional Masculino 100ml", transaction_type: "VENDA", quantity: -3, unit_price: 134.90, notes: "Cliente Maria", created_at: "2026-01-20T16:00:00Z" },
  { id: "m11", product_name: "Luna Intenso Feminino 50ml", transaction_type: "VENDA", quantity: -2, unit_price: 189.90, notes: "Cliente Ana", created_at: "2026-01-25T18:00:00Z" },
  { id: "m12", product_name: "Lumina Shampoo Cabelos Lisos 300ml", transaction_type: "VENDA", quantity: -3, unit_price: 32.90, notes: null, created_at: "2026-02-14T10:00:00Z" },
  { id: "m13", product_name: "Ekos Castanha Sabonete Líquido 250ml", transaction_type: "VENDA", quantity: -5, unit_price: 28.90, notes: "Kit presente", created_at: "2026-02-20T15:00:00Z" },
  { id: "m14", product_name: "Natura Homem Desodorante Spray 100ml", transaction_type: "VENDA", quantity: -5, unit_price: 24.90, notes: null, created_at: "2026-03-05T12:00:00Z" },
  { id: "m15", product_name: "Essencial Exclusivo Masculino 100ml", transaction_type: "VENDA", quantity: -1, unit_price: 159.90, notes: "Cliente João", created_at: "2026-03-03T17:00:00Z" },

  // Vendas esta semana (2-8 março 2026) para milestone + top semanal
  { id: "m16", product_name: "Kaiak Tradicional Masculino 100ml", transaction_type: "VENDA", quantity: -2, unit_price: 134.90, notes: "Cliente Pedro", created_at: "2026-03-06T10:00:00Z" },
  { id: "m17", product_name: "Luna Intenso Feminino 50ml", transaction_type: "VENDA", quantity: -1, unit_price: 189.90, notes: "Cliente Carla", created_at: "2026-03-06T15:00:00Z" },
  { id: "m18", product_name: "Chronos Antissinais 30+ 30ml", transaction_type: "VENDA", quantity: -3, unit_price: 94.90, notes: "Kit skincare", created_at: "2026-03-07T09:30:00Z" },
  { id: "m19", product_name: "Ekos Maracujá Óleo Trifásico 150ml", transaction_type: "VENDA", quantity: -2, unit_price: 54.90, notes: null, created_at: "2026-03-07T14:00:00Z" },
  { id: "m24", product_name: "Aquarela Shine Gloss Labial 5ml", transaction_type: "VENDA", quantity: -4, unit_price: 29.90, notes: "Revenda loja", created_at: "2026-03-08T08:00:00Z" },
  { id: "m25", product_name: "Ekos Castanha Sabonete Líquido 250ml", transaction_type: "VENDA", quantity: -3, unit_price: 28.90, notes: null, created_at: "2026-03-08T11:00:00Z" },

  // Saídas — outros tipos
  { id: "m20", product_name: "Tododia Cereja e Avelã 400ml", transaction_type: "PRESENTE", quantity: -2, unit_price: null, notes: "Presente mãe", created_at: "2026-02-08T09:00:00Z" },
  { id: "m21", product_name: "Faces Batom Hidratante Rosa Natural", transaction_type: "BRINDE", quantity: -1, unit_price: null, notes: "Brinde cliente fiel", created_at: "2026-01-30T14:00:00Z" },
  { id: "m22", product_name: "Plant Gel de Limpeza Facial 150ml", transaction_type: "USO_PROPRIO", quantity: -1, unit_price: null, notes: null, created_at: "2026-02-22T08:00:00Z" },
  { id: "m23", product_name: "Aquarela Shine Gloss Labial 5ml", transaction_type: "PERDA", quantity: -1, unit_price: null, notes: "Produto danificado", created_at: "2026-03-01T11:00:00Z" },

  // Entradas mais antigas para gráfico de timeline
  { id: "m30", product_name: "Tododia Cereja e Avelã 400ml", transaction_type: "ENTRADA", quantity: 10, unit_price: 22.50, notes: "Pedido ciclo 10/2025", created_at: "2025-10-15T08:00:00Z" },
  { id: "m31", product_name: "Chronos Antissinais 30+ 30ml", transaction_type: "ENTRADA", quantity: 8, unit_price: 55.00, notes: "Pedido ciclo 11/2025", created_at: "2025-11-20T07:00:00Z" },
  { id: "m32", product_name: "Faces Batom Hidratante Rosa Natural", transaction_type: "ENTRADA", quantity: 6, unit_price: 12.50, notes: null, created_at: "2025-09-08T11:00:00Z" },
  { id: "m33", product_name: "Ekos Maracujá Óleo Trifásico 150ml", transaction_type: "ENTRADA", quantity: 10, unit_price: 32.00, notes: "Pedido ciclo 12/2025", created_at: "2025-12-01T10:00:00Z" },
  { id: "m34", product_name: "Chronos Antissinais 30+ 30ml", transaction_type: "VENDA", quantity: -2, unit_price: 94.90, notes: null, created_at: "2025-12-20T16:00:00Z" },
  { id: "m35", product_name: "Ekos Maracujá Óleo Trifásico 150ml", transaction_type: "VENDA", quantity: -3, unit_price: 54.90, notes: "Cliente Paula", created_at: "2026-01-15T13:00:00Z" },
];

// ── Profile ──
export const DEMO_PROFILE: Profile = {
  id: "demo",
  display_name: "Consultora Teste",
  whatsapp_number: "5571999772054",
  storefront_enabled: true,
  store_slug: "demo",
  plan: "pro",
};

// ── Batches ──
export const DEMO_BATCHES: Record<string, InventoryBatch[]> = {
  d1: [
    { id: "b1", batch_code: "LOTE-B1", quantity: 7, cost_price: 78.90, expiration_date: "2026-08-15", created_at: "2026-01-05T10:00:00Z" },
    { id: "b2", batch_code: "LOTE-B2", quantity: 5, cost_price: 78.90, expiration_date: "2026-11-20", created_at: "2026-02-15T14:00:00Z" },
  ],
  d2: [
    { id: "b3", batch_code: "LOTE-B3", quantity: 8, cost_price: 115.00, expiration_date: "2027-01-10", created_at: "2025-12-05T09:30:00Z" },
  ],
  d8: [
    { id: "b4", batch_code: "LOTE-B4", quantity: 4, cost_price: 95.00, expiration_date: "2027-06-01", created_at: "2025-12-12T15:00:00Z" },
  ],
};

// ── Helper: check if demo mode ──
export function isDemoMode(): boolean {
  return localStorage.getItem("auth_token") === "demo-token";
}