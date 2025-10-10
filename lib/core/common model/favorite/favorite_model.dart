// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'favorite_model.g.dart';

@HiveType(typeId: 6)
class FavoriteModel extends HiveObject {
  @HiveField(0)
  final String favoriteId;
  @HiveField(1)
  final String productid;
  @HiveField(2)
  final String customerId;
  FavoriteModel({
    required this.favoriteId,
    required this.productid,
    required this.customerId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'favoriteId': favoriteId,
      'productid': productid,
      'customerId': customerId,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      favoriteId: map['favoriteId'] as String,
      productid: map['productid'] as String,
      customerId: map['customerId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteModel.fromJson(String source) =>
      FavoriteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FavoriteModel(favoriteId: $favoriteId, productid: $productid, customerId: $customerId)';
}
