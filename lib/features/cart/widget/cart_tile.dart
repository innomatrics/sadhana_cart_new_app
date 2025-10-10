import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/common%20repo/cart/cart_notifier.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';

class CartTile extends ConsumerWidget {
  final ProductModel product;
  final CartModel cart;
  final num priceForItem;
  final SizeVariant? selectedSize;
  const CartTile({
    super.key,
    required this.product,
    required this.cart,
    required this.priceForItem,
    this.selectedSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        log("Product tapped: ${product.productid}");
        log("Product category: ${product.category}");
        navigateToProductDesignBasedOnCategory(
          context: context,
          categoryName: product.category ?? '',
          product: product,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        padding: const EdgeInsets.all(10),
        height: size.height * 0.19,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Container(
              width: size.width * 0.3,
              height: size.height * 0.17,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
                image: (product.images != null && product.images!.isNotEmpty)
                    ? DecorationImage(
                        image: CachedNetworkImageProvider(
                          product.images!.first,
                          cacheKey: product.productid,
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (product.images == null || product.images!.isEmpty)
                  ? const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    )
                  : null,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "${Constants.indianCurrency} ${priceForItem.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
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
                    const SizedBox(height: 5),
                    if (selectedSize != null &&
                        selectedSize!.size.isNotEmpty &&
                        selectedSize!.size != "nan")
                      Text(
                        "Size: ${selectedSize!.size}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Quantity adjuster
                        _quantityContainer(
                          size: size,
                          quantity: cart.quantity,
                          cart: cart,
                        ),
                        IconButton(
                          onPressed: () async {
                            ref
                                .read(cartProvider.notifier)
                                .removeFromCart(cartId: cart.cartId);
                          },
                          icon: const Icon(Icons.delete, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quantityContainer({
    required Size size,
    required int quantity,
    required CartModel cart,
  }) {
    const Color iconColor = Colors.grey;

    return Consumer(
      builder: (context, ref, child) {
        return Container(
          height: size.height * 0.04,
          width: size.width * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: iconColor, width: 1.4),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: IconButton(
                  onPressed: () {
                    ref
                        .read(cartProvider.notifier)
                        .decreaseQuantity(cart: cart);
                  },
                  icon: const Icon(Icons.remove, size: 18),
                  color: iconColor,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ),
              Text(
                "$quantity",
                style: const TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    ref
                        .read(cartProvider.notifier)
                        .increaseQuantity(cart: cart);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  color: iconColor,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
