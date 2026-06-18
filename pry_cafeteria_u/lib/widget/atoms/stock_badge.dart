import 'package:flutter/material.dart';

class StockBadge extends StatelessWidget {
  final int stock;

  const StockBadge({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = stock > 0 && stock <= 5;
    final bool outOfStock = stock == 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: outOfStock
            ? Colors.red.shade100
            : isLowStock
                ? Colors.orange.shade100
                : Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        outOfStock ? 'Agotado' : 'Stock: $stock',
        style: TextStyle(
          fontSize: 12,
          color: outOfStock
              ? Colors.red.shade900
              : isLowStock
                  ? Colors.orange.shade900
                  : Colors.green.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
