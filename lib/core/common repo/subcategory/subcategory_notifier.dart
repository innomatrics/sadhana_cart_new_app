import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/common%20model/subcategory/subcategory_model.dart';
import 'package:sadhana_cart/core/common%20repo/subcategory/subcategory_state.dart';
import 'package:sadhana_cart/core/common%20services/subcategory/subcategory_service.dart';

final subcategoryProvider =
    StateNotifierProvider.autoDispose<SubcategoryNotifier, SubcategoryState>(
      (ref) => SubcategoryNotifier(),
    );

final subcategoryAsync = FutureProvider.autoDispose
    .family<List<SubcategoryModel>, String>((ref, category) async {
      return await SubcategoryService.fetchSubcategoryByCategoryName(
        category: category,
      );
    });

class SubcategoryNotifier extends StateNotifier<SubcategoryState> {
  SubcategoryNotifier() : super(SubcategoryState.initial());

  Future<List<SubcategoryModel>> fetchSubcategoryByCategoryName({
    required String categoryName,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null, subcategory: []);
      final data = await SubcategoryService.fetchSubcategoryByCategoryName(
        category: categoryName,
      );
      state = state.copyWith(isLoading: false, subcategory: data, error: null);
      return data;
    } catch (e) {
      state.copyWith(isLoading: false, error: e.toString(), subcategory: []);
    }
    return [];
  }
}
