import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20model/order/order_state.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20services/order/order_service.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>(
  (ref) => OrderNotifier(),
);

final currentOrderIdProvider = StateProvider<String?>((ref) => null);

class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier() : super(OrderState.initial());

  List<OrderModel> allOrders = [];
  List<OrderModel> filterOrder = [];

  void addOrder({required OrderModel order}) async {
    state = state.copyWith(orders: [...state.orders, order]);
  }

  void fetchCustomOrderDetails() async {
    try {
      state = state.copyWith(isLoading: true, orders: [], error: null);
      final orders = await OrderService.fetchCustomerOrderDetails();
      allOrders = orders;
      state = state.copyWith(isLoading: false, orders: orders, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), orders: []);
    }
  }

  Future<void> savePurchasedProducts({
    required List<ProductModel> products,
    required AddressModel address,
    required String paymentMethod,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await OrderService.savePurchasedProducts(
        products: products,
        address: address,
        paymentMethod: paymentMethod,
      );

      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void filterOrderByStatus({required String query}) {
    if (query.toLowerCase() == 'all') {
      state = state.copyWith(orders: allOrders);
      return;
    }

    final filteredOrders = allOrders.where((order) {
      return order.orderStatus?.toLowerCase() == query.toLowerCase();
    }).toList();

    state = state.copyWith(orders: filteredOrders);
  }

  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required String apiStatus,
  }) async {
    try {
      log("updateOrderStatus called");
      log(
        "Params -> userId: $userId, orderId: $orderId, apiStatus: $apiStatus",
      );

      final ordersRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orders');

      final orderIdNumber = int.tryParse(orderId);

      final querySnapshot = await ordersRef
          .where('order_id', isEqualTo: orderIdNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        log(
          "No order document found with order_id: $orderIdNumber under userId: $userId",
        );
        return;
      }

      final doc = querySnapshot.docs.first;
      final docRef = ordersRef.doc(doc.id);

      await docRef.update({'status': apiStatus});
      log("Firestore update success -> orderId: $orderId, status: $apiStatus");

      log("Updating local allOrders list...");
      allOrders = allOrders.map((o) {
        if (o.orderId.toString() == orderId) {
          log("Updating order in local list -> $orderId to status: $apiStatus");
          return o.copyWith(orderStatus: apiStatus);
        }
        return o;
      }).toList();

      state = state.copyWith(orders: allOrders);
      log("State updated successfully");
    } catch (e, st) {
      log("Error in updateOrderStatus: $e");
      log("Stacktrace: $st");
      state = state.copyWith(error: e.toString());
    }
  }
}
