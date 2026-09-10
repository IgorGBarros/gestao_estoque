// pages/ReferralLanding.tsx
//
// Página pública /ref/[code] — quando uma consultora compartilha seu
// link de indicação, quem acessa vê essa tela antes de se cadastrar.
// O código é salvo automaticamente no sessionStorage e aplicado no signup.
import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Gift, ArrowRight, CheckCircle, Loader2 } from "lucide-react";
import { api } from "../services/api";
import logoMinhaAmora from "../assets/logo-minhaamora.png";

export default function ReferralLanding() {
  const { code } = useParams<{ code: string }>();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(true);
  const [dados, setDados] = useState<{
    valido: boolean; bonus_dias?: number; nome_indicadora?: string; motivo?: string;
  } | null>(null);

  useEffect(() => {
    if (!code) return;
    // Salva o código no sessionStorage pra o Auth.tsx pegar automaticamente
    sessionStorage.setItem("ma_referral_code", code.toUpperCase());

    api.get(`/ref/${code}/`)
      .then((r) => setDados(r.data))
      .catch(() => setDados({ valido: false, motivo: "Erro ao verificar o código." }))
      .finally(() => setLoading(false));
  }, [code]);

  const irParaCadastro = () => {
    navigate(`/auth?ref=${code}&mode=signup`);
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#FDF2F7] to-white flex flex-col items-center justify-center px-4">
      <img src={logoMinhaAmora} alt="Minha Amora" className="h-12 mb-8" />

      {loading ? (
        <div className="flex items-center gap-2 text-muted-foreground">
          <Loader2 className="h-5 w-5 animate-spin" />
          <span className="text-sm">Verificando convite...</span>
        </div>
      ) : dados?.valido ? (
        <div className="w-full max-w-sm text-center space-y-6">
          <div className="flex justify-center">
            <div className="flex h-16 w-16 items-center justify-center rounded-full bg-brand/10">
              <Gift className="h-8 w-8 text-brand" />
            </div>
          </div>

          <div>
            {dados.nome_indicadora && (
              <p className="text-sm text-muted-foreground mb-1">
                <strong className="text-foreground">{dados.nome_indicadora}</strong> te convidou para o
              </p>
            )}
            <h1 className="text-2xl font-bold text-foreground">Minha Amora</h1>
            <p className="text-muted-foreground mt-1">Gestão de estoque para consultoras</p>
          </div>

          {/* Benefício */}
          <div className="rounded-2xl border border-emerald-200 bg-emerald-50 p-4 space-y-2">
            <p className="text-sm font-semibold text-emerald-800">
              🎁 Seu teste grátis especial
            </p>
            <p className="text-3xl font-bold text-emerald-700">{dados.bonus_dias} dias</p>
            <p className="text-xs text-emerald-600">
              Em vez dos 14 dias padrão — sem cartão, cancele quando quiser
            </p>
          </div>

          {/* O que é */}
          <div className="text-left space-y-2">
            {[
              "Controle de estoque com validade e FIFO",
              "Cálculo de lucro real em cada venda",
              "Alerta de produtos próximos do vencimento",
              "Vitrine online para compartilhar pelo WhatsApp",
            ].map((f) => (
              <div key={f} className="flex items-start gap-2 text-sm">
                <CheckCircle className="h-4 w-4 shrink-0 text-emerald-600 mt-0.5" />
                <span className="text-foreground">{f}</span>
              </div>
            ))}
          </div>

          <button
            onClick={irParaCadastro}
            className="flex w-full items-center justify-center gap-2 rounded-2xl bg-brand py-4 text-base font-semibold text-white hover:opacity-90 active:scale-95 transition-all"
          >
            Começar meu teste de {dados.bonus_dias} dias
            <ArrowRight className="h-5 w-5" />
          </button>

          <p className="text-xs text-muted-foreground">
            Código de convite: <strong className="font-mono">{code?.toUpperCase()}</strong>
          </p>
        </div>
      ) : (
        <div className="text-center space-y-4">
          <p className="text-lg font-semibold text-foreground">Convite inválido</p>
          <p className="text-sm text-muted-foreground">{dados?.motivo || "Esse código não é válido ou expirou."}</p>
          <button
            onClick={() => navigate("/")}
            className="rounded-xl border border-border px-6 py-2.5 text-sm hover:bg-secondary"
          >
            Ir para a página inicial
          </button>
        </div>
      )}
    </div>
  );
}
