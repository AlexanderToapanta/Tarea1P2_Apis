import 'package:flutter/material.dart';
import '../atoms/price_text.dart';
import '../atoms/custom_button.dart';

class OrderSummaryCard extends StatelessWidget {
  final double total;
  final bool isBusy;
  final VoidCallback onConfirm;

  const OrderSummaryCard({
    super.key,
    required this.total,
    required this.isBusy,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total del Pedido',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              PriceText(price: total, fontSize: 24),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: CustomButton(
              label: 'CONFIRMAR PEDIDO',
              isLoading: isBusy,
              onPressed: onConfirm,
            ),
          ),
        ],
      ),
    );
  }
}
