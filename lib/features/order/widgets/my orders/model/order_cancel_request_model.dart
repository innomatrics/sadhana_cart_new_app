// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderCancelRequestModel {
  final String? requestId;
  final int? orderId;
  final String? userId;
  final String? reason;
  final String? cancelledBy;
  final Timestamp? requestedAt;
  OrderCancelRequestModel({
    this.requestId,
    this.orderId,
    this.userId,
    this.reason,
    this.cancelledBy,
    this.requestedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestId': requestId,
      'orderId': orderId,
      'userId': userId,
      'reason': reason,
      'cancelledBy': cancelledBy,
      'requestedAt': requestedAt,
    };
  }

  factory OrderCancelRequestModel.fromMap(Map<String, dynamic> map) {
    return OrderCancelRequestModel(
      requestId: map['requestId'] != null ? map['requestId'] as String : null,
      orderId: map['orderId'] != null ? map['orderId'] as int : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      reason: map['reason'] != null ? map['reason'] as String : null,
      cancelledBy: map['cancelledBy'] != null
          ? map['cancelledBy'] as String
          : null,
      requestedAt: map['requestedAt'] != null
          ? map['requestedAt'] as Timestamp
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderCancelRequestModel.fromJson(String source) =>
      OrderCancelRequestModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

//state

class OrderCancelState {
  final bool isLoading;
  final List<OrderCancelRequestModel> request;
  final String? error;
  OrderCancelState({
    this.isLoading = false,
    this.request = const [],
    this.error,
  });

  factory OrderCancelState.initial() =>
      OrderCancelState(isLoading: false, request: const [], error: null);

  OrderCancelState copyWith({
    bool? isLoading,
    List<OrderCancelRequestModel>? request,
    String? error,
  }) {
    return OrderCancelState(
      isLoading: isLoading ?? this.isLoading,
      request: request ?? this.request,
      error: error ?? this.error,
    );
  }
}
