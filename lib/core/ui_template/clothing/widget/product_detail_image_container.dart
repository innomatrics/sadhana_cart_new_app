import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProductDetailImageContainer extends StatelessWidget {
  final List<String> images;
  const ProductDetailImageContainer({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.4,
      width: size.width * 1,
      child: CarouselSlider(
        items: images
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
        options: CarouselOptions(),
      ),
    );
  }
}
