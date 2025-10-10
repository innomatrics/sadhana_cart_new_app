import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20repo/order/order_notifier.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/api_provider.dart';
import 'package:sadhana_cart/core/enums/order_status_enums.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/shiprocket_api_services.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/view/order_tracking_page.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/widget/order_product_carousel_slider.dart';

class OrderDetailsPage extends ConsumerStatefulWidget {
  final OrderModel order;
  const OrderDetailsPage({super.key, required this.order});

  @override
  ConsumerState<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends ConsumerState<OrderDetailsPage> {
  late OrderModel order;
  bool isLoading = true;
  String formattedDate = "--";

  @override
  void initState() {
    super.initState();
    order = widget.order;

    // Format the date safely
    try {
      formattedDate = DateFormat(
        'dd MMM yyyy, hh:mm a',
      ).format(order.orderDate.toDate());
    } catch (e) {
      formattedDate = "--";
    }

    final userId = FirebaseAuth.instance.currentUser!.uid;
    _syncOrderStatus(userId);
  }

  Future<void> _syncOrderStatus(String userId) async {
    try {
      final apiService = ShiprocketApiServices(
        ref.read(dioProvider),
        ref.read(tokenManagerProvider),
      );

      final apiResponse = await apiService.getOrderDetails(order.orderId!);

      final apiStatus = apiResponse['data']?['status']?.toString() ?? '';
      final firebaseStatus = order.orderStatus ?? 'Pending';

      log("Firebase Order Status (before update): $firebaseStatus");

      if (apiStatus.isNotEmpty && apiStatus != firebaseStatus) {
        log(
          " Status mismatch detected (API: $apiStatus vs Firebase: $firebaseStatus). "
          "Calling OrderNotifier.updateOrderStatus...",
        );

        // Convert orderId to number before passing to Firestore query
        final orderIdNumber = int.tryParse(order.orderId!) ?? 0;

        // Call centralized update method
        await ref
            .read(orderProvider.notifier)
            .updateOrderStatus(
              userId: userId,
              orderId: orderIdNumber.toString(),
              apiStatus: apiStatus,
            );

        setState(() {
          order = order.copyWith(orderStatus: apiStatus);
        });

        log("Local state updated successfully to: ${order.orderStatus}");
        log("OrderId: ${order.orderId}");
        final ordersRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('orders');

        final querySnapshot = await ordersRef
            .where('orderId', isEqualTo: int.tryParse(order.orderId!))
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final docData = querySnapshot.docs.first.data();
          log("Firestore document after update: $docData");
        } else {
          log(" Firestore document not found after update");
        }
      } else {
        log("No update required. Status already matches.");
      }
    } catch (e, st) {
      log("Exception in _syncOrderStatus: $e");
      log("Stacktrace: $st");
    } finally {
      log("Finished");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final orderStatus = order.orderStatus ?? 'Pending';

    final image = OrderStatusEnums.values
        .firstWhere(
          (e) => e.label == orderStatus,
          orElse: () => OrderStatusEnums.pending,
        )
        .image;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Status container
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: size.height * 0.15,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.primaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 0),
                          Text(
                            "Your order is: $orderStatus",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.1,
                            width: size.width * 0.3,
                            child: Image.asset(image, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Basic details
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // if (order.products.isNotEmpty)
                            //   OrderProductCarousel(
                            //     product: order.products.first,
                            //   )
                            // else
                            //   Container(
                            //     height: size.height * 0.25,
                            //     width: 200,
                            //     color: Colors.white,
                            //     // child: const Icon(Icons.image, size: 50),
                            //   ),
                            const SizedBox(height: 16),
                            Container(
                              height: 50,
                              // width: 100,
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Order ID: ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: order.shiprocketOrderId
                                              .toString(),
                                        ),
                                      );
                                      showCustomSnackbar(
                                        context: context,
                                        message: "Copied",
                                        type: ToastType.success,
                                      );
                                    },
                                    child: Text(
                                      "${order.shiprocketOrderId == 0 ? order.orderId : order.shiprocketOrderId ?? order.orderId}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            _customText(
                              title: "Order Date: ",
                              titleColor: AppColor.orderStatusColor,
                              value: formattedDate,
                              valueColor: Colors.black,
                            ),

                            const SizedBox(height: 8),
                            _customText(
                              title: "Delivery Address: ",
                              titleColor: AppColor.orderStatusColor,
                              value: order.address ?? '--',
                              valueColor: Colors.black,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 8),
                            _customText(
                              title: "Quantity: ",
                              titleColor: AppColor.orderStatusColor,
                              value: order.quantity.toString(),
                              valueColor: Colors.black,
                            ),
                            const SizedBox(height: 8),
                            _customText(
                              title: "Total Amount: ",
                              titleColor: AppColor.orderStatusColor,
                              value:
                                  "₹ ${order.totalAmount.toStringAsFixed(2)}",
                              valueColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Products List
                    if (order.products.isNotEmpty)
                      Column(
                        children: order.products.map((product) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (order.products.isNotEmpty)
                                  OrderProductCarousel(product: product)
                                else
                                  Container(
                                    height: size.height * 0.25,
                                    width: 200,
                                    color: Colors.white,
                                    // child: const Icon(Icons.image, size: 50),
                                  ),

                                const SizedBox(height: 16),
                                const Text(
                                  "Product Details: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Name: ",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        product.name ?? '--',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text(
                                      "Price: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "₹${(product.price ?? 0).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Text(
                                      "Quantity: ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "${product.quantity ?? 1}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    product.sizevariants?.isNotEmpty ?? true
                                        ? Text(
                                            "Selected Size: ${product.sizevariants?.first.size}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    orderStatus ==
                                            OrderStatusEnums.cancelled.label
                                        ? const SizedBox.shrink()
                                        : OutlinedButton(
                                            onPressed: () => navigateTo(
                                              context: context,
                                              screen: OrderTrackingPage(
                                                order: order,
                                              ),
                                            ),
                                            child: const Text(
                                              "Track Order",
                                              style: TextStyle(
                                                color:
                                                    AppColor.dartPrimaryColor,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    else
                      const Text("No products found"),
                  ],
                ),
              ),
            ),
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
    int? maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: fontSize,
            fontWeight: titleFontWeight,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: valueFontWeight,
            ),
          ),
        ),
      ],
    );
  }
}
