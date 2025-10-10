import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/common%20repo/order/order_notifier.dart';
import 'package:sadhana_cart/core/enums/order_status_enums.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';

class OrderService {
  static const String userCollection = 'users';
  static const String productCollection = 'products';

  static final String currentUser = FirebaseAuth.instance.currentUser!.uid;

  // Path: /users/{currentUserId}/orders
  static final CollectionReference orderRef = FirebaseFirestore.instance
      .collection(userCollection)
      .doc(currentUser)
      .collection('orders');

  static final CollectionReference productRef = FirebaseFirestore.instance
      .collection(productCollection);

  static Future<bool> addMultipleProductOrder({
    required double totalAmount,
    required String address,
    required int phoneNumber,
    required double? latitude,
    required double? longitude,
    required String orderDate,
    required int quantity,
    required List<OrderProductModel> products,
    required Timestamp createdAt,
    required WidgetRef ref,
    required String paymentMethod,
    int? shiprocketOrderId,
    int? shipmentId,
    String? status,
  }) async {
    try {
      final docRef = orderRef.doc();
      final OrderModel orderModel = OrderModel(
        quantity: quantity,
        userId: currentUser,
        totalAmount: totalAmount,
        address: address,
        phoneNumber: phoneNumber,
        latitude: latitude!,
        longitude: longitude!,
        orderStatus: OrderStatusEnums.pending.label,
        orderDate: Timestamp.now(),
        orderId: docRef.id,
        createdAt: createdAt,
        products: products,
        paymentMethod: paymentMethod,
        shiprocketOrderId: shiprocketOrderId,
        shipmentId: shipmentId,
        shiprocketStatus: status,
      );

      await docRef.set(orderModel.toMap());
      ref.read(orderProvider.notifier).addOrder(order: orderModel);
      ref.read(currentOrderIdProvider.notifier).state = docRef.id;

      debugPrint(
        "Multiple product order created successfully with ID: ${docRef.id}",
      );
      return true;
    } catch (e, st) {
      debugPrint("Order creation failed: $e");
      debugPrint(st.toString());
      return false;
    }
  }

  static Future<bool> addSingleOrder({
    required double totalAmount,
    required int phoneNumber,
    required String address,
    required double latitude,
    required double longitude,
    required int quantity,
    required OrderProductModel product,
    required Timestamp createdAt,
    required WidgetRef ref,
    required String selectedSizeFromUser,
    required String paymentMethod,
    required int shipmentId,
  }) async {
    try {
      // Find user-selected size variant safely
      SizeVariant? selectedVariant;
      if (product.sizevariants != null && product.sizevariants!.isNotEmpty) {
        try {
          selectedVariant = product.sizevariants!.firstWhere(
            (v) => v.size == selectedSizeFromUser,
          );
        } catch (_) {
          selectedVariant = null;
        }
        if (selectedVariant == null) {
          log(
            "Selected size '$selectedSizeFromUser' not found for product ${product.productid}",
          );
          return false;
        }
      } else {
        selectedVariant = null;
      }

      final orderDoc = orderRef.doc();
      final orderModel = OrderModel(
        quantity: quantity,
        userId: currentUser,
        totalAmount: totalAmount,
        address: address,
        phoneNumber: phoneNumber,
        latitude: latitude,
        longitude: longitude,
        orderStatus: OrderStatusEnums.pending.label,
        orderDate: Timestamp.now(),
        orderId: orderDoc.id,
        createdAt: createdAt,
        shipmentId: shipmentId,
        products: [product],
        paymentMethod: paymentMethod,
        shiprocketOrderId: shipmentId,
      );

      // Fetch product from Firestore
      final productQuery = await productRef
          .where('productid', isEqualTo: product.productid)
          .limit(1)
          .get();
      if (productQuery.docs.isEmpty) throw Exception("Product not found");

      final productRefDoc = productRef.doc(productQuery.docs.first.id);
      final data = ProductModel.fromMap(
        productQuery.docs.first.data() as Map<String, dynamic>,
      );

      // Transaction: update stock & save order
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final currentTotalStock = data.stock ?? 0;
        if (currentTotalStock < quantity) {
          // message
          throw Exception("Insufficient total stock");
        }
        transaction.update(productRefDoc, {
          'stock': currentTotalStock - quantity,
        });

        final updatedVariants = data.sizevariants?.map((variant) {
          if (variant.size == selectedVariant?.size &&
              (variant.color ?? '') == (selectedVariant?.color ?? '')) {
            final newStock = (variant.stock) - quantity;
            if (newStock < 0) {
              throw Exception("Insufficient stock for selected size");
            }
            return {
              'sku': variant.skuSuffix,
              'size': variant.size,
              'color': variant.color,
              'stock': newStock,
            };
          }
          return {
            'sku': variant.skuSuffix,
            'size': variant.size,
            'color': variant.color,
            'stock': variant.stock,
          };
        }).toList();

        transaction.update(productRefDoc, {'sizevariants': updatedVariants});

        final userOrderRef = FirebaseFirestore.instance
            .collection(userCollection)
            .doc(currentUser)
            .collection('orders')
            .doc(orderDoc.id);
        transaction.set(userOrderRef, orderModel.toMap());
      });

      // Update provider
      ref.read(orderProvider.notifier).addOrder(order: orderModel);

      // Save current order ID in a separate provider
      ref.read(currentOrderIdProvider.notifier).state = orderDoc.id;

      return true;
    } catch (e, stack) {
      debugPrint("addSingleOrder error: $e\n$stack");
      return false;
    }
  }

  static Future<List<OrderModel>> fetchCustomerOrderDetails() async {
    try {
      debugPrint("Fetching orders for user: $currentUser");
      final QuerySnapshot querySnapshot = await orderRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        debugPrint(
          "Found ${querySnapshot.docs.length} orders for user: $currentUser",
        );
        final data = querySnapshot.docs
            .map((e) => OrderModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        debugPrint("order data : $data");
        return data;
      } else {
        debugPrint("No orders found for user: $currentUser");
        return [];
      }
    } catch (e) {
      debugPrint("Order Service fetch error: $e");
      return [];
    }
  }

  static Future<void> savePurchasedProducts({
    required List<ProductModel> products,
    required AddressModel address,
    required String paymentMethod,
  }) async {
    try {
      final userDocRef = FirebaseFirestore.instance
          .collection(userCollection)
          .doc(currentUser);

      // Collection to hold purchased products
      final purchasedRef = userDocRef.collection('orders');

      for (final product in products) {
        final productId = product.productid ?? '';

        if (productId.isEmpty) {
          debugPrint("Skipping product with empty productId");
          continue;
        }

        final productDoc = purchasedRef.doc(productId);
        final snapshot = await productDoc.get();

        if (snapshot.exists) {
          final currentData = snapshot.data() as Map<String, dynamic>;
          final currentQuantity = currentData['quantity'] ?? 0;

          await productDoc.update({
            'productId': productId,
            'quantity': currentQuantity + (product.quantity ?? 1),
            'lastPurchasedAt': FieldValue.serverTimestamp(),
            'paymentMethod': paymentMethod,
            'address': address.toMap(),
          });

          debugPrint("Updated purchased product: $productId with new quantity");
        } else {
          await productDoc.set({
            ...product.toMap(),
            'quantity': product.quantity ?? 1,
            'firstPurchasedAt': FieldValue.serverTimestamp(),
            'lastPurchasedAt': FieldValue.serverTimestamp(),
            'paymentMethod': paymentMethod,
            'address': address.toMap(),
          });

          debugPrint("Added new purchased product: $productId");
        }
      }
    } catch (e, stack) {
      debugPrint("Error saving purchased products: $e");
      debugPrint("Stack: $stack");
    }
  }
}
