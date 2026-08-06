// pages/Support.tsx
//
// ⚠️ Simplificado: o fluxo de conversa ("Falar com a gente") mudou pra
// dentro do ChatAssistant.tsx (o balão flutuante global, modo 🆘 Ajuda) —
// esta página agora é só a Central de Ajuda (listagem agrupada por
// categoria, com filtro por tipo). Consome o MESMO GET /api/ajuda/ que a
// seção "Aprenda a usar" do profile usa.
import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { ArrowLeft, PlayCircle, HelpCircle, BookOpen, Newspaper } from "lucide-react";
import { api } from "../services/api";
import { Badge } from "../components/ui/badge";

interface HelpContentItem {
  id: number;
  tipo: "video" | "faq" | "guia" | "novidade";
  titulo: string;
  corpo: string;
  video_url: string | null;
  categoria: string;
  ordem: number;
}

const TIPO_INFO: Record<string, { label: string; icon: any }> = {
  video: { label: "Vídeo", icon: PlayCircle },
  faq: { label: "Dúvida frequente", icon: HelpCircle },
  guia: { label: "Guia", icon: BookOpen },
  novidade: { label: "Novidade", icon: Newspaper },
};

// Extrai o ID de embed do YouTube de qualquer formato de link comum.
function youtubeEmbedUrl(url: string): string | null {
  const m = url.match(/(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/))([a-zA-Z0-9_-]{6,})/);
  return m ? `https://www.youtube.com/embed/${m[1]}` : null;
}

export default function Support() {
  const navigate = useNavigate();
  const [conteudos, setConteudos] = useState<HelpContentItem[]>([]);
  const [filtroTipo, setFiltroTipo] = useState<string>("");
  const [itemAtivo, setItemAtivo] = useState<HelpContentItem | null>(null);

  useEffect(() => {
    api.get("ajuda/").then((r) => setConteudos(r.data)).catch(() => {});
  }, []);

  const filtrados = filtroTipo ? conteudos.filter((c) => c.tipo === filtroTipo) : conteudos;
  const grupos = filtrados.reduce<Record<string, HelpContentItem[]>>((acc, item) => {
    const chave = item.categoria || "Geral";
    (acc[chave] ||= []).push(item);
    return acc;
  }, {});

  return (
    <div className="min-h-screen bg-background pb-20">
      <header className="sticky top-0 z-20 border-b border-border bg-card">
        <div className="mx-auto flex max-w-3xl items-center gap-3 px-4 py-4">
          <button onClick={() => navigate("/")} className="rounded-lg p-1.5 hover:bg-secondary">
            <ArrowLeft className="h-5 w-5" />
          </button>
          <h1 className="font-display text-lg font-bold text-foreground">Central de Ajuda</h1>
        </div>
      </header>

      <main className="mx-auto max-w-3xl px-4 py-5 space-y-5">
        <div className="flex flex-wrap gap-1.5">
          <button
            onClick={() => setFiltroTipo("")}
            className={`rounded-full px-3 py-1 text-xs font-medium ${!filtroTipo ? "bg-brand text-white" : "bg-secondary text-muted-foreground"}`}
          >
            Tudo
          </button>
          {Object.entries(TIPO_INFO).map(([k, v]) => (
            <button
              key={k}
              onClick={() => setFiltroTipo(k)}
              className={`rounded-full px-3 py-1 text-xs font-medium ${filtroTipo === k ? "bg-brand text-white" : "bg-secondary text-muted-foreground"}`}
            >
              {v.label}
            </button>
          ))}
        </div>

        {Object.keys(grupos).length === 0 ? (
          <p className="py-10 text-center text-sm text-muted-foreground">Nenhum conteúdo disponível ainda.</p>
        ) : (
          Object.entries(grupos).map(([categoria, itens]) => (
            <div key={categoria}>
              <h3 className="mb-2 text-xs font-bold uppercase tracking-wide text-muted-foreground">{categoria}</h3>
              <div className="space-y-2">
                {itens.map((item) => {
                  const info = TIPO_INFO[item.tipo];
                  const Icon = info.icon;
                  return (
                    <button
                      key={item.id}
                      onClick={() => setItemAtivo(item)}
                      className="flex w-full items-center gap-3 rounded-xl border border-border bg-card p-3 text-left transition-colors hover:border-brand/30"
                    >
                      <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-lg bg-brand/10">
                        <Icon className="h-5 w-5 text-brand" />
                      </div>
                      <div className="min-w-0">
                        <p className="truncate font-medium text-foreground">{item.titulo}</p>
                        <p className="text-xs text-muted-foreground">{info.label}</p>
                      </div>
                    </button>
                  );
                })}
              </div>
            </div>
          ))
        )}
      </main>

      {itemAtivo && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4"
          onClick={() => setItemAtivo(null)}
        >
          <div className="w-full max-w-2xl" onClick={(e) => e.stopPropagation()}>
            {itemAtivo.tipo === "video" && itemAtivo.video_url ? (
              <>
                <div className="aspect-video w-full overflow-hidden rounded-xl bg-black">
                  {youtubeEmbedUrl(itemAtivo.video_url) ? (
                    <iframe
                      className="h-full w-full"
                      src={youtubeEmbedUrl(itemAtivo.video_url)!}
                      title={itemAtivo.titulo}
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                      allowFullScreen
                    />
                  ) : (
                    <a href={itemAtivo.video_url} target="_blank" rel="noopener noreferrer" className="flex h-full items-center justify-center text-white underline">
                      Abrir vídeo
                    </a>
                  )}
                </div>
                <div className="mt-3 rounded-xl bg-card p-3">
                  <p className="font-medium text-foreground">{itemAtivo.titulo}</p>
                  {itemAtivo.corpo && <p className="mt-1 text-sm text-muted-foreground">{itemAtivo.corpo}</p>}
                </div>
              </>
            ) : (
              <div className="max-h-[80vh] overflow-y-auto rounded-xl bg-card p-5">
                <Badge variant="outline" className="mb-2">{TIPO_INFO[itemAtivo.tipo].label}</Badge>
                <p className="font-display text-lg font-bold text-foreground">{itemAtivo.titulo}</p>
                <p className="mt-2 whitespace-pre-wrap text-sm text-muted-foreground">{itemAtivo.corpo}</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}