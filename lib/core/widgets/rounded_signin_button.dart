import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundedSigninButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;
  const RoundedSigninButton({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: size.height * 0.07,
        width: size.width * 0.15,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.4),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
      ),
    );
  }
}
