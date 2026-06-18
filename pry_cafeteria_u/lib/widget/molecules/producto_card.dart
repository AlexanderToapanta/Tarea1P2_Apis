import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/producto.dart';
import '../../viewmodels/pedido_viewmodel.dart';
import '../atoms/price_text.dart';
import '../atoms/stock_badge.dart';
import '../atoms/custom_button.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;

  const ProductoCard({super.key, required this.producto});

  IconData _getCategoryIcon(String? categoria) {
    switch (categoria?.toLowerCase()) {
      case 'bebidas':
        return Icons.local_cafe;
      case 'comida':
        return Icons.restaurant;
      case 'postres':
        return Icons.cake;
      default:
        return Icons.fastfood;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.orange.shade50,
              width: double.infinity,
              child: Center(
                child: Icon(
                  _getCategoryIcon(producto.categoria),
                  size: 60,
                  color: Colors.orange.shade300,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (producto.categoria != null)
                  Text(
                    producto.categoria!,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceText(price: producto.precio, fontSize: 15),
                    StockBadge(stock: producto.stock),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: 'Añadir',
                    icon: Icons.add_shopping_cart,
                    onPressed: producto.stock > 0
                        ? () {
                            context.read<PedidoViewModel>().addToCart(producto, 1);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${producto.nombre} añadido'),
                                duration: const Duration(milliseconds: 500),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
