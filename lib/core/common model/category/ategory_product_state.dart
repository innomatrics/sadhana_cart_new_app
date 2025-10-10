import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class CategoryProductState {
  final List<ProductModel> products;
  final bool isLoading;
  final String? error;

  CategoryProductState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  factory CategoryProductState.initial() =>
      CategoryProductState(isLoading: false, error: null, products: []);

  CategoryProductState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    String? error,
  }) {
    return CategoryProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
