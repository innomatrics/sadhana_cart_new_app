// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sadhana_cart/core/common%20model/cart/cart_with_product.dart';

class CartState {
  final bool isLoading;
  final List<CartWithProduct> cart;
  final String? error;
  CartState({this.isLoading = false, this.cart = const [], this.error});

  factory CartState.initial() =>
      CartState(isLoading: false, cart: [], error: null);

  CartState copyWith({
    bool? isLoading,
    List<CartWithProduct>? cart,
    String? error,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      cart: cart ?? this.cart,
      error: error ?? this.error,
    );
  }
}
