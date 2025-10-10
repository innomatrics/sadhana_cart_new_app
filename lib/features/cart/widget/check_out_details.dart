import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_with_product.dart';
import 'package:sadhana_cart/core/constants/constants.dart';

class CheckOutDetails extends ConsumerWidget {
  final List<CartWithProduct> cartItems;

  const CheckOutDetails({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmount = cartItems.fold<double>(
      0.0,
      (sum, item) =>
          sum + ((item.product.offerprice ?? 0.0) * item.cart.quantity),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          _customRowText(
            title: "Product Price",
            value:
                "${Constants.indianCurrency} ${totalAmount.toStringAsFixed(2)}",
            valueColor: Colors.black,
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),

          _customRowText(
            title: "Shipping",
            value: "Free",
            valueColor: Colors.black,
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),

          _customRowText(
            title: "Subtotal",
            value:
                "${Constants.indianCurrency} ${totalAmount.toStringAsFixed(2)}",
            valueColor: Colors.black,
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  Widget _customRowText({
    required String title,
    required String value,
    Color? valueColor = Colors.black,
    Color? titleColor = Colors.grey,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
