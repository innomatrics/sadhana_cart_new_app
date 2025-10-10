import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/colors/app_color_enum.dart';
import 'package:sadhana_cart/core/common model/product/product_model.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/ui_template/common%20widgets/product_price_rating.dart';
import 'package:sadhana_cart/core/ui_template/foot_wear/view%20model/footwear_notifier.dart';
import 'package:sadhana_cart/core/widgets/custom_divider.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/widget_template.dart';

class FootWearDetails extends StatelessWidget {
  final ProductModel product;
  const FootWearDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductPriceRating(product: product),
            const CustomDivider(),
            const SizedBox(height: 10),

            /// Colors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Color :",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Consumer(
                    builder: (context, ref, child) {
                      final selecIndex = ref.watch(footwearColorSelection);
                      return Expanded(
                        child: Wrap(
                          children: List.generate(
                            product.sizevariants!.length,
                            (index) {
                              final isSelected = index == selecIndex;
                              final colorName =
                                  product.sizevariants![index].color;
                              final color = getColorFromDatabase(colorName!);
                              final isWhite = color == AppColors.white.color;

                              return GestureDetector(
                                onTap: () =>
                                    ref
                                            .read(
                                              footwearColorSelection.notifier,
                                            )
                                            .state =
                                        index,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: isSelected
                                        ? Border.all(
                                            color: AppColor.primaryColor,
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      border: isWhite
                                          ? Border.all(color: Colors.grey)
                                          : null,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const CustomDivider(),
            const SizedBox(height: 20),

            /// Sizes
            Consumer(
              builder: (context, ref, child) {
                final selectSize = ref.watch(footWearSizeSelection);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        "Size :",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Wrap(
                          children: List.generate(
                            product.sizevariants!.length,
                            (index) {
                              final sizeItem =
                                  product.sizevariants![index].size;
                              final firstPart = sizeItem.split(" ")[0];
                              final isSelected = index == selectSize;
                              return GestureDetector(
                                onTap: () {
                                  ref
                                          .read(footWearSizeSelection.notifier)
                                          .state =
                                      index;
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColor.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      firstPart,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    indicatorColor: AppColor.primaryColor,
                    tabs: [
                      Tab(
                        child: Text(
                          "Description",
                          style: Constants.productTabBarTextStyle,
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Details",
                          style: Constants.productTabBarTextStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            product.description!,
                            style: const TextStyle(
                              color: WidgetTemplate.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              product.footweartype != null
                                  ? WidgetTemplate.productDetailsRowTemplate(
                                      title: "Footwear Type: ",
                                      value: product.footweartype!,
                                      isGiveSpaceAtlast: true,
                                    )
                                  : const SizedBox.shrink(),
                              product.footwearmaterial != null
                                  ? WidgetTemplate.productDetailsRowTemplate(
                                      title: "Material: ",
                                      value: product.footwearmaterial != null
                                          ? product.footwearmaterial!
                                          : "N/A",
                                      isGiveSpaceAtlast: true,
                                    )
                                  : const SizedBox.shrink(),
                              product.gender != null
                                  ? WidgetTemplate.productDetailsRowTemplate(
                                      title: "Gender",
                                      value: product.gender!,
                                      isGiveSpaceAtlast: true,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomElevatedButton(
                      child: const Text(
                        "Add to Cart",
                        style: customElevatedButtonTextStyle,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
