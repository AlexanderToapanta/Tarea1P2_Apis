import pool from "../config/db.js";

// Obtener todos los productos
export const getAllProductos = async () => {
    const result = await pool.query(
        "SELECT * FROM productos ORDER BY categoria ASC, nombre ASC"
    );
    return result.rows;
};

// Obtener producto por ID
export const getProductoById = async (id) => {
    const result = await pool.query(
        "SELECT * FROM productos WHERE id = $1",
        [id]
    );
    return result.rows[0];
};

// Crear producto
export const createProducto = async (producto) => {
    const { nombre, descripcion, precio, categoria, stock } = producto;
    const result = await pool.query(
        `INSERT INTO productos (nombre, descripcion, precio, categoria, stock)
         VALUES ($1, $2, $3, $4, $5)
         RETURNING *`,
        [nombre, descripcion ?? null, precio, categoria ?? null, stock ?? 0]
    );
    return result.rows[0];
};

// Actualizar producto
export const updateProducto = async (id, producto) => {
    const { nombre, descripcion, precio, categoria, stock } = producto;
    const result = await pool.query(
        `UPDATE productos
         SET nombre=$1, descripcion=$2, precio=$3, categoria=$4, stock=$5
         WHERE id=$6
         RETURNING *`,
        [nombre, descripcion ?? null, precio, categoria ?? null, stock, id]
    );
    return result.rows[0];
};

// Eliminar producto
export const deleteProducto = async (id) => {
    const result = await pool.query(
        "DELETE FROM productos WHERE id=$1 RETURNING *",
        [id]
    );
    return result.rows[0];
};
