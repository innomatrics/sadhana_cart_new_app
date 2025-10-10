import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/skeletonizer/rating_star_loader.dart';
import 'package:sadhana_cart/features/rating/view%20model/rating_notifier.dart';

class ProductPriceRating extends StatelessWidget {
  final ProductModel product;
  const ProductPriceRating({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            product.name ?? '',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(height: 10),

        // Rating & Price
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final ratingAsync = ref.watch(
                    avgRatingProvider(product.productid ?? ''),
                  );
                  return ratingAsync.when(
                    data: (rating) {
                      return StarRating(
                        mainAxisAlignment: MainAxisAlignment.start,
                        rating: (rating).toDouble(),
                        color: AppColor.ratingColor,
                        size: 25.0,
                        onRatingChanged: (value) {
                          log(value.toString());
                        },
                      );
                    },
                    error: (e, s) => const Text('error'),
                    loading: () => const RatingStarLoader(),
                  );
                },
              ),
              Row(
                children: [
                  Text(
                    "${Constants.indianCurrency} ${product.offerprice}",
                    style: const TextStyle(
                      fontSize: 20,
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
            ],
          ),
        ),
      ],
    );
  }
}
