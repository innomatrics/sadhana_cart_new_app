import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/helper/cache_manager_helper.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/skeletonizer/image_loader.dart';

class AllProductsTile extends ConsumerWidget {
  final ProductModel product;

  const AllProductsTile({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boundaryKey = GlobalKey();
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                log(product.category ?? "No Category");
                log(product.productid!);
                navigateToProductDesignBasedOnCategory(
                  context: context,
                  categoryName: product.category?.toLowerCase() ?? "",
                  product: product,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Product Image
                    RepaintBoundary(
                      key: boundaryKey,
                      child: Container(
                        color: Colors.white,
                        child: CachedNetworkImage(
                          imageUrl: product.images?.isNotEmpty == true
                              ? product.images![0]
                              : "",
                          errorWidget: (context, _, _) => const ImageLoader(),
                          placeholder: (context, _) => const ImageLoader(),
                          height: size.height * 0.20,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          cacheManager: CustomCacheManager.cacheManager,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                product.name ?? "No Name",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    "${Constants.indianCurrency} ${product.offerprice ?? 0}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "₹ ${product.price ?? 0}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
