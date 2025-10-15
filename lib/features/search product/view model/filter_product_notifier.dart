import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20services/product/product_service.dart';
import 'package:sadhana_cart/features/search%20product/model/product_filter.dart';

final productFilterProvider = StateProvider<ProductFilter>(
  (ref) => ProductFilter(),
);

final filterProductsProvider =
    StateNotifierProvider<
      FilteredProductsNotifier,
      AsyncValue<List<ProductModel>>
    >((ref) => FilteredProductsNotifier());

class FilteredProductsNotifier
    extends StateNotifier<AsyncValue<List<ProductModel>>> {
  FilteredProductsNotifier() : super(const AsyncValue.loading());

  List<ProductModel> _products = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  Future<void> loadProducts(ProductFilter filter, {bool reset = false}) async {
    if (_isLoadingMore) return;

    if (reset) {
      _products = [];
      _lastDocument = null;
      _hasMore = true;
      state = const AsyncValue.loading();
    }
    if (!_hasMore) return;

    _isLoadingMore = true;
    try {
      final result = await ProductService.filterProductsByQuery(
        name: null,
        category: filter.category,
        minPrice: (filter.minPrice ?? 0).toDouble(),
        maxPrice: (filter.maxPrice ?? double.infinity).toDouble(),
        startAfterDoc: _lastDocument,
        limit: 20,
      );

      final fetched = result.products;
      final lastDoc = result.lastDocument;

      if (fetched.length < 20) _hasMore = false;
      if (fetched.isNotEmpty) _lastDocument = lastDoc;

      List<ProductModel> finalList;
      if (filter.name != null && filter.name!.isNotEmpty) {
        final queryLower = filter.name!.toLowerCase();
        finalList = fetched.where((p) {
          return (p.name ?? '').toLowerCase().contains(queryLower);
        }).toList();
      } else {
        finalList = fetched;
      }

      _products = [..._products, ...finalList];
      state = AsyncValue.data([..._products]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
}
