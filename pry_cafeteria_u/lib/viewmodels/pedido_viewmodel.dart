import 'package:flutter/material.dart';
import '../model/pedido.dart';
import '../model/producto.dart';
import '../model/api_service.dart';

class PedidoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  final Map<int, int> _cart = {}; // productId -> quantity
  List<Pedido> _pedidos = [];
  bool _isBusy = false;
  String? _error;

  Map<int, int> get cart => _cart;
  List<Pedido> get pedidos => _pedidos;
  bool get isBusy => _isBusy;
  String? get error => _error;

  void addToCart(Producto producto, int cantidad) {
    if (cantidad <= 0) return;
    if (cantidad > producto.stock) {
      _error = 'No hay suficiente stock';
      notifyListeners();
      return;
    }
    _cart[producto.id!] = (_cart[producto.id!] ?? 0) + cantidad;
    notifyListeners();
  }

  void removeFromCart(int productoId) {
    _cart.remove(productoId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double calculateSubtotal(Producto producto) {
    return (producto.precio * (_cart[producto.id] ?? 0));
  }

  Future<bool> registrarPedido(String clienteNombre) async {
    if (_cart.isEmpty) {
      _error = 'El pedido debe tener al menos un producto';
      notifyListeners();
      return false;
    }

    _isBusy = true;
    _error = null;
    notifyListeners();

    try {
      final items = _cart.entries.map((e) => PedidoItem(
        productoId: e.key,
        cantidad: e.value,
      )).toList();

      final pedido = Pedido(
        clienteNombre: clienteNombre,
        items: items,
      );

      await _apiService.createPedido(pedido);
      clearCart();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> fetchPedidos() async {
    _isBusy = true;
    notifyListeners();
    try {
      _pedidos = await _apiService.getPedidos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }
}
