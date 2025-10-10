import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class ProductWithDoc {
  final ProductModel product;
  final DocumentSnapshot document;

  ProductWithDoc({required this.product, required this.document});
}
