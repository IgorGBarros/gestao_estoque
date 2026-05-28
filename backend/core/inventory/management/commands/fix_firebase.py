# fix_firebase.py
import json
import re
import sys

# =============================================================================
# ⚠️ COLE SEU JSON ORIGINAL DO FIREBASE AQUI (com quebras de linha reais)
# =============================================================================
raw_json = '''{
  "type": "service_account",
  "project_id": "plataforma-financeira-29a27",
  "private_key_id": "c45a45aa082b475ce4909a62bacf478fd5677038",
  "private_key": "-----BEGIN PRIVATE KEY-----
MIIEugIBADANBgkqhkiG9w0BAQEFAASCBKQwggSgAgEAAoIBAQDBY0QkPz1UOjie
h/KSt1tvepO/355ZqEYXZP1yJ4jcxeyFu5iWhfNkTVjLUVvQPnzCssk5hPUWqd/l
m51bj2TvF5/UCpXZVc6evfNuuhBYpKX9Q31IQJV0I8NMMyNGrZm9s0BwBs2CP9s6
j5V4qiBVZuyQSp6a+71o6Q5J1r/cqURqKLFPAuTtQl15Fwc2Cn16oTq1lyfX4E+t
OCpNbQ3VjRn3r231O806Mv0rmI/Ds6QIxMB7R/cZksL9KXrqGcY0pFsJBJ1m1ZT+
DUVbzbtTUkumepj9hEbT3EvmPABd8hdbvLOu6guURKNL8jXEnhBHkeX682xE2Ai5
VbSEnmytAgMBAAECggEAJVTfjFy93tLPZ8EIIWzuZHaF65oEJDwg7baz21PI7o9x
oX5Nji8lBUWOIM+fmPNbG62uPSGOu3WHEHiqF4j2m9YUZzc05qvTE19JTSRzb902
4s1is64t+6nEs2LCykvMXCusgoO5q81eaW9a1ByJWdsgyxjwhawXjBdDSBtB1dts
OQ995V+VQ3jwe0NK8DIucYCcMRR7Q78M6LJFmm9BFT1NYXET0dYdAeYfrSJafx1b
nsLDXeRAAHkF9Ccsm5i6IAioLEToMtEDjfIiYXShIYQrfaMdzwZeZ2Fz94CwRrD4
iQHHIXZCeKD67aFZc26E3XAIMsiiepbLyzzUlPmZKQKBgQDjzStZSBDzuiOyzoPx
q32nK4JJDMnordakrjQJemlEsNuQ5Y9Hz/zalx8RaHcwg0FibbKPmPIriIJjbLBK
qpraW/tM/Ck5ZSrRtlQ4OnnnJbWZJsIq03xTniiz1DaKg6gZacDLxJG1XpA/n5HR
Mij7VXS/wmlHv5xamMfV1iTdRQKBgQDZU46VIo0jU3tYOBlGSbWQCKFxDlp54IB8
UucA9wQZWHJ9iXFpxJ/XiW6iNRBU2LGJdqPYmFKcPLfgV6U65XfGFloFtbPbW+ql
1r25XCFvvO/JqCnMg0ZNEaz9hnn/xI/EsLlviq+C2xkAoAW824HCGU5vL/+rDe0Y
IiZ2NNFESQKBgDV2kIbqr/fTps8vQq40VlAmmPQ2CSkPq4GI1POohA44B7/w8Hil
Kq3Oq971CowbMfw8zJyBA80Nw7Q77QAJHEDFN6xwvegXgz4msYtkxflm00D3ZLiS
W+pwAxN5abeGgKw+Mp5gKuZLJEWaWKmlQRMDklvy76yEHtjwZG4eTRaVAoGASdsb
mZMkY9z7DgACluB1030bYFCAburcv2NtHebUfciRIBiVclxf9d++uWFPK4Z4zz6C
cBlT+cSouJUQkfNpwOfXsBkQBnw2QiW4VEX7Fv4ef2mmytnSCl73azFIRKOIOE/W
tRFslAvhc1Tunj/62PvArAij2n3hFVKFv6YzeAECfyE5SOggyvG5i+jU2F7id1lG
E3qJrZ7J7wlh3s9O7fxJNcly0QlYdhoOONGuWH3wN+gB1PwKab419l/CGUD/pisG
smSKNSLD0EFAUFwF1Ieo+40CyuWcrMLy6541dd6hWVI1hqAcJhHhB977t09ySuWT
2r4RSLDjgnxlUUKhZcw=
-----END PRIVATE KEY-----
",
  "client_email": "firebase-adminsdk-526b7@plataforma-financeira-29a27.iam.gserviceaccount.com",
  "client_id": "116924952760947013947",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-526b7%40plataforma-financeira-29a27.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}'''

def fix_firebase_json(json_str):
    """
    Corrige quebras de linha reais na private_key para \\n escapados,
    então minifica o JSON para uma linha.
    """
    # Encontrar o valor da private_key usando regex
    pattern = r'("private_key"\s*:\s*")(.+?)("\s*[,,}])'
    
    def escape_match(match):
        prefix = match.group(1)
        key_content = match.group(2)
        suffix = match.group(3)
        
        # Escapar caracteres problemáticos
        escaped = (key_content
            .replace('\\\\', '\\\\\\\\')  # \\ → \\\\ (primeiro!)
            .replace('\n', '\\n')          # newline real → \n
            .replace('\r', '\\r')
            .replace('\t', '\\t')
        )
        return prefix + escaped + suffix
    
    # Aplicar correção apenas na private_key
    fixed = re.sub(pattern, escape_match, json_str, flags=re.DOTALL)
    
    # Parse e minificar
    data = json.loads(fixed)
    minified = json.dumps(data, separators=(',', ':'), ensure_ascii=False)
    
    return minified

# =============================================================================
# 🚀 EXECUTAR
# =============================================================================

if __name__ == "__main__":
    try:
        result = fix_firebase_json(raw_json)
        print("✅ JSON corrigido e minificado!")
        print("📋 Copie a linha abaixo e cole no Render → FIREBASE_CREDENTIALS:\n")
        print(result)
        print(f"\n📏 Tamanho: {len(result)} caracteres")
        
        # Salvar em arquivo para facilitar
        with open("firebase_minified.txt", "w", encoding="utf-8") as f:
            f.write(result)
        print("\n💡 Também salvo em: firebase_minified.txt")
        
    except Exception as e:
        print(f"❌ Erro: {e}")
        print("\n💡 Dica: Verifique se o JSON original está completo.")
        sys.exit(1)