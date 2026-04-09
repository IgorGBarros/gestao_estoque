from django.core.management.base import BaseCommand
from django.utils import timezone
from inventory.models import Product
from seleniumbase import SB
from bs4 import BeautifulSoup
import re
import time
import random

class Command(BaseCommand):
    help = 'Varredura Total: Salva apenas NOVOS SKUs da página "Todos os Produtos" - SEM alterar existentes'
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # ✅ CACHE DE SKUs EXISTENTES PARA PERFORMANCE
        self.existing_skus = set()
        self.protected_skus = set()
        self._load_existing_skus()
    
    def _load_existing_skus(self):
        """✅ CARREGAR SKUs EXISTENTES NO INÍCIO PARA EVITAR CONSULTAS REPETIDAS"""
        try:
            # Carregar todos os SKUs existentes
            existing_products = Product.objects.values_list('natura_sku', 'bar_code')
            
            for sku, barcode in existing_products:
                if sku:
                    self.existing_skus.add(str(sku))
                    # ✅ PRODUTOS COM BARCODE SÃO SUPER PROTEGIDOS
                    if barcode:
                        self.protected_skus.add(str(sku))
            
            self.stdout.write(f"📋 Carregados {len(self.existing_skus)} SKUs existentes")
            self.stdout.write(f"🔒 {len(self.protected_skus)} produtos protegidos (com barcode)")
            
        except Exception as e:
            self.stdout.write(self.style.ERROR(f"⚠️ Erro ao carregar SKUs existentes: {e}"))
            self.existing_skus = set()
            self.protected_skus = set()

    def handle(self, *args, **kwargs):
        base_url = "https://www.natura.com.br/c/todos-produtos"
        
        self.stdout.write(self.style.WARNING(f"🕷️ Iniciando Varredura Total PROTEGIDA em: {base_url}"))
        self.stdout.write(self.style.WARNING("🛡️ MODO PROTEÇÃO: Apenas novos produtos serão adicionados"))
        
        with SB(uc=True, headless=True, page_load_strategy="eager") as sb:
            # ✅ CONFIGURAR TIMEOUTS OTIMIZADOS
            sb.driver.set_page_load_timeout(30)
            sb.driver.set_script_timeout(20)
            
            try: 
                sb.open("https://www.natura.com.br/")
                sb.sleep(2)
            except: 
                pass
            
            page = 1
            empty_pages_count = 0
            total_found = 0
            total_new = 0
            total_skipped = 0
            
            while True:
                url = f"{base_url}?page={page}"
                self.stdout.write(f"📂 Lendo Página {page}...")
                
                try:
                    sb.open(url)
                    
                    # ✅ SCROLL OTIMIZADO
                    sb.execute_script("window.scrollTo(0, document.body.scrollHeight * 0.3);")
                    sb.sleep(0.5)
                    sb.execute_script("window.scrollTo(0, document.body.scrollHeight);")
                    sb.sleep(1.5)
                    
                    # ✅ VERIFICAR SE CHEGOU AO FIM
                    page_title = sb.get_title()
                    if "Ops" in page_title or "404" in page_title:
                        self.stdout.write(self.style.SUCCESS("🏁 Fim das páginas encontrado."))
                        break
                    
                    soup = BeautifulSoup(sb.get_page_source(), 'html.parser')
                    links = soup.find_all('a', href=re.compile(r'NATBRA-(\d+)'))
                    
                    if not links:
                        empty_pages_count += 1
                        self.stdout.write(self.style.WARNING(f"   ⚠️ Nenhum produto na página {page}."))
                        if empty_pages_count >= 3: 
                            break
                    else:
                        empty_pages_count = 0
                    
                    count_new = 0
                    count_skipped = 0
                    count_protected = 0
                    
                    for link in links:
                        href = link['href']
                        match = re.search(r'NATBRA-(\d+)', href)
                        
                        if match:
                            sku = match.group(1)
                            total_found += 1
                            
                            # ✅ VERIFICAR SE SKU JÁ EXISTE (CACHE)
                            if sku in self.existing_skus:
                                count_skipped += 1
                                
                                # ✅ LOG ESPECIAL PARA PRODUTOS PROTEGIDOS
                                if sku in self.protected_skus:
                                    count_protected += 1
                                    # self.stdout.write(f"   🔒 SKU {sku} protegido (tem barcode) - pulando")
                                
                                continue  # ✅ PULAR PRODUTO EXISTENTE
                            
                            # ✅ EXTRAIR NOME DO PRODUTO
                            name = link.get('title') or link.get('aria-label')
                            if not name:
                                name_tag = link.find(['h3', 'h4', 'p', 'span'])
                                if name_tag: 
                                    name = name_tag.text.strip()
                            
                            if not name or len(name) < 3: 
                                name = f"Produto Natura {sku}"
                            
                            # ✅ CRIAR APENAS NOVOS PRODUTOS
                            try:
                                product = Product.objects.create(
                                    natura_sku=str(sku),
                                    name=name[:200],
                                    category='Geral',
                                    official_price=0,  # Preço oficial (Global)
                                    bar_code=None,
                                    description=f"Descoberto em Todos os Produtos (Pág {page})",
                                    last_checked_at=timezone.now(),
                                    #is_protected=True  # ✅ MARCAR COMO PROTEGIDO
                                )
                                
                                # ✅ ADICIONAR AO CACHE PARA EVITAR DUPLICATAS NA MESMA EXECUÇÃO
                                self.existing_skus.add(str(sku))
                                count_new += 1
                                total_new += 1
                                
                                # ✅ LOG DE SUCESSO
                                self.stdout.write(f"   ✨ NOVO: {sku} - {name[:40]}...")
                                
                            except Exception as e:
                                self.stdout.write(f"   ❌ Erro ao criar SKU {sku}: {e}")
                                continue
                    
                    total_skipped += count_skipped
                    
                    # ✅ RELATÓRIO DA PÁGINA
                    self.stdout.write(self.style.SUCCESS(
                        f"   ✅ Pág {page}: {len(links)} produtos | "
                        f"✨ {count_new} novos | "
                        f"⏭️ {count_skipped} existentes | "
                        f"🔒 {count_protected} protegidos"
                    ))
                    
                    page += 1
                    sb.sleep(random.uniform(1.5, 3.0))  # ✅ DELAY OTIMIZADO
                    
                except Exception as e:
                    self.stdout.write(self.style.ERROR(f"❌ Erro na pág {page}: {e}"))
                    sb.sleep(5)
                    page += 1  # ✅ CONTINUAR MESMO COM ERRO
        
        # ✅ RELATÓRIO FINAL
        self.stdout.write(self.style.SUCCESS("🎉 Varredura Completa Finalizada!"))
        self.stdout.write(self.style.SUCCESS(f"📊 ESTATÍSTICAS FINAIS:"))
        self.stdout.write(f"   🔍 Total encontrados: {total_found}")
        self.stdout.write(f"   ✨ Novos adicionados: {total_new}")
        self.stdout.write(f"   ⏭️ Existentes pulados: {total_skipped}")
        self.stdout.write(f"   🔒 Protegidos (com barcode): {len(self.protected_skus)}")
        
        if total_new > 0:
            self.stdout.write(self.style.SUCCESS(f"✅ {total_new} novos produtos adicionados ao catálogo!"))
        else:
            self.stdout.write(self.style.WARNING("ℹ️ Nenhum produto novo encontrado - catálogo já atualizado"))