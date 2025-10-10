import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RatingStarLoader extends StatelessWidget {
  const RatingStarLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: SizedBox(
          height: 40,
          width: 200,
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.star, color: Colors.grey.shade300),
              );
            },
          ),
        ),
      ),
    );
  }
}
