import express from "express";
import {
    listarProductos,
    obtenerProducto,
    crearProducto,
    actualizarProducto,
    eliminarProducto,
} from "../controllers/productoController.js";
import validateProducto from "../middlewares/validateProducto.js";

const router = express.Router();

// GET    /api/productos        — Listar todos
router.get("/", listarProductos);

// GET    /api/productos/:id    — Obtener por ID
router.get("/:id", obtenerProducto);

// POST   /api/productos        — Crear (con validación)
router.post("/", validateProducto, crearProducto);

// PUT    /api/productos/:id    — Actualizar (con validación)
router.put("/:id", validateProducto, actualizarProducto);

// DELETE /api/productos/:id    — Eliminar
router.delete("/:id", eliminarProducto);

export default router;
