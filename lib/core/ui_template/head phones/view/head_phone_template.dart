import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/ui_template/common%20widgets/product_price_rating.dart';
import 'package:sadhana_cart/core/ui_template/head%20phones/widgets/product_detail_row.dart';
import 'package:sadhana_cart/core/widgets/custom_carousel_slider.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_tile_dropdown.dart';

class HeadPhoneTemplate extends StatefulWidget {
  final ProductModel product;
  const HeadPhoneTemplate({super.key, required this.product});

  @override
  State<HeadPhoneTemplate> createState() => _HeadPhoneTemplateState();
}

class _HeadPhoneTemplateState extends State<HeadPhoneTemplate> {
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
            CustomCarouselSlider(product: widget.product),
            ProductPriceRating(product: widget.product),

            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 16, top: 16),
                    child: Text(
                      "Product Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(),
                  CustomTileDropdown(
                    title: "Description",
                    value: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.product.description!,
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ),
                  const Divider(),
                  const CustomTileDropdown(
                    title: "Overview",
                    value: Column(
                      children: [
                        ProductDetailRow(title: "Brand", value: "HP"),
                        ProductDetailRow(title: "Model", value: "H200"),
                        ProductDetailRow(title: "Type", value: "On-Ear"),
                        ProductDetailRow(title: "Color", value: "Black"),
                      ],
                    ),
                  ),
                  const Divider(),
                  const CustomTileDropdown(
                    title: "Features",
                    value: Column(
                      children: [
                        ProductDetailRow(
                          title: "Connectivity",
                          value: "Wireless Bluetooth 5.0",
                        ),
                        ProductDetailRow(
                          title: "Noise Cancellation",
                          value: "Active",
                        ),
                        ProductDetailRow(
                          title: "Microphone",
                          value: "Built-in",
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const CustomTileDropdown(
                    title: "Specs",
                    value: Column(
                      children: [
                        ProductDetailRow(
                          title: "Battery Life",
                          value: "15 Hours",
                        ),
                        ProductDetailRow(title: "Weight", value: "250g"),
                        ProductDetailRow(title: "Driver Size", value: "40mm"),
                        ProductDetailRow(
                          title: "Frequency Response",
                          value: "20Hz – 20kHz",
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  const CustomTileDropdown(
                    title: "Extras",
                    value: Column(
                      children: [
                        ProductDetailRow(title: "Warranty", value: "1 Year"),
                        ProductDetailRow(
                          title: "In the Box",
                          value: "Headphone, Charging Cable, User Manual",
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
