import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pedido_viewmodel.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../widget/molecules/cart_item_tile.dart';
import '../widget/organisms/order_summary_card.dart';
import '../widget/atoms/custom_button.dart';

class PedidoFormView extends StatefulWidget {
  const PedidoFormView({super.key});

  @override
  State<PedidoFormView> createState() => _PedidoFormViewState();
}

class _PedidoFormViewState extends State<PedidoFormView> {
  final _nombreController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Carrito')),
      body: Consumer2<PedidoViewModel, ProductoViewModel>(
        builder: (context, pedidoVm, productoVm, child) {
          if (pedidoVm.cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Tu carrito está vacío', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: 'IR A COMPRAR',
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.shopping_bag_outlined,
                  ),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: '¿A nombre de quién?',
                      hintText: 'Ej. Juan Pérez',
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Necesitamos tu nombre' : null,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Icon(Icons.list_alt, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('RESUMEN DE PRODUCTOS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: pedidoVm.cart.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final productId = pedidoVm.cart.keys.elementAt(index);
                      final cantidad = pedidoVm.cart[productId]!;
                      final producto = productoVm.productos.firstWhere((p) => p.id == productId);

                      return CartItemTile(
                        producto: producto,
                        cantidad: cantidad,
                        onRemove: () => pedidoVm.removeFromCart(productId),
                      );
                    },
                  ),
                ),
                OrderSummaryCard(
                  total: _calculateTotal(pedidoVm, productoVm),
                  isBusy: pedidoVm.isBusy,
                  onConfirm: () async {
                    if (_formKey.currentState!.validate()) {
                      final success = await pedidoVm.registrarPedido(_nombreController.text);
                      if (!mounted) return;
                      if (success) {
                        _showSuccessDialog();
                        productoVm.fetchProductos();
                      } else if (pedidoVm.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(pedidoVm.error!), backgroundColor: Colors.red),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text('¡Pedido realizado con éxito! Próximamente estará listo.', textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to grid
            },
            child: const Text('ACEPTAR'),
          ),
        ],
      ),
    );
  }

  double _calculateTotal(PedidoViewModel pedidoVm, ProductoViewModel productoVm) {
    double total = 0;
    pedidoVm.cart.forEach((productId, cantidad) {
      final producto = productoVm.productos.firstWhere((p) => p.id == productId);
      total += producto.precio * cantidad;
    });
    return total;
  }
}
