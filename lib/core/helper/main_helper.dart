import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sadhana_cart/core/common%20model/banner/banner_model.dart';
import 'package:sadhana_cart/core/common%20model/brand/brand_model.dart';
import 'package:sadhana_cart/core/common%20model/category/category_model.dart';
import 'package:sadhana_cart/core/common%20model/favorite/favorite_model.dart';
import 'package:sadhana_cart/core/common%20model/notification/notification_model.dart';
import 'package:sadhana_cart/core/common%20model/search%20field/search_field_model.dart';
import 'package:sadhana_cart/core/common%20model/subcategory/subcategory_model.dart';
import 'package:sadhana_cart/firebase_options.dart';

class MainHelper {
  static const String bannerBox = 'bannerBox';
  static const String cateogoryBox = 'categoryBox';
  static const String searchBox = 'searchBox';
  static const String subcategoryBox = 'subcategoryBox';
  static const String favoriteBox = 'favoriteBox';
  static const String cartBox = 'cartBox';
  static const String brandBox = 'brandBox';
  static const String walletBox = 'walletBox';
  static const String notificationBox = 'notificationBox';
  static const String localBox = "localDataBox";
  //inits
  static Future<void> inits() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize Firebase
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, stackTrace) {
      log(" Firebase init failed: $e");
      log(" Stack trace: $stackTrace");
    }
    //initialize hive
    await Hive.initFlutter();

    //register adapters
    Hive.registerAdapter<BannerModel>(BannerModelAdapter());
    Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
    Hive.registerAdapter<SearchFieldModel>(SearchFieldModelAdapter());
    Hive.registerAdapter<SubcategoryModel>(SubcategoryModelAdapter());
    Hive.registerAdapter<FavoriteModel>(FavoriteModelAdapter());
    Hive.registerAdapter<BrandModel>(BrandModelAdapter());
    // notifications
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter<NotificationModel>(NotificationModelAdapter());
    //open boxes
    await Hive.openBox<BannerModel>(bannerBox);
    await Hive.openBox<CategoryModel>(cateogoryBox);
    await Hive.openBox<SearchFieldModel>(searchBox);
    await Hive.openBox<SubcategoryModel>(subcategoryBox);
    await Hive.openBox<FavoriteModel>(favoriteBox);
    await Hive.openBox<BrandModel>(brandBox);
    await Hive.openBox<NotificationModel>(notificationBox);
    await Hive.openBox(localBox);
  }
}
