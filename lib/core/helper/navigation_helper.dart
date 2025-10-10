import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/constants/category_constants.dart';
import 'package:sadhana_cart/core/ui_template/accessories/view/accessories_screen.dart';
import 'package:sadhana_cart/core/ui_template/clothing/view/clothing_products_details.dart';
import 'package:sadhana_cart/core/ui_template/other_product/view/other_product_details.dart';

void navigateTo({required BuildContext context, required Widget screen}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void navigateBack({required BuildContext context}) {
  Navigator.pop(context);
}

void navigateToReplacement({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void navigateWithRoute({
  required BuildContext context,
  required String screenPath,
}) {
  Navigator.pushNamed(context, screenPath);
}

void navigateToProductDesignBasedOnCategory({
  required BuildContext context,
  required String categoryName,
  required ProductModel product,
}) {
  final clothingList = CategoryConstants.clothingKeywords;

  final List<String> clothData = [];

  for (var cloth in clothingList) {
    final data = cloth.trim().replaceAll(' ', '');
    clothData.add(data);
  }

  final isClothing = clothData.any(
    (clothing) => categoryName.toLowerCase().contains(clothing.toLowerCase()),
  );

  final accessoryList = CategoryConstants.accessoriesKeywords;

  final isAccessories = accessoryList.any(
    (e) => categoryName.toLowerCase().contains(e.toLowerCase()),
  );

  if (isClothing) {
    navigateTo(
      context: context,
      screen: ClothingProductsDetails(product: product),
    );
  } else if (isAccessories) {
    navigateTo(
      context: context,
      screen: AccessoriesScreen(product: product),
    );
  } else {
    navigateTo(
      context: context,
      screen: OtherProductDetails(product: product),
    );
  }
}
