import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20services/product/product_service.dart';

final allProductsProvider =
    StateNotifierProvider<AllProductsNotifier, List<ProductModel>>(
      (ref) => AllProductsNotifier(ref)..initializeProducts(),
    );

class AllProductsNotifier extends StateNotifier<List<ProductModel>> {
  final Ref ref;
  AllProductsNotifier(this.ref) : super([]);

  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  bool _isLoading = false;
  final int _limit = 10;

  late Stream<QuerySnapshot> _productStream;
  late StreamSubscription<QuerySnapshot> _productSubscription;

  void initializeProducts() {
    state = [];
    _lastDocument = null;
    _hasMore = true;
    _isLoading = false;
    _startStream();
  }

  // Start listening to the product stream with pagination
  void _startStream() {
    _productStream = FirebaseFirestore.instance
        .collection(ProductService.products)
        .orderBy("timestamp", descending: true)
        .limit(_limit)
        .snapshots();

    _productSubscription = _productStream.listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        final products = snapshot.docs
            .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();

        final List<ProductModel> updatedList = List.from(state);
        updatedList.addAll(products);
        state = updatedList;

        _lastDocument = snapshot.docs.last;

        if (products.length < _limit) {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }
    });
  }

  Future<void> fetchNextProducts() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    try {
      if (_lastDocument != null) {
        _productStream = FirebaseFirestore.instance
            .collection(ProductService.products)
            .orderBy("timestamp", descending: true)
            .startAfterDocument(_lastDocument!)
            .limit(_limit)
            .snapshots();
      }

      _productSubscription.cancel();
      _productSubscription = _productStream.listen((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          final products = snapshot.docs
              .map(
                (e) => ProductModel.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList();

          final List<ProductModel> updatedList = List.from(state);
          updatedList.addAll(products);
          state = updatedList;

          _lastDocument = snapshot.docs.last;

          if (products.length < _limit) {
            _hasMore = false;
          }
        } else {
          _hasMore = false;
        }
      });
    } catch (e) {
      log("AllProductsNotifier fetch error: $e");
    }

    _isLoading = false;
  }

  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _productSubscription.cancel();
    super.dispose();
  }
}
