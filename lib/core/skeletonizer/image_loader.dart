import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Skeletonizer(
        child: Container(
          height: size.height * 0.1,
          width: size.width * 1,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
