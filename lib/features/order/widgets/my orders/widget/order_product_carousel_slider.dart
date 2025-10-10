import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/view_photo.dart';

class OrderProductCarousel extends ConsumerWidget {
  final OrderProductModel product;
  const OrderProductCarousel({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final controller = CarouselSliderController();

    final images = product.images ?? [];
    final currentIndexRaw = ref.watch(carouselController);

    final currentIndex = (images.isEmpty || currentIndexRaw >= images.length)
        ? 0
        : currentIndexRaw;

    if (images.isEmpty) {
      ref.read(carouselController.notifier).state = 0;
      return SizedBox(
        height: size.height * 0.25,
        child: const Icon(Icons.image, size: 50),
      );
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          carouselController: controller,
          itemBuilder: (context, index, realIdx) {
            final imageUrl = images[index];
            return GestureDetector(
              onTap: () {
                navigateTo(
                  context: context,
                  screen: ViewPhoto(imageUrl: imageUrl),
                );
              },
              child: SizedBox(
                width: size.width,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: size.height * 0.25,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              ref.read(carouselController.notifier).state = index;
            },
          ),
        ),
        Positioned(
          bottom: 5,
          left: 0,
          right: 0,
          child: Center(
            child: DotsIndicator(
              dotsCount: images.length,
              position: currentIndex.toDouble(),
              decorator: const DotsDecorator(activeColor: Colors.blue),
              onTap: (index) {
                // Ensure tapped index is within bounds
                if (index < images.length) {
                  ref.read(carouselController.notifier).state = index;
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
