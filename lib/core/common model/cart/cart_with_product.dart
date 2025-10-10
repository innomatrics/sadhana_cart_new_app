import 'dart:convert';
import 'package:sadhana_cart/core/common%20model/cart/cart_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class CartWithProduct {
  final CartModel cart;
  final ProductModel product;
  CartWithProduct({required this.cart, required this.product});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'cart': cart.toMap(), 'product': product.toMap()};
  }

  factory CartWithProduct.fromMap(Map<String, dynamic> map) {
    return CartWithProduct(
      cart: CartModel.fromMap(map['cart'] as Map<String, dynamic>),
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartWithProduct.fromJson(String source) =>
      CartWithProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
