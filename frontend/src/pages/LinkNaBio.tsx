// src/pages/LinkNaBio.tsx
//
// Página enxuta pra colocar no link da bio do Instagram — de propósito
// simples, 3 botões + espaço pro vídeo de apresentação, sem lista longa
// de link (padrão comprovado do mercado, não é achismo). Rota separada
// da landing page completa (/lp) — essa aqui é feita pra quem já viu
// conteúdo em vídeo no Instagram e está decidindo clicar ou não.
import { useNavigate } from "react-router-dom";
import { ArrowRight, MessageCircle, Sparkles } from "lucide-react";
import logoMinhaAmora from "../assets/logo-minhaamora.png";

// ⚠️ Troca pelo número de WhatsApp de suporte real antes de publicar.
const WHATSAPP_SUPORTE = "5500000000000";

export default function LinkNaBio() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#FDF2F7] to-white flex flex-col items-center px-4 py-10">
      <img src={logoMinhaAmora} alt="Minha Amora" className="h-14 mb-6" />

      {/* ⚠️ Espaço reservado pro vídeo de apresentação — troca o iframe
          pelo vídeo de verdade assim que gravar (Dia 4-5 do plano). Até
          lá, mostra um cartão de "em breve" em vez de quebrar a página. */}
      <div className="w-full max-w-sm aspect-[9/16] max-h-[420px] rounded-2xl bg-white shadow-md border border-border flex items-center justify-center mb-6 overflow-hidden">
        {/* Troque por: <iframe src="https://www.youtube.com/embed/SEU_VIDEO_ID" className="w-full h-full" allowFullScreen /> */}
        <div className="text-center px-6">
          <Sparkles className="h-8 w-8 text-brand mx-auto mb-2" />
          <p className="text-sm text-muted-foreground">Vídeo de apresentação em breve</p>
        </div>
      </div>

      <div className="w-full max-w-sm space-y-3">
        <a
          href="/auth"
          onClick={(e) => { e.preventDefault(); navigate("/auth"); }}
          className="flex items-center justify-center gap-2 w-full rounded-2xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-400 hover:to-rose-400 text-white font-bold py-4 shadow-lg shadow-pink-500/25 transition-all"
        >
          Testar Grátis — 14 dias
          <ArrowRight className="h-4 w-4" />
        </a>

        <a
          href="/lp"
          onClick={(e) => { e.preventDefault(); navigate("/lp"); }}
          className="flex items-center justify-center gap-2 w-full rounded-2xl border border-border bg-white hover:bg-secondary font-semibold py-4 transition-colors"
        >
          Conhecer o sistema
        </a>

        <a
          href={`https://api.whatsapp.com/send?phone=${WHATSAPP_SUPORTE}&text=${encodeURIComponent("Olá, tenho dúvidas sobre o Minha Amora! 😊")}`}
          target="_blank"
          rel="noopener noreferrer"
          className="flex items-center justify-center gap-2 w-full rounded-2xl border border-emerald-300 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-semibold py-4 transition-colors"
        >
          <MessageCircle className="h-4 w-4" />
          Falar no WhatsApp
        </a>
      </div>

      <p className="mt-8 text-xs text-muted-foreground text-center">
        Gestão de estoque para consultoras de Natura, Avon, Boticário,
        Eudora, Mary Kay e Quem Disse Berenice.
      </p>
    </div>
  );
}
