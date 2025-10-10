import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/ui_template/common%20widgets/product_price_rating.dart';
import 'package:sadhana_cart/core/widgets/custom_carousel_slider.dart';

class MobileTemplate extends StatelessWidget {
  final ProductModel product;
  const MobileTemplate({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCarouselSlider(product: product),
            ProductPriceRating(product: product),
          ],
        ),
      ),
    );
  }
}
