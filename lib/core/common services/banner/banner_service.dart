import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sadhana_cart/core/common%20model/banner/banner_model.dart';
import 'package:sadhana_cart/core/helper/hive_helper.dart';

class BannerService {
  static const String posterCollection = "posters";
  static final bannerRef = FirebaseFirestore.instance.collection(
    posterCollection,
  );
  static Future<List<BannerModel>> fetchBanners() async {
    try {
      final QuerySnapshot querySnapshot = await bannerRef.get();
      final data = querySnapshot.docs
          .map((e) => BannerModel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      for (final banners in data) {
        await HiveHelper.addBanners(banner: banners);
      }

      return data;
    } catch (e) {
      log("banner service error $e");
      return [];
    }
  }
}
