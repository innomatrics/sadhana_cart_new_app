import 'package:flutter/material.dart';

class ProductDetailRow extends StatelessWidget {
  final String title;
  final String value;
  const ProductDetailRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // aligns text at the top if wraps
        children: [
          // Left: fixed width for title
          SizedBox(
            width: size.width * 0.4, // adjust based on your layout
            child: Text(
              "$title :",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(width: size.width * 0.0001), // space between title and value
          // Right: value takes remaining width and wraps
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
