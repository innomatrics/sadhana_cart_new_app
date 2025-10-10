import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_fetch_result.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/common%20services/product/product_result.dart';
import 'package:sadhana_cart/core/common%20services/product/product_with_doc.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/features/rating/service/rating_service.dart';

class ProductService {
  static const String products = "products";
  static final CollectionReference productRef = FirebaseFirestore.instance
      .collection(products);

  static final FirebaseStorage storage = FirebaseStorage.instance;
  static Future<ProductFetchResult> fetchProductByPagination({
    required Ref ref,
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      ref.read(loadingProvider.notifier).state = true;

      Query query = productRef
          .orderBy("productid", descending: true)
          .limit(limit);
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final querySnapshot = await query.get();

      final data = querySnapshot.docs
          .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      ref.read(loadingProvider.notifier).state = false;

      return ProductFetchResult(
        products: data,
        lastDocument: querySnapshot.docs.isNotEmpty
            ? querySnapshot.docs.last
            : null,
      );
    } catch (e) {
      log("ProductService fetch error: $e");
      ref.read(loadingProvider.notifier).state = false;
      return ProductFetchResult(products: [], lastDocument: null);
    }
  }

  static Future<List<ProductModel>> fetchProducts() async {
    try {
      final QuerySnapshot querySnapshot = await productRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs
            .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        return data;
      }
      return [];
    } catch (e) {
      log("ProductService fetch error: $e");
      return [];
    }
  }

  static Future<List<ProductModel>> getProductsByCategory({
    required String category,
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    try {
      Query query = productRef
          .where("category", isEqualTo: category)
          .orderBy("productid", descending: true)
          .limit(limit);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      final QuerySnapshot querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs
            .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        return data;
      }
    } catch (e) {
      log("ProductService fetch error: $e");
      return [];
    }
    return [];
  }

  static Future<List<ProductModel>> getProductsBySubcategory({
    required String subcategory,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await productRef
          .where("subcategory", isEqualTo: subcategory)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs
            .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        return data;
      }
    } catch (e) {
      log("ProductService fetch error: $e");
      return [];
    }
    return [];
  }

  static Future<List<ProductModel>> getProductByBrands({
    required String brand,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await productRef
          .where("brand", isEqualTo: brand)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs
            .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        return data;
      }
    } catch (e) {
      log("ProductService fetch error: $e");
      return [];
    }
    return [];
  }

  //pagination
  static Stream<List<ProductModel>> getFeatureProducts() {
    try {
      return productRef
          .where("category", isEqualTo: "Kids")
          .limit(10)
          .snapshots()
          .map((querySnapshot) {
            if (querySnapshot.docs.isNotEmpty) {
              return querySnapshot.docs.map((e) {
                final map = e.data() as Map<String, dynamic>;
                final product = ProductModel.fromMap(map);

                return product;
              }).toList();
            } else {
              return [];
            }
          });
    } catch (e) {
      log("feature products stream error: $e");
      return Stream.value([]);
    }
  }

  // Recommanded products (Based on the category)
  static Stream<List<ProductModel>> getTopRatingProducts({int limit = 6}) {
    try {
      return productRef
          .orderBy("productid", descending: true)
          .limit(limit)
          .snapshots()
          .map((snap) {
            if (snap.docs.isNotEmpty) {
              return snap.docs
                  .map(
                    (e) =>
                        ProductModel.fromMap(e.data() as Map<String, dynamic>),
                  )
                  .toList();
            }
            return [];
          });
    } catch (e) {
      log("ProductService getTopRatedProducts error: $e");
      return Stream.value([]);
    }
  }

  static Future<List<ProductModel>> getProductByQuery({
    required String query,
  }) async {
    try {
      log("Search started for query: '$query'");

      final trimmedQuery = query.trim().toLowerCase();
      if (trimmedQuery.isEmpty) {
        log("Query is empty after trimming. Returning empty list.");
        return [];
      }

      // Fetch all products
      final allDocs = await productRef.get();
      final allProducts = allDocs.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap(data);
      }).toList();

      // log("Total products fetched: ${allProducts.length}");

      // Filter locally for match (case-insensitive)
      final filteredProducts = allProducts.where((product) {
        final name = product.name?.toLowerCase() ?? "";
        return name.contains(trimmedQuery);
      }).toList();

      // Log only matched products
      if (filteredProducts.isEmpty) {
        log("No products matched query '$query'");
      } else {
        for (var p in filteredProducts) {
          log("Matched product: ${p.name}");
        }
      }

      return filteredProducts;
    } catch (e, stackTrace) {
      log("ProductService fetch error: $e", stackTrace: stackTrace);
      return [];
    }
  }

  static Future<List<ProductModel>> getProductsByMoneyFilter({
    int? min,
    int? max,
    double? rating,
  }) async {
    try {
      log("Starting product filter: min=$min, max=$max, rating=$rating");

      Query query = productRef;

      if (min != null) {
        query = query.where("price", isGreaterThanOrEqualTo: min);
        log("Applying min price filter: $min");
      }

      if (max != null) {
        query = query.where("price", isLessThanOrEqualTo: max);
        log("Applying max price filter: $max");
      }

      final querySnapshot = await query.get();
      log("Products fetched from Firestore: ${querySnapshot.docs.length}");

      var products = querySnapshot.docs
          .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      List<ProductModel> matchedProducts = [];

      if (rating != null) {
        log("Filtering by rating: $rating");

        // Process all ratings concurrently
        final futures = products.map((product) async {
          final avgRating = await RatingService.getAverageRating(
            productId: product.productid!,
          );

          if (avgRating >= rating && avgRating < rating + 1) {
            log(
              " Matched product: ${product.name} | Price: ${product.price} | AvgRating: $avgRating",
            );
            return product;
          } else {
            return null;
          }
        }).toList();

        final results = await Future.wait(futures);
        matchedProducts = results.whereType<ProductModel>().toList();
      } else {
        log("ℹ No rating filter applied, all products matched");
        matchedProducts = products;
      }

      log("Total matched products: ${matchedProducts.length}");
      return matchedProducts;
    } catch (e, stackTrace) {
      log(" ProductService fetch error: $e", stackTrace: stackTrace);
      return [];
    }
  }

  static Future<bool> decreaseStockForProducts(
    List<OrderProductModel> orderedProducts,
  ) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (final orderProduct in orderedProducts) {
        final productQuerySnapshot = await productRef
            .where('productid', isEqualTo: orderProduct.productid)
            .limit(1)
            .get();

        if (productQuerySnapshot.docs.isEmpty) {
          log("Product not found: ${orderProduct.productid}");
          continue;
        }

        final productDoc = productQuerySnapshot.docs.first;
        final productData = ProductModel.fromMap(
          productDoc.data() as Map<String, dynamic>,
        );

        final currentStock = productData.stock ?? 0;
        final newStock = currentStock - orderProduct.quantity!;

        if (newStock < 0) {
          log("Not enough stock for ${orderProduct.name}");
          continue;
        }

        // Correctly update size variants and convert to Map
        final updatedSizeVariants = productData.sizevariants!.map((variant) {
          final match = orderProduct.sizevariants?.firstWhere(
            (v) => v.size == variant.size,
            orElse: () =>
                SizeVariant(size: "", stock: 0, color: '', skuSuffix: ''),
          );

          if (match?.size.isNotEmpty ?? false) {
            final updatedStock = (variant.stock - match!.stock).clamp(
              0,
              variant.stock,
            );
            return SizeVariant(
              size: variant.size,
              stock: updatedStock,
              color: variant.color,
              skuSuffix: variant.skuSuffix,
            ).toMap();
          }

          return variant.toMap();
        }).toList();

        batch.update(productDoc.reference, {
          'stock': newStock,
          'sizevariants': updatedSizeVariants,
        });

        log("Stock updated for ${orderProduct.name}");
      }

      await batch.commit();
      return true;
    } catch (e, st) {
      log("Error updating stock: $e");
      log(st.toString());
      return false;
    }
  }

  static Future<FilteredProductResult> filterProductsByQuery({
    String? name,
    String? category,
    double? minPrice,
    double? maxPrice,
    DocumentSnapshot? startAfterDoc,
    int limit = 20,
  }) async {
    Query query = FirebaseFirestore.instance.collection('products');

    if (name != null && name.isNotEmpty) {
      query = query
          .where('name_lower', isGreaterThanOrEqualTo: name.toLowerCase())
          .where('name_lower', isLessThanOrEqualTo: '$name\uf8ff');
    }

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    if (minPrice != null) {
      query = query.where('offerprice', isGreaterThanOrEqualTo: minPrice);
    }
    if (maxPrice != null) {
      query = query.where('offerprice', isLessThanOrEqualTo: maxPrice);
    }

    query = query.orderBy('offerprice');

    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }

    query = query.limit(limit);

    final snapshot = await query.get();
    log('Fetched ${snapshot.docs.length} products for query: $name');

    final products = snapshot.docs.map((doc) {
      return ProductModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    final lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return FilteredProductResult(products, lastDocument);
  }

  static Future<List<ProductWithDoc>> getProductByQueryForSearch({
    required String search,
    DocumentSnapshot? startAfterDoc,
    int limit = 20,
  }) async {
    try {
      Query query = productRef;

      if (search.isNotEmpty) {
        query = query.where("name_lower", isEqualTo: search.toLowerCase());
      }

      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }

      query = query.limit(limit);

      final QuerySnapshot querySnapshot = await query.get();

      final List<ProductWithDoc> productsWithDocs = querySnapshot.docs.map((
        doc,
      ) {
        final product = ProductModel.fromMap(
          doc.data() as Map<String, dynamic>,
        );
        return ProductWithDoc(product: product, document: doc);
      }).toList();

      return productsWithDocs;
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<ProductModel> getProductThroughId({
    required String productId,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await productRef
          .where("productid", isEqualTo: productId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return ProductModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
        );
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }
}
