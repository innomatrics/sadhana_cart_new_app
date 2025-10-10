import 'dart:convert';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';

class CartModel {
  final String cartId;

  final String customerId;

  final String productid;

  int quantity = 1;
  final SizeVariant? sizeVariant;
  CartModel({
    required this.cartId,
    required this.customerId,
    required this.productid,
    required this.quantity,
    this.sizeVariant,
  });

  CartModel copyWith({
    String? cartId,
    String? customerId,
    String? productid,
    int? quantity,

    SizeVariant? sizeVariant,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      customerId: customerId ?? this.customerId,
      productid: productid ?? this.productid,
      quantity: quantity ?? this.quantity,

      sizeVariant: sizeVariant ?? this.sizeVariant,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cartId': cartId,
      'customerId': customerId,
      'productid': productid,
      'quantity': quantity,

      'sizeVariant': sizeVariant?.toMap(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      cartId: map['cartId'] as String,
      customerId: map['customerId'] as String,
      productid: map['productid'] as String,
      quantity: map['quantity'] as int,

      sizeVariant: map['sizeVariant'] != null
          ? SizeVariant.fromMap(map['sizeVariant'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartModel(cartId: $cartId, customerId: $customerId, productid: $productid, quantity: $quantity, sizeVariant: $sizeVariant)';
  }

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;

    return other.cartId == cartId &&
        other.customerId == customerId &&
        other.productid == productid &&
        other.quantity == quantity &&
        other.sizeVariant == sizeVariant;
  }

  @override
  int get hashCode {
    return cartId.hashCode ^
        customerId.hashCode ^
        productid.hashCode ^
        quantity.hashCode ^
        sizeVariant.hashCode;
  }
}
