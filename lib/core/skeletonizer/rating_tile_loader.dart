import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RatingTileLoader extends StatelessWidget {
  const RatingTileLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Skeletonizer(
      child: SizedBox(
        height: size.height * 0.14,
        width: size.width * 1,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(AppImages.noProfile),
              ),
              title: Text(
                "This is the placeholder",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 60.0),
              child: Text(
                "This is the review placeholder",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
