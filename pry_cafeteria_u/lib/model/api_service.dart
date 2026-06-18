import 'dart:convert';
import 'package:http/http.dart' as http;
import 'producto.dart';
import 'pedido.dart';
import 'api_response.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<Producto>> getProductos() async {
    final response = await http.get(Uri.parse('$baseUrl/productos'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson(
        decoded,
        (data) => (data as List).map((p) => Producto.fromJson(p)).toList(),
      );
      return apiResponse.data ?? [];
    } else {
      throw Exception('Error al cargar productos: ${response.body}');
    }
  }

  Future<void> createPedido(Pedido pedido) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pedido.toJson()),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      final decoded = json.decode(response.body);
      throw Exception(decoded['message'] ?? 'Error al crear pedido');
    }
  }

  Future<List<Pedido>> getPedidos() async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final apiResponse = ApiResponse.fromJson(
        decoded,
        (data) => (data as List).map((p) => Pedido.fromJson(p)).toList(),
      );
      return apiResponse.data ?? [];
    } else {
      throw Exception('Error al cargar pedidos');
    }
  }
}
