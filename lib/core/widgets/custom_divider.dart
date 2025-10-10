import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color = Color(0xffF3F3F6);
    return const Divider(
      color: color,
      thickness: 1.2,
      indent: 20,
      endIndent: 20,
    );
  }
}
