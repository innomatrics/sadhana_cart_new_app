import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class ProductFetchResult {
  final List<ProductModel> products;
  final DocumentSnapshot? lastDocument;

  ProductFetchResult({required this.products, this.lastDocument});
}
