import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../viewmodels/pedido_viewmodel.dart';
import 'pedido_form_view.dart';
import 'pedido_resumen_view.dart';
import '../widget/molecules/producto_card.dart';
import '../widget/atoms/custom_button.dart';

class ProductoGridView extends StatefulWidget {
  const ProductoGridView({super.key});

  @override
  State<ProductoGridView> createState() => _ProductoGridViewState();
}

class _ProductoGridViewState extends State<ProductoGridView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductoViewModel>().fetchProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Café Universitario'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            tooltip: 'Historial',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PedidoResumenView()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PedidoFormView()),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Consumer<PedidoViewModel>(
                    builder: (context, vm, child) {
                      if (vm.cart.isEmpty) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '${vm.cart.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<ProductoViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
          
          if (vm.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error al cargar productos', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  CustomButton(
                    label: 'REINTENTAR',
                    onPressed: () => vm.fetchProductos(),
                    icon: Icons.refresh,
                  ),
                ],
              ),
            );
          }

          if (vm.productos.isEmpty) {
            return const Center(child: Text('No hay productos disponibles por ahora.'));
          }

          return RefreshIndicator(
            onRefresh: () => vm.fetchProductos(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: vm.productos.length,
              itemBuilder: (context, index) => ProductoCard(producto: vm.productos[index]),
            ),
          );
        },
      ),
    );
  }
}
