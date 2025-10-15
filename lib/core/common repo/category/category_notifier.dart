import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/common%20model/category/category_model.dart';
import 'package:sadhana_cart/core/common%20services/category/category_services.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

final categoryProvider =
    StateNotifierProvider<CategoryNotifier, List<CategoryModel>>(
      (ref) => CategoryNotifier(ref)..initializeCategory(),
    );
final categoryAsync = FutureProvider<List<CategoryModel>>((ref) async {
  return await CategoryServices.getAllCategory();
});

class CategoryNotifier extends StateNotifier<List<CategoryModel>> {
  final Ref ref;
  CategoryNotifier(this.ref) : super([]);

  void initializeCategory() async {
    // final isInternet = await ConnectionHelper.checkInternetConnection();
    // if (!isInternet) {

    // }
    state = HiveHelper.getCategoryModel();
  }
}
