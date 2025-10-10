import 'dart:developer' show log;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_model.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_state.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_with_product.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20services/cart/cart_service.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';

class CartNotifier extends StateNotifier<CartState> {
  final Ref ref;
  CartNotifier(this.ref) : super(CartState.initial()) {
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      state = state.copyWith(isLoading: true, cart: []);
      final carts = await CartService.fetchCartItemsWithProducts();
      state = state.copyWith(cart: [...carts], isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), cart: []);
    }
  }

  Future<void> addToCart({required ProductModel product, String? size}) async {
    ref.read(cartLoadingProvider.notifier).state = true;
    final bool success = await CartService.addToCart(size, product: product);
    if (success) {
      final carts = await CartService.fetchCartItemsWithProducts();
      state = state.copyWith(cart: [...carts]);
      ref.read(cartLoadingProvider.notifier).state = false;
    }
  }

  Future<void> removeFromCart({required String cartId}) async {
    state = state.copyWith(
      cart: state.cart.where((e) => e.cart.cartId != cartId).toList(),
    );
    ref.read(cartLoadingProvider.notifier).state = true;
    if (cartId.trim().isEmpty) {
      log("removeFromCart: cartId empty, skipping");
      ref.read(cartLoadingProvider.notifier).state = false;
      return;
    }

    final bool success = await CartService.deleteCart(cartId: cartId);
    if (success) {
      final updatedCarts = await CartService.fetchCartItemsWithProducts();
      state = state.copyWith(cart: [...updatedCarts]);
      ref.read(cartLoadingProvider.notifier).state = false;
    } else {
      state = state.copyWith(
        cart: state.cart.where((c) => c.cart.cartId != cartId).toList(),
      );
      ref.read(cartLoadingProvider.notifier).state = false;
    }
  }

  void increaseQuantity({required CartModel cart}) {
    final index = state.cart.indexWhere((c) => c.cart.cartId == cart.cartId);
    if (index == -1) return;

    final current = state.cart[index];
    final maxStock = current.product.sizevariants!.isEmpty
        ? current.product.stock
        : current.product.sizevariants?[index].stock ?? 0;

    if (cart.quantity < maxStock!) {
      final updatedCart = cart.copyWith(quantity: cart.quantity + 1);
      log(updatedCart.toString());
      final updatedItem = CartWithProduct(
        cart: updatedCart,
        product: current.product,
      );

      final updatedState = [...state.cart];
      updatedState[index] = updatedItem;
      state = state.copyWith(cart: updatedState);
    }
  }

  void decreaseQuantity({required CartModel cart}) {
    final index = state.cart.indexWhere((c) => c.cart.cartId == cart.cartId);
    if (index == -1 || cart.quantity <= 1) return;
    final current = state.cart[index];
    final updatedCart = cart.copyWith(quantity: cart.quantity - 1);
    final updatedItem = CartWithProduct(
      cart: updatedCart,
      product: current.product,
    );

    final updatedState = [...state.cart];
    updatedState[index] = updatedItem;
    state = state.copyWith(cart: updatedState);
  }

  double getCartTotalAmount() {
    double total = 0.0;

    for (final cartWithProduct in state.cart) {
      final price = cartWithProduct.product.offerprice ?? 0.0;
      total += price * cartWithProduct.cart.quantity;
    }

    return total;
  }

  void resetCart({required List<CartModel> cart}) async {
    final bool isSuccess = await CartService.removeAllPaidCartItems(cart: cart);
    if (isSuccess) {
      state = state.copyWith(cart: []);
    } else {
      log("reset cart failed");
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref)..loadCart();
});
