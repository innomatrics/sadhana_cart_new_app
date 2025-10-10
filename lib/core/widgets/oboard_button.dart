import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class OboardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  const OboardButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        splashFactory: NoSplash.splashFactory,
        minimumSize: Size(size.width * 0.70, size.height * 0.07),
        backgroundColor: AppColor.onboardButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(50),
          side: const BorderSide(color: Colors.white, width: 1.2),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
