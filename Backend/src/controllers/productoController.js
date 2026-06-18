import {
    getAllProductos,
    getProductoById,
    createProducto,
    updateProducto,
    deleteProducto,
} from "../models/productoModel.js";

// Respuesta estándar
const handleResponse = (res, status, message, data = null) => {
    res.status(status).json({
        status: status >= 200 && status < 300 ? "success" : "error",
        message,
        data,
    });
};

// GET /api/productos
export const listarProductos = async (req, res, next) => {
    try {
        const productos = await getAllProductos();
        handleResponse(res, 200, "Productos obtenidos correctamente", productos);
    } catch (error) {
        next(error);
    }
};

// GET /api/productos/:id
export const obtenerProducto = async (req, res, next) => {
    const { id } = req.params;
    try {
        const producto = await getProductoById(id);
        if (!producto) return handleResponse(res, 404, "Producto no encontrado");
        handleResponse(res, 200, "Producto obtenido correctamente", producto);
    } catch (error) {
        next(error);
    }
};

// POST /api/productos
export const crearProducto = async (req, res, next) => {
    try {
        const nuevoProducto = await createProducto(req.body);
        handleResponse(res, 201, "Producto creado correctamente", nuevoProducto);
    } catch (error) {
        next(error);
    }
};

// PUT /api/productos/:id
export const actualizarProducto = async (req, res, next) => {
    const { id } = req.params;
    try {
        const productoActualizado = await updateProducto(id, req.body);
        if (!productoActualizado) return handleResponse(res, 404, "Producto no encontrado");
        handleResponse(res, 200, "Producto actualizado correctamente", productoActualizado);
    } catch (error) {
        next(error);
    }
};

// DELETE /api/productos/:id
export const eliminarProducto = async (req, res, next) => {
    const { id } = req.params;
    try {
        const productoEliminado = await deleteProducto(id);
        if (!productoEliminado) return handleResponse(res, 404, "Producto no encontrado");
        handleResponse(res, 200, "Producto eliminado correctamente", productoEliminado);
    } catch (error) {
        next(error);
    }
};
