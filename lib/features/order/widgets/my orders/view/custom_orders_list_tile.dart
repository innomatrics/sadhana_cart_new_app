import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/order/order_notifier.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_outline_button.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/view/cancel_order_page.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/view/order_details_page.dart';

class CustomOrdersListTile extends ConsumerStatefulWidget {
  const CustomOrdersListTile({super.key});

  @override
  ConsumerState<CustomOrdersListTile> createState() =>
      _CustomOrdersListTileState();
}

class _CustomOrdersListTileState extends ConsumerState<CustomOrdersListTile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(orderProvider.notifier).fetchCustomOrderDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final size = MediaQuery.of(context).size;

    if (orderState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orderState.error != null) {
      return Center(child: Text("Error: ${orderState.error}"));
    }

    if (orderState.orders.isEmpty) {
      return const Center(
        child: Text(
          "No orders found",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: orderState.orders.length,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final order = orderState.orders[index];

        // Format createdAt safely
        String createdAtText = "--";
        try {
          order.createdAt.toDate().toString();
        } catch (e) {
          createdAtText = "--";
        }

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          height: size.height * 0.33,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            spacing: 25,
            children: [
              //  Order ID + Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Text(
                          "Tracking Number: ",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: order.orderId ?? '--'),
                            );
                            showCustomSnackbar(
                              context: context,
                              message: "Copied to clipboard",
                              type: ToastType.success,
                            );
                          },
                          child: Text(
                            order.orderId ?? '--',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    createdAtText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xff777E90),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    // color: Colors.blue,
                    child:
                        order.products.isNotEmpty &&
                            (order.products.first.images?.isNotEmpty ?? false)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: order.products.first.images!.first,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.red),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  Expanded(child: Text(order.products.first.name ?? "N/A")),
                ],
              ),

              //  Quantity + Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _customText(
                    title: "Quantity: ",
                    titleFontWeight: FontWeight.bold,
                    titleColor: const Color(0xff777e90),
                    value: order.quantity.toString(),
                    valueColor: Colors.black,
                    valueFontWeight: FontWeight.bold,
                  ),
                  _customText(
                    title: "Subtotal: ",
                    titleFontWeight: FontWeight.bold,
                    titleColor: const Color(0xff777e90),
                    value:
                        "${Constants.indianCurrency} ${(order.totalAmount).toStringAsFixed(2)}",
                    valueColor: Colors.black,
                    valueFontWeight: FontWeight.bold,
                  ),
                ],
              ),

              //  Status + Details Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomOutlineButton(
                    onPressed: () {
                      navigateTo(
                        context: context,
                        screen: CancelOrderPage(
                          shippingId: order.shipmentId ?? 0,
                          order: order,
                        ),
                      );
                    },
                    child: const Text(
                      "Cancel order",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomOutlineButton(
                        child: const Text(
                          "Details",
                          style: customOutlinedButtonStyle,
                        ),
                        onPressed: () {
                          log(order.toString());
                          navigateTo(
                            context: context,
                            screen: OrderDetailsPage(order: order),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _customText({
    required String title,
    Color? titleColor = Colors.black,
    double fontSize = 16,
    FontWeight? titleFontWeight = FontWeight.normal,
    required String value,
    Color? valueColor = const Color(0xff777E90),
    FontWeight? valueFontWeight = FontWeight.normal,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: fontSize,
            fontWeight: titleFontWeight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: valueFontWeight,
          ),
        ),
      ],
    );
  }
}
