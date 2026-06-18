import 'package:flutter/material.dart';
import '../../model/producto.dart';
import '../atoms/price_text.dart';

class CartItemTile extends StatelessWidget {
  final Producto producto;
  final int cantidad;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.producto,
    required this.cantidad,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.orange.shade100,
        child: const Icon(Icons.coffee, color: Colors.orange),
      ),
      title: Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('Cantidad: $cantidad'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PriceText(price: producto.precio * cantidad),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
