import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20services/favorite/favorite_service.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Set<ProductModel>>(
      (ref) => FavoriteNotifier(ref)..initialize(),
    );

class FavoriteNotifier extends StateNotifier<Set<ProductModel>> {
  final Ref ref;
  FavoriteNotifier(this.ref) : super({});

  Future<void> initialize() async {
    final favorites = await FavoriteService.fetchUserFavoriteProducts();
    state = favorites;
  }

  void addToFavorite({required ProductModel product}) {
    ref.read(favoriteLoadingProvider.notifier).state = true;
    state = {...state, product};
    ref.read(favoriteLoadingProvider.notifier).state = false;
  }

  void removeFromFavorite({required ProductModel product}) {
    ref.read(favoriteLoadingProvider.notifier).state = true;
    state = state.where((e) => e.productid != product.productid).toSet();
    ref.read(favoriteLoadingProvider.notifier).state = false;
  }

  bool isFavorite(String productid) {
    return state.any((e) => e.productid == productid);
  }
}
