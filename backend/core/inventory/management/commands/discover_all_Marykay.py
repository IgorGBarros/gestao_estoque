from django.core.management.base import BaseCommand
from django.utils import timezone
from inventory.models import Product
from seleniumbase import SB
from bs4 import BeautifulSoup
import re
import time
import random

class Command(BaseCommand):
    help = 'Varredura Total Mary Kay: Salva apenas NOVOS SKUs - SEM alterar existentes'
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # ✅ CACHE DE SKUs EXISTENTES PARA PERFORMANCE
        self.existing_skus = set()
        self.protected_skus = set()
        self._load_existing_skus()
    
    def _load_existing_skus(self):
        """✅ CARREGAR SKUs EXISTENTES NO INÍCIO PARA EVITAR CONSULTAS REPETIDAS"""
        try:
            # Carregar todos os SKUs existentes da Mary Kay
            existing_products = Product.objects.filter(brand="Mary Kay").values_list('natura_sku', 'bar_code')
            
            for sku, barcode in existing_products:
                if sku:
                    self.existing_skus.add(str(sku))
                    # ✅ PRODUTOS COM BARCODE SÃO SUPER PROTEGIDOS
                    if barcode:
                        self.protected_skus.add(str(sku))
            
            self.stdout.write(f"📋 Carregados {len(self.existing_skus)} SKUs Mary Kay existentes")
            self.stdout.write(f"🔒 {len(self.protected_skus)} produtos protegidos (com barcode)")
            
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"⚠️ Erro ao carregar SKUs existentes: {e}"))
            self.existing_skus = set()
            self.protected_skus = set()

    def handle(self, *args, **kwargs):
        # 🚀 CONFIGURAÇÃO MARY KAY
        mary_kay_urls = [
            "https://loja.marykay.com.br/cuidados-faciais",
            "https://loja.marykay.com.br/maquiagem", 
            "https://loja.marykay.com.br/cuidados-corporais",
            "https://loja.marykay.com.br/fragrancias",
            "https://loja.marykay.com.br/presentes",
            "https://loja.marykay.com.br/promocoes"
        ]
        
        self.stdout.write(self.style.WARNING(f"🕷️ Iniciando Varredura Total Mary Kay PROTEGIDA"))
        self.stdout.write(self.style.WARNING("🛡️ MODO PROTEÇÃO: Apenas novos produtos serão adicionados"))
        
        with SB(uc=True, headless=True, page_load_strategy="eager") as sb:
            # ✅ CONFIGURAR TIMEOUTS OTIMIZADOS
            sb.driver.set_page_load_timeout(30)
            sb.driver.set_script_timeout(20)
            
            # ✅ CONFIGURAR TRATAMENTO DE ERROS JAVASCRIPT
            sb.execute_script("""
                // Silenciar erros de JavaScript do site Mary Kay
                window.onerror = function() { return true; };
                window.addEventListener('error', function(e) { 
                    e.stopPropagation(); 
                }, true);
            """)
            
            total_found = 0
            total_new = 0
            total_skipped = 0
            
            # ✅ PROCESSAR CADA CATEGORIA DA MARY KAY
            for category_url in mary_kay_urls:
                category_name = category_url.split('/')[-1].replace('-', ' ').title()
                self.stdout.write(f"\n🎨 Processando categoria: {category_name}")
                
                page = 1
                empty_pages_count = 0
                
                while page <= 10:  # Limitar a 10 páginas por categoria
                    url = f"{category_url}?page={page}"
                    self.stdout.write(f"📂 Lendo Página {page} - {category_name}...")
                    
                    try:
                        sb.open(url)
                        sb.sleep(3)  # Aguardar carregamento JavaScript
                        
                        # ✅ AGUARDAR CARREGAMENTO
                        try:
                            sb.wait_for_element("body", timeout=15)
                        except:
                            sb.sleep(2)
                        
                        # ✅ SCROLL PARA CARREGAR PRODUTOS
                        sb.execute_script("window.scrollTo(0, document.body.scrollHeight * 0.5);")
                        sb.sleep(2)
                        sb.execute_script("window.scrollTo(0, document.body.scrollHeight);")
                        sb.sleep(3)
                        
                        # ✅ VERIFICAR SE CHEGOU AO FIM
                        page_title = sb.get_title()
                        if "erro" in page_title.lower() or "error" in page_title.lower():
                            self.stdout.write(f"   ⚠️ Erro na página {page}")
                            break
                        
                        soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
                        
                        # ✅ EXTRAIR LINKS DE PRODUTOS MARY KAY
                        product_links = self.extract_mary_kay_links(soup)
                        
                        if not product_links:
                            empty_pages_count += 1
                            self.stdout.write(f"   ⚠️ Nenhum produto na página {page}")
                            if empty_pages_count >= 2:
                                break
                        else:
                            empty_pages_count = 0
                        
                        # ✅ PROCESSAR PRODUTOS ENCONTRADOS
                        count_new, count_skipped, count_protected = self.process_mary_kay_products(
                            sb, product_links, category_name, page
                        )
                        
                        total_found += len(product_links)
                        total_new += count_new
                        total_skipped += count_skipped
                        
                        # ✅ RELATÓRIO DA PÁGINA
                        self.stdout.write(self.style.SUCCESS(
                            f"   ✅ Pág {page}: {len(product_links)} produtos | "
                            f"✨ {count_new} novos | "
                            f"⏭️ {count_skipped} existentes | "
                            f"🔒 {count_protected} protegidos"
                        ))
                        
                        page += 1
                        sb.sleep(random.uniform(2.0, 4.0))
                        
                    except Exception as e:
                        self.stdout.write(self.style.ERROR(f"❌ Erro na pág {page}: {e}"))
                        sb.sleep(5)
                        page += 1
        
        # ✅ RELATÓRIO FINAL
        self.stdout.write(self.style.SUCCESS("🎉 Varredura Mary Kay Finalizada!"))
        self.stdout.write(self.style.SUCCESS(f"📊 ESTATÍSTICAS FINAIS:"))
        self.stdout.write(f"   🔍 Total encontrados: {total_found}")
        self.stdout.write(f"   ✨ Novos adicionados: {total_new}")
        self.stdout.write(f"   ⏭️ Existentes pulados: {total_skipped}")
        self.stdout.write(f"   🔒 Protegidos (com barcode): {len(self.protected_skus)}")
        
        if total_new > 0:
            self.stdout.write(self.style.SUCCESS(f"✅ {total_new} novos produtos Mary Kay adicionados!"))
        else:
            self.stdout.write(self.style.WARNING("ℹ️ Nenhum produto novo encontrado - catálogo Mary Kay já atualizado"))

    def extract_mary_kay_links(self, soup):
        """✅ EXTRAIR LINKS DE PRODUTOS MARY KAY DAS PÁGINAS DE LISTAGEM"""
        links = []
        
        # ✅ BUSCAR LINKS DE PRODUTOS
        product_cards = soup.find_all('a', href=True)
        
        for a in product_cards:
            href = a.get('href')
            if not href or len(href) < 20:
                continue
            
            # ✅ FILTROS ESPECÍFICOS MARY KAY
            if any(x in href.lower() for x in ['login', 'cart', 'account', 'search', 'category']):
                continue
            
            # ✅ VERIFICAR SE É PRODUTO (tem estrutura de produto)
            if ('marykay.com.br' in href or href.startswith('/')) and len(href) > 15:
                full_url = href if href.startswith('http') else f"https://loja.marykay.com.br{href}"
                
                # ✅ EVITAR DUPLICATAS
                if full_url not in links:
                    links.append(full_url)
        
        return links[:15]  # Limitar a 15 produtos por página

    def process_mary_kay_products(self, sb, product_links, category_name, page):
        """✅ PROCESSAR PRODUTOS MARY KAY DE UMA PÁGINA"""
        count_new = 0
        count_skipped = 0
        count_protected = 0
        
        for product_url in product_links:
            try:
                sb.open(product_url)
                sb.sleep(2)
                
                # ✅ EXTRAIR SKU E DADOS BÁSICOS
                product_data = self.extract_mary_kay_simple(sb)
                
                if not product_data or not product_data.get('sku'):
                    continue
                
                sku = str(product_data['sku'])
                
                # ✅ VERIFICAR SE SKU JÁ EXISTE (CACHE)
                if sku in self.existing_skus:
                    count_skipped += 1
                    
                    # ✅ LOG ESPECIAL PARA PRODUTOS PROTEGIDOS
                    if sku in self.protected_skus:
                        count_protected += 1
                    
                    continue  # ✅ PULAR PRODUTO EXISTENTE
                
                # ✅ CRIAR APENAS NOVOS PRODUTOS
                try:
                    product = Product.objects.create(
                        natura_sku=sku,
                        name=product_data['name'][:200],
                        brand="Mary Kay",
                        category=self.detect_mary_kay_category(product_data['name']),
                        official_price=product_data.get('price', 0),
                        bar_code=None,
                        image_url=product_data.get('image_url'),
                        description=f"Descoberto em {category_name} (Pág {page})",
                        last_checked_at=timezone.now()
                    )
                    
                    # ✅ ADICIONAR AO CACHE
                    self.existing_skus.add(sku)
                    count_new += 1
                    
                    # ✅ LOG DE SUCESSO
                    self.stdout.write(f"   ✨ NOVO: {sku} - {product_data['name'][:40]}...")
                    
                except Exception as e:
                    self.stdout.write(f"   ❌ Erro ao criar SKU {sku}: {e}")
                    continue
                
            except Exception as e:
                continue  # ✅ IGNORAR ERROS E CONTINUAR
        
        return count_new, count_skipped, count_protected

    def extract_mary_kay_simple(self, sb):
        """⚡ EXTRAÇÃO SIMPLIFICADA MARY KAY (SEM VARIAÇÕES)"""
        try:
            soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
            
            # ✅ SKU
            sku_tag = soup.find(class_=re.compile(r'product-identifier__value'))
            sku = sku_tag.text.strip() if sku_tag else None
            
            if not sku:
                return None
            
            # ✅ NOME
            name_tag = soup.find(['h1', 'h2'], class_=re.compile(r'product|title|brand'))
            name = name_tag.text.strip() if name_tag else f"Produto Mary Kay {sku}"
            
            # ✅ PREÇO (SIMPLIFICADO)
            price = 0
            try:
                int_tag = soup.find(class_=re.compile(r'currencyInteger'))
                frac_tag = soup.find(class_=re.compile(r'currencyFraction'))
                
                if int_tag and frac_tag:
                    price_str = f"{int_tag.text.strip()}.{frac_tag.text.strip()}"
                    price = float(price_str)
            except:
                pass
            
            # ✅ IMAGEM
            image_url = None
            img_tag = soup.find('img', class_=re.compile(r'productImageTag--main'))
            if img_tag and img_tag.get('src'):
                image_url = img_tag['src'].split('?')[0]
            
            return {
                'sku': sku,
                'name': name,
                'price': price,
                'image_url': image_url
            }
            
        except Exception:
            return None

    def detect_mary_kay_category(self, name):
        """🚀 FUNÇÃO DE INTELIGÊNCIA: Define a categoria Mary Kay"""
        if not name: 
            return "Geral"
        
        name_lower = name.lower()
        
        # Cuidados Faciais
        if any(x in name_lower for x in ['facial', 'serum', 'tônico', 'demaquilante', 'protetor solar', 'anti-idade', 'vitamina c', 'limpeza']):
            return "Cuidados Faciais"
        
        # Maquiagem
        if any(x in name_lower for x in ['batom', 'base', 'corretivo', 'pó', 'rimel', 'delineador', 'palette', 'paleta', 'lápis', 'blush', 'iluminador', 'sombra', 'gloss']):
            return "Maquiagem"
        
        # Corpo e Banho
        if any(x in name_lower for x in ['corporal', 'hidratante', 'creme', 'óleo', 'loção', 'esfoliante']):
            return "Corpo e Banho"
        
        # Perfumaria
        if any(x in name_lower for x in ['colônia', 'parfum', 'perfume', 'fragrância', 'eau de']):
            return "Perfumaria"
        
        return "Geral"