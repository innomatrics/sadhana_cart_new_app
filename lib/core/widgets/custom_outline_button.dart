import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class CustomOutlineButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const CustomOutlineButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColor.onboardButtonColor, width: 1.2),
        minimumSize: Size(size.width * 0.3, size.height * 0.05),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}

const customOutlinedButtonStyle = TextStyle(
  color: Colors.black,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);
