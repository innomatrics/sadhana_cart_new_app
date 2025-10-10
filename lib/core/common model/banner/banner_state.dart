// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sadhana_cart/core/common%20model/banner/banner_model.dart';

class BannerState {
  final bool isLoading;
  final List<BannerModel>? banner;
  final String? error;
  BannerState({this.isLoading = false, this.banner = const [], this.error});

  factory BannerState.initial() =>
      BannerState(isLoading: false, banner: [], error: null);

  BannerState copyWith({
    bool? isLoading,
    List<BannerModel>? banner,
    String? error,
  }) {
    return BannerState(
      isLoading: isLoading ?? this.isLoading,
      banner: banner ?? this.banner,
      error: error ?? this.error,
    );
  }
}
