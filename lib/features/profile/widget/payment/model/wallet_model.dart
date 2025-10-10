import 'dart:convert';

import 'package:hive/hive.dart';

class WalletModel extends HiveObject {
  final String cardId;
  final String customerId;
  final String maskedNumber;
  final String expiryDate;
  final String cardHolderName;
  final String paymentToken;
  final String cardBrand;
  final String color;
  final String last4Digits;
  WalletModel({
    required this.cardId,
    required this.customerId,
    required this.maskedNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.paymentToken,
    required this.color,
    required this.cardBrand,
    required this.last4Digits,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cardId': cardId,
      'customerId': customerId,
      'maskedNumber': maskedNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'paymentToken': paymentToken,
      'cardBrand': cardBrand,
      'color': color,
      'last4Digits': last4Digits,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      cardId: map['cardId'] as String,
      customerId: map['customerId'] as String,
      maskedNumber: map['maskedNumber'] as String,
      expiryDate: map['expiryDate'] as String,
      cardHolderName: map['cardHolderName'] as String,
      paymentToken: map['paymentToken'] as String,
      color: map['color'] as String,
      cardBrand: map['cardBrand'] as String,
      last4Digits: map['last4Digits'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(String source) =>
      WalletModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DriverCreditCardModel(cardId: $cardId, customerId: $customerId, maskedNumber: $maskedNumber, expiryDate: $expiryDate, cardHolderName: $cardHolderName, paymentToken: $paymentToken, cardBrand: $cardBrand, last4Digits: $last4Digits)';
  }
}
