import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';

final loadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final productDataProvider = FutureProvider.family
    .autoDispose<ProductModel, String>((ref, id) async {
      ref.read(loadingProvider.notifier).state = true;
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("products")
          .where("id", isEqualTo: id)
          .get();
      final data = querySnapshot.docs
          .map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>))
          .toList()
          .first;
      ref.read(loadingProvider.notifier).state = false;
      return data;
    });
final genderProvider = StateProvider.autoDispose<String?>((ref) => null);

final profileImageProvider = StateProvider.autoDispose<File?>((ref) => null);

final passEyeProvider = StateProvider.autoDispose<bool>((ref) => true);
final confirmPassEyeProvider = StateProvider.autoDispose<bool>((ref) => true);

final userAdderssIconProvider = StateProvider.autoDispose<IconData>(
  (ref) => Icons.home,
);
final userAddressTitleProvider = StateProvider.autoDispose<String>(
  (ref) => "Home",
);

final addressDeleteLoader = StateProvider.autoDispose<bool>((ref) => false);

final showNotificationProvider = StateProvider<bool>((ref) => false);

final showLockedScreennotificationProvider = StateProvider<bool>(
  (ref) => false,
);

final addressRadioButtonProvider = StateProvider<int>((ref) => 0);

final addressFillingProvider = StateProvider<bool>((ref) => false);

//order page index

final orderStepperPageProvider = StateProvider<int>((ref) => 0);

final orderAcceptTerms = StateProvider<bool>((ref) => false);

final orderStatusIndexProvider = StateProvider<int>((ref) => 0);

//clothing details
//used autodispose because so many product using same provider so it will be disposed
//if i didn't dispose it properly.. when you click adding to cart for another product it will use the data of previous product
final clothingSizeProvider = StateProvider.autoDispose<int>((ref) => 0);

final clothingColorProvider = StateProvider<int>((ref) => 0);

final clothingIndexProvider = StateProvider<int>((ref) => 0);

final carouselController = StateProvider.autoDispose<int>((ref) => 0);

//cart loading disposer provider

final cartLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

final selectedSizeVariant = StateProvider.autoDispose<SizeVariant?>(
  (ref) => null,
);

//favorite laoding disposer provider

final favoriteLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);

//filter

final filterCategoryProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final filterSubcategoryProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final filterPanelProvider = StateProvider.autoDispose<bool>((ref) => false);

final isFilterAppliedProvider = StateProvider<bool>((ref) => false);
