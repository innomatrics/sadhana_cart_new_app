// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'subcategory_model.g.dart';

@HiveType(typeId: 3)
class SubcategoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final Timestamp? createdAt;
  @HiveField(4)
  final Timestamp? updatedAt;
  SubcategoryModel({
    required this.id,
    required this.name,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory SubcategoryModel.fromMap(Map<String, dynamic> map) {
    return SubcategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      createdAt: map['createdAt'] != null
          ? map['createdAt'] as Timestamp
          : null,
      updatedAt: map['updatedAt'] != null
          ? map['updatedAt'] as Timestamp
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubcategoryModel.fromJson(String source) =>
      SubcategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
