import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/ui_template/common%20widgets/product_price_rating.dart';
import 'package:sadhana_cart/core/widgets/custom_carousel_slider.dart';
import 'package:sadhana_cart/core/widgets/custom_tile_dropdown.dart';

class PersonalCarePage extends StatelessWidget {
  final ProductModel product;
  const PersonalCarePage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCarouselSlider(product: product),
            ProductPriceRating(product: product),
            CustomTileDropdown(
              title: "Description",
              value: Text(product.description!),
            ),

            // Specifications Section
          ],
        ),
      ),
    );
  }
}
