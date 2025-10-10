class ProductFilter {
  final String? name;
  final String? category;
  final num? minPrice;
  final num? maxPrice;
  ProductFilter({this.name, this.category, this.minPrice, this.maxPrice});

  ProductFilter copyWith({
    String? name,
    String? category,
    num? minPrice,
    num? maxPrice,
  }) {
    return ProductFilter(
      name: name ?? this.name,
      category: category ?? this.category,

      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}
