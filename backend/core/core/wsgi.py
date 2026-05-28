# backend/core/core/wsgi.py - SUBSTITUIR TODO O CONTEÚDO

"""
WSGI config for core project.
"""
import os
import sys
import time
from django.core.wsgi import get_wsgi_application

# ✅ Log de inicialização COM FLUSH (crítico para Render capturar)
start_time = time.time()
print(f"🚀 WSGI application starting - PID: {os.getpid()}", flush=True)
print(f"🔍 Python: {sys.version}", flush=True)
print(f"🔍 DJANGO_SETTINGS_MODULE: {os.environ.get('DJANGO_SETTINGS_MODULE')}", flush=True)
print(f"🔍 PORT env: {os.environ.get('PORT', 'NOT SET')}", flush=True)
print(f"🔍 RENDER env: {os.environ.get('RENDER', 'NOT SET')}", flush=True)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'core.settings')

try:
    print("📦 Loading Django...", flush=True)
    application = get_wsgi_application()
    load_time = time.time() - start_time
    print(f"✅ Django loaded in {load_time:.2f}s", flush=True)
    
    # ✅ Teste rápido de conexão com banco (opcional, apenas DEBUG)
    if os.environ.get('DEBUG', 'False').lower() == 'true':
        try:
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
            print("✅ Database connection OK", flush=True)
        except Exception as e:
            print(f"⚠️ Database connection warning: {e}", flush=True)
    
except Exception as e:
    print(f"❌ Failed to load Django: {e}", flush=True)
    import traceback
    traceback.print_exc(file=sys.stdout)
    sys.stdout.flush()
    raise

print(f"🎯 WSGI application ready - Total init: {time.time() - start_time:.2f}s", flush=True)