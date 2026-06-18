import Joi from "joi";

const productoSchema = Joi.object({
    nombre: Joi.string().min(2).max(255).required().messages({
        "any.required": "El nombre del producto es requerido",
        "string.empty": "El nombre no puede estar vacío",
        "string.min": "El nombre debe tener al menos 2 caracteres",
    }),
    descripcion: Joi.string().max(500).optional().allow("", null),
    precio: Joi.number().positive().precision(2).required().messages({
        "any.required": "El precio es requerido",
        "number.base": "El precio debe ser un número",
        "number.positive": "El precio debe ser mayor a 0",
    }),
    categoria: Joi.string().max(100).optional().allow("", null),
    stock: Joi.number().integer().min(0).default(0).messages({
        "number.min": "El stock no puede ser negativo",
        "number.integer": "El stock debe ser un número entero",
    }),
});

const validateProducto = (req, res, next) => {
    const { error, value } = productoSchema.validate(req.body, { abortEarly: false });
    if (error) {
        return res.status(400).json({
            status: "error",
            message: "Datos inválidos",
            errors: error.details.map((d) => d.message),
        });
    }
    req.body = value;
    next();
};

export default validateProducto;
