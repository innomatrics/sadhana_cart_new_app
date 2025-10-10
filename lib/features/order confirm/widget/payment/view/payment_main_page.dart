import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/order/order_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/common%20repo/order/order_notifier.dart';
import 'package:sadhana_cart/core/common%20services/order/order_service.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/api_provider.dart';
import 'package:sadhana_cart/core/common%20services/shiprocket_api/shiprocket_api_services.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/enums/payment_enum.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_check_box.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_button.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/controller/payment_controller.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/controller/payment_state.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/view/payment_success_page.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/view/update_location_page.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/widget/payment_option_tile.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';
import 'package:sadhana_cart/features/profile/widget/address/view%20model/address_notifier.dart';

class PaymentMainPage extends ConsumerStatefulWidget {
  final ProductModel product;
  final String? selectedSize;
  final int? selectedIndex;
  const PaymentMainPage({
    super.key,
    this.selectedIndex,
    required this.product,
    this.selectedSize,
  });

  @override
  ConsumerState<PaymentMainPage> createState() => _PaymentMainPageState();
}

class _PaymentMainPageState extends ConsumerState<PaymentMainPage> {
  int currentStep = 0;
  String? _selectedMethod;
  bool isLoading = false;
  int? shipmentId;

  final PageController _pageController = PageController();

  void _goToStep(int step) {
    setState(() {
      currentStep = step;
    });
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(addressprovider.notifier).updateAddress();
      log("Size: ${widget.selectedSize}");
    });
  }

  Future<void> _handlePayment() async {
    setState(() {
      isLoading = true;
    });

    final addressState = ref.read(addressprovider);
    final AddressModel? address = addressState.addresses.isNotEmpty
        ? addressState.addresses.last
        : null;

    if (address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add an address first.")),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    // log("selectedSize: ${widget.selectedSize}");
    // log("selectedIndex: ${widget.selectedIndex}");
    final orderProduct = OrderProductModel(
      productid: widget.product.productid!,
      name: widget.product.name!,
      price: (widget.product.offerprice ?? 0.0).toDouble(),
      stock: widget.product.stock ?? 0,
      quantity: int.tryParse(widget.product.quantity.toString()) ?? 1,
      sku: widget.product.basesku ?? '',
      sizevariants:
          (widget.product.sizevariants != null &&
              widget.product.sizevariants!.isNotEmpty &&
              widget.selectedSize != null &&
              widget.selectedIndex != null)
          ? [
              SizeVariant(
                size: widget.selectedSize!,
                stock:
                    widget.product.sizevariants![widget.selectedIndex!].stock,
                skuSuffix:
                    (widget.product.sizevariants != null &&
                        widget.product.sizevariants!.isNotEmpty &&
                        widget.selectedSize != null &&
                        widget.selectedIndex != null)
                    ? widget
                              .product
                              .sizevariants![widget.selectedIndex!]
                              .skuSuffix ??
                          widget.product.basesku ??
                          ""
                    : widget.product.basesku ?? "",
                color:
                    widget.product.sizevariants![widget.selectedIndex!].color,
              ),
            ]
          : [],
      images: widget.product.images,
    );

    if (_selectedMethod == PaymentEnum.cash.label) {
      // COD flow
      try {
        //  log("Placing COD order for product: ${widget.product.toMap()}");

        final success = await OrderService.addSingleOrder(
          totalAmount: (widget.product.offerprice ?? 0.0).toDouble(),
          phoneNumber: address.phoneNumber ?? 0,
          address:
              "${address.title ?? ''}, ${address.streetName}, ${address.city}, ${address.state}, ${address.pinCode}",
          latitude: address.lattitude,
          longitude: address.longitude,
          quantity: (widget.product.quantity as int?) ?? 1,
          product: orderProduct,
          createdAt: Timestamp.now(),
          ref: ref,
          selectedSizeFromUser: widget.selectedSize.toString(),
          paymentMethod: '$_selectedMethod',
          shipmentId: shipmentId ?? 0,
        );

        if (!mounted) return;

        if (success) {
          final currentUser = ref.read(userProvider)?.customerId ?? "demoUser";
          final currentOrderId = ref.read(currentOrderIdProvider);
          // Wait until Firestore document exists
          await _waitForOrderDoc(currentOrderId!, currentUser);
          // Call Shiprocket API for COD
          await _callShiprocketApiAfterPayment(
            "COD-${DateTime.now().millisecondsSinceEpoch}",
          );

          if (mounted) {
            showCustomSnackbar(
              context: context,
              message: "Order placed successfully!",
              type: ToastType.success,
            );
          }

          if (mounted) {
            navigateToReplacement(
              context: context,
              screen: const PaymentSuccessPage(),
            );
          }
        } else {}
      } catch (e) {
        //  log("COD error: $e");

        if (mounted) {
          showCustomSnackbar(
            context: context,
            message: "Error placing order.",
            type: ToastType.error,
          );
        }
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else if (_selectedMethod == PaymentEnum.online.label) {
      // Online payment flow
      setState(() {
        isLoading = true; // Payment UI will handle loading
      });

      final acceptedTerms = ref.read(orderAcceptTerms);
      if (!acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please accept Terms & Conditions")),
        );
        setState(() {
          isLoading = false; // stop loading if terms not accepted
        });
        return;
      }

      final paymentController = ref.read(paymentProvider.notifier);
      // final user = ref.read(userProvider);
      final user = ref.watch(userProvider);

      // Reset
      paymentController.resetPaymentState();
      paymentController.startPayment(
        amount: (widget.product.offerprice ?? 0).toDouble(),
        contact: address.phoneNumber.toString(),
        email: user?.email ?? "demo@example.com",
      );

      // log(
      //   "AMount:${(widget.product.offerprice ?? 0).toDouble()}, Contact: ${address.phoneNumber.toString()}, Email : ${user.email}",
      // );
    }
  }

  // CAll API
  Future<void> _callShiprocketApiAfterPayment(String paymentId) async {
    // log("started");
    try {
      // log("Try");
      final addressState = ref.read(addressprovider);
      final AddressModel? address = addressState.addresses.isNotEmpty
          ? addressState.addresses.last
          : null;

      if (address == null) {
        //   log("No address found, skipping Shiprocket API call.");
        return;
      }

      final userEmail = ref.read(userProvider)?.email ?? "demo@example.com";
      final currentUser = ref.read(userProvider)?.customerId ?? "demoUser";
      final currentOrderId = ref.read(currentOrderIdProvider);

      final shiprocketService = ShiprocketApiServices(
        ref.read(dioProvider),
        ref.read(tokenManagerProvider),
      );

      final selectedSizeSafe =
          widget.selectedSize ??
          (widget.product.sizevariants != null &&
                  widget.product.sizevariants!.isNotEmpty
              ? widget.product.sizevariants!.first.size
              : "DemoSize");

      // log("address : $addressResult");

      final Map<String, dynamic> orderData = {
        "order_id": "DEMO${DateTime.now().millisecondsSinceEpoch}",
        "order_date": DateTime.now().toString(),
        "pickup_location": "Office",
        "billing_customer_name": address.name ?? "",
        "billing_last_name": address.name ?? "N/A",
        "billing_address": address.streetName,
        "billing_city": address.city,
        "billing_pincode": address.pinCode,
        "billing_state": address.state,
        "billing_country": "India",
        "billing_email": userEmail,
        "billing_phone": address.phoneNumber ?? "",
        "shipping_is_billing": true,
        "shipping_country": "India",
        "shipping_email": userEmail,
        "order_items": [
          {
            "name": widget.product.name ?? "",
            "sku":
                (widget.product.sizevariants != null &&
                    widget.product.sizevariants!.isNotEmpty &&
                    widget.selectedSize != null &&
                    widget.selectedIndex != null)
                ? widget
                          .product
                          .sizevariants![widget.selectedIndex!]
                          .skuSuffix ??
                      widget.product.basesku ??
                      ""
                : widget.product.basesku ?? "",
            "units": (widget.product.quantity ?? 1).toString(),
            "selling_price": (widget.product.offerprice ?? 0.0).toString(),
            "size": selectedSizeSafe,
          },
        ],
        "payment_method": _selectedMethod == PaymentEnum.cash.label
            ? "COD"
            : "Prepaid",
        "sub_total": (widget.product.offerprice ?? 0.0).toString(),
        "length": (widget.product.length ?? 1),
        "breadth": 1,
        "height": (widget.product.height ?? 1),
        "weight": (widget.product.weight ?? 1).toString(),
      };

      // log("=== Shiprocket API Call ===");
      // log("Payment ID: $paymentId");
      // log("Order Data: $orderData");

      final apiResult = await shiprocketService.createOrder(orderData);
      // log("Shiprocket API Response: $apiResult");

      final ship = apiResult['shipment_id'] as int? ?? 0;

      setState(() {
        shipmentId = ship;
      });

      final trackingDetails = await shiprocketService.getTrackingDetails(
        shipmentId: shipmentId ?? 0,
      );

      log(trackingDetails.toString());
      // --- STORE ONLY order_id AND status ---
      if (apiResult['order_id'] != null && apiResult['status'] != null) {
        final userOrderRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .collection('orders')
            .doc(currentOrderId); // generates a new order doc

        final updateMap = {
          "orderId": apiResult['order_id'],
          // "shiprocketOrderId": apiResult['order_id'],
          "status": apiResult['status'],
        };

        await userOrderRef.set(updateMap, SetOptions(merge: true));

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(userOrderRef, updateMap);
        });

        // Fetch back the document and print it
        // --- VERIFY UPDATE ---
        final updatedDoc = await userOrderRef.get();
        //  log("Fetched Firestore data after update: ${updatedDoc.data()}");
        if (updatedDoc.exists) {
          final data = updatedDoc.data();
          //   log("Fetched Firestore data after update: $data");

          if (data?['orderId'] != apiResult['order_id'] ||
              data?['status'] != apiResult['status']) {
            // log(
            //   "Firestore update mismatch! Data did not match Shiprocket response.",
            // );
          } else {
            //  log("Firestore successfully updated with Shiprocket data.");
          }
        } else {
          //  log("Firestore document not found after update!");
        }
      }
    } catch (e, stackTrace) {
      log("Error calling Shiprocket API: $e");
      log("StackTrace: $stackTrace");
    }
  }

  Future<void> _waitForOrderDoc(String docId, String userId) async {
    final userOrderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(docId);

    int attempts = 0;
    while (attempts < 10) {
      final doc = await userOrderRef.get();
      if (doc.exists) {
        log("✅ Order doc exists now: ${doc.data()}");
        return;
      }
      attempts++;
      log("Waiting for Firestore to write order... attempt $attempts");
      await Future.delayed(const Duration(milliseconds: 300));
    }
    log("⚠️ Order doc not found after waiting!");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final product = widget.product;
    // final paymentController = ref.read(paymentProvider.notifier);

    // Watch address state
    final addressState = ref.watch(addressprovider);
    final AddressModel? address = addressState.addresses.isNotEmpty
        ? addressState.addresses.last
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (isLoading)
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.height * 0.07,
                // decoration: BoxDecoration(
                //   color: Colors.black,
                //   borderRadius: BorderRadius.circular(32),
                // ),
                child: const Center(child: Text("")),
              )
            : CustomElevatedButton(
                child: Text(
                  currentStep == 0 ? "Next" : "Confirm Payment",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () async {
                  if (currentStep == 0) {
                    _goToStep(1);
                  } else {
                    if (_selectedMethod != null) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await _handlePayment(); // await the async payment handling
                      } catch (e) {
                        // handle errors if necessary
                        setState(() {
                          isLoading = false;
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select a payment method"),
                        ),
                      );
                    }
                  }
                },
              ),
      ),
      body: Stack(
        children: [
          Consumer(
            builder: (context, ref, _) {
              ref.listen<PaymentState>(paymentProvider, (previous, next) async {
                if (next.success && next.paymentId != null) {
                  log("Payment confirmed! Payment ID: ${next.paymentId}");

                  final addressState = ref.read(addressprovider);
                  final AddressModel? address =
                      addressState.addresses.isNotEmpty
                      ? addressState.addresses.last
                      : null;

                  if (address == null) return;

                  // Convert ProductModel to OrderProductModel
                  final orderProduct = OrderProductModel(
                    productid: widget.product.productid!,
                    name: widget.product.name!,
                    price: (widget.product.offerprice ?? 0.0).toDouble(),
                    stock: widget.product.stock ?? 0,
                    quantity:
                        int.tryParse(widget.product.quantity.toString()) ?? 1,
                    sku: widget.product.basesku,
                    sizevariants:
                        (widget.selectedSize != null &&
                            widget.selectedIndex != null &&
                            widget.product.sizevariants != null &&
                            widget.product.sizevariants!.isNotEmpty &&
                            widget.selectedIndex! <
                                widget.product.sizevariants!.length)
                        ? [
                            SizeVariant(
                              size: widget.selectedSize!,
                              stock:
                                  widget
                                      .product
                                      .sizevariants![widget.selectedIndex!]
                                      .stock ??
                                  0,
                              skuSuffix:
                                  widget
                                      .product
                                      .sizevariants![widget.selectedIndex!]
                                      .skuSuffix ??
                                  "",
                              color:
                                  widget
                                      .product
                                      .sizevariants![widget.selectedIndex!]
                                      .color ??
                                  "",
                            ),
                          ]
                        : [],
                    images: widget.product.images,
                  );

                  // 1️Create the order first
                  final orderCreated = await OrderService.addSingleOrder(
                    totalAmount: (widget.product.offerprice ?? 0.0).toDouble(),
                    phoneNumber: address.phoneNumber ?? 0,
                    address:
                        "${address.title}, ${address.streetName}, ${address.city}, ${address.state}, ${address.pinCode}",
                    latitude: address.lattitude,
                    longitude: address.longitude,
                    quantity:
                        int.tryParse(widget.product.quantity.toString()) ?? 1,
                    product: orderProduct,
                    createdAt: Timestamp.now(),
                    ref: ref,
                    selectedSizeFromUser: widget.selectedSize ?? "",
                    paymentMethod: '$_selectedMethod',
                    shipmentId: shipmentId ?? 0,
                  );

                  if (!orderCreated) {
                    if (context.mounted) {
                      showCustomSnackbar(
                        context: context,
                        message: "Failed to place order. Try again.",
                        type: ToastType.error,
                      );
                    }
                    return;
                  }

                  // Set currentOrderIdProvider immediately after order creation
                  final orderDocId = ref.read(currentOrderIdProvider);
                  // Make sure addSingleOrder sets this inside the method
                  log("Order created with doc ID: $orderDocId");

                  // Now call Shiprocket API to update orderId & orderStatus
                  await _callShiprocketApiAfterPayment(next.paymentId!);

                  setState(() {
                    isLoading = true;
                  });

                  if (context.mounted) {
                    showCustomSnackbar(
                      context: context,
                      message: "Order placed successfully!",
                      type: ToastType.success,
                    );
                    navigateToReplacement(
                      context: context,
                      screen: const PaymentSuccessPage(),
                    );
                  }
                } else if (next.error != null) {
                  // log("Payment failed or cancelled: ${next.error}");
                  setState(() {
                    isLoading = false;
                  });
                }
              });

              return Column(
                children: [
                  // Step indicator
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => _goToStep(0),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: currentStep == 0
                                      ? Colors.black
                                      : Colors.grey,
                                  child: const Text(
                                    "1",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text("Step 1"),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: currentStep == 1
                                    ? Colors.black
                                    : Colors.grey,
                                child: const Text(
                                  "2",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text("Step 2"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        // Step 1: Product + User Details
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Tile
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 60,
                                      color: Colors.grey.shade300,
                                      child:
                                          product.images != null &&
                                              product.images!.isNotEmpty
                                          ? Image.network(
                                              product.images![0],
                                              fit: BoxFit.fitHeight,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name ?? "Product Name",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          if (widget.selectedSize != null &&
                                              widget.selectedSize!.isNotEmpty)
                                            Text(
                                              "Size: ${widget.selectedSize}",
                                            ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                "₹ ${product.offerprice ?? 0}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "₹ ${product.price ?? 0}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // User details
                              Container(
                                width: size.width,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: addressState.isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : address != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_outlined,
                                                color: Colors.grey[600],
                                              ),
                                              Text(
                                                " ${address.name}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone_outlined,
                                                color: Colors.grey[600],
                                              ),
                                              Text(
                                                " ${address.phoneNumber}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 14),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.location_city,
                                                color: Colors.grey[600],
                                              ),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      address.title ?? "",
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${address.streetName},${address.city},${address.state},${address.pinCode}"
                                                          .replaceAll(
                                                            ',',
                                                            ',\u200B',
                                                          ),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                      softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : const Text("No address found"),
                              ),
                              const SizedBox(height: 14),
                              GestureDetector(
                                onTap: () {
                                  navigateTo(
                                    context: context,
                                    screen: const UpdateLocationPage(),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Edit Address",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Icon(
                                        Icons.edit_location_alt_outlined,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Step 2: Payment Method
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Select Payment Method",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              PaymentOptionTile(
                                title: "Cash On Delivery",
                                description:
                                    "Pay when you receive your product",
                                price: "₹${product.offerprice ?? 0}",
                                selected:
                                    _selectedMethod == PaymentEnum.cash.label,
                                onTap: () {
                                  setState(() {
                                    _selectedMethod = PaymentEnum.cash.label;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),
                              PaymentOptionTile(
                                title: "Online Payment",
                                description: "Pay now using card or UPI",
                                price: "₹${product.offerprice ?? 0}",
                                selected:
                                    _selectedMethod == PaymentEnum.online.label,
                                onTap: () {
                                  setState(() {
                                    _selectedMethod = PaymentEnum.online.label;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  const SizedBox(width: 20),
                                  Consumer(
                                    builder: (context, ref, child) {
                                      final value = ref.watch(orderAcceptTerms);
                                      return CustomCheckBox(
                                        value: value,
                                        onChanged: (newValue) {
                                          ref
                                                  .read(
                                                    orderAcceptTerms.notifier,
                                                  )
                                                  .state =
                                              newValue!;
                                        },
                                      );
                                    },
                                  ),
                                  const Text(
                                    "I agree to",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  CustomTextButton(
                                    text: "Terms and Conditions",
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
