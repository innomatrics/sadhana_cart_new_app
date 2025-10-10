// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class FavoriteState {
  final bool isLoading;
  final Set<ProductModel> favoriteProducts;
  final String? error;
  FavoriteState({
    this.isLoading = false,
    this.favoriteProducts = const {},
    this.error,
  });

  factory FavoriteState.initial() =>
      FavoriteState(isLoading: false, error: null, favoriteProducts: {});
  FavoriteState copyWith({
    bool? isLoading,
    Set<ProductModel>? favoriteProducts,
    String? error,
  }) {
    return FavoriteState(
      isLoading: isLoading ?? this.isLoading,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      error: error ?? this.error,
    );
  }
}
