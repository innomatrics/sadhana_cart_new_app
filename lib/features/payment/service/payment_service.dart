import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_model.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_with_product.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/common%20repo/cart/cart_notifier.dart';
import 'package:sadhana_cart/core/common%20services/order/order_service.dart';
import 'package:sadhana_cart/core/common%20services/product/product_service.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/api_provider.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/shiprocket_api_services.dart';
import 'package:sadhana_cart/core/enums/payment_enum.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/service/notification_service.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/view/payment_success_page.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';
import 'package:sadhana_cart/features/profile/widget/address/view%20model/address_notifier.dart';

class PaymentService {
  static Future<void> handlePayment({
    required BuildContext context,
    required String selectedMethod,
    required List<ProductModel> products,
    required WidgetRef ref,
    required SizeVariant selectedVariant,
    required double shippingCharges,
  }) async {
    try {
      final cartWithProduct = ref.watch(
        cartProvider.select((value) => value.cart),
      );

      // Prepare order products
      final List<OrderProductModel> orderproducts = await _prepareOrderProducts(
        cartWithProduct,
        selectedVariant,
      );

      final shipRocket = ShiprocketApiServices(
        Dio(),
        ref.read(tokenManagerProvider),
      );
      log("Selected Payment Method: $selectedMethod");

      final cart = cartWithProduct.map((e) => e.cart).toList();
      final cartNotifier = ref.watch(cartProvider.notifier);
      final totalAmount = cartNotifier.getCartTotalAmount();
      final addressState = ref.read(addressprovider);
      final AddressModel? address = addressState.addresses.isNotEmpty
          ? addressState.addresses.last
          : null;

      if (address == null && context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Please add an address first.",
          type: ToastType.info,
        );
        return;
      }

      // Common logic for both payment methods
      if (selectedMethod == PaymentEnum.cash.label ||
          selectedMethod == PaymentEnum.online.label && context.mounted) {
        if (context.mounted) {
          await _processOrder(
            context: context,
            selectedMethod: selectedMethod,
            orderproducts: orderproducts,
            shipRocket: shipRocket,
            address: address!,
            totalAmount: totalAmount,
            selectedVariant: selectedVariant,
            shippingCharges: shippingCharges,
            ref: ref,
            cart: cart,
          );
        }
      } else {
        throw Exception("Invalid payment method selected");
      }
    } catch (e) {
      log("Error in Payment Service: $e");
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "An error occurred. Please try again.",
          type: ToastType.error,
        );
      }
      // Re-throw to let the caller handle the error state
      rethrow;
    }
  }

  // Prepare order products from cart
  static Future<List<OrderProductModel>> _prepareOrderProducts(
    List<CartWithProduct> cartWithProduct,
    SizeVariant selectedVariant,
  ) async {
    final List<OrderProductModel> orderproducts = [];

    for (var i = 0; i < cartWithProduct.length; i++) {
      final product = cartWithProduct.map((e) => e.product).toList()[i];
      final cartItem = cartWithProduct.map((e) => e.cart).toList()[i];
      final pricePerItem = product.offerprice ?? 0.0;
      final totalPrice = cartItem.quantity * pricePerItem;

      orderproducts.add(
        OrderProductModel(
          productid: product.productid!,
          name: product.name!,
          price: totalPrice.toDouble(),
          stock: product.stock ?? 0,
          quantity: cartItem.quantity,
          height: num.parse(product.height ?? "0"),
          hsn: product.hsncode,
          length: num.parse(product.length ?? "0"),
          sku: selectedVariant.skuSuffix ?? product.basesku,
          weight: num.parse(product.weight ?? "0"),
          width: num.parse(product.width ?? "0"),
          sizevariants: [
            SizeVariant(
              size: cartItem.sizeVariant?.size ?? "",
              stock: cartItem.quantity,
            ),
          ],
          images: product.images,
        ),
      );
    }

    return orderproducts;
  }

  // Process order (common for both payment methods)
  static Future<void> _processOrder({
    required BuildContext context,
    required String selectedMethod,
    required List<OrderProductModel> orderproducts,
    required ShiprocketApiServices shipRocket,
    required AddressModel address,
    required double totalAmount,
    required SizeVariant selectedVariant,
    required double shippingCharges,
    required WidgetRef ref,
    required List<CartModel> cart,
  }) async {
    log("Processing order with $selectedMethod");

    log("Fetching warehouse location");
    final userData = ref.watch(userProvider);
    final email = userData?.email ?? "";
    final name = userData?.name ?? "";

    final paymentMethod = selectedMethod == PaymentEnum.cash.label
        ? "cash"
        : "prepaid";

    // Build Shiprocket order data
    final shipRocketOrderData = buildShiprocketOrderData(
      products: orderproducts,
      address: address,
      totalAmount: totalAmount,
      sizevariant: selectedVariant,
      ref: ref,
      shippingCharges: shippingCharges,
      pickupLocation: "Office",
      userEmail: email,
      paymentMethod: paymentMethod,
    );

    log("Creating Shiprocket order");
    final shiprocketCreateOrder = await shipRocket.createOrder(
      shipRocketOrderData,
    );

    final orderId = shiprocketCreateOrder["order_id"] as int? ?? 0;
    final shipmentId = shiprocketCreateOrder["shipment_id"] as int? ?? 0;
    final status = shiprocketCreateOrder["status"] as String? ?? '';

    final quantity = orderproducts.fold<int>(
      0,
      (int sum, el) => sum + el.quantity!,
    );
    log("Shiprocket Order ID: $orderId");

    // Add order to Firestore
    final success = await OrderService.addMultipleProductOrder(
      totalAmount: totalAmount,
      address:
          "${address.title}, ${address.streetName}, ${address.city}, ${address.state}, ${address.pinCode}",
      phoneNumber: address.phoneNumber ?? 0,
      latitude: address.lattitude,
      longitude: address.longitude,
      orderDate: DateTime.now().toString(),
      quantity: quantity,
      products: orderproducts,
      createdAt: Timestamp.now(),
      ref: ref,
      paymentMethod: selectedMethod,
      shipmentId: shipmentId,
      shiprocketOrderId: orderId,
      status: status,
    );

    if (success) {
      log("Order placed successfully in Firestore");

      // Update stock
      final stockUpdated = await ProductService.decreaseStockForProducts(
        orderproducts,
      );

      if (stockUpdated) {
        log("Stock updated successfully");

        // Clear cart
        ref.read(cartProvider.notifier).resetCart(cart: cart);

        // Send notification
        NotificationService.sendNotification(
          title: "Order Placed",
          message: "$name placed an order via $selectedMethod.",
          screen: '/order',
        );

        if (context.mounted) {
          showCustomSnackbar(
            context: context,
            message: "Order placed successfully!",
            type: ToastType.success,
          );

          // Navigate to success page
          navigateToReplacement(
            context: context,
            screen: const PaymentSuccessPage(),
          );
        }
      } else {
        log("Failed to update stock");
        if (context.mounted) {
          showCustomSnackbar(
            context: context,
            message:
                "Order placed but failed to update stock. Please contact support.",
            type: ToastType.info,
          );
        }
      }
    } else {
      log("Failed to place order in Firestore");
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: "Failed to place order. Please try again.",
          type: ToastType.error,
        );
      }
    }
  }

  // Online payment handler (called from payment controller when Razorpay succeeds)
  static Future<void> handleOnlinePaymentSuccess({
    required BuildContext context,
    required List<ProductModel> products,
    required WidgetRef ref,
    required SizeVariant selectedVariant,
    required double shippingCharges,
  }) async {
    try {
      log("Processing online payment success");

      // Call the same processOrder method but with online payment method
      await handlePayment(
        context: context,
        selectedMethod: PaymentEnum.online.label,
        products: products,
        ref: ref,
        selectedVariant: selectedVariant,
        shippingCharges: shippingCharges,
      );
    } catch (e) {
      log("Error in online payment success handler: $e");
      rethrow;
    }
  }

  static Map<String, dynamic> buildShiprocketOrderData({
    required List<OrderProductModel> products,
    required AddressModel address,
    required double totalAmount,
    required SizeVariant sizevariant,
    required WidgetRef ref,
    required double shippingCharges,
    required String pickupLocation,
    required String userEmail,
    required String paymentMethod,
  }) {
    num height = 0.0;
    num weight = 0.0;
    num length = 0.0;

    for (final p in products) {
      height += p.height ?? 0;
      weight += p.weight ?? 0;
      length += p.length ?? 0;
    }

    return {
      "order_id": DateTime.now().millisecondsSinceEpoch.toString(),
      "order_date": DateTime.now().toIso8601String(),
      "billing_customer_name": address.title,
      "pickup_location": pickupLocation,
      "billing_last_name": "",
      "billing_address": address.streetName,
      "billing_city": address.city,
      "billing_state": address.state,
      "billing_pincode": address.pinCode,
      "billing_country": "India",
      "billing_email": userEmail,
      "billing_phone": address.phoneNumber.toString(),
      "shipping_is_billing": true,
      "order_items": products.map((p) {
        return {
          "name": p.name,
          "sku": sizevariant.skuSuffix ?? p.sku,
          "units": p.quantity,
          "selling_price": p.price,
          "discount": 0,
          "tax": 0,
        };
      }).toList(),
      "payment_method": paymentMethod,
      "shipping_charges": shippingCharges,
      "giftwrap_charges": 0,
      "transaction_charges": 0,
      "total_discount": 0,
      "sub_total": totalAmount,
      "length": length <= 0.5 ? 1 : length,
      "height": height <= 0.5 ? 1 : height,
      "weight": weight <= 0.5 ? 1 : weight,
      'breadth': length <= 0.5 ? 1 : length,
    };
  }
}
