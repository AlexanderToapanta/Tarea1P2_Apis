import express from "express";
import cors from "cors";
import dotenv from "dotenv";

import productoRoutes from "./routers/productoRoutes.js";
import pedidoRoutes from "./routers/pedidoRoutes.js";
import errorHandler from "./middlewares/errorHandler.js";
import initDb from "./database/initDb.js";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// ── Middlewares globales ────────────────────────────────────
app.use(express.json());
app.use(cors());

// ── Health check ────────────────────────────────────────────
app.get("/health", (_req, res) => {
    res.json({
        status: "ok",
        message: "☕ Cafetería API está corriendo",
        timestamp: new Date().toISOString(),
    });
});

// ── Rutas ───────────────────────────────────────────────────
app.use("/api/productos", productoRoutes);
app.use("/api/pedidos", pedidoRoutes);

// ── 404 para rutas no definidas ─────────────────────────────
app.use((_req, res) => {
    res.status(404).json({ status: "error", message: "Ruta no encontrada" });
});

// ── Manejo centralizado de errores ──────────────────────────
app.use(errorHandler);

// ── Inicializar DB y arrancar servidor ──────────────────────
initDb().then(() => {
    app.listen(PORT, () => {
        console.log("─────────────────────────────────────────");
        console.log(`☕  Cafetería API  |  Puerto: ${PORT}`);
        console.log("─────────────────────────────────────────");
        console.log("  GET    /api/productos");
        console.log("  POST   /api/productos");
        console.log("  PUT    /api/productos/:id");
        console.log("  DELETE /api/productos/:id");
        console.log("  GET    /api/pedidos");
        console.log("  POST   /api/pedidos");
        console.log("  PUT    /api/pedidos/:id");
        console.log("  DELETE /api/pedidos/:id");
        console.log("─────────────────────────────────────────");
    });
});