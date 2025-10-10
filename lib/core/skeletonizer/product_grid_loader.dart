import 'package:flutter/material.dart';

class ProductGridLoader extends StatelessWidget {
  const ProductGridLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: size.height * 0.20,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
            // Name placeholder
            Container(
              height: 14,
              width: double.infinity,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            const SizedBox(height: 6),
            // Price placeholder
            Container(
              height: 14,
              width: 60,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ],
        ),
      ),
    );
  }
}
