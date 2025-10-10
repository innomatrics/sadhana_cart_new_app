// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'banner_model.g.dart';

@HiveType(typeId: 1)
class BannerModel extends HiveObject {
  @HiveField(0)
  final String bannerId;
  @HiveField(1)
  final String bannerName;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final String productId;
  @HiveField(4)
  final String status;
  BannerModel({
    required this.bannerId,
    required this.bannerName,
    required this.image,
    required this.productId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bannerId': bannerId,
      'bannerName': bannerName,
      'image': image,
      'productId': productId,
      'status': status,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      bannerId: map['bannerId'] as String,
      bannerName: map['bannerName'] as String,
      image: map['image'] as String,
      productId: map['productId'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BannerModel(bannerId: $bannerId, bannerName: $bannerName, image: $image, productId: $productId, status: $status)';
  }
}
