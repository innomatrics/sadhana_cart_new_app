import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';

enum OrderStatusEnums {
  all,
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

extension OrderStatusEnumsExtension on OrderStatusEnums {
  String get label {
    switch (this) {
      case OrderStatusEnums.all:
        return "All";
      case OrderStatusEnums.pending:
        return "Pending";
      case OrderStatusEnums.processing:
        return "Processing";
      case OrderStatusEnums.shipped:
        return "Shipped";
      case OrderStatusEnums.delivered:
        return "Delivered";
      case OrderStatusEnums.cancelled:
        return "Cancelled";
    }
  }
}

extension OrderStatusEnumColorExtension on OrderStatusEnums {
  Color get color {
    switch (this) {
      case OrderStatusEnums.all:
        return Colors.black;
      case OrderStatusEnums.pending:
        return Colors.yellow;
      case OrderStatusEnums.processing:
        return Colors.blue;
      case OrderStatusEnums.shipped:
        return Colors.green;
      case OrderStatusEnums.delivered:
        return Colors.green;
      case OrderStatusEnums.cancelled:
        return Colors.red;
    }
  }
}

extension OrderStatusEnumsImageExtension on OrderStatusEnums {
  String get image {
    switch (this) {
      case OrderStatusEnums.all:
      case OrderStatusEnums.pending:
        return AppImages.orderPendingWhite;
      case OrderStatusEnums.processing:
        return AppImages.orderProcessingWhite;
      case OrderStatusEnums.shipped:
        return AppImages.orderShippedWhite;
      case OrderStatusEnums.delivered:
        return AppImages.orderDeliveredWhite;
      case OrderStatusEnums.cancelled:
        return AppImages.orderCanceledWhite;
    }
  }
}
