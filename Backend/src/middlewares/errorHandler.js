// Manejo centralizado de errores
const errorHandler = (err, req, res, next) => {
    console.error("❌ Error:", err.stack);
    res.status(err.status || 500).json({
        status: "error",
        message: err.status ? err.message : "Error interno del servidor",
        error: process.env.NODE_ENV !== "production" ? err.message : undefined,
    });
};

export default errorHandler;
