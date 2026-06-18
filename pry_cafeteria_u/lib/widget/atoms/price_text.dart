import 'package:flutter/material.dart';

class PriceText extends StatelessWidget {
  final double price;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const PriceText({
    super.key,
    required this.price,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: TextStyle(
        fontSize: fontSize,
        color: color ?? Theme.of(context).colorScheme.primary,
        fontWeight: fontWeight,
      ),
    );
  }
}
