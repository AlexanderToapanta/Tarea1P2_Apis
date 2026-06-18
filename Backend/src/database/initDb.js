import pool from "../config/db.js";

// Crea las tablas si no existen (idempotente).
// Los datos de prueba (seed) son insertados directamente por PostgreSQL
// al iniciar el contenedor, via docker-entrypoint-initdb.d/01-init.sql.
// En desarrollo local (sin Docker), el init.sql completo se puede correr manualmente.
const initDb = async () => {
    const sql = `
        CREATE TABLE IF NOT EXISTS productos (
            id          SERIAL PRIMARY KEY,
            nombre      VARCHAR(255) NOT NULL,
            descripcion TEXT,
            precio      DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
            categoria   VARCHAR(100),
            imagen_url  VARCHAR(500),
            stock       INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
            created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS pedidos (
            id             SERIAL PRIMARY KEY,
            cliente_nombre VARCHAR(255) NOT NULL,
            estado         VARCHAR(50) NOT NULL DEFAULT 'pendiente'
                               CHECK (estado IN ('pendiente', 'completado', 'cancelado')),
            total          DECIMAL(10, 2) NOT NULL DEFAULT 0,
            created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS detalle_pedido (
            id              SERIAL PRIMARY KEY,
            pedido_id       INTEGER NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
            producto_id     INTEGER NOT NULL REFERENCES productos(id),
            cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
            precio_unitario DECIMAL(10, 2) NOT NULL,
            subtotal        DECIMAL(10, 2) NOT NULL
        );
    `;

    try {
        await pool.query(sql);
        console.log("✅ Tablas verificadas/creadas correctamente");
    } catch (error) {
        console.error("❌ Error al inicializar la base de datos:", error.message);
        process.exit(1);
    }
};

export default initDb;
