import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/cart/cart_notifier.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/skeletonizer/rating_tile_loader.dart';
import 'package:sadhana_cart/core/ui_template/clothing/widget/clothing%20details/edit_review.dart';
import 'package:sadhana_cart/core/ui_template/clothing/widget/clothing%20details/rating_tile.dart';
import 'package:sadhana_cart/core/ui_template/common%20widgets/product_price_rating.dart';
import 'package:sadhana_cart/core/ui_template/head%20phones/widgets/product_detail_row.dart';
import 'package:sadhana_cart/core/widgets/custom_carousel_slider.dart';
import 'package:sadhana_cart/core/widgets/custom_divider.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_rating_widget.dart';
import 'package:sadhana_cart/core/widgets/custom_text_button.dart';
import 'package:sadhana_cart/core/widgets/custom_tile_dropdown.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/auth/view/sign%20up/view/sign_in_mobile.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/view/payment_main_page.dart';
import 'package:sadhana_cart/features/rating/view%20model/rating_notifier.dart';

class ClothingProductsDetails extends StatelessWidget {
  final ProductModel product;

  const ClothingProductsDetails({super.key, required this.product});

  void checkStockAndProceed({
    required BuildContext context,
    required WidgetRef ref,
    required ProductModel product,
    required void Function(ProductModel, int, String) onStockAvailable,
  }) {
    final selectedSizeIndex = ref.read(clothingSizeProvider);
    final selectedSize = product.sizevariants!.isNotEmpty
        ? product.sizevariants![selectedSizeIndex].stock
        : product.stock ?? 0;

    if ((selectedSize) <= 0) {
      log("Stock not available for size: $selectedSize 'Unknown'");
      showCustomSnackbar(
        context: context,
        message: "Stock not available for selected size",
        type: ToastType.error,
      );
      return;
    }

    log("Stock available ($selectedSize) for size: $selectedSize, proceeding");

    onStockAvailable(product, selectedSizeIndex, selectedSize.toString());
  }

  @override
  Widget build(BuildContext context) {
    final productData = product.getDetailsByCategory();
    final size = MediaQuery.of(context).size;
    log(product.toString());
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final checkUser = ref.watch(authNotifierProvider);
                  final cartItems = ref.watch(cartProvider);
                  final cartNotifier = ref.read(cartProvider.notifier);
                  final bool isAlreadyInCart = cartItems.cart.any(
                    (c) => c.cart.productid == product.productid,
                  );

                  final selectedSizeIndex = ref.watch(clothingSizeProvider);
                  final selected = product.sizevariants!.isNotEmpty
                      ? product.sizevariants![selectedSizeIndex].size
                      : "L";
                  final loader = ref.watch(cartLoadingProvider);

                  return AbsorbPointer(
                    absorbing: loader,
                    child: CustomElevatedButton(
                      child: loader
                          ? const Loader()
                          : Text(
                              isAlreadyInCart ? "Remove" : "Add to Cart",
                              style: customElevatedButtonTextStyle,
                            ),
                      onPressed: () async {
                        if (!isAlreadyInCart) {
                          if (!checkUser) {
                            navigateTo(
                              context: context,
                              screen: const SignInMobile(),
                            );
                            return;
                          }
                          final stock = product.sizevariants!.isNotEmpty
                              ? product.sizevariants![selectedSizeIndex].stock
                              : product.stock ?? 0;

                          if (stock <= 0) {
                            log("Cannot add to cart. Stock not available.");
                            showCustomSnackbar(
                              context: context,
                              message: "Stock not available for selected size",
                              type: ToastType.error,
                            );
                            return;
                          }

                          await cartNotifier.addToCart(
                            product: product,
                            size: selected,
                          );

                          if (context.mounted) {
                            showCustomSnackbar(
                              context: context,
                              message: "Added to cart",
                              type: ToastType.success,
                            );
                          }
                        } else {
                          final cartItem = cartItems.cart.firstWhere(
                            (c) => c.cart.productid == product.productid,
                          );

                          await cartNotifier.removeFromCart(
                            cartId: cartItem.cart.cartId,
                          );

                          if (context.mounted) {
                            showCustomSnackbar(
                              context: context,
                              message: "Removed from cart",
                              type: ToastType.success,
                            );
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final checkUser = ref.watch(authNotifierProvider);
                  return CustomElevatedButton(
                    child: const Text(
                      "Buy now",
                      style: customElevatedButtonTextStyle,
                    ),
                    onPressed: () {
                      if (!checkUser) {
                        navigateTo(
                          context: context,
                          screen: const SignInMobile(),
                        );
                        return;
                      }
                      checkStockAndProceed(
                        context: context,
                        ref: ref,
                        product: product,
                        onStockAvailable:
                            (product, selectedSizeIndex, selectedSize) {
                              navigateTo(
                                context: context,
                                screen: PaymentMainPage(
                                  product: product,
                                  selectedSize:
                                      (product.sizevariants != null &&
                                          selectedSizeIndex >= 0 &&
                                          selectedSizeIndex <
                                              product.sizevariants!.length)
                                      ? product
                                            .sizevariants![selectedSizeIndex]
                                            .size
                                            .toString()
                                      : "",
                                  selectedIndex: selectedSizeIndex,
                                ),
                              );
                            },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCarouselSlider(product: product),
            SizedBox(
              width: size.width,
              child: Column(children: [ProductPriceRating(product: product)]),
            ),
            const SizedBox(height: 20),

            /// Sizes
            Consumer(
              builder: (context, ref, child) {
                final selectedSizeIndex = ref.watch(clothingSizeProvider);

                final hasValidSizes =
                    product.sizevariants != null &&
                    product.sizevariants!.any(
                      (variant) =>
                          variant.size.toLowerCase() != 'nan' &&
                          variant.size.trim().isNotEmpty,
                    );

                if (!hasValidSizes) return const SizedBox.shrink();

                return product.sizevariants!.isNotEmpty
                    ? Column(
                        children: [
                          const CustomDivider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Size:",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: List.generate(
                                      product.sizevariants?.length ?? 0,
                                      (index) {
                                        final sizeItem =
                                            product.sizevariants?[index];
                                        final isSelected =
                                            index == selectedSizeIndex;
                                        if (sizeItem == null ||
                                            sizeItem.size.toLowerCase() ==
                                                'nan' ||
                                            sizeItem.size.trim().isEmpty) {
                                          return const SizedBox.shrink();
                                        }

                                        final bool sizeHaveMoreContent =
                                            sizeItem.size.length > 3
                                            ? false
                                            : true;

                                        return GestureDetector(
                                          onTap: () {
                                            ref
                                                    .read(
                                                      clothingSizeProvider
                                                          .notifier,
                                                    )
                                                    .state =
                                                index;
                                            log(productData.toString());
                                          },
                                          child: Container(
                                            height: 40,
                                            width: sizeHaveMoreContent
                                                ? 40
                                                : 120,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColor.primaryColor
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColor.primaryColor
                                                    : Colors.grey.shade300,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.shade200,
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              sizeItem.size,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const CustomDivider(),
                        ],
                      )
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
            CustomTileDropdown(
              title: "Description",
              value: Text(product.description!),
            ),
            const SizedBox(height: 20),
            CustomTileDropdown(
              title: "Details",
              value: Column(
                children: productData.entries
                    .map(
                      (entry) => ProductDetailRow(
                        title: entry.key,
                        value: entry.value,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                final ratingAsync = ref.watch(
                  specificProductrating(product.productid!),
                );

                return ratingAsync.when(
                  loading: () => const RatingTileLoader(),
                  error: (error, stack) =>
                      Center(child: Text("Error: ${error.toString()}")),
                  data: (ratingList) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${ratingList.length} Ratings",
                              style: const TextStyle(
                                color: AppColor.primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomTextButton(
                              text: "Write a Review",
                              onPressed: () {
                                showRatingDialog(
                                  context: context,
                                  productId: product.productid!,
                                  ref: ref,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        itemCount: ratingList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final currentUser =
                              FirebaseAuth.instance.currentUser!.uid;
                          final rating = ratingList[index];
                          return GestureDetector(
                            onTap: () {
                              if (rating.userId == currentUser) {
                                showEditRatingDialoge(
                                  context: context,
                                  ref: ref,
                                  productId: product.productid!,
                                  ratingId: rating.ratingId,
                                );
                              } else {
                                showCustomSnackbar(
                                  context: context,
                                  message: "You can't edit other user's review",
                                  type: ToastType.error,
                                );
                              }
                            },
                            child: RatingTile(
                              imageUrl: rating.image.isEmpty
                                  ? AppImages.noProfile
                                  : rating.image,
                              name: rating.userName,
                              rating: rating.rating,
                              review: rating.comment,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
