import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/favorite/favorite_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20repo/favorite/fav_model_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/favorite/favorite_notifier.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

class FavoriteService {
  static const String favorites = 'favorites';
  static const String user = 'users';
  static const String product = 'products';
  static final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  static final CollectionReference favoriteRef = FirebaseFirestore.instance
      .collection(user)
      .doc(currentUserId)
      .collection(favorites);
  static final CollectionReference productRef = FirebaseFirestore.instance
      .collection(product);

  //add
  static Future<bool> addToFavorite({
    required ProductModel product,
    required WidgetRef ref,
  }) async {
    try {
      final docRef = favoriteRef.doc();
      final favoriteModel = FavoriteModel(
        favoriteId: docRef.id,
        productid: product.productid!,
        customerId: currentUserId,
      );
      await favoriteRef.doc(docRef.id).set(favoriteModel.toMap());
      // await HiveHelper.addFavorites(favorite: favoriteModel);
      //updated notifier
      ref.read(favoriteProvider.notifier).addToFavorite(product: product);
      ref
          .read(favoriteModelProvider.notifier)
          .addToFavorite(favorite: favoriteModel);
      return true;
    } catch (e) {
      log("Error adding favorite: $e");
      return false;
    }
  }

  //get

  static Future<Set<FavoriteModel>> fetchFavorites() async {
    try {
      final QuerySnapshot querySnapshot = await favoriteRef.get();
      final data = querySnapshot.docs
          .map((e) => FavoriteModel.fromMap(e.data() as Map<String, dynamic>))
          .toSet();
      //store in local

      for (final favorite in data) {
        await HiveHelper.addFavorites(favorite: favorite);
      }
      log("favorite data $data");
      return data;
    } catch (e) {
      log("favorite service error $e");
      return {};
    }
  }

  static Future<bool> deleteFavorite({
    required String favoriteId,
    required WidgetRef ref,
    required ProductModel product,
  }) async {
    try {
      await favoriteRef.doc(favoriteId).delete();
      await HiveHelper.deleteFavorite(key: favoriteId);
      ref.read(favoriteProvider.notifier).removeFromFavorite(product: product);
      ref
          .read(favoriteModelProvider.notifier)
          .removeFromFavorite(favoriteId: favoriteId);
      return true;
    } catch (e) {
      log("Error deleting favorite: $e");
      return false;
    }
  }

  static Future<Set<ProductModel>> fetchUserFavoriteProducts() async {
    try {
      final List<ProductModel> favData = [];

      final QuerySnapshot favSnapshot = await FirebaseFirestore.instance
          .collection(user)
          .doc(currentUserId)
          .collection(favorites)
          .get();

      final List<String> productIds = favSnapshot.docs
          .map((doc) => doc["productid"] as String)
          .toList();

      final List<Future<QuerySnapshot>> futures = productIds.map((productId) {
        return productRef.where("productid", isEqualTo: productId).get();
      }).toList();

      final List<QuerySnapshot> results = await Future.wait(futures);

      for (final snapshot in results) {
        if (snapshot.docs.isNotEmpty) {
          final products = snapshot.docs.map(
            (doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>),
          );
          favData.addAll(products);
        }
      }

      return favData.toSet();
    } catch (e) {
      log("favorite service error: $e");
      return {};
    }
  }
}
