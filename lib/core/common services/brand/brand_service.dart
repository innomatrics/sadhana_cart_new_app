import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadhana_cart/core/common%20model/brand/brand_model.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

class BrandService {
  static const String brand = "brand";

  static final CollectionReference brandRef = FirebaseFirestore.instance
      .collection(brand);

  static Future<List<BrandModel>> fetchBrands() async {
    try {
      final QuerySnapshot querySnapshot = await brandRef.get();
      final data = querySnapshot.docs
          .map((e) => BrandModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();

      //store in local storage
      for (final brand in data) {
        await HiveHelper.addBrand(brand: brand);
      }
      return data;
    } catch (e) {
      log("brand service error $e");
      return [];
    }
  }
}
