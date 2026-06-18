import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../viewmodels/pedido_viewmodel.dart';
import '../widget/atoms/price_text.dart';

class PedidoResumenView extends StatefulWidget {
  const PedidoResumenView({super.key});

  @override
  State<PedidoResumenView> createState() => _PedidoResumenViewState();
}

class _PedidoResumenViewState extends State<PedidoResumenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PedidoViewModel>().fetchPedidos();
    });
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Historial de Pedidos')),
      body: Consumer<PedidoViewModel>(
        builder: (context, vm, child) {
          if (vm.isBusy) return const Center(child: CircularProgressIndicator());
          
          if (vm.error != null && vm.pedidos.isEmpty) {
            return Center(child: Text('Error: ${vm.error}'));
          }

          if (vm.pedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('No has realizado pedidos aún', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: vm.pedidos.length,
            itemBuilder: (context, index) {
              final pedido = vm.pedidos[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  leading: const CircleAvatar(child: Icon(Icons.receipt)),
                  title: Text(pedido.clienteNombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Estado: ${pedido.estado?.toUpperCase()}'),
                  trailing: PriceText(price: pedido.total ?? 0),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.orange.shade50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: #${pedido.id}', style: const TextStyle(fontSize: 12)),
                          Text('Fecha: ${_formatDate(pedido.fecha)}', style: const TextStyle(fontSize: 12)),
                          const Divider(),
                          ...pedido.items.map((item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${item.cantidad}x ${item.productoNombre ?? 'Producto'}'),
                                    PriceText(price: item.subtotal ?? 0, fontSize: 14),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
