"""
Identidade do desenvolvedor — separada de CustomUser de propósito.

Uma consultora nunca tem uma DeveloperAccount, e um desenvolvedor nunca tem
uma Store. São dois produtos diferentes (o app de gestão de estoque, e a
API comercial de dados agregados) compartilhando a mesma infraestrutura de
banco/deploy, mas com identidades que não se misturam.
"""
import uuid

from django.contrib.auth.hashers import check_password, make_password
from django.db import models


class DeveloperAccount(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True, db_index=True)
    password_hash = models.CharField(max_length=255)

    name = models.CharField(max_length=150)
    company_name = models.CharField(max_length=150, blank=True)

    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    last_login_at = models.DateTimeField(null=True, blank=True)

    # ─────────────────────────────────────────────────────────────
    # ⚠️ ENCAIXE PARA REVISÃO DE LGPD — deixado pronto, não aplicado ainda.
    # ─────────────────────────────────────────────────────────────
    # O produto real (Fase 3) vende dado agregado de comportamento de
    # consultoras/clientes finais pra marcas — isso muda a categoria de
    # risco de LGPD do que construímos até aqui no admin-panel. Antes de
    # vender de verdade, alguém com conhecimento jurídico precisa revisar:
    #
    #   1. Se o termo que a CONSULTORA aceita hoje (ver ConsentRecord em
    #      inventory/models.py) já cobre "seus dados de venda podem virar
    #      inteligência de mercado agregada e vendida a terceiros" — o
    #      purpose 'data_commercialization' foi adicionado lá, mas NADA
    #      ainda checa esse consentimento, porque não existe endpoint de
    #      venda de dado ainda (isso é Fase 3).
    #   2. Que termo o DESENVOLVEDOR (cliente da API) precisa aceitar sobre
    #      uso responsável do dado agregado que ele está comprando.
    #
    # Os dois campos abaixo só GUARDAM a aceitação quando ela existir — não
    # bloqueiam cadastro nem validam conteúdo nenhum agora. É opcional na
    # Fase 1 de propósito, pra não travar ninguém num termo que ainda não
    # foi escrito/revisado.
    terms_accepted_at = models.DateTimeField(null=True, blank=True)
    terms_version = models.CharField(max_length=20, blank=True)

    class Meta:
        db_table = 'developer_accounts'
        verbose_name = 'Conta de desenvolvedor'
        verbose_name_plural = 'Contas de desenvolvedor'

    # ⚠️ Necessário pro DRF: IsAuthenticated checa `request.user.is_authenticated`.
    # AbstractBaseUser do Django fornece isso de graça; como esta classe é um
    # models.Model comum de propósito (pra não herdar nenhuma máquina de
    # AUTH_USER_MODEL), precisa declarar manualmente.
    is_authenticated = True
    is_anonymous = False

    def __str__(self):
        return f"{self.name} <{self.email}>"

    def set_password(self, raw_password):
        self.password_hash = make_password(raw_password)

    def check_password(self, raw_password):
        return check_password(raw_password, self.password_hash)
