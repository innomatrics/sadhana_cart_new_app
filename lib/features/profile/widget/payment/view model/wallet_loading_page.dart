import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WalletLoadingPage extends StatelessWidget {
  const WalletLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Skeletonizer(
      child: CarouselSlider(
        items: AppImages.bannerImages
            .map(
              (e) => ClipRect(
                clipBehavior: Clip.hardEdge,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  height: size.height * 0.3,
                  width: size.width * 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset(e.image, fit: BoxFit.cover),
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: size.height * 0.3,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: true,
          viewportFraction: 1,
          aspectRatio: 16 / 9,
          scrollDirection: Axis.horizontal,
          enableInfiniteScroll: true,
          pauseAutoPlayOnTouch: true,
          scrollPhysics: const BouncingScrollPhysics(),
        ),
      ),
    );
  }
}
