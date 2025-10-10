import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';

class SearchProductTile extends ConsumerWidget {
  final ScrollController? controller;
  final List<ProductModel> products;
  final bool isLoadingMore;
  final void Function(ProductModel)? onTap;

  const SearchProductTile({
    super.key,
    this.controller,
    required this.products,
    this.onTap,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    if (products.isEmpty) {
      return const Center(child: Text("No products found"));
    }

    return GridView.builder(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: isLoadingMore ? products.length + 1 : products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        if (index >= products.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = products[index];

        return GestureDetector(
          onTap: () => onTap?.call(product),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  navigateToProductDesignBasedOnCategory(
                    context: context,
                    categoryName: product.category?.toLowerCase() ?? "",
                    product: product,
                  );
                },
                child: Container(
                  height: size.height * 0.22,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: product.images != null && product.images!.isNotEmpty
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                              product.images!.first,
                              cacheKey: product.productid,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: product.images == null || product.images!.isEmpty
                        ? Colors.grey.shade200
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    "${Constants.indianCurrency} ${product.offerprice?.toStringAsFixed(0) ?? '0'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
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
        );
      },
    );
  }
}
