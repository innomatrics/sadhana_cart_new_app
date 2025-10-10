import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrderDetailsLoader extends StatelessWidget {
  const OrderDetailsLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Skeletonizer(
        child: ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              height: size.height * 0.3,
              width: size.width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      ),
    );
  }
}
