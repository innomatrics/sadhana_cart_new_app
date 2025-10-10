import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/ui_template/common%20widgets/product_price_rating.dart';
import 'package:sadhana_cart/core/ui_template/head%20phones/widgets/product_detail_row.dart';
import 'package:sadhana_cart/core/widgets/custom_carousel_slider.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_tile_dropdown.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Spec Sction
  Widget buildSpecsSection() {
    final hasSpecs =
        widget.product.ram != null ||
        widget.product.storage != null ||
        widget.product.battery != null ||
        widget.product.camera != null ||
        widget.product.processor != null ||
        widget.product.display != null ||
        widget.product.os != null;

    if (!hasSpecs) return const SizedBox.shrink();

    return Column(
      children: [
        CustomTileDropdown(
          title: "Specifications",
          value: Column(
            children: [
              if (widget.product.ram != null)
                ProductDetailRow(title: "RAM", value: widget.product.ram!),
              if (widget.product.storage != null)
                ProductDetailRow(
                  title: "Storage",
                  value: widget.product.storage!,
                ),
              if (widget.product.battery != null)
                ProductDetailRow(
                  title: "Battery",
                  value: widget.product.battery!,
                ),
              if (widget.product.camera != null)
                ProductDetailRow(
                  title: "Camera",
                  value: widget.product.camera!,
                ),
              if (widget.product.processor != null)
                ProductDetailRow(
                  title: "Processor",
                  value: widget.product.processor!,
                ),
              if (widget.product.display != null)
                ProductDetailRow(
                  title: "Display",
                  value: widget.product.display!,
                ),
              if (widget.product.os != null)
                ProductDetailRow(title: "OS", value: widget.product.os!),
            ],
          ),
        ),
        Divider(color: Colors.grey[200]),
      ],
    );
  }

  // Extras Section
  Widget buildExtrasSection() {
    // Check if there is any extra data
    final hasExtras =
        widget.product.warranty != null ||
        widget.product.sizevariants!.isNotEmpty;

    if (!hasExtras) return const SizedBox.shrink();

    return Column(
      children: [
        CustomTileDropdown(
          title: "Extras",
          value: Column(
            children: [
              if (widget.product.warranty != null)
                ProductDetailRow(
                  title: "Warranty",
                  value: widget.product.warranty!,
                ),
              if (widget.product.sizevariants!.isNotEmpty)
                ProductDetailRow(
                  title: "Variants",
                  value: widget.product.sizevariants!.join(", "),
                ),
            ],
          ),
        ),
        Divider(color: Colors.grey[200]),
      ],
    );
  }

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
          onPressed: () {
            //  Add buy functionality
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Images
            CustomCarouselSlider(product: widget.product),

            // Price & Rating Section
            ProductPriceRating(product: widget.product),

            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey[200]),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16, top: 16),
                    child: Text(
                      "Product Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(color: Colors.grey[200]),

                  // Description Section
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
                  Divider(color: Colors.grey[200]),

                  // Overview Section
                  // CustomTileDropdown(
                  //   title: "Overview",
                  //   value: Column(
                  //     children: [
                  //       ProductDetailRow(
                  //         title: "Brand",
                  //         value: widget.product.brand!,
                  //       ),

                  //       ProductDetailRow(
                  //         title: "Model",
                  //         value: widget.product.baseSku!,
                  //       ),
                  //       ProductDetailRow(
                  //         title: "Category",
                  //         value: widget.product.category!,
                  //       ),
                  //       ProductDetailRow(
                  //         title: "Subcategory",
                  //         value: widget.product.subcategory!,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Divider(color: Colors.grey[200]),

                  // Specs Section (conditionally visible)
                  buildSpecsSection(),

                  buildExtrasSection(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
