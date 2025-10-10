import 'package:flutter/material.dart';

class Constants {
  static const String indianCurrency = "₹";
  static const String orderPendingText =
      "The order has been placed but not yet processed. "
      "It is waiting to be confirmed and moved to the next stage. "
      "No actions have been taken on the order yet.";

  static const String orderProcessingText =
      "The order is currently being prepared for shipment. "
      "Items are being packed and necessary checks are in progress. "
      "It will soon be handed over for delivery.";

  static const String orderShippedText =
      "The order has been shipped and is on its way. "
      "It has left the warehouse and is with the delivery service. "
      "Tracking updates may be available during transit.";

  static const String orderDeliveredText =
      "The order has been successfully delivered to the customer. "
      "This marks the completion of the order lifecycle. "
      "No further action is required unless a return or issue arises.";

  static const String orderCancelledText =
      "The order was cancelled before completion. "
      "It may have been stopped by the customer or due to a system issue. "
      "No items will be shipped or charged for this order.";

  static const String webClientId = "AIzaSyDpjMz_gzDUtdLtBryB1hDBccT7vgqRYaE";

  static const TextStyle productTabBarTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
