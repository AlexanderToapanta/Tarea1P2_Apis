import 'package:flutter/material.dart';
import '../model/producto.dart';
import '../model/api_service.dart';

class ProductoViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Producto> _productos = [];
  bool _isLoading = false;
  String? _error;

  List<Producto> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _productos = await _apiService.getProductos();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
