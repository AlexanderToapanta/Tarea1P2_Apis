import pool from "../config/db.js";

// Obtener todos los pedidos con su detalle
export const getAllPedidos = async () => {
    const result = await pool.query(`
        SELECT
            p.id,
            p.cliente_nombre,
            p.estado,
            p.total,
            p.created_at,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id',              dp.id,
                        'producto_id',     dp.producto_id,
                        'producto_nombre', pr.nombre,
                        'cantidad',        dp.cantidad,
                        'precio_unitario', dp.precio_unitario,
                        'subtotal',        dp.subtotal
                    )
                ) FILTER (WHERE dp.id IS NOT NULL),
                '[]'
            ) AS detalle
        FROM pedidos p
        LEFT JOIN detalle_pedido dp ON p.id = dp.pedido_id
        LEFT JOIN productos pr      ON dp.producto_id = pr.id
        GROUP BY p.id
        ORDER BY p.created_at DESC
    `);
    return result.rows;
};

// Obtener pedido por ID con detalle
export const getPedidoById = async (id) => {
    const result = await pool.query(`
        SELECT
            p.id,
            p.cliente_nombre,
            p.estado,
            p.total,
            p.created_at,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id',              dp.id,
                        'producto_id',     dp.producto_id,
                        'producto_nombre', pr.nombre,
                        'cantidad',        dp.cantidad,
                        'precio_unitario', dp.precio_unitario,
                        'subtotal',        dp.subtotal
                    )
                ) FILTER (WHERE dp.id IS NOT NULL),
                '[]'
            ) AS detalle
        FROM pedidos p
        LEFT JOIN detalle_pedido dp ON p.id = dp.pedido_id
        LEFT JOIN productos pr      ON dp.producto_id = pr.id
        WHERE p.id = $1
        GROUP BY p.id
    `, [id]);
    return result.rows[0];
};

// Crear pedido — aplica reglas de negocio con transacción
export const createPedido = async ({ cliente_nombre, items }) => {
    const client = await pool.connect();

    try {
        await client.query("BEGIN");

        let total = 0;
        const itemsValidados = [];

        // Validar stock y calcular total
        for (const item of items) {
            const { producto_id, cantidad } = item;

            // Bloquear fila del producto para evitar condición de carrera
            const productoResult = await client.query(
                "SELECT * FROM productos WHERE id = $1 FOR UPDATE",
                [producto_id]
            );
            const producto = productoResult.rows[0];

            if (!producto) {
                throw new Error(`Producto con id ${producto_id} no encontrado`);
            }

            if (producto.stock < cantidad) {
                throw new Error(
                    `Stock insuficiente para "${producto.nombre}". ` +
                    `Disponible: ${producto.stock}, solicitado: ${cantidad}`
                );
            }

            const subtotal = parseFloat(producto.precio) * cantidad;
            total += subtotal;

            itemsValidados.push({
                producto_id,
                cantidad,
                precio_unitario: parseFloat(producto.precio),
                subtotal,
            });
        }

        // Insertar pedido
        const pedidoResult = await client.query(
            `INSERT INTO pedidos (cliente_nombre, estado, total)
             VALUES ($1, 'pendiente', $2)
             RETURNING *`,
            [cliente_nombre, total]
        );
        const nuevoPedido = pedidoResult.rows[0];

        // Insertar detalle y descontar stock
        for (const item of itemsValidados) {
            await client.query(
                `INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario, subtotal)
                 VALUES ($1, $2, $3, $4, $5)`,
                [nuevoPedido.id, item.producto_id, item.cantidad, item.precio_unitario, item.subtotal]
            );

            await client.query(
                "UPDATE productos SET stock = stock - $1 WHERE id = $2",
                [item.cantidad, item.producto_id]
            );
        }

        await client.query("COMMIT");

        // Retornar pedido con detalle completo
        return await getPedidoById(nuevoPedido.id);
    } catch (error) {
        await client.query("ROLLBACK");
        throw error;
    } finally {
        client.release();
    }
};

// Actualizar estado del pedido
export const updateEstadoPedido = async (id, estado) => {
    const result = await pool.query(
        "UPDATE pedidos SET estado=$1 WHERE id=$2 RETURNING *",
        [estado, id]
    );
    return result.rows[0];
};

// Eliminar pedido (detalle se elimina por CASCADE)
export const deletePedido = async (id) => {
    const result = await pool.query(
        "DELETE FROM pedidos WHERE id=$1 RETURNING *",
        [id]
    );
    return result.rows[0];
};
