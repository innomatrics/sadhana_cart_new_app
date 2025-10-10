import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartLoader extends StatelessWidget {
  const CartLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Skeletonizer(
      child: Scaffold(
        body: Expanded(
          child: ListView.builder(
            itemCount: 4,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(10),
                height: size.height * 0.17,
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      height: size.height * 0.17,
                      width: size.width * 0.3,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(AppImages.onboard),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "This is the placeholder",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "This is the placeholder",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
