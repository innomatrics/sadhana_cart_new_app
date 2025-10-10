import 'package:flutter/material.dart';

class OrderedProductTile extends StatelessWidget {
  const OrderedProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
      height: size.height * 0.1,
      width: size.width * 1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(children: [Text("Products Details Section")]),
    );
  }
}
