// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sadhana_cart/core/common%20model/subcategory/subcategory_model.dart';

class SubcategoryState {
  final bool isLoading;
  final List<SubcategoryModel> subcategory;
  final String? error;
  SubcategoryState({
    this.isLoading = false,
    this.subcategory = const [],
    this.error,
  });

  factory SubcategoryState.initial() {
    return SubcategoryState(isLoading: false, error: null, subcategory: []);
  }

  SubcategoryState copyWith({
    bool? isLoading,
    List<SubcategoryModel>? subcategory,
    String? error,
  }) {
    return SubcategoryState(
      isLoading: isLoading ?? this.isLoading,
      subcategory: subcategory ?? this.subcategory,
      error: error ?? this.error,
    );
  }
}
