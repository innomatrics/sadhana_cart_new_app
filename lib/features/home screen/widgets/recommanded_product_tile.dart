import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/product/product_notifier.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/skeletonizer/image_loader.dart';
import 'package:sadhana_cart/core/skeletonizer/product_loader.dart';

class RecommandedProductTile extends ConsumerWidget {
  const RecommandedProductTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final prod = ref.watch(topRatedProductsProvider);
    return SizedBox(
      height: size.height * 0.38,
      width: size.width * 1,
      child: prod.when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final product = data[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6,
                ),
                child: Container(
                  width: size.width * 0.45,
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
                          log(product.category!);

                          navigateToProductDesignBasedOnCategory(
                            context: context,
                            categoryName: product.category!.toLowerCase(),
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
                              // Image
                              Container(
                                color: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl: product.images?.isNotEmpty == true
                                      ? product.images![0]
                                      : "",
                                  errorWidget: (context, _, _) =>
                                      const ImageLoader(),
                                  height: size.height * 0.25,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Text(
                          product.name!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                              "${Constants.indianCurrency} ${product.offerprice}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "₹ ${product.price ?? 0}", // Original Price
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const ProductLoader(),
      ),
    );
  }
}


/*
// get all product and Shuffle
  List<ProductModel> getRandomProducts() {
    // for (var category in categories) {
    //   for (var sub in category.subcategories) {
    //     allProducts.addAll(sub.products);
    //   }
    // }
    // allProducts.shuffle();
    // return allProducts.take(5).toList();
    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final recommendedProducts = getRandomProducts();
    return SizedBox(
      height: size.height * 0.38,
      child: ListView.builder(
        itemCount: recommendedProducts.length,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final product = recommendedProducts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Container(
              width: size.width * 0.45,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300, // dark shadow
                    // spreadRadius: 5, // how much the shadow spreads
                    blurRadius: 5, // softness of the shadow
                    offset: const Offset(
                      0,
                      2,
                    ), // vertical shadow (0,8 means below the box)
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      log(product.name!);

                      // Navigate to Product Detail Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          // Image
                          Container(
                            color: Colors.white,
                            child: Image(
                              image: CachedNetworkImageProvider(
                                product.images![0],
                              ),
                              height: size.height * 0.25,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // RAting container
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${product.rating}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Text(
                      product.name!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "${Constants.indianCurrency} ${product.price}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/