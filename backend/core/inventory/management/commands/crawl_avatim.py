"""
management/commands/crawl_avatim.py

Crawler da Avatim (avatim.com.br) — plataforma VNDA (brasileira).
Não usa Selenium porque o JSON do produto está embutido diretamente
no HTML da página, nos blocos <script> — não precisa de JS renderizado.

Estratégia:
  1. Percorre as páginas de listagem (/todos-os-produtos?page=N) pra
     descobrir todos os slugs/IDs de produto.
  2. Para cada produto, busca a página individual e extrai o JSON
     embutido (variants/skus — mesmo formato que o usuário mostrou:
     full_name, sku, price, barcode, image_url, etc.)
  3. Salva no banco com brand='Avatim' e review_status='aprovado'.

Uso:
  python manage.py crawl_avatim          # roda com defaults
  python manage.py crawl_avatim --limit 100   # limita a N produtos
  python manage.py crawl_avatim --dry-run     # mostra o que faria, não salva
"""
import json
import re
import time
import random
from django.core.management.base import BaseCommand
from django.utils import timezone

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/120.0.0.0 Safari/537.36"
    ),
    "Accept-Language": "pt-BR,pt;q=0.9",
}

BASE_URL = "https://www.avatim.com.br"

# Mapeamento de categorias Avatim → nosso sistema.
# Usa o campo attribute1 (ex: "Essência para Difusor", "Sabonete Líquido")
# ou o segmento da URL do produto quando attribute1 não estiver disponível.
CATEGORIA_MAP = {
    "essência para difusor": "Casa",
    "essencia para difusor": "Casa",
    "difusor": "Casa",
    "vela": "Casa",
    "incenso": "Casa",
    "água perfumada": "Casa",
    "perfume para interiores": "Casa",
    "sachê": "Casa",
    "sachê perfumado": "Casa",
    "óleo essencial": "Casa",
    "sabonete": "Corpo e Banho",
    "hidratante": "Corpo e Banho",
    "óleo": "Corpo e Banho",
    "esfoliante": "Corpo e Banho",
    "body splash": "Perfumaria",
    "deo parfum": "Perfumaria",
    "deo colônia": "Perfumaria",
    "colônia": "Perfumaria",
    "perfume": "Perfumaria",
    "shampoo": "Cabelos",
    "condicionador": "Cabelos",
    "máscara capilar": "Cabelos",
    "desodorante": "Corpo e Banho",
}


def _detectar_categoria(attribute1: str, nome: str) -> str:
    chave = (attribute1 or "").lower().strip()
    for palavra, cat in CATEGORIA_MAP.items():
        if palavra in chave:
            return cat
    # Fallback pelo nome do produto
    nome_lower = (nome or "").lower()
    if any(x in nome_lower for x in ["difusor", "vela", "incenso", "sachê", "ambiental"]):
        return "Casa"
    if any(x in nome_lower for x in ["perfume", "colônia", "splash", "parfum"]):
        return "Perfumaria"
    if any(x in nome_lower for x in ["sabonete", "hidratante", "esfoliante", "desodorante"]):
        return "Corpo e Banho"
    if any(x in nome_lower for x in ["shampoo", "condicionador", "cabelo"]):
        return "Cabelos"
    return "Geral"


def _extrair_json_produto(html: str):
    """
    Extrai o JSON de variantes embutido no HTML da página de produto
    da plataforma VNDA. O formato típico é:
      <script>var skus = [{...}];</script>
    ou
      <script>window.Vnda.Data.skus = [{...}];</script>
    """
    # Padrões comuns da VNDA
    padroes = [
        r'var\s+skus\s*=\s*(\[.*?\]);',
        r'window\.Vnda\.Data\.skus\s*=\s*(\[.*?\]);',
        r'"skus"\s*:\s*(\[.*?\])',
        r'data-skus=["\'](\[.*?\])["\']',
    ]
    for padrao in padroes:
        m = re.search(padrao, html, re.DOTALL)
        if m:
            try:
                return json.loads(m.group(1))
            except json.JSONDecodeError:
                continue
    return None


def _extrair_imagem(html: str) -> str:
    """
    Extrai a primeira imagem de produto do Open Graph ou da primeira
    tag img com CDN da Avatim.
    """
    m = re.search(r'<meta[^>]+property="og:image"[^>]+content="([^"]+)"', html)
    if m:
        return m.group(1)
    m = re.search(r'(https://cdn\.vnda\.com\.br/avatim/[^"\']+\.jpg[^"\']*)', html)
    if m:
        return m.group(1)
    return ""


def _buscar_pagina(url: str, sessao) -> str | None:
    import requests
    try:
        resp = sessao.get(url, headers=HEADERS, timeout=15)
        if resp.status_code == 200:
            return resp.text
        if resp.status_code == 429:
            print(f"  ⏳ Rate limit — aguardando 30s")
            time.sleep(30)
        return None
    except Exception as e:
        print(f"  ❌ Erro ao buscar {url}: {e}")
        return None


def _descobrir_slugs(sessao, max_pages: int = 50) -> list[str]:
    """
    Percorre as páginas de listagem e coleta todos os slugs de produto.
    """
    slugs = []
    for page in range(1, max_pages + 1):
        url = f"{BASE_URL}/todos-os-produtos?page={page}"
        html = _buscar_pagina(url, sessao)
        if not html:
            break

        # Links de produto na VNDA são /produto/<slug>-<id>
        encontrados = re.findall(r'/produto/([\w\-]+-\d+)', html)
        novos = [s for s in encontrados if s not in slugs]

        if not novos:
            # Nenhum produto novo nessa página → chegamos no fim
            break

        slugs.extend(novos)
        print(f"  Página {page}: +{len(novos)} slugs ({len(slugs)} total)")
        time.sleep(random.uniform(0.5, 1.0))

    return list(dict.fromkeys(slugs))  # deduplica mantendo a ordem


class Command(BaseCommand):
    help = "Crawler da Avatim — importa todos os produtos do catálogo avatim.com.br"

    def add_arguments(self, parser):
        parser.add_argument("--limit", type=int, default=0, help="Limita a N produtos (0 = sem limite)")
        parser.add_argument("--dry-run", action="store_true", help="Mostra o que faria, não salva nada")
        parser.add_argument("--max-pages", type=int, default=50, help="Máximo de páginas de listagem a varrer (default 50)")

    def handle(self, *args, **options):
        import requests
        from inventory.models import Product

        limite = options["limit"]
        dry_run = options["dry_run"]
        max_pages = options["max_pages"]

        self.stdout.write(self.style.WARNING(
            f"🌿 Crawl da Avatim | limite={limite or 'sem limite'} | dry_run={dry_run}"
        ))

        sessao = requests.Session()

        self.stdout.write("🔍 Descobrindo slugs de produtos...")
        slugs = _descobrir_slugs(sessao, max_pages)
        self.stdout.write(f"   {len(slugs)} produtos encontrados no catálogo")

        if limite:
            slugs = slugs[:limite]

        criados = atualizados = ignorados = erros = 0

        for i, slug in enumerate(slugs, 1):
            url = f"{BASE_URL}/produto/{slug}"
            self.stdout.write(f"[{i}/{len(slugs)}] {slug}")

            html = _buscar_pagina(url, sessao)
            if not html:
                erros += 1
                continue

            variantes = _extrair_json_produto(html)
            if not variantes:
                self.stdout.write(f"  ⚠️ JSON não encontrado — pulando")
                ignorados += 1
                continue

            # Pega a variante principal (main=True) ou a primeira
            variante = next((v for v in variantes if v.get("main")), variantes[0])

            nome = (variante.get("full_name") or variante.get("name") or "").strip()
            if not nome:
                ignorados += 1
                continue

            sku = str(variante.get("sku") or "").strip()
            barcode = str(variante.get("barcode") or "").strip() or None
            preco = variante.get("sale_price") or variante.get("price")
            imagem = variante.get("image_url") or _extrair_imagem(html)
            attribute1 = variante.get("attribute1") or ""
            categoria = _detectar_categoria(attribute1, nome)

            self.stdout.write(
                f"  → {nome[:50]} | sku={sku} | barcode={barcode} | "
                f"cat={categoria} | R$ {preco}"
            )

            if dry_run:
                continue

            # Tenta casar por SKU primeiro, depois por código de barras
            produto = None
            if sku:
                produto = Product.objects.filter(natura_sku=sku).first()
            if not produto and barcode:
                produto = Product.objects.filter(bar_code=barcode).first()

            defaults = {
                "name": nome,
                "brand": "Avatim",
                "category": categoria,
                "image_url": imagem or "",
                "review_status": "aprovado",
                "last_checked_at": timezone.now(),
            }
            if preco is not None:
                defaults["official_price"] = preco
            if barcode:
                defaults["bar_code"] = barcode
            if sku:
                defaults["natura_sku"] = sku

            if produto:
                # Só atualiza campos que estão vazios — não sobrescreve
                # correção manual que já tenha sido feita.
                alterados = []
                for campo, valor in defaults.items():
                    if campo in ("review_status", "last_checked_at"):
                        continue  # sempre preserva o status existente
                    atual = getattr(produto, campo, None)
                    if not atual and valor:
                        setattr(produto, campo, valor)
                        alterados.append(campo)
                if alterados:
                    produto.save(update_fields=alterados)
                    atualizados += 1
                else:
                    ignorados += 1
            else:
                Product.objects.create(**defaults)
                criados += 1

            time.sleep(random.uniform(0.3, 0.8))

        self.stdout.write("")
        self.stdout.write(self.style.SUCCESS(
            f"✅ Concluído — criados: {criados} | atualizados: {atualizados} | "
            f"ignorados: {ignorados} | erros: {erros}"
        ))
