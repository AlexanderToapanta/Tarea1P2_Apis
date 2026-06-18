class Producto {
  final int? id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String? categoria;
  final int stock;

  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    this.categoria,
    required this.stock,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'] is String 
          ? double.parse(json['precio']) 
          : (json['precio'] as num).toDouble(),
      categoria: json['categoria'],
      stock: json['stock'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'categoria': categoria,
      'stock': stock,
    };
  }
}
