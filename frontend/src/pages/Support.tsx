// pages/Support.tsx — Central de Ajuda
//
// Blocos separados por tipo (Vídeos, FAQs, Guias, Novidades), cada um com
// os itens daquele tipo. Vídeos mostram thumbnail (extraída do próprio
// link do YouTube) e tocam DENTRO do sistema, num modal com iframe — nunca
// abrem o YouTube numa aba nova.
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
  video: { label: "Vídeos", icon: PlayCircle },
  faq: { label: "Dúvidas Frequentes", icon: HelpCircle },
  guia: { label: "Guias", icon: BookOpen },
  novidade: { label: "Novidades", icon: Newspaper },
};
const ORDEM_BLOCOS: HelpContentItem["tipo"][] = ["video", "faq", "guia", "novidade"];

/** Extrai só o ID do vídeo, de qualquer formato de link comum do YouTube. */
function youtubeId(url: string): string | null {
  const m = url.match(/(?:youtu\.be\/|youtube\.com\/(?:watch\?v=|embed\/))([a-zA-Z0-9_-]{6,})/);
  return m ? m[1] : null;
}

export default function Support() {
  const navigate = useNavigate();
  const [conteudos, setConteudos] = useState<HelpContentItem[]>([]);
  const [itemAtivo, setItemAtivo] = useState<HelpContentItem | null>(null);

  useEffect(() => {
    api.get("ajuda/").then((r) => setConteudos(r.data)).catch(() => {});
  }, []);

  const blocos = ORDEM_BLOCOS.map((tipo) => ({
    tipo,
    info: TIPO_INFO[tipo],
    itens: conteudos.filter((c) => c.tipo === tipo),
  })).filter((b) => b.itens.length > 0);

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

      <main className="mx-auto max-w-3xl px-4 py-5 space-y-8">
        {blocos.length === 0 ? (
          <p className="py-10 text-center text-sm text-muted-foreground">Nenhum conteúdo disponível ainda.</p>
        ) : (
          blocos.map(({ tipo, info, itens }) => (
            <section key={tipo}>
              <h2 className="mb-3 flex items-center gap-2 font-display text-base font-bold text-foreground">
                <info.icon className="h-4.5 w-4.5 text-brand" /> {info.label}
              </h2>

              {tipo === "video" ? (
                <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
                  {itens.map((item) => {
                    const vid = item.video_url ? youtubeId(item.video_url) : null;
                    return (
                      <button
                        key={item.id}
                        onClick={() => setItemAtivo(item)}
                        className="group text-left"
                      >
                        <div className="relative aspect-video overflow-hidden rounded-xl bg-secondary">
                          {vid ? (
                            <img
                              src={`https://img.youtube.com/vi/${vid}/hqdefault.jpg`}
                              alt={item.titulo}
                              className="h-full w-full object-cover transition-transform group-hover:scale-105"
                            />
                          ) : (
                            <div className="flex h-full w-full items-center justify-center">
                              <PlayCircle className="h-8 w-8 text-muted-foreground" />
                            </div>
                          )}
                          <div className="absolute inset-0 flex items-center justify-center bg-black/20 opacity-0 transition-opacity group-hover:opacity-100">
                            <div className="flex h-9 w-9 items-center justify-center rounded-full bg-white/90">
                              <PlayCircle className="h-5 w-5 text-brand" />
                            </div>
                          </div>
                        </div>
                        <p className="mt-1.5 line-clamp-2 text-xs font-medium text-foreground">{item.titulo}</p>
                      </button>
                    );
                  })}
                </div>
              ) : (
                <div className="space-y-2">
                  {itens.map((item) => (
                    <button
                      key={item.id}
                      onClick={() => setItemAtivo(item)}
                      className="flex w-full items-center gap-3 rounded-xl border border-border bg-card p-3 text-left transition-colors hover:border-brand/30"
                    >
                      <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-brand/10">
                        <info.icon className="h-5 w-5 text-brand" />
                      </div>
                      <div className="min-w-0">
                        <p className="truncate font-medium text-foreground">{item.titulo}</p>
                        {item.categoria && <p className="text-xs text-muted-foreground">{item.categoria}</p>}
                      </div>
                    </button>
                  ))}
                </div>
              )}
            </section>
          ))
        )}
      </main>

      {/* Player embutido — o vídeo toca AQUI DENTRO, nunca abre o YouTube
          numa aba nova. */}
      {itemAtivo && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center bg-black/70 p-4"
          onClick={() => setItemAtivo(null)}
        >
          <div className="w-full max-w-2xl" onClick={(e) => e.stopPropagation()}>
            {itemAtivo.tipo === "video" && itemAtivo.video_url ? (
              <>
                <div className="aspect-video w-full overflow-hidden rounded-xl bg-black">
                  {youtubeId(itemAtivo.video_url) ? (
                    <iframe
                      className="h-full w-full"
                      src={`https://www.youtube.com/embed/${youtubeId(itemAtivo.video_url)}?autoplay=1`}
                      title={itemAtivo.titulo}
                      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                      allowFullScreen
                    />
                  ) : (
                    <div className="flex h-full items-center justify-center text-white">Vídeo indisponível</div>
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