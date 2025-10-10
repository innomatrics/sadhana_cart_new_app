// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'size_variant.g.dart';

@HiveType(typeId: 9)
class SizeVariant extends HiveObject {
  @HiveField(0)
  final String size;

  @HiveField(1)
  final String? color;

  @HiveField(2)
  int stock;

  @HiveField(3)
  final String? skuSuffix;

  SizeVariant({
    required this.size,
    this.color,
    required this.stock,
    this.skuSuffix,
  });

  SizeVariant copyWith({
    String? size,
    String? color,
    int? stock,
    String? skuSuffix,
  }) {
    return SizeVariant(
      size: size ?? this.size,
      color: color ?? this.color,
      stock: stock ?? this.stock,
      skuSuffix: skuSuffix ?? this.skuSuffix,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size,
      'color': color,
      'stock': stock,
      'skuSuffix': skuSuffix,
    };
  }

  factory SizeVariant.fromMap(Map<String, dynamic> map) {
    return SizeVariant(
      size: map['size'] as String,
      color: map['color'] != null ? map['color'] as String : null,
      stock: map['stock'] as int,
      skuSuffix: map['skuSuffix'] != null ? map['skuSuffix'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SizeVariant.fromJson(String source) =>
      SizeVariant.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SizeVariant(size: $size, color: $color, stock: $stock, skuSuffix: $skuSuffix)';
  }

  @override
  bool operator ==(covariant SizeVariant other) {
    if (identical(this, other)) return true;

    return other.size == size &&
        other.color == color &&
        other.stock == stock &&
        other.skuSuffix == skuSuffix;
  }

  @override
  int get hashCode {
    return size.hashCode ^ color.hashCode ^ stock.hashCode ^ skuSuffix.hashCode;
  }
}
