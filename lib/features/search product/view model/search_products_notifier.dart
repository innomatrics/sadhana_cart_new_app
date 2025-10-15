import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

final searchProductsProvider = StateNotifierProvider.autoDispose
    .family<SearchProductsNotifier, AsyncValue<List<ProductModel>>, String>((
      ref,
      keyword,
    ) {
      return SearchProductsNotifier(keyword);
    });

class SearchProductsNotifier
    extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final String keyword;
  final int limit = 30;

  bool hasMore = true;
  bool isLoadingMore = false;
  DocumentSnapshot? lastDoc;

  SearchProductsNotifier(this.keyword) : super(const AsyncValue.loading()) {
    if (keyword.isNotEmpty) {
      _loadInitial();
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> _loadInitial() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("products")
          .where("searchkeywords", arrayContains: keyword.toLowerCase())
          .limit(limit)
          .get();

      if (snapshot.docs.isNotEmpty) {
        lastDoc = snapshot.docs.last;
      }

      hasMore = snapshot.docs.length == limit;

      final products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();

      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!hasMore || isLoadingMore) return;

    isLoadingMore = true;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("products")
          .where("searchkeywords", arrayContains: keyword.toLowerCase())
          .startAfterDocument(lastDoc!)
          .limit(limit)
          .get();

      if (snapshot.docs.isNotEmpty) {
        lastDoc = snapshot.docs.last;
      }

      if (snapshot.docs.length < limit) {
        hasMore = false;
      }

      final newProducts = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();

      state.whenData((oldProducts) {
        state = AsyncValue.data([...oldProducts, ...newProducts]);
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }

    isLoadingMore = false;
  }
}
