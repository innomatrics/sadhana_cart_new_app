import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/favorite/fav_model_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/favorite/favorite_notifier.dart';
import 'package:sadhana_cart/core/common%20services/favorite/favorite_service.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/cache_manager_helper.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/skeletonizer/image_loader.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/core/widgets/view_photo.dart';
import 'package:sadhana_cart/features/auth/view/sign%20up/view/sign_in_mobile.dart';

class CustomCarouselSlider extends ConsumerWidget {
  final ProductModel product;
  const CustomCarouselSlider({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final controller = CarouselSliderController();
    int currentIndex = ref.watch(carouselController);

    final images = product.images ?? [];
    final dotsCount = images.length;

    // Ensure currentIndex is always valid
    if (currentIndex >= dotsCount) currentIndex = 0;

    return Stack(
      children: [
        /// Image Carousel
        if (dotsCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 55),
            child: CarouselSlider.builder(
              itemCount: dotsCount,
              carouselController: controller,
              itemBuilder: (context, index, realIdx) {
                final imageUrl = images[index];
                return GestureDetector(
                  onTap: () {
                    log('Image tapped: $imageUrl');
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
                      cacheKey: imageUrl,
                      cacheManager: CustomCacheManager.cacheManager,
                      placeholder: (context, url) =>
                          const Center(child: ImageLoader()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: size.height * 0.45,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                enlargeCenterPage: true,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                pauseAutoPlayOnTouch: true,
                scrollPhysics: const BouncingScrollPhysics(),
                onPageChanged: (index, reason) {
                  log('Carousel page changed: $index');
                  ref.read(carouselController.notifier).state = index;
                },
              ),
            ),
          ),

        /// Back & Favorite Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
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
              Consumer(
                builder: (context, ref, child) {
                  final favSet = ref.watch(favoriteProvider);
                  final checkUser = ref.watch(authNotifierProvider);
                  final isFavorite = favSet.any(
                    (e) => e.productid == product.productid,
                  );
                  final favModel = ref.watch(favoriteModelProvider);
                  final matchedFavorite = favModel.firstWhereOrNull(
                    (e) => e.productid == product.productid,
                  );
                  final String? existsFavoriteId = matchedFavorite?.favoriteId;
                  final loader = ref.watch(favoriteLoadingProvider);
                  return AbsorbPointer(
                    absorbing: loader,
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        if (!checkUser) {
                          navigateTo(
                            context: context,
                            screen: const SignInMobile(),
                          );
                          return;
                        }
                        try {
                          if (!isFavorite) {
                            await FavoriteService.addToFavorite(
                              product: product,
                              ref: ref,
                            );
                            if (context.mounted) {
                              showCustomSnackbar(
                                context: context,
                                message: "Added to favorite",
                                type: ToastType.success,
                              );
                            }
                          } else if (existsFavoriteId != null) {
                            await FavoriteService.deleteFavorite(
                              favoriteId: existsFavoriteId,
                              product: product,
                              ref: ref,
                            );
                            if (context.mounted) {
                              showCustomSnackbar(
                                context: context,
                                message: "Removed from favorite",
                                type: ToastType.success,
                              );
                            }
                          }
                        } catch (e) {
                          log("Error toggling favorite: $e");
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        /// Dot Indicator
        if (dotsCount > 0)
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Center(
              child: DotsIndicator(
                dotsCount: dotsCount,
                position: currentIndex.toDouble(),
                onTap: (index) {
                  ref.read(carouselController.notifier).state = index;
                },
                decorator: DotsDecorator(
                  size: const Size.square(8.0),
                  activeSize: const Size(18.0, 8.0),
                  color: Colors.grey.shade400,
                  activeColor: AppColor.dartPrimaryColor,
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
