import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/brand/brand_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20repo/product/product_notifier.dart';
import 'package:sadhana_cart/core/common%20services/brand/brand_service.dart';
import 'package:sadhana_cart/core/helper/connection_helper.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

final brandProvider = StateNotifierProvider<BrandNotifier, List<BrandModel>>(
  (ref) => BrandNotifier(ref)..initialize(),
);

class BrandNotifier extends StateNotifier<List<BrandModel>> {
  final Ref ref;
  BrandNotifier(this.ref) : super([]);

  void initialize() async {
    final bool isInternet = await ConnectionHelper.checkInternetConnection();
    if (isInternet) {
      state = await BrandService.fetchBrands();
    } else {
      state = HiveHelper.getBrands();
    }
  }

  List<ProductModel> getBrandProduct() {
    final product = ref.watch(productProvider);
    for (final brand in state) {
      return product.where((e) => e.brand == brand.name).toList();
    }
    return [];
  }
}
