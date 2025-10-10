import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/widgets/widget_template.dart';

class LaptopAdditionalInformation extends StatelessWidget {
  final ProductModel product;
  const LaptopAdditionalInformation({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Description",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            product.description!,
            style: const TextStyle(
              color: AppColor.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Specifications",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          if (product.screensize != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Screen Size",
              value: product.screensize!,
              isGiveSpaceAtlast: false,
            ),
          if (product.processor != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Processor",
              value: product.processor!,
              isGiveSpaceAtlast: false,
            ),
          if (product.ram != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "RAM",
              value: product.ram!,
              isGiveSpaceAtlast: false,
            ),
          if (product.storage != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Storage",
              value: product.storage!,
              isGiveSpaceAtlast: false,
            ),
          if (product.battery != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Battery",
              value: product.battery!,
              isGiveSpaceAtlast: false,
            ),
          if (product.camera != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Camera",
              value: product.camera!,
              isGiveSpaceAtlast: false,
            ),
          if (product.display != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Display",
              value: product.display!,
              isGiveSpaceAtlast: false,
            ),
          if (product.warranty != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Warranty",
              value: product.warranty!,
              isGiveSpaceAtlast: false,
            ),
          if (product.os != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "OS",
              value: product.os!,
              isGiveSpaceAtlast: false,
            ),
          if (product.weight != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Weight",
              value: product.weight!.toString(),
              isGiveSpaceAtlast: false,
            ),
          if (product.dimension != null)
            WidgetTemplate.productDetailsRowTemplate(
              title: "Dimensions",
              value: product.dimension!,
              isGiveSpaceAtlast: false,
            ),
          const SizedBox(height: 30),
          const Text(
            "Reviews",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
