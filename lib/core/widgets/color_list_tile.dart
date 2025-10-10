import 'package:flutter/material.dart';

class ColorListTile extends StatelessWidget {
  final String text;
  final Widget widget;
  const ColorListTile({super.key, required this.text, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        widget,
      ],
    );
  }
}
