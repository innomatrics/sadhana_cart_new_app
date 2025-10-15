import 'package:collection/collection.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/common%20model/favorite/favorite_model.dart';
import 'package:sadhana_cart/core/common%20services/favorite/favorite_service.dart';

final favoriteModelProvider =
    StateNotifierProvider<FavModelNotifier, Set<FavoriteModel>>(
      (ref) => FavModelNotifier()..fetchFavoriteModel(),
    );

class FavModelNotifier extends StateNotifier<Set<FavoriteModel>> {
  FavModelNotifier() : super({});

  void fetchFavoriteModel() async {
    state = await FavoriteService.fetchFavorites();
  }

  FavoriteModel? getFavoriteModel(String productid) =>
      state.firstWhereOrNull((element) => element.productid == productid);

  void addToFavorite({required FavoriteModel favorite}) {
    state = {...state, favorite};
  }

  void removeFromFavorite({required String favoriteId}) {
    state = state.where((e) => e.favoriteId != favoriteId).toSet();
  }

  String checkTheProductIsInFavorite(String productid) =>
      state.firstWhere((element) => element.productid == productid).favoriteId;
}
