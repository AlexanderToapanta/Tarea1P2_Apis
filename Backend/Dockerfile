# ══════════════════════════════════════════════════════════════
#  ☕  CAFETERÍA UNIVERSITARIA — Contenedor único
#     Incluye: PostgreSQL 15 + Node.js 20 (Alpine)
# ══════════════════════════════════════════════════════════════

FROM node:20-alpine

# Instalar PostgreSQL y su-exec (para cambiar de usuario)
RUN apk add --no-cache postgresql postgresql-contrib su-exec

# Variables de entorno por defecto
ENV PGDATA=/var/lib/postgresql/data \
    DB_USER=postgres \
    DB_PASSWORD=cafeteria123 \
    DB_HOST=localhost \
    DB_NAME=cafeteriadb \
    DB_PORT=5432 \
    PORT=3000 \
    NODE_ENV=production

WORKDIR /app

# Instalar dependencias Node (capa cacheada)
COPY package*.json ./
RUN npm install --omit=dev

# Copiar código fuente
COPY src/ ./src/

# Copiar script de arranque
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/entrypoint.sh"]
