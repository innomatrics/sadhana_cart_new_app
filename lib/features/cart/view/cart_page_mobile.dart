import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common repo/cart/cart_notifier.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/skeletonizer/cart_loader.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/features/cart/widget/cart_tile.dart';
import 'package:sadhana_cart/features/cart/widget/check_out_details.dart';
import 'package:sadhana_cart/features/payment/view/payment_main_for_list_of_product.dart';

class CartPageMobile extends ConsumerStatefulWidget {
  final PreferredSizeWidget? appBar;
  const CartPageMobile({super.key, this.appBar});

  @override
  ConsumerState<CartPageMobile> createState() => _CartPageMobileState();
}

class _CartPageMobileState extends ConsumerState<CartPageMobile> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(cartProvider.notifier).loadCart();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final selectedSize = ref.watch(selectedSizeVariant);
    final userLogged = ref.watch(authNotifierProvider);

    if (!userLogged) {
      return const Center(child: Text("You are not logged in"));
    }

    if (cart.isLoading) {
      return const CartLoader();
    }

    if (cart.cart.isEmpty) {
      return const Center(child: Text("Your cart is empty"));
    }

    return Scaffold(
      appBar: widget.appBar,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cart.length,
              itemBuilder: (context, index) {
                final cw = cart.cart[index];
                final cartItem = cw.cart;
                final product = cw.product;

                final selectedSize =
                    cartItem.sizeVariant ??
                    SizeVariant(size: "", color: "", stock: 0);
                final offerPrice = product.offerprice ?? 0.0;
                final quantity = cartItem.quantity;
                final priceForItem = offerPrice * quantity;

                return CartTile(
                  product: product,
                  cart: cartItem,
                  priceForItem: priceForItem,
                  selectedSize: selectedSize,
                );
              },
            ),
          ),

          // Checkout section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CheckOutDetails(cartItems: cart.cart),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  child: const Text(
                    "Checkout",
                    style: customElevatedButtonTextStyle,
                  ),
                  onPressed: () {
                    final notifier = ref.read(cartProvider.notifier);
                    final model = ref.read(cartProvider);
                    final product = cart.cart.map((e) => e.product).toList();
                    final carts = model.cart.map((e) => e.cart).toList();
                    final totalAmount = notifier.getCartTotalAmount();

                    navigateTo(
                      context: context,
                      screen: PaymentMainForListOfProduct(
                        products: product,
                        totalAmount: totalAmount,
                        cart: carts,
                        shippingCharges: 0.0,
                        selectedSizeIndex: selectedSize,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
