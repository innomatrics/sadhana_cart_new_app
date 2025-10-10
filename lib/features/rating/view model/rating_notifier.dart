import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/features/rating/model/rating_model.dart';
import 'package:sadhana_cart/features/rating/model/rating_state.dart';
import 'package:sadhana_cart/features/rating/service/rating_service.dart';

final ratingProvider = StateNotifierProvider<RatingNotifier, RatingState>(
  (ref) => RatingNotifier(),
);

final specificProductrating = FutureProvider.autoDispose
    .family<List<RatingModel>, String>((ref, productId) async {
      return await RatingService.fetchRating(productId: productId);
    });

final avgRatingProvider = FutureProvider.autoDispose.family<double, String>((
  ref,
  productId,
) async {
  return await RatingService.getAverageRating(productId: productId);
});

class RatingNotifier extends StateNotifier<RatingState> {
  RatingNotifier() : super(RatingState.initialState());

  Future<bool> addrating({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    final bool isSuccess = await RatingService.addRating(
      productId: productId,
      rating: rating,
      comment: comment,
    );
    if (isSuccess) {
      state = state.copyWith(
        isLoading: false,
        ratings: await fetchProductRating(productId: productId),
      );
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteRating({
    required String ratingId,
    required String productId,
  }) async {
    final bool isSuccess = await RatingService.deleteUserOwnRating(
      productId: productId,
      ratingId: ratingId,
    );

    if (isSuccess) {
      state = state.copyWith(
        isLoading: false,
        ratings: await fetchProductRating(productId: productId),
      );
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updaterating({
    required String ratingId,
    required String comment,
    required double rating,
    required String productId,
  }) async {
    final bool isSuccess = await RatingService.updateOwnRating(
      ratingId: ratingId,
      comment: comment,
      productId: productId,
      rating: rating,
    );
    if (isSuccess) {
      state = state.copyWith(
        isLoading: false,
        ratings: await fetchProductRating(productId: productId),
      );
      return true;
    } else {
      return false;
    }
  }

  Future<List<RatingModel>> fetchProductRating({
    required String productId,
  }) async {
    try {
      state = state.copyWith(isLoading: true, ratings: []);
      final data = await RatingService.fetchRating(productId: productId);
      state = state.copyWith(isLoading: false, ratings: data);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        ratings: [],
        error: e.toString(),
      );
    }
    return state.ratings;
  }
}
