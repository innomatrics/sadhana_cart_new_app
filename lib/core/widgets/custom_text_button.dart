import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextDecoration? textDecoration;
  final Color color;
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textDecoration,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: color, decoration: textDecoration),
      ),
    );
  }
}
