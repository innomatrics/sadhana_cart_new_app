import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';

class FootWearCarousel extends StatelessWidget {
  final ProductModel product;
  const FootWearCarousel({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CarouselSlider(
          items: product.images!
              .map(
                (e) => Container(
                  height: size.height * 0.4,
                  width: size.width * 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(e, cacheKey: e),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(height: size.height * 0.4),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                onPressed: () => navigateBack(context: context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              ),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                onPressed: () {},
                icon: const Icon(Icons.favorite, color: Colors.red),
              ),
            ],
          ),
        ),
        Positioned(
          top: size.height * 0.37,
          right: size.width * 0.45,
          child: DotsIndicator(
            dotsCount: product.images!.length,
            animate: true,
            axis: Axis.horizontal,
            animationDuration: const Duration(milliseconds: 200),
            position: 0,
            onTap: (value) {
              log(value.toString());
            },
          ),
        ),
      ],
    );
  }
}
