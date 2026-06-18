import {
    getAllPedidos,
    getPedidoById,
    createPedido,
    updateEstadoPedido,
    deletePedido,
} from "../models/pedidoModel.js";

// Respuesta estándar
const handleResponse = (res, status, message, data = null) => {
    res.status(status).json({
        status: status >= 200 && status < 300 ? "success" : "error",
        message,
        data,
    });
};

// GET /api/pedidos
export const listarPedidos = async (req, res, next) => {
    try {
        const pedidos = await getAllPedidos();
        handleResponse(res, 200, "Pedidos obtenidos correctamente", pedidos);
    } catch (error) {
        next(error);
    }
};

// GET /api/pedidos/:id
export const obtenerPedido = async (req, res, next) => {
    const { id } = req.params;
    try {
        const pedido = await getPedidoById(id);
        if (!pedido) return handleResponse(res, 404, "Pedido no encontrado");
        handleResponse(res, 200, "Pedido obtenido correctamente", pedido);
    } catch (error) {
        next(error);
    }
};

// POST /api/pedidos  — aplica reglas de negocio (stock, total, mínimo 1 producto)
export const crearPedido = async (req, res, next) => {
    try {
        const nuevoPedido = await createPedido(req.body);
        handleResponse(res, 201, "Pedido creado correctamente", nuevoPedido);
    } catch (error) {
        // Errores de lógica de negocio → 400, no 500
        if (
            error.message.includes("Stock insuficiente") ||
            error.message.includes("no encontrado")
        ) {
            return res.status(400).json({
                status: "error",
                message: error.message,
                data: null,
            });
        }
        next(error);
    }
};

// PUT /api/pedidos/:id  — solo actualiza estado
export const actualizarEstadoPedido = async (req, res, next) => {
    const { id } = req.params;
    const { estado } = req.body;

    const estadosValidos = ["pendiente", "completado", "cancelado"];
    if (!estado || !estadosValidos.includes(estado)) {
        return res.status(400).json({
            status: "error",
            message: `Estado inválido. Debe ser uno de: ${estadosValidos.join(", ")}`,
            data: null,
        });
    }

    try {
        const pedidoActualizado = await updateEstadoPedido(id, estado);
        if (!pedidoActualizado) return handleResponse(res, 404, "Pedido no encontrado");
        handleResponse(res, 200, "Estado del pedido actualizado", pedidoActualizado);
    } catch (error) {
        next(error);
    }
};

// DELETE /api/pedidos/:id
export const eliminarPedido = async (req, res, next) => {
    const { id } = req.params;
    try {
        const pedidoEliminado = await deletePedido(id);
        if (!pedidoEliminado) return handleResponse(res, 404, "Pedido no encontrado");
        handleResponse(res, 200, "Pedido eliminado correctamente", pedidoEliminado);
    } catch (error) {
        next(error);
    }
};
