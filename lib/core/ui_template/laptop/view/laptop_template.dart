import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/ui_template/common%20widgets/product_price_rating.dart';
import 'package:sadhana_cart/core/ui_template/foot_wear/view/laptop_additional_information.dart';
import 'package:sadhana_cart/core/widgets/custom_carousel_slider.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/ui_template/clothing/widget/clothing%20details/rating_tile.dart';

class LaptopTemplate extends StatelessWidget {
  final ProductModel product;
  const LaptopTemplate({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomElevatedButton(
          child: const Text(
            "Add to Cart",
            style: customElevatedButtonTextStyle,
          ),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCarouselSlider(product: product),
            ProductPriceRating(product: product),
            LaptopAdditionalInformation(product: product),
            RatingTile(
              imageUrl: product.images![0],
              name: "This is the placeholder",
              rating: 4.5,
              review: "This is the placeholder",
            ),
          ],
        ),
      ),
    );
  }
}
