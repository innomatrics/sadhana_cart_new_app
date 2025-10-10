// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String ratingId;
  final String userId;
  final String userName;
  final String productid;
  final String image;
  final double rating;
  final String comment;
  final Timestamp createdAt;
  RatingModel({
    required this.ratingId,
    required this.userId,
    required this.userName,
    required this.productid,
    required this.image,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ratingId': ratingId,
      'userId': userId,
      'userName': userName,
      'productid': productid,
      'image': image,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      ratingId: map['ratingId'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      productid: map['productid'] as String,
      image: map['image'] as String,
      rating: map['rating'] as double,
      comment: map['comment'] as String,
      createdAt: map['createdAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingModel.fromJson(String source) =>
      RatingModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
