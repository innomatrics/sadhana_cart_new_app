import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sadhana_cart/core/helper/avoid_null_values.dart';
import 'package:sadhana_cart/features/rating/model/rating_model.dart';

class RatingService {
  static const String rating = "rating";
  static final CollectionReference ratingRef = FirebaseFirestore.instance
      .collection(rating);

  static final CollectionReference productRef = FirebaseFirestore.instance
      .collection("products");
  static final CollectionReference userRef = FirebaseFirestore.instance
      .collection("users");

  static final currentUser = FirebaseAuth.instance.currentUser!.uid;

  static Future<bool> addRating({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      final String currentUser = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentUser.isEmpty) {
        log("User is not logged in");
        return false;
      }

      final docRef = ratingRef.doc();
      final userDoc = await userRef.doc(currentUser).get();

      final userName = userDoc.get("name");

      if (!userDoc.exists) {
        log("User document not found for userId: $currentUser");
        return false;
      }

      final String imageUrl = userDoc.get("profileImage");
      if (imageUrl.isEmpty) {
        log("Profile image is missing for userId: $currentUser");
        return false;
      }

      final ratingModel = RatingModel(
        ratingId: docRef.id,
        userId: currentUser,
        userName: userName,
        image: imageUrl,
        productid: productId,
        rating: rating,
        comment: comment,
        createdAt: Timestamp.now(),
      );

      await docRef.set(ratingModel.toMap());
      return true;
    } catch (e) {
      log("rating service error $e");
      return false;
    }
  }

  static Future<List<RatingModel>> fetchRating({
    required String productId,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await ratingRef
          .where("productid", isEqualTo: productId)
          .get();
      return querySnapshot.docs
          .map((e) => RatingModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log("rating service error $e");
      return [];
    }
  }

  static Future<bool> deleteUserOwnRating({
    required String productId,
    required String ratingId,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await ratingRef
          .where("productid", isEqualTo: productId)
          .where("ratingId", isEqualTo: ratingId)
          .where("userId", isEqualTo: currentUser)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        return true;
      }
      return false;
    } catch (e) {
      log("rating service error $e");
      return false;
    }
  }

  static Future<bool> updateOwnRating({
    required String productId,
    required double rating,
    required String comment,
    required String ratingId,
  }) async {
    try {
      final String currentUser = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentUser.isEmpty) {
        log("User is not logged in");
        return false;
      }
      final userDoc = await userRef.doc(currentUser).get();

      final userName = userDoc.get("name");

      if (!userDoc.exists) {
        log("User document not found for userId: $currentUser");
        return false;
      }

      final String imageUrl = userDoc.get("profileImage");
      if (imageUrl.isEmpty) {
        log("Profile image is missing for userId: $currentUser");
        return false;
      }
      final QuerySnapshot querySnapshot = await ratingRef
          .where("productid", isEqualTo: productId)
          .where("ratingId", isEqualTo: ratingId)
          .where("userId", isEqualTo: currentUser)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final RatingModel ratingModel = RatingModel(
          ratingId: querySnapshot.docs.first.id,
          userId: currentUser,
          userName: userName,
          image: imageUrl,
          productid: productId,
          rating: rating,
          comment: comment,
          createdAt: Timestamp.now(),
        );

        final Map<String, dynamic> newdata =
            AvoidNullValues.removeNullValuesDeep(ratingModel.toMap());

        await querySnapshot.docs.first.reference.update(newdata);
        return true;
      }
      return false;
    } catch (e) {
      log("rating service error $e");
      return false;
    }
  }

  static Future<double> getAverageRating({required String productId}) async {
    try {
      final querySnapshot = await ratingRef
          .where("productid", isEqualTo: productId)
          .get();

      final docs = querySnapshot.docs;

      if (docs.isEmpty) return 0.0;

      double totalRating = 0;

      for (final doc in docs) {
        final data = doc.data() as Map<String, dynamic>;
        final double rating = (data['rating'] ?? 0).toDouble();
        totalRating += rating;
      }

      final double avgRating = totalRating / docs.length;
      return double.parse(avgRating.toStringAsFixed(1));
    } catch (e) {
      log("getAverageRating error: $e");
      return 0.0;
    }
  }
}
