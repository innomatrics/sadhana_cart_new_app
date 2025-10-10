import 'package:hive/hive.dart';

part 'brand_model.g.dart';

@HiveType(typeId: 7)
class BrandModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String logoUrl;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String categoryId;

  @HiveField(5)
  final String subCategoryId;

  BrandModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.description,
    required this.categoryId,
    required this.subCategoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return BrandModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      subCategoryId: map['subCategoryId'] ?? '',
    );
  }
}
