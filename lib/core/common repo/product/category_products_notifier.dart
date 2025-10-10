import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/category/ategory_product_state.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

final productRef = FirebaseFirestore.instance.collection('products');

class CategoryProductNotifier extends StateNotifier<CategoryProductState> {
  CategoryProductNotifier(this.category)
    : super(CategoryProductState.initial()) {
    fetchProducts();
  }

  final String category;
  List<ProductModel> _allProducts = [];
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  Future<void> fetchProducts() async {
    if (!hasMore || state.isLoading) return;

    try {
      state = state.copyWith(isLoading: true);

      Query query = productRef
          .where('category', isEqualTo: category)
          .orderBy('name')
          .limit(20);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }

      final querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        lastDoc = querySnapshot.docs.last;
        final products = querySnapshot.docs
            .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        _allProducts.addAll(products);
        state = state.copyWith(isLoading: false, products: _allProducts);
      } else {
        hasMore = false;
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      log("Error fetching products: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void filter({required String query}) {
    if (query.isEmpty) {
      state = state.copyWith(products: _allProducts);
    } else {
      final filteredProducts = _allProducts
          .where(
            (product) =>
                product.name!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
      state = state.copyWith(products: filteredProducts);
    }
  }

  void refresh() {
    _allProducts = [];
    state = state.copyWith(products: [], isLoading: false);
    lastDoc = null;
    hasMore = true;
    fetchProducts();
  }
}

final categoryProductProvider = StateNotifierProvider.autoDispose
    .family<CategoryProductNotifier, CategoryProductState, String>(
      (ref, category) => CategoryProductNotifier(category),
    );
