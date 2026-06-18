class Pedido {
  final int? id;
  final String clienteNombre;
  final String? fecha;
  final double? total;
  final String? estado;
  final List<PedidoItem> items;

  Pedido({
    this.id,
    required this.clienteNombre,
    this.fecha,
    this.total,
    this.estado,
    required this.items,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      clienteNombre: json['cliente_nombre'],
      fecha: json['fecha'] ?? json['created_at'],
      total: json['total'] != null 
          ? (json['total'] is String ? double.parse(json['total']) : (json['total'] as num).toDouble())
          : null,
      estado: json['estado'],
      items: (json['items'] as List?)
              ?.map((i) => PedidoItem.fromJson(i))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente_nombre': clienteNombre,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class PedidoItem {
  final int productoId;
  final int cantidad;
  final String? productoNombre;
  final double? precioUnitario;
  final double? subtotal;

  PedidoItem({
    required this.productoId,
    required this.cantidad,
    this.productoNombre,
    this.precioUnitario,
    this.subtotal,
  });

  factory PedidoItem.fromJson(Map<String, dynamic> json) {
    return PedidoItem(
      productoId: json['producto_id'],
      cantidad: json['cantidad'],
      productoNombre: json['producto_nombre'],
      precioUnitario: json['precio_unitario'] != null
          ? (json['precio_unitario'] is String ? double.parse(json['precio_unitario']) : (json['precio_unitario'] as num).toDouble())
          : null,
      subtotal: json['subtotal'] != null
          ? (json['subtotal'] is String ? double.parse(json['subtotal']) : (json['subtotal'] as num).toDouble())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producto_id': productoId,
      'cantidad': cantidad,
    };
  }
}
