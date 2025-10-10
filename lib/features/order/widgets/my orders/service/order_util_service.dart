import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/model/order_cancel_request_model.dart';

class OrderUtilService {
  static final currentUser = FirebaseAuth.instance.currentUser!.uid;

  static final CollectionReference orderCancelRef = FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser)
      .collection("orderCancel");

  static final CollectionReference orderRef = FirebaseFirestore.instance
      .collection("users")
      .doc(currentUser)
      .collection("orders");

  static Future<bool> cancelOrder({
    required int shiprocketOrderId,
    required String reason,
    required Ref ref,
  }) async {
    try {
      final docRef = orderCancelRef.doc();
      final cancelForm = OrderCancelRequestModel(
        cancelledBy: null,
        requestedAt: Timestamp.now(),
        requestId: docRef.id,
        userId: currentUser,
        orderId: shiprocketOrderId,
        reason: reason,
      );

      await docRef.set(cancelForm.toMap());
      return true;
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  static Future<List<OrderCancelRequestModel>> getAllRequest() async {
    try {
      final QuerySnapshot querySnapshot = await orderCancelRef.get();
      return querySnapshot.docs
          .map(
            (e) => OrderCancelRequestModel.fromMap(
              e.data() as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get order cancel requests: $e');
    }
  }

  static Future<bool> changeOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      final DocumentSnapshot documentSnapshot = await orderRef
          .doc(orderId)
          .get();

      if (documentSnapshot.exists) {
        await documentSnapshot.reference.update({"orderStatus": status});
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}
