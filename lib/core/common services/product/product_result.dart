import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class FilteredProductResult {
  final List<ProductModel> products;
  final DocumentSnapshot? lastDocument;

  FilteredProductResult(this.products, this.lastDocument);
}
