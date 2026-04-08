# inventory/management/commands/super_crawler_optimized.py
from django.core.management.base import BaseCommand
from django.utils import timezone
from django.db.models import Q
from inventory.models import Product, PriceHistory
from seleniumbase import SB
from bs4 import BeautifulSoup
import re
from decimal import Decimal
import random
import time
from collections import defaultdict
from datetime import timedelta

def detect_category(name):
    """🚀 FUNÇÃO DE INTELIGÊNCIA: Define a categoria para QUALQUER marca"""
    if not name: 
        return "Geral"
    
    name_lower = name.lower()
    
    # Perfumaria
    if any(x in name_lower for x in ['colônia', 'parfum', 'toilette', 'deo corporal', 'perfume', 'fragrância', 'eau de']):
        return "Perfumaria"
    
    # Cabelos
    if any(x in name_lower for x in ['shampoo', 'condicionador', 'máscara', 'cabelo', 'leave-in', 'finalizador']):
        return "Cabelos"
    
    # Corpo e Banho
    if any(x in name_lower for x in ['sabonete', 'hidratante', 'creme', 'óleo', 'desodorante', 'polpa', 'loção']):
        return "Corpo e Banho"
    
    # Maquiagem
    if any(x in name_lower for x in ['batom', 'base', 'corretivo', 'pó', 'rimel', 'delineador', 'palette', 'paleta', 'lápis', 'blush', 'iluminador', 'sombra', 'gloss']):
        return "Maquiagem"
    
    # Cuidados Faciais
    if any(x in name_lower for x in ['facial', 'serum', 'tônico', 'demaquilante', 'protetor solar', 'anti-idade', 'vitamina c']):
        return "Cuidados Faciais"
    
    # Infantil
    if any(x in name_lower for x in ['mamãe', 'bebê', 'infantil', 'criança', 'baby']):
        return "Infantil"
    
    # Masculino
    if any(x in name_lower for x in ['barba', 'homem', 'masculino', 'men']):
        return "Homem"
    
    return "Geral"

class Command(BaseCommand):
    help = 'Super Crawler Ultra-Otimizado: Performance melhorada por marca'
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # ✅ CACHE DE SKUs EXISTENTES PARA MARY KAY
        self.existing_mary_kay_skus = set()
        self._load_existing_mary_kay_skus()
    
    def _load_existing_mary_kay_skus(self):
        """✅ CARREGAR SKUs EXISTENTES DA MARY KAY NO INÍCIO"""
        try:
            existing_skus = Product.objects.filter(brand="Mary Kay").values_list('natura_sku', flat=True)
            self.existing_mary_kay_skus = set(existing_skus)
            print(f"📋 Carregados {len(self.existing_mary_kay_skus)} SKUs existentes da Mary Kay")
        except Exception as e:
            print(f"⚠️ Erro ao carregar SKUs existentes: {e}")
            self.existing_mary_kay_skus = set()
    
    def add_arguments(self, parser):
        parser.add_argument('--brand', type=str, help='Marca específica para crawlear')
        parser.add_argument('--update-existing', action='store_true', help='Priorizar produtos existentes')
        parser.add_argument('--max-pages', type=int, default=10, help='Máximo de páginas por marca')
        parser.add_argument('--fast-mode', action='store_true', help='Modo rápido (menos delays)')

    def handle(self, *args, **options):
        # 🚀 CONFIGURAÇÃO OTIMIZADA POR MARCA
        STORES = [
            {
                "brand": "Natura", 
                "list_url": "https://www.natura.com.br/c/todos-produtos", 
                "domain": "www.natura.com.br", 
                "prefix": "NATBRA",
                "speed": "fast",  # ✅ MARCA RÁPIDA
                "delay": 1.0      # ✅ DELAY MÍNIMO
            },
            {
                "brand": "Avon", 
                "list_url": "https://www.avon.com.br/c/todos-produtos", 
                "domain": "www.avon.com.br", 
                "prefix": "AVNBRA",
                "speed": "fast",  # ✅ MARCA RÁPIDA
                "delay": 1.0      # ✅ DELAY MÍNIMO
            },
            {
                "brand": "O Boticário", 
                "list_url": "https://www.boticario.com.br/todos-os-produtos/", 
                "domain": "www.boticario.com.br", 
                "prefix": None,
                "speed": "fast",  # ✅ MARCA RÁPIDA
                "delay": 1.5      # ✅ DELAY MÍNIMO
            },
            {
                "brand": "Quem Disse Berenice", 
                "list_url": "https://www.quemdisseberenice.com.br/todos-produtos-site/", 
                "domain": "www.quemdisseberenice.com.br", 
                "prefix": None,
                "speed": "fast",  # ✅ MARCA RÁPIDA
                "delay": 1.5      # ✅ DELAY MÍNIMO
            },
            {
                "brand": "Eudora", 
                "list_url": "https://www.eudora.com.br/site-todo/", 
                "domain": "www.eudora.com.br", 
                "prefix": None,
                "speed": "fast",  # ✅ MARCA RÁPIDA
                "delay": 1.5      # ✅ DELAY MÍNIMO
            },
            {
                "brand": "Mary Kay",
                "list_urls": [
                    "https://loja.marykay.com.br/cuidados-faciais",
                    "https://loja.marykay.com.br/maquiagem", 
                    "https://loja.marykay.com.br/cuidados-corporais",
                    "https://loja.marykay.com.br/fragrancias"  # ✅ REDUZIDO PARA 4 URLs
                ],
                "domain": "loja.marykay.com.br", 
                "prefix": None,
                "speed": "slow",   # ✅ MARCA LENTA (JavaScript)
                "delay": 3.0       # ✅ DELAY NECESSÁRIO
            }
        ]

        # ✅ MODO RÁPIDO: REDUZIR DELAYS
        if options['fast_mode']:
            for store in STORES:
                store['delay'] = store['delay'] * 0.5  # Reduzir delays pela metade
            self.stdout.write(self.style.WARNING("⚡ MODO RÁPIDO ATIVADO: Delays reduzidos"))
        
        # ✅ FILTRAR MARCA ESPECÍFICA SE SOLICITADO
        if options['brand']:
            STORES = [s for s in STORES if s['brand'].lower() == options['brand'].lower()]
            if not STORES:
                self.stdout.write(self.style.ERROR(f"❌ Marca '{options['brand']}' não encontrada!"))
                return

        # ✅ PROCESSAR MARCAS RÁPIDAS PRIMEIRO
        fast_stores = [s for s in STORES if s['speed'] == 'fast']
        slow_stores = [s for s in STORES if s['speed'] == 'slow']
        
        self.stdout.write(f"🚀 Marcas rápidas: {len(fast_stores)} | 🐌 Marcas lentas: {len(slow_stores)}")
        
        # ✅ PRIORIZAR PRODUTOS EXISTENTES
        if options['update_existing']:
            self.stdout.write(self.style.WARNING("🎯 MODO PRIORITÁRIO: Atualizando produtos existentes primeiro..."))
            self.update_existing_products(STORES)
        
        MAX_PAGES = options['max_pages']
        total_processed = 0

        # ✅ CONFIGURAÇÃO SELENIUMBASE OTIMIZADA
        with SB(
            uc=True,
            headless=True, 
            page_load_strategy="eager",  # ✅ CARREGAMENTO MAIS RÁPIDO
            disable_js=False,
            disable_csp=True,
            incognito=True,
        ) as sb:
            
            # ✅ TIMEOUTS OTIMIZADOS
            sb.driver.set_page_load_timeout(30)  # ✅ REDUZIDO DE 45 para 30
            sb.driver.set_script_timeout(20)     # ✅ REDUZIDO DE 30 para 20
            
            # ✅ CONFIGURAR TRATAMENTO DE ERROS GLOBAL
            sb.driver.execute_cdp_cmd('Page.addScriptToEvaluateOnNewDocument', {
                'source': '''
                    Object.defineProperty(navigator, 'webdriver', {
                        get: () => undefined,
                    });
                    
                    window.addEventListener('error', function(e) {
                        if (e.message && e.message.includes('return')) {
                            e.stopPropagation();
                            e.preventDefault();
                            return true;
                        }
                    }, true);
                    
                    window.onerror = function(msg, url, line, col, error) {
                        if (msg && msg.includes('Illegal return statement')) {
                            return true;
                        }
                        return false;
                    };
                '''
            })
            
            # ✅ PROCESSAR MARCAS RÁPIDAS PRIMEIRO
            for store in fast_stores:
                processed = self.process_fast_brand(sb, store, MAX_PAGES)
                total_processed += processed
                self.stdout.write(f"✅ {store['brand']}: {processed} produtos processados")
            
            # ✅ PROCESSAR MARCAS LENTAS POR ÚLTIMO
            for store in slow_stores:
                processed = self.process_slow_brand(sb, store, min(MAX_PAGES, 5))  # ✅ LIMITAR MARY KAY
                total_processed += processed
                self.stdout.write(f"✅ {store['brand']}: {processed} produtos processados")

        self.stdout.write(self.style.SUCCESS(f"🎉 Total processado: {total_processed} produtos"))

    def extract_mary_kay_simple(self, sb):
        """⚡ EXTRAÇÃO SIMPLIFICADA MARY KAY COM VERIFICAÇÃO DE SKU EXISTENTE"""
        try:
            soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
            
            # ✅ SKU
            sku_tag = soup.find(class_=re.compile(r'product-identifier__value'))
            sku = sku_tag.text.strip() if sku_tag else None
            
            if not sku:
                return None
            
            # ✅ VERIFICAR SE SKU JÁ EXISTE NO BANCO
            if sku in self.existing_mary_kay_skus:
                self.stdout.write(f"   ⏭️ SKU {sku} já existe no banco, pulando...")
                return None
            
            # ✅ NOME
            name_tag = soup.find(['h1', 'h2'], class_=re.compile(r'product|title'))
            name = name_tag.text.strip() if name_tag else f"Produto Mary Kay {sku}"
            
            # ✅ PREÇO (SIMPLIFICADO)
            price = Decimal('0.00')
            try:
                price_tag = soup.find(class_=re.compile(r'price|valor'))
                if price_tag:
                    price_text = re.search(r'(\d+[,\.]\d{2})', price_tag.text)
                    if price_text:
                        price = Decimal(price_text.group(1).replace(',', '.'))
            except:
                pass
            
            return {
                'sku': sku,
                'name': name,
                'price': price,
                'image_url': None,
                'desc': "Mary Kay"
            }
            
        except Exception:
            return None

    def parse_mary_kay_variation(self, soup, variation_text):
        """✅ PARSER MELHORADO PARA MARY KAY COM VERIFICAÇÃO DE SKU"""
        try:
            # ✅ SKU
            sku_tag = soup.find(class_=re.compile(r'product-identifier__value'))
            sku = sku_tag.text.strip() if sku_tag else None
            
            if not sku:
                return None
            
            # ✅ VERIFICAR SE SKU JÁ EXISTE NO BANCO
            if sku in self.existing_mary_kay_skus:
                self.stdout.write(f"   ⏭️ SKU {sku} (variação: {variation_text}) já existe no banco, pulando...")
                return None
            
            # ✅ NOME BASE
            base_name_tag = soup.find(class_=re.compile(r'productBrand'))
            base_name = base_name_tag.text.strip() if base_name_tag else "Produto Mary Kay"
            
            # ✅ NOME COMPLETO COM VARIAÇÃO
            if variation_text:
                full_name = f"{base_name} - {variation_text}"
            else:
                full_name = base_name
            
            # ✅ PREÇO
            price = Decimal('0.00')
            try:
                int_tag = soup.find(class_=re.compile(r'currencyInteger'))
                frac_tag = soup.find(class_=re.compile(r'currencyFraction'))
                
                if int_tag and frac_tag:
                    price_str = f"{int_tag.text.strip()}.{frac_tag.text.strip()}"
                    price = Decimal(price_str)
            except:
                pass
            
            # ✅ IMAGEM
            image_url = None
            img_tag = soup.find('img', class_=re.compile(r'productImageTag--main'))
            if img_tag and img_tag.has_attr('src'):
                image_url = img_tag['src'].split('?')[0]
            
            # ✅ DESCRIÇÃO
            description = f"Mary Kay - {variation_text}" if variation_text else "Mary Kay"
            
            return {
                'sku': sku,
                'name': full_name,
                'price': price,
                'image_url': image_url,
                'desc': description
            }
            
        except Exception as e:
            self.stdout.write(f"❌ Erro ao parsear Mary Kay: {e}")
            return None

    def save_product_safely(self, product_data, brand):
        """✅ SALVAMENTO SEGURO COM ATUALIZAÇÃO DO CACHE"""
        try:
            sku = product_data['sku']
            name = product_data['name'] or f"Produto {brand} - {sku}"
            price = product_data['price']
            image_url = product_data['image_url']
            description = product_data['desc']
            
            if "Access Denied" in name or "Access Denied" in str(description):
                return False
            
            if not sku or len(str(sku)) < 2:
                return False
            
            smart_category = detect_category(name)
            
            product, created = Product.objects.get_or_create(
                natura_sku=str(sku),
                defaults={
                    'name': name[:255],
                    'brand': brand,
                    'category': smart_category,
                    'official_price': price,
                    'bar_code': None,
                    'image_url': image_url,
                    'description': description or f"Descoberto no site {brand}",
                    'last_checked_at': timezone.now(),
                    'last_checked_price': price,
                    'is_protected': True
                }
            )
            
            # ✅ ADICIONAR SKU AO CACHE SE FOR MARY KAY E NOVO
            if brand == "Mary Kay" and created:
                self.existing_mary_kay_skus.add(str(sku))
            
            if not created:
                if len(name) > len(product.name) or "Produto" in product.name:
                    product.name = name[:255]
                
                product.brand = brand
                product.category = smart_category
                product.official_price = price
                product.last_checked_at = timezone.now()
                product.last_checked_price = price
                
                if image_url and not product.image_url:
                    product.image_url = image_url
                
                if description and (not product.description or len(description) > len(product.description)):
                    product.description = description
                
                product.save()
            
            # ✅ HISTÓRICO DE PREÇOS - CORRIGIDO PARA USAR captured_at
            if price > 0:
                try:
                    # Verificar se já existe um preço similar nas últimas 24 horas
                    recent_price = PriceHistory.objects.filter(
                        product=product,
                        price=price,
                        captured_at__gte=timezone.now() - timedelta(hours=24)  # ✅ CORRIGIDO: captured_at
                    ).first()
                    
                    if not recent_price:
                        PriceHistory.objects.create(
                            product=product,
                            price=price
                            # ✅ captured_at será definido automaticamente pelo modelo
                        )
                except Exception as price_error:
                    # ✅ NÃO MOSTRAR ERRO - apenas log interno
                    pass
            
            status = "✨" if created else "🔄"
            img_status = "🖼️" if image_url else "❌"
            price_display = f"R$ {price}" if price > 0 else "Sem preço"
            
            self.stdout.write(self.style.SUCCESS(
                f"{status} [{brand}] {sku} ({smart_category}) - {name[:30]}... | {price_display} | {img_status}"
            ))
            
            return True
            
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"❌ Erro ao salvar produto: {e}"))
            return False

    # ✅ MANTER TODOS OS OUTROS MÉTODOS INALTERADOS
    def process_fast_brand(self, sb, store, max_pages):
        """⚡ PROCESSAMENTO OTIMIZADO PARA MARCAS RÁPIDAS"""
        processed = 0
        empty_pages = 0
        
        for page in range(1, max_pages + 1):
            if empty_pages >= 2:  # ✅ PARAR MAIS CEDO
                break
                
            url = f"{store['list_url']}?page={page}" if '?' not in store['list_url'] else f"{store['list_url']}&page={page}"
            
            try:
                sb.open(url)
                sb.sleep(store['delay'])  # ✅ DELAY MÍNIMO
                
                # ✅ SCROLL RÁPIDO
                sb.execute_script("window.scrollTo(0, document.body.scrollHeight);")
                sb.sleep(0.5)  # ✅ DELAY MÍNIMO
                
                # ✅ VERIFICAR BLOQUEIOS
                page_title = sb.get_title()
                if "Access Denied" in page_title or "erro" in page_title.lower():
                    self.stdout.write(self.style.ERROR(f"⛔ Bloqueio detectado em {store['brand']}!"))
                    continue
                
                soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
                products = self.extract_fast_products(soup, store)
                
                if not products:
                    empty_pages += 1
                    continue
                
                empty_pages = 0
                
                # ✅ PROCESSAMENTO EM LOTE
                for product_data in products:
                    if self.save_product_safely(product_data, store['brand']):
                        processed += 1
                
                self.stdout.write(f"   📄 Página {page}: {len(products)} produtos")
                
            except Exception as e:
                self.stdout.write(f"❌ Erro página {page}: {e}")
                continue
        
        return processed

    def process_slow_brand(self, sb, store, max_pages):
        """🐌 PROCESSAMENTO CUIDADOSO PARA MARY KAY COM VERIFICAÇÃO DE SKU"""
        processed = 0
        skipped = 0
        
        urls_to_visit = store.get('list_urls', [store.get('list_url')])
        
        for base_url in urls_to_visit:
            for page in range(1, max_pages + 1):
                url = f"{base_url}?page={page}"
                
                try:
                    sb.open(url)
                    sb.sleep(store['delay'])  # ✅ DELAY NECESSÁRIO
                    
                    # ✅ AGUARDAR JAVASCRIPT
                    try:
                        sb.wait_for_element("body", timeout=15)
                    except:
                        sb.sleep(2)
                    
                    # ✅ SCROLL GRADUAL
                    sb.execute_script("window.scrollTo(0, document.body.scrollHeight * 0.5);")
                    sb.sleep(1)
                    sb.execute_script("window.scrollTo(0, document.body.scrollHeight);")
                    sb.sleep(2)
                    
                    soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
                    product_links = self.extract_mary_kay_links(soup, store)
                    
                    # ✅ PROCESSAR APENAS OS PRIMEIROS 10 PRODUTOS POR PÁGINA
                    limited_links = product_links[:10]
                    
                    for product_link in limited_links:
                        try:
                            sb.open(product_link['url'])
                            sb.sleep(2)  # ✅ DELAY REDUZIDO
                            
                            # ✅ EXTRAÇÃO SIMPLIFICADA (SEM VARIAÇÕES) COM VERIFICAÇÃO DE SKU
                            product_data = self.extract_mary_kay_simple(sb)
                            
                            if product_data is None:
                                skipped += 1
                                continue
                            
                            if self.save_product_safely(product_data, store['brand']):
                                processed += 1
                            
                        except Exception:
                            continue  # ✅ IGNORAR ERROS E CONTINUAR
                    
                    self.stdout.write(f"   📄 {base_url} - Página {page}: {len(limited_links)} produtos | Pulados: {skipped}")
                    
                except Exception:
                    continue
        
        return processed

    # ✅ MANTER TODOS OS OUTROS MÉTODOS ORIGINAIS INALTERADOS
    def extract_fast_products(self, soup, store):
        """⚡ EXTRAÇÃO RÁPIDA PARA MARCAS SIMPLES"""
        products = []
        
        if store['brand'] in ["Natura", "Avon"]:
            # ✅ EXTRAÇÃO DIRETA POR SKU
            product_cards = soup.find_all('a', href=re.compile(rf"{store['prefix']}-\d+"))
            
            for a in product_cards[:20]:  # ✅ LIMITAR A 20 POR PÁGINA
                href = a.get('href')
                if not href:
                    continue
                
                # ✅ EXTRAIR SKU DIRETAMENTE DA URL
                sku_match = re.search(rf'{store["prefix"]}-(\d+)', href)
                if not sku_match:
                    continue
                
                sku = sku_match.group(1)
                
                # ✅ NOME DO PRODUTO
                name_elem = a.find(['h2', 'h3', 'span'], class_=re.compile(r'product|title|name'))
                name = name_elem.text.strip() if name_elem else f"Produto {store['brand']} {sku}"
                
                # ✅ PREÇO (OPCIONAL)
                price = Decimal('0.00')
                price_elem = a.find(['span', 'div'], class_=re.compile(r'price|valor'))
                if price_elem:
                    price_text = re.search(r'(\d+[,\.]\d{2})', price_elem.text)
                    if price_text:
                        price = Decimal(price_text.group(1).replace(',', '.'))
                
                products.append({
                    'sku': sku,
                    'name': name,
                    'price': price,
                    'image_url': None,
                    'desc': f"Produto {store['brand']}"
                })
        
        else:
            # ✅ OUTRAS MARCAS: EXTRAÇÃO SIMPLIFICADA
            product_cards = soup.find_all('a', href=True)
            
            for a in product_cards[:15]:  # ✅ LIMITAR A 15 POR PÁGINA
                href = a.get('href')
                if not href or '/p' not in href:
                    continue
                
                # ✅ SKU GENÉRICO
                sku = href.split('/')[-1][:10]  # ✅ USAR PARTE DA URL COMO SKU
                
                # ✅ NOME
                name_elem = a.find(['h2', 'h3', 'span'])
                name = name_elem.text.strip() if name_elem else f"Produto {store['brand']}"
                
                products.append({
                    'sku': sku,
                    'name': name,
                    'price': Decimal('0.00'),
                    'image_url': None,
                    'desc': f"Produto {store['brand']}"
                })
        
        return products

    def extract_mary_kay_links(self, soup, store):
        """🔗 EXTRAIR APENAS LINKS DA MARY KAY (SEM PROCESSAR)"""
        links = []
        
        product_cards = soup.find_all('a', href=True)
        for a in product_cards:
            href = a.get('href')
            if not href or len(href) < 20:
                continue
            
            # ✅ FILTROS BÁSICOS
            if any(x in href.lower() for x in ['login', 'cart', 'account', 'search']):
                continue
            
            full_url = href if href.startswith('http') else f"https://{store['domain']}{href}"
            links.append({"url": full_url, "brand": store['brand']})
        
        return links

    def update_existing_products(self, stores):
        """✅ ATUALIZAR PRODUTOS EXISTENTES PRIMEIRO"""
        brand_names = [store['brand'] for store in stores]
        
        existing_products = Product.objects.filter(
            Q(brand__in=brand_names) & (
                Q(name__icontains='Produto') | 
                Q(last_checked_at__lt=timezone.now() - timedelta(days=7)) |
                Q(official_price=0)
            )
        ).order_by('last_checked_at')[:50]
        
        self.stdout.write(f"🎯 Encontrados {existing_products.count()} produtos para atualizar")
        
        for product in existing_products:
            self.stdout.write(f"   📝 Marcado para atualização: {product.brand} - {product.natura_sku}")

    # ✅ MANTER TODOS OS OUTROS MÉTODOS ORIGINAIS...
    def discover_products_for_brand(self, sb, store, page):
        """✅ DESCOBRIR PRODUTOS DE UMA MARCA EM UMA PÁGINA"""
        discovered = []
        
        if store['brand'] == 'Mary Kay':
            urls_to_visit = store.get('list_urls', [])
        else:
            urls_to_visit = [store.get('list_url')]
        
        for base_url in urls_to_visit:
            if not base_url:
                continue
                
            if '?' in base_url:
                url = f"{base_url}&page={page}"
            else:
                url = f"{base_url}?page={page}"
            
            try:
                sb.open(url)
                
                try:
                    sb.wait_for_element("body", timeout=15)
                except Exception:
                    sb.sleep(5)
                
                sb.sleep(random.uniform(2.0, 4.0))
                
                # ✅ SCROLL INTELIGENTE
                sb.execute_script("window.scrollTo(0, document.body.scrollHeight * 0.3);")
                sb.sleep(2)
                sb.execute_script("window.scrollTo(0, document.body.scrollHeight * 0.8);")
                sb.sleep(3)
                
                # ✅ VERIFICAR BLOQUEIOS
                page_title = sb.get_title()
                if "Access Denied" in page_title or "erro" in page_title.lower():
                    self.stdout.write(self.style.ERROR(f"⛔ Bloqueio detectado em {store['brand']}!"))
                    continue
                
                soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
                page_links = self.extract_product_links(soup, store)
                discovered.extend(page_links)
                
            except Exception as e:
                self.stdout.write(self.style.ERROR(f"❌ Erro ao descobrir {store['brand']}: {e}"))
                continue
        
        return discovered

    def extract_product_links(self, soup, store):
        """✅ EXTRAIR LINKS DE PRODUTOS DO HTML"""
        links = []
        
        if store['brand'] in ["Natura", "Avon"]:
            product_cards = soup.find_all('a', href=re.compile(rf"{store['prefix']}-\d+"))
            for a in product_cards:
                href = a.get('href')
                if href:
                    full_url = href if href.startswith('http') else f"https://{store['domain']}{href}"
                    links.append({
                        "url": full_url, 
                        "brand": store['brand'], 
                        "prefix": store['prefix']
                    })
        
        elif store['brand'] == "Mary Kay":
            product_cards = soup.find_all('a', href=True)
            for a in product_cards:
                href = a.get('href')
                if not href or href in ['/', '#'] or 'javascript' in href:
                    continue
                
                if (len(href) > 15 and 
                    'login' not in href.lower() and 
                    'account' not in href.lower() and 
                    'cart' not in href.lower() and
                    'checkout' not in href.lower() and
                    'search' not in href.lower() and
                    'category' not in href.lower()):
                    
                    full_url = href if href.startswith('http') else f"https://{store['domain']}{href}"
                    if full_url not in [link['url'] for link in links]:
                        links.append({
                            "url": full_url, 
                            "brand": store['brand']
                        })
        
        else:
            product_cards = soup.find_all('a', href=True)
            for a in product_cards:
                href = a.get('href')
                if href and '/p' in href:
                    full_url = href if href.startswith('http') else f"https://{store['domain']}{href}"
                    if full_url not in [link['url'] for link in links]:
                        links.append({
                            "url": full_url, 
                            "brand": store['brand']
                        })
        
        return links

    def process_discovered_products(self, sb, discovered_products):
        """✅ PROCESSAR PRODUTOS DESCOBERTOS DE FORMA INTELIGENTE"""
        total_products = sum(len(products) for products in discovered_products.values())
        self.stdout.write(self.style.WARNING(f"\n🛒 Processando {total_products} produtos descobertos..."))
        
        all_products = []
        for brand, products in discovered_products.items():
            all_products.extend(products)
        
        random.shuffle(all_products)
        
        processed = 0
        errors = 0
        
        for product_info in all_products:
            try:
                success = self.extract_single_product(sb, product_info)
                if success:
                    processed += 1
                else:
                    errors += 1
                
                sb.sleep(random.uniform(3.0, 6.0))
                
            except Exception as e:
                errors += 1
                self.stdout.write(self.style.ERROR(f"❌ Erro no produto: {e}"))
                sb.sleep(2.0)
        
        self.stdout.write(self.style.SUCCESS(f"📊 Processados: {processed} | Erros: {errors}"))

    def extract_single_product(self, sb, product_info):
        """✅ EXTRAIR DADOS DE UM PRODUTO ESPECÍFICO"""
        product_url = product_info["url"]
        brand = product_info["brand"]
        
        try:
            sb.open(product_url)
            sb.sleep(random.uniform(3.0, 5.0))
            
            products_to_save = []
            
            if brand == "Mary Kay":
                products_to_save = self.extract_mary_kay_product(sb)
            elif brand in ["Natura", "Avon"]:
                products_to_save = self.extract_natura_avon_product(sb, product_info)
            else:
                products_to_save = self.extract_other_brand_product(sb, brand)
            
            for product_data in products_to_save:
                self.save_product_safely(product_data, brand)
            
            return len(products_to_save) > 0
            
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"❌ Erro ao extrair {brand}: {e}"))
            return False

    def extract_mary_kay_product(self, sb):
        """✅ EXTRAÇÃO MARY KAY COM TRATAMENTO DE ERROS"""
        products = []
        
        try:
            sb.wait_for_element('body', timeout=20)
            sb.sleep(4)
            
            page_title = sb.get_title()
            if "erro" in page_title.lower() or "error" in page_title.lower():
                self.stdout.write(f"⚠️ Página com erro detectada: {page_title}")
                return []
            
            try:
                variations = sb.execute_script("""
                    try {
                        var elements = document.querySelectorAll('div[role="button"][class*="skuSelectorItem"]');
                        return Array.from(elements).map(function(el, index) {
                            return {
                                index: index,
                                text: el.textContent ? el.textContent.trim() : ''
                            };
                        });
                    } catch(e) {
                        return [];
                    }
                """)
            except Exception:
                variations = []
            
            if variations and len(variations) > 0:
                self.stdout.write(f"   🎨 Produto com {len(variations)} variações")
                
                for i, variation in enumerate(variations):
                    if i >= 8:
                        break
                        
                    try:
                        sb.execute_script(f"""
                            try {{
                                var elements = document.querySelectorAll('div[role="button"][class*="skuSelectorItem"]');
                                if (elements[{variation['index']}]) {{
                                    elements[{variation['index']}].click();
                                }}
                            }} catch(e) {{
                                // Ignorar erro
                            }}
                        """)
                        sb.sleep(3)
                        
                        soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
                        product_data = self.parse_mary_kay_variation(soup, variation['text'])
                        
                        if product_data and product_data['sku']:
                            products.append(product_data)
                            
                    except Exception as e:
                        self.stdout.write(f"   ⚠️ Erro na variação {variation['text']}: {e}")
                        continue
            else:
                soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
                product_data = self.parse_mary_kay_variation(soup, "")
                
                if product_data and product_data['sku']:
                    products.append(product_data)
            
        except Exception as e:
            if "Illegal return statement" not in str(e):
                self.stdout.write(f"❌ Erro geral Mary Kay: {e}")
        
        return products

    def parse_mary_kay_variation(self, soup, variation_text):
        """✅ PARSER MELHORADO PARA MARY KAY"""
        try:
            # ✅ SKU
            sku_tag = soup.find(class_=re.compile(r'product-identifier__value'))
            sku = sku_tag.text.strip() if sku_tag else None
            
            if not sku:
                return None
            
            # ✅ NOME BASE
            base_name_tag = soup.find(class_=re.compile(r'productBrand'))
            base_name = base_name_tag.text.strip() if base_name_tag else "Produto Mary Kay"
            
            # ✅ NOME COMPLETO COM VARIAÇÃO
            if variation_text:
                full_name = f"{base_name} - {variation_text}"
            else:
                full_name = base_name
            
            # ✅ PREÇO
            price = Decimal('0.00')
            try:
                int_tag = soup.find(class_=re.compile(r'currencyInteger'))
                frac_tag = soup.find(class_=re.compile(r'currencyFraction'))
                
                if int_tag and frac_tag:
                    price_str = f"{int_tag.text.strip()}.{frac_tag.text.strip()}"
                    price = Decimal(price_str)
            except:
                pass
            
            # ✅ IMAGEM
            image_url = None
            img_tag = soup.find('img', class_=re.compile(r'productImageTag--main'))
            if img_tag and img_tag.has_attr('src'):
                image_url = img_tag['src'].split('?')[0]
            
            # ✅ DESCRIÇÃO
            description = f"Mary Kay - {variation_text}" if variation_text else "Mary Kay"
            
            return {
                'sku': sku,
                'name': full_name,
                'price': price,
                'image_url': image_url,
                'desc': description
            }
            
        except Exception as e:
            self.stdout.write(f"❌ Erro ao parsear Mary Kay: {e}")
            return None

    def extract_natura_avon_product(self, sb, product_info):
        """✅ EXTRAÇÃO NATURA/AVON"""
        products = []
        
        try:
            soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
            prefix = product_info.get("prefix")
            
            sku_match = re.search(rf'{prefix}-(\d+)', product_info["url"])
            sku = sku_match.group(1) if sku_match else None
            
            title_tag = soup.find('h1')
            name = title_tag.text.strip() if title_tag else f"Produto {product_info['brand']}"
            
            price = Decimal('0.00')
            price_tag = soup.find(['div', 'span'], id="product-price")
            if price_tag:
                aria_label = price_tag.get('aria-label', '')
                match = re.search(r'(\d{1,3}(\.\d{3})*,\d{2})', aria_label) or re.search(r'(\d{1,3}(\.\d{3})*,\d{2})', price_tag.text)
                if match:
                    price = Decimal(match.group(1).replace('.', '').replace(',', '.'))
            
            image_url = None
            img_tag = soup.find('img', src=re.compile(r'production\.na01\.natura\.com|avon'))
            if img_tag and img_tag.has_attr('src'):
                image_url = img_tag.get('src').split('?')[0]
            
            desc_tag = soup.find('div', id=re.compile(r'description', re.I))
            description = desc_tag.get_text(separator='\n', strip=True) if desc_tag else f"Produto {product_info['brand']}"
            
            if sku:
                products.append({
                    'sku': sku,
                    'name': name,
                    'price': price,
                    'image_url': image_url,
                    'desc': description
                })
                
        except Exception as e:
            self.stdout.write(f"❌ Erro {product_info['brand']}: {e}")
        
        return products

    def extract_other_brand_product(self, sb, brand):
        """✅ EXTRAÇÃO OUTRAS MARCAS"""
        products = []
        
        try:
            soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
            
            sku_div = soup.find('div', class_=re.compile(r'product-sku'))
            sku = None
            if sku_div:
                raw_sku = sku_div.text.replace('Cod:', '').replace('"', '').strip()
                if raw_sku:
                    sku = raw_sku
            
            name_tag = soup.find('h1')
            name = name_tag.text.strip() if name_tag else f"Produto {brand}"
            
            price = Decimal('0.00')
            price_div = soup.find('div', class_=re.compile(r'nproduct-price-value'))
            if price_div and price_div.has_attr('content'):
                try:
                    price = Decimal(price_div['content'])
                except:
                    pass
            
            image_url = None
            img_tag = soup.find('img', class_=re.compile(r'product-image'))
            if img_tag:
                raw_img = img_tag.get('data-zoom-image') or img_tag.get('data-src') or img_tag.get('src')
                if raw_img and not raw_img.startswith('data:image'):
                    image_url = raw_img
            
            desc_tag = soup.find('div', class_=re.compile(r'product-description'))
            description = desc_tag.get_text(separator='\n', strip=True) if desc_tag else f"Produto {brand}"
            
            if sku:
                products.append({
                    'sku': sku,
                    'name': name,
                    'price': price,
                    'image_url': image_url,
                    'desc': description
                })
                
        except Exception as e:
            self.stdout.write(f"❌ Erro {brand}: {e}")
        
        return products

    def save_product_safely(self, product_data, brand):
        """✅ SALVAMENTO SEGURO COM CORREÇÃO COMPLETA"""
        try:
            sku = product_data['sku']
            name = product_data['name'] or f"Produto {brand} - {sku}"
            price = product_data['price']
            image_url = product_data['image_url']
            description = product_data['desc']
            
            if "Access Denied" in name or "Access Denied" in str(description):
                return False
            
            if not sku or len(str(sku)) < 2:
                return False
            
            smart_category = detect_category(name)
            
            product, created = Product.objects.get_or_create(
                natura_sku=str(sku),
                defaults={
                    'name': name[:255],
                    'brand': brand,
                    'category': smart_category,
                    'official_price': price,
                    'bar_code': None,
                    'image_url': image_url,
                    'description': description or f"Descoberto no site {brand}",
                    'last_checked_at': timezone.now(),
                    'last_checked_price': price,
                    'is_protected': True
                }
            )
            
            if not created:
                if len(name) > len(product.name) or "Produto" in product.name:
                    product.name = name[:255]
                
                product.brand = brand
                product.category = smart_category
                product.official_price = price
                product.last_checked_at = timezone.now()
                product.last_checked_price = price
                
                if image_url and not product.image_url:
                    product.image_url = image_url
                
                if description and (not product.description or len(description) > len(product.description)):
                    product.description = description
                
                product.save()
            
            # ✅ HISTÓRICO DE PREÇOS - CORRIGIDO PARA USAR captured_at
            if price > 0:
                try:
                    # Verificar se já existe um preço similar nas últimas 24 horas
                    recent_price = PriceHistory.objects.filter(
                        product=product,
                        price=price,
                        captured_at__gte=timezone.now() - timedelta(hours=24)  # ✅ CORRIGIDO: captured_at
                    ).first()
                    
                    if not recent_price:
                        PriceHistory.objects.create(
                            product=product,
                            price=price
                            # ✅ captured_at será definido automaticamente pelo modelo
                        )
                except Exception as price_error:
                    # ✅ NÃO MOSTRAR ERRO - apenas log interno
                    pass
            
            status = "✨" if created else "🔄"
            img_status = "🖼️" if image_url else "❌"
            price_display = f"R$ {price}" if price > 0 else "Sem preço"
            
            self.stdout.write(self.style.SUCCESS(
                f"{status} [{brand}] {sku} ({smart_category}) - {name[:30]}... | {price_display} | {img_status}"
            ))
            
            return True
            
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"❌ Erro ao salvar produto: {e}"))
            return False