import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/banner/banner_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/product/product_notifier.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/skeletonizer/banner_loader.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';

class BannerListMobile extends ConsumerStatefulWidget {
  const BannerListMobile({super.key});

  @override
  ConsumerState<BannerListMobile> createState() => _BannerListMobileState();
}

class _BannerListMobileState extends ConsumerState<BannerListMobile> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(bannerProvider.notifier).initBanners();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bannerState = ref.watch(bannerProvider);

    if (bannerState.isLoading) {
      return const BannerLoader();
    }

    if (bannerState.banner?.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: bannerState.banner![0].image,
          fit: BoxFit.cover,
          width: double.infinity,
          errorWidget: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image, size: 40),
            );
          },
        ),
      );
    }

    if (bannerState.banner?.isEmpty ?? true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          AppImages.bannerImages.first.image,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    return CarouselSlider(
      items: bannerState.banner!
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: GestureDetector(
                onTap: () {
                  final productAsync = ref.read(
                    productByIdProvider(bannerState.banner!.first.productId),
                  );

                  productAsync.when(
                    data: (prod) {
                      navigateToProductDesignBasedOnCategory(
                        context: context,
                        categoryName: prod.category ?? '',
                        product: prod,
                      );
                    },
                    loading: () => const Loader(),
                    error: (error, stackTrace) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Failed to load user profile: $error'),
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: e.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image, size: 40),
                      );
                    },
                  ),
                ),
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
    );
  }
}
