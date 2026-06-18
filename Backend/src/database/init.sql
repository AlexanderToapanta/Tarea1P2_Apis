-- ============================================================
--  CAFETERÍA UNIVERSITARIA — Inicialización de base de datos
-- ============================================================

-- Tabla: productos
CREATE TABLE IF NOT EXISTS productos (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio      DECIMAL(10, 2) NOT NULL CHECK (precio > 0),
    categoria   VARCHAR(100),
    stock       INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id             SERIAL PRIMARY KEY,
    cliente_nombre VARCHAR(255) NOT NULL,
    estado         VARCHAR(50) NOT NULL DEFAULT 'pendiente'
                       CHECK (estado IN ('pendiente', 'completado', 'cancelado')),
    total          DECIMAL(10, 2) NOT NULL DEFAULT 0,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: detalle_pedido  (relación Pedido ↔ Producto)
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id              SERIAL PRIMARY KEY,
    pedido_id       INTEGER NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
    producto_id     INTEGER NOT NULL REFERENCES productos(id),
    cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal        DECIMAL(10, 2) NOT NULL
);

-- ============================================================
--  SEED DATA — Productos iniciales de cafetería
-- ============================================================
INSERT INTO productos (nombre, descripcion, precio, categoria, stock)
VALUES
    ('Café Americano',     'Café negro de origen colombiano',                 1.50, 'Bebidas', 50),
    ('Cappuccino',         'Café con leche espumosa y canela',                2.25, 'Bebidas', 40),
    ('Sandwich de Pollo',  'Pan integral con pollo a la plancha y vegetales', 3.50, 'Comida',  20),
    ('Empanada de Queso',  'Empanada crujiente rellena de queso',             1.25, 'Comida',  30),
    ('Jugo de Naranja',    'Jugo natural recién exprimido',                   1.75, 'Bebidas', 25),
    ('Muffin de Chocolate','Muffin esponjoso con chips de chocolate',         1.50, 'Postres', 15),
    ('Ensalada César',     'Lechuga romana con aderezo césar y croutones',    4.00, 'Comida',  10),
    ('Agua con Gas',       'Agua mineral con gas natural',                    0.75, 'Bebidas', 100)
ON CONFLICT DO NOTHING;
