import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BannerLoader extends StatelessWidget {
  const BannerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Skeletonizer(
      child: Container(
        height: size.height * 0.3,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
