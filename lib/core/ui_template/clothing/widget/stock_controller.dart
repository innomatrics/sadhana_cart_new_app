import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';

class StockController {
  static void checkStockAndProceed({
    required BuildContext context,
    required WidgetRef ref,
    required ProductModel product,
    required void Function(ProductModel, int, String) onStockAvailable,
  }) {
    final selectedSizeIndex = ref.read(clothingSizeProvider);
    final selectedSize = product.sizevariants?[selectedSizeIndex];

    if (selectedSize == null || (selectedSize.stock) <= 0) {
      log("Stock not available for size: ${selectedSize?.size ?? 'Unknown'}");
      showCustomSnackbar(
        context: context,
        message: "Stock not available for selected size",
        type: ToastType.error,
      );
      return;
    }

    log(
      "Stock available (${selectedSize.stock}) for size: ${selectedSize.size}, proceeding",
    );

    onStockAvailable(product, selectedSizeIndex, selectedSize.size);
  }
}
