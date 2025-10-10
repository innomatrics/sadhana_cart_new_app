import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> orderAuth({
  required String userId,
  required String paymentMethod, // "cash" or "upi"
  required String name,
  required String email,
  required String phone,
  required String address,
  required double amount,
  required List<Map<String, dynamic>> items, // cart items
  required String paymentId, // from Razorpay or empty if cash
}) async {
  try {
    final orderData = {
      "paymentMethod": paymentMethod,
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "amount": amount,
      "items": items, // each item { "id": "p1", "name": "Shirt", "qty": 2 }
      "paymentId": paymentId,
      "status": paymentMethod == "cash" ? "pending" : "paid",
      "createdAt": FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("orders")
        .add(orderData);

    log("Order stored successfully");
  } catch (e) {
    log("Failed to store order: $e");
  }
}
