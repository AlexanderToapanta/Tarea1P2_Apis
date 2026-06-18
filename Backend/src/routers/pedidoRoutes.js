import express from "express";
import {
    listarPedidos,
    obtenerPedido,
    crearPedido,
    actualizarEstadoPedido,
    eliminarPedido,
} from "../controllers/pedidoController.js";
import validatePedido from "../middlewares/validatePedido.js";

const router = express.Router();

// GET    /api/pedidos          — Listar todos con detalle
router.get("/", listarPedidos);

// GET    /api/pedidos/:id      — Obtener pedido con detalle
router.get("/:id", obtenerPedido);

// POST   /api/pedidos          — Crear pedido (valida stock, descuenta stock)
router.post("/", validatePedido, crearPedido);

// PUT    /api/pedidos/:id      — Actualizar estado del pedido
router.put("/:id", actualizarEstadoPedido);

// DELETE /api/pedidos/:id      — Eliminar pedido (detalle en CASCADE)
router.delete("/:id", eliminarPedido);

export default router;
