// src/pages/ApiDocs.tsx
import { useState, useEffect } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { ArrowLeft, BookOpen, Server } from 'lucide-react';
import { Button } from '@/components/ui/button';
import SwaggerEmbed from '@/components/api/SwaggerEmbed';

export default function ApiDocs() {
  const navigate = useNavigate();
  
  // URL do schema OpenAPI - use variável de ambiente ou fallback
  const API_SCHEMA_URL = import.meta.env.VITE_API_SCHEMA_URL 
    || 'https://api.minhaamora.com.br/api/v1/schema/';

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
              <Server className="h-5 w-5 text-primary" />
              Minha Amora API
            </div>
          </div>
          <nav className="flex items-center gap-4 text-sm">
            <button onClick={() => navigate('/api')} className="hover:text-primary">Início</button>
            <span className="text-primary font-medium flex items-center gap-1">
              <BookOpen className="h-4 w-4" /> Documentação
            </span>
            <button onClick={() => navigate('/api/pricing')} className="hover:text-primary">Preços</button>
          </nav>
        </div>
      </header>

      {/* Conteúdo */}
      <main className="container mx-auto px-4 py-8">
        <div className="mb-6">
          <h1 className="text-3xl font-bold mb-2">Documentação da API</h1>
          <p className="text-muted-foreground">
            Explore os endpoints, teste requisições e integre em minutos.
          </p>
        </div>

        {/* Swagger UI Embed */}
        <div className="border border-border rounded-xl overflow-hidden">
          <SwaggerEmbed url={API_SCHEMA_URL} />
        </div>

        {/* Links Úteis */}
        <div className="mt-8 grid md:grid-cols-3 gap-4">
          <div className="p-4 border border-border rounded-lg">
            <h3 className="font-medium mb-2">📚 Guias</h3>
            <ul className="space-y-1 text-sm text-muted-foreground">
              <li><button onClick={() => navigate('/api/docs/authentication')} className="hover:text-primary">Autenticação</button></li>
              <li><button onClick={() => navigate('/api/docs/rate-limiting')} className="hover:text-primary">Rate Limiting</button></li>
              <li><button onClick={() => navigate('/api/docs/webhooks')} className="hover:text-primary">Webhooks</button></li>
            </ul>
          </div>
          <div className="p-4 border border-border rounded-lg">
            <h3 className="font-medium mb-2">🔧 SDKs</h3>
            <ul className="space-y-1 text-sm text-muted-foreground">
              <li><a href="#" className="hover:text-primary">Python (pip install minha-amora)</a></li>
              <li><a href="#" className="hover:text-primary">JavaScript (npm install @minha-amora/api)</a></li>
              <li><a href="#" className="hover:text-primary">PHP (composer require minha-amora/sdk)</a></li>
            </ul>
          </div>
          <div className="p-4 border border-border rounded-lg">
            <h3 className="font-medium mb-2">❓ Suporte</h3>
            <ul className="space-y-1 text-sm text-muted-foreground">
              <li><a href="mailto:suporte@minhaamora.com.br" className="hover:text-primary">suporte@minhaamora.com.br</a></li>
              <li><button onClick={() => navigate('/api/status')} className="hover:text-primary">Status da API</button></li>
              <li><a href="https://status.minhaamora.com.br" className="hover:text-primary" target="_blank">Uptime</a></li>
            </ul>
          </div>
        </div>
      </main>
    </div>
  );
}