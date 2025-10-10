// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final Timestamp? createdAt;
  @HiveField(4)
  final Timestamp? updatedAt;
  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      image: map['image'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? map['createdAt'] as Timestamp
          : null,
      updatedAt: map['updatedAt'] != null
          ? map['updatedAt'] as Timestamp
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
