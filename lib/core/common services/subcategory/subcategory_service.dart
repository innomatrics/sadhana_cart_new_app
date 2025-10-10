import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadhana_cart/core/common%20model/subcategory/subcategory_model.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

class SubcategoryService {
  static const String subcategoryName = "subcategory";

  static final CollectionReference subcategoryRef = FirebaseFirestore.instance
      .collection(subcategoryName);

  static Future<List<SubcategoryModel>> fetchSubcategory() async {
    try {
      final QuerySnapshot querySnapshot = await subcategoryRef.get();
      final List<SubcategoryModel> data = querySnapshot.docs
          .map(
            (e) => SubcategoryModel.fromMap(e.data() as Map<String, dynamic>),
          )
          .toList();
      for (final element in data) {
        await HiveHelper.addSubcategory(subcategory: element);
      }
      return data;
    } catch (e) {
      log("subcategory service error $e");
      return [];
    }
  }

  static Future<List<SubcategoryModel>> fetchSubcategoryByCategoryName({
    required String category,
  }) async {
    try {
      final QuerySnapshot querySnapshot = await subcategoryRef
          .where("category", isEqualTo: category)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs
            .map(
              (e) => SubcategoryModel.fromMap(e.data() as Map<String, dynamic>),
            )
            .toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      log("subcategory service error $e");
      return [];
    }
  }
}
