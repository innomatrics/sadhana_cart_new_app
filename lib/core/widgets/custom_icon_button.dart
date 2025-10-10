import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.red,
        elevation: 1,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
