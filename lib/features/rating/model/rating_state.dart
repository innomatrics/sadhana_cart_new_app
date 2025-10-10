// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sadhana_cart/features/rating/model/rating_model.dart';

class RatingState {
  final bool isLoading;
  final List<RatingModel> ratings;
  final String? error;
  RatingState({this.isLoading = false, this.ratings = const [], this.error});

  factory RatingState.initialState() {
    return RatingState(isLoading: false, ratings: [], error: null);
  }

  RatingState copyWith({
    bool? isLoading,
    List<RatingModel>? ratings,
    String? error,
  }) {
    return RatingState(
      isLoading: isLoading ?? this.isLoading,
      ratings: ratings ?? this.ratings,
      error: error ?? this.error,
    );
  }
}
