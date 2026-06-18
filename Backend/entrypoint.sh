#!/bin/sh
set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  ☕  CAFETERÍA UNIVERSITARIA — API   ║"
echo "╚══════════════════════════════════════╝"
echo ""

# ── 1. Preparar directorios necesarios para PostgreSQL ───────
mkdir -p /run/postgresql
chown -R postgres:postgres /run/postgresql

# ── 2. Inicializar PostgreSQL (solo la primera vez) ──────────
if [ ! -f "$PGDATA/PG_VERSION" ]; then
    echo "▶ Primera ejecución: inicializando base de datos..."
    mkdir -p "$PGDATA"
    chown -R postgres:postgres "$PGDATA"
    su-exec postgres initdb -D "$PGDATA" --locale=C --encoding=UTF8 --auth-local=trust > /dev/null 2>&1
    echo "  → Directorio de datos creado"
fi

# ── 3. Arrancar PostgreSQL en background ─────────────────────
echo "▶ Iniciando PostgreSQL..."
su-exec postgres pg_ctl start -D "$PGDATA" -l /tmp/postgres.log -w -t 30 > /dev/null 2>&1
echo "  → PostgreSQL listo ✅"

# ── 4. Crear contraseña, usuario y base de datos ─────────────
echo "▶ Configurando base de datos..."

su-exec postgres psql -c "ALTER USER ${DB_USER} WITH PASSWORD '${DB_PASSWORD}';" postgres > /dev/null 2>&1 || true

DB_EXISTS=$(su-exec postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}';" postgres 2>/dev/null || echo "0")
if [ "$DB_EXISTS" != "1" ]; then
    su-exec postgres psql -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};" postgres > /dev/null 2>&1
    echo "  → Base de datos '${DB_NAME}' creada"
else
    echo "  → Base de datos '${DB_NAME}' ya existe"
fi

# ── 5. Ejecutar SQL: tablas + datos de prueba ────────────────
echo "▶ Ejecutando script de inicialización SQL..."
su-exec postgres psql -d "$DB_NAME" -f /app/src/database/init.sql > /dev/null 2>&1
echo "  → Tablas y datos de prueba listos ✅"

echo ""
echo "────────────────────────────────────────"
echo "  🗄  PostgreSQL  →  localhost:${DB_PORT}"
echo "  🚀  API REST    →  http://localhost:${PORT}"
echo "────────────────────────────────────────"
echo ""

# ── 6. Iniciar Node.js en primer plano (PID 1) ───────────────
exec node src/index.js
