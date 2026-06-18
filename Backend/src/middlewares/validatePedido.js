import Joi from "joi";

const pedidoSchema = Joi.object({
    cliente_nombre: Joi.string().min(2).max(255).required().messages({
        "any.required": "El nombre del cliente es requerido",
        "string.empty": "El nombre del cliente no puede estar vacío",
        "string.min": "El nombre debe tener al menos 2 caracteres",
    }),
    items: Joi.array()
        .items(
            Joi.object({
                producto_id: Joi.number().integer().positive().required().messages({
                    "any.required": "El producto_id es requerido",
                    "number.positive": "El producto_id debe ser un número positivo",
                }),
                cantidad: Joi.number().integer().min(1).required().messages({
                    "any.required": "La cantidad es requerida",
                    "number.min": "La cantidad debe ser al menos 1",
                    "number.integer": "La cantidad debe ser un número entero",
                }),
            })
        )
        .min(1)
        .required()
        .messages({
            "any.required": "Debe incluir al menos un producto en el pedido",
            "array.min": "El pedido debe tener al menos un producto",
            "array.base": "Items debe ser un arreglo",
        }),
});

const validatePedido = (req, res, next) => {
    const { error, value } = pedidoSchema.validate(req.body, { abortEarly: false });
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

export default validatePedido;
