"""
management/commands/crawl_avatim.py

Crawler da Avatim (avatim.com.br) — plataforma VNDA (brasileira).
Não usa Selenium porque os dados do produto estão embutidos diretamente
no HTML da página em atributos data-* e inputs — não precisa de JS renderizado.

Estratégia:
  1. Percorre as páginas de listagem (/todos-os-produtos?page=N) pra
     descobrir todos os slugs/IDs de produto.
  2. Para cada produto, busca a página individual e extrai os dados
     dos atributos HTML (nome, preço, SKU, categoria, etc.)
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
import requests
from decimal import Decimal
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
    "acessórios": "Acessórios",
    "kit": "Kits",
    "necessaire": "Acessórios",
}


def _detectar_categoria(categoria_html: str, nome: str) -> str:
    """Detecta categoria baseado na categoria do HTML ou no nome."""
    if categoria_html:
        chave = categoria_html.lower().strip()
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
    if any(x in nome_lower for x in ["necessaire", "kit", "acessório"]):
        return "Acessórios"
    return "Geral"


def _extrair_dados_produto(html: str):
    """
    Extrai os dados do produto diretamente do HTML da página.
    Usa a mesma lógica robusta de regex do crawler de referência.
    """
    dados = {}
    
    # 1. Extrair nome do produto
    m = re.search(r'<h[13][^>]*class="name"[^>]*>([^<]+)</h[13]>', html)
    if m:
        dados['nome'] = m.group(1).strip()
    
    # 2. Extrair preço (Lógica robusta baseada no crawler de referência)
    # Procura por "R$" seguido de espaço/&nbsp; e o formato brasileiro exato: 1.234,56 ou 56,78
    m = re.search(r'R\$\s*(?:&nbsp;)?\s*(\d{1,3}(?:\.\d{3})*,\d{2})', html)
    
    if m:
        # Converte formato brasileiro (1.234,56) para formato Decimal padrão (1234.56)
        preco_str = m.group(1).replace('.', '').replace(',', '.')
        try:
            dados['preco'] = Decimal(preco_str)
        except Exception:
            pass
    
    # Fallback: se não achou no texto formatado, tenta data-price (às vezes vem como "61.00")
    if 'preco' not in dados:
        m = re.search(r'data-price="([\d.,]+)"', html)
        if m:
            raw_price = m.group(1)
            # Se tiver vírgula, é formato brasileiro. Se não, pode ser float padrão.
            if ',' in raw_price:
                preco_str = raw_price.replace('.', '').replace(',', '.')
            else:
                preco_str = raw_price
            
            try:
                dados['preco'] = Decimal(preco_str)
            except Exception:
                pass

    # 3. Extrair SKU
    m = re.search(r'<input[^>]*name="sku"[^>]*value="([^"]*)"', html)
    if m:
        dados['sku'] = m.group(1).strip()
    else:
        m = re.search(r'data-sku="([^"]*)"', html)
        if m:
            dados['sku'] = m.group(1).strip()
    
    # 4. Extrair ID do produto
    m = re.search(r'data-product-id="(\d+)"', html)
    if m:
        dados['product_id'] = m.group(1)
    
    # 5. Extrair categoria
    m = re.search(r'categoria[^>]*>([^<]+)</', html, re.IGNORECASE)
    if m:
        dados['categoria_html'] = m.group(1).strip()
    
    # 6. Extrair linha/attribute1
    m = re.search(r'linha[^>]*>([^<]+)</', html, re.IGNORECASE)
    if m:
        dados['linha'] = m.group(1).strip()
    
    # 7. Extrair imagem
    m = re.search(r'<meta[^>]+property="og:image"[^>]+content="([^"]+)"', html)
    if m:
        dados['imagem'] = m.group(1)
    else:
        m = re.search(r'(https://cdn\.vnda\.com\.br/avatim/[^"\']+\.jpg[^"\']*)', html)
        if m:
            dados['imagem'] = m.group(1)
    
    # 8. Extrair barcode
    m = re.search(r'data-barcode="([^"]*)"', html)
    if m and m.group(1):
        dados['barcode'] = m.group(1)
    
    return dados if dados else None


def _buscar_pagina(url: str, sessao: requests.Session) -> str | None:
    try:
        resp = sessao.get(url, headers=HEADERS, timeout=15)
        if resp.status_code == 200:
            return resp.text
        if resp.status_code == 429:
            print("  ⏳ Rate limit — aguardando 30s")
            time.sleep(30)
            resp = sessao.get(url, headers=HEADERS, timeout=15)
            if resp.status_code == 200:
                return resp.text
        return None
    except Exception as e:
        print(f"  ❌ Erro ao buscar {url}: {e}")
        return None


def _descobrir_slugs(sessao: requests.Session, max_pages: int = 50) -> list[str]:
    """
    Percorre as páginas de listagem e coleta todos os slugs de produto.
    """
    slugs = []
    for page in range(1, max_pages + 1):
        url = f"{BASE_URL}/todos-os-produtos?page={page}"
        html = _buscar_pagina(url, sessao)
        if not html:
            break

        # Links de produto: /produto/<slug-com-numeros>
        encontrados = re.findall(r'/produto/([a-z0-9\-]+)', html)
        novos = [s for s in encontrados if s not in slugs]

        if not novos:
            break

        slugs.extend(novos)
        print(f"  Página {page}: +{len(novos)} slugs ({len(slugs)} total)")
        time.sleep(random.uniform(0.5, 1.0))

    return list(dict.fromkeys(slugs))


class Command(BaseCommand):
    help = "Crawler da Avatim — importa todos os produtos do catálogo avatim.com.br"

    def add_arguments(self, parser):
        parser.add_argument("--limit", type=int, default=0, help="Limita a N produtos (0 = sem limite)")
        parser.add_argument("--dry-run", action="store_true", help="Mostra o que faria, não salva nada")
        parser.add_argument("--max-pages", type=int, default=50, help="Máximo de páginas de listagem (default 50)")

    def handle(self, *args, **options):
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

            dados = _extrair_dados_produto(html)
            if not dados:
                self.stdout.write(self.style.WARNING("  ⚠️ Dados não encontrados — pulando"))
                ignorados += 1
                continue

            nome = dados.get('nome', '').strip()
            if not nome:
                self.stdout.write(self.style.WARNING("  ⚠️ Nome não encontrado — pulando"))
                ignorados += 1
                continue

            sku = dados.get('sku', '').strip()
            barcode = dados.get('barcode')
            preco = dados.get('preco')
            imagem = dados.get('imagem', '')
            categoria_html = dados.get('categoria_html', '')
            linha = dados.get('linha', '')
            
            categoria = _detectar_categoria(categoria_html or linha, nome)

            # Formata o preço para exibição correta (ex: 82.00 em vez de 820.0)
            preco_formatado = f"R$ {preco:.2f}" if preco is not None else "R$ 0.00"

            self.stdout.write(
                f"  → {nome[:50]} | sku={sku} | barcode={barcode} | "
                f"cat={categoria} | {preco_formatado}"
            )

            if dry_run:
                continue

            # Buscar produto existente
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
                alterados = []
                for campo, valor in defaults.items():
                    if campo in ("review_status", "last_checked_at"):
                        continue
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