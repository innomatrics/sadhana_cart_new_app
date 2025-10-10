import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20repo/order/order_notifier.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/enums/order_status_enums.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_outline_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_form_field.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/view%20model/order_cancel_notifier.dart';

class CancelOrderPage extends StatefulWidget {
  final int shippingId;
  final OrderModel order;
  const CancelOrderPage({
    super.key,
    required this.shippingId,
    required this.order,
  });

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  final reasonController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              //image
              Consumer(
                builder: (context, ref, child) {
                  final image = widget.order.products.first.images!;
                  if (widget.order.products.first.images!.length == 1) {
                    return SizedBox(
                      height: size.height * 0.30,
                      width: size.width * 1,
                      child: Image.network(image.first, fit: BoxFit.fitHeight),
                    );
                  }
                  return CarouselSlider(
                    items: widget.order.products.first.images!
                        .map(
                          (e) => SizedBox(
                            height: size.height * 0.30,
                            width: size.width * 1,
                            child: Image.network(e, fit: BoxFit.fitHeight),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      height: size.height * 0.45,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      enableInfiniteScroll: true,
                      pauseAutoPlayOnTouch: true,
                      scrollPhysics: const BouncingScrollPhysics(),
                      onPageChanged: (index, reason) {
                        ref.read(carouselController.notifier).state = index;
                      },
                    ),
                  );
                },
              ),

              //order details
              Text(
                widget.order.products.first.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Subtotal: ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${Constants.indianCurrency} ${widget.order.products.first.price!.toStringAsFixed(2)}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  const Text(
                    "Quantity: ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.order.quantity.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Form(
                key: formKey,
                child: CustomTextFormField(
                  controller: reasonController,
                  labelText: "Reason",
                  isShowBorder: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  maxLine: 5,
                  validator: (value) =>
                      value!.isEmpty ? "Reason is required" : null,
                ),
              ),
              Center(
                child: CustomOutlineButton(
                  onPressed: showAlert,
                  child: const Text(
                    "Cancel Order",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return SlideInUp(
          duration: const Duration(milliseconds: 100),
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Cancel Order"),
            content: const Text("Are you sure you want to cancel this order?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No", style: TextStyle(color: Colors.black)),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return TextButton(
                    onPressed: () async {
                      final isValid = formKey.currentState!.validate();
                      if (!isValid) {
                        Navigator.pop(context);
                        return;
                      }

                      final bool isSuccess = await ref
                          .read(orderCancelProvider.notifier)
                          .addCancelRequest(
                            orderId: widget.order.shipmentId!,
                            reason: reasonController.text,
                          );
                      final bool changedOrderStatus = await ref
                          .read(orderCancelProvider.notifier)
                          .changeOrderStatus(
                            orderId: widget.order.orderId ?? "",
                            status: OrderStatusEnums.cancelled.label,
                          );
                      if (isSuccess && changedOrderStatus && context.mounted) {
                        navigateBack(context: context);
                        showCustomSnackbar(
                          context: context,
                          message: "Order Cancelled Form Submit Successfully",
                          type: ToastType.success,
                        );
                        ref.invalidate(orderProvider);
                      }
                      if (context.mounted) {
                        navigateBack(context: context);
                      }
                      if (context.mounted) {
                        navigateBack(context: context);
                      }
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
