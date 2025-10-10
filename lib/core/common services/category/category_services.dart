import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadhana_cart/core/common%20model/category/category_model.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

class CategoryServices {
  static const colletionName = "category";

  static CollectionReference categoryRef = FirebaseFirestore.instance
      .collection(colletionName);

  static Future<List<CategoryModel>> getAllCategory() async {
    try {
      final QuerySnapshot querySnapshot = await categoryRef.get();
      final List<CategoryModel> data = querySnapshot.docs
          .map((e) => CategoryModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      for (final category in data) {
        await HiveHelper.addCategories(category: category);
      }
      return data;
    } catch (e) {
      log("category service error $e");
      return [];
    }
  }
}
