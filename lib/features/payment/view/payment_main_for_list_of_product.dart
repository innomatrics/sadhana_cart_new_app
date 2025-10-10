import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20model/cart/cart_model.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';
import 'package:sadhana_cart/core/common%20model/product/size_variant.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/enums/payment_enum.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_check_box.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_text_button.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/settings/view/terms_of_use_page.dart';
import 'package:sadhana_cart/features/order confirm/widget/payment/controller/payment_state.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/controller/payment_controller.dart';
import 'package:sadhana_cart/features/payment/service/payment_service.dart';
import 'package:sadhana_cart/features/payment/view/order_address.dart';
import 'package:sadhana_cart/features/order confirm/widget/payment/widget/payment_option_tile.dart';
import 'package:sadhana_cart/features/profile/widget/address/view%20model/address_notifier.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';

class PaymentMainForListOfProduct extends ConsumerStatefulWidget {
  final List<ProductModel> products;
  final List<CartModel> cart;
  final double totalAmount;
  final SizeVariant? selectedSizeIndex;
  final double? shippingCharges;

  const PaymentMainForListOfProduct({
    super.key,
    required this.cart,
    required this.products,
    required this.totalAmount,
    this.selectedSizeIndex,
    required this.shippingCharges,
  });

  @override
  ConsumerState<PaymentMainForListOfProduct> createState() =>
      _PaymentMainPageState();
}

class _PaymentMainPageState extends ConsumerState<PaymentMainForListOfProduct> {
  int currentStep = 0;
  String? _selectedMethod;
  bool _isLoading = false;
  bool _hasPaymentProcessed = false;
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
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for payment state changes (for online payments)
    ref.listen<PaymentState>(paymentProvider, (previous, next) async {
      if (_hasPaymentProcessed) return;

      log("PaymentState changed: success=${next.success}, error=${next.error}");

      if (next.success) {
        _hasPaymentProcessed = true;
        setState(() => _isLoading = true);

        await PaymentService.handlePayment(
          context: context,
          selectedMethod: _selectedMethod!,
          products: widget.products,
          ref: ref,
          selectedVariant: widget.selectedSizeIndex != null
              ? widget.selectedSizeIndex!
              : SizeVariant(size: "", stock: 0, color: ''),
          shippingCharges: widget.shippingCharges ?? 0,
        );

        setState(() => _isLoading = false);
      } else if (next.error != null) {
        setState(() {
          _isLoading = false;
          _hasPaymentProcessed = false;
        });
        showCustomSnackbar(
          context: context,
          message: next.error!,
          type: ToastType.error,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
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
                      if (_hasPaymentProcessed) {
                        showCustomSnackbar(
                          context: context,
                          message: "Payment already processed",
                          type: ToastType.info,
                        );
                        return;
                      }

                      setState(() => _isLoading = true);

                      // Check terms and conditions for online payment
                      if (_selectedMethod == PaymentEnum.online.label) {
                        final acceptedTerms = ref.read(orderAcceptTerms);
                        if (!acceptedTerms) {
                          setState(() => _isLoading = false);
                          showCustomSnackbar(
                            context: context,
                            message: "Please accept Terms & Conditions",
                            type: ToastType.info,
                          );
                          return;
                        }

                        final addressState = ref.read(addressprovider);
                        final AddressModel? address =
                            addressState.addresses.isNotEmpty
                            ? addressState.addresses.last
                            : null;
                        final user = ref.watch(userProvider);

                        if (address == null) {
                          setState(() => _isLoading = false);
                          showCustomSnackbar(
                            context: context,
                            message: "Please add an address first.",
                            type: ToastType.info,
                          );
                          return;
                        }

                        // Start online payment process
                        final paymentController = ref.read(
                          paymentProvider.notifier,
                        );
                        paymentController.startPayment(
                          amount: widget.totalAmount,
                          contact: address.phoneNumber.toString(),
                          email: user?.email ?? "demo@example.com",
                        );
                      }
                      // Handle cash payment directly
                      else if (_selectedMethod == PaymentEnum.cash.label) {
                        _hasPaymentProcessed = true;
                        await PaymentService.handlePayment(
                          context: context,
                          selectedMethod: _selectedMethod!,
                          products: widget.products,
                          ref: ref,
                          selectedVariant:
                              widget.selectedSizeIndex ??
                              SizeVariant(size: '', stock: 0, color: ''),
                          shippingCharges: widget.shippingCharges ?? 0,
                        );
                        setState(() => _isLoading = false);
                      }
                    } else {
                      showCustomSnackbar(
                        context: context,
                        message: "Please select a payment method",
                        type: ToastType.info,
                      );
                    }
                  }
                },
              ),
      ),
      body: Stack(
        children: [
          Column(
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
                                  ? AppColor.dartPrimaryColor
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
                                ? AppColor.dartPrimaryColor
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
                    // Step 1: Show products + address form
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.products.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final product = widget.products[index];
                                final cartItem = widget.cart[index];
                                final pricePerItem = product.offerprice ?? 0.0;
                                final specificPrice =
                                    pricePerItem * cartItem.quantity;
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 90,
                                        width: 60,
                                        child:
                                            product.images != null &&
                                                product.images!.isNotEmpty
                                            ? Image.network(
                                                product.images![0],
                                                fit: BoxFit.fitHeight,
                                              )
                                            : const SizedBox.shrink(),
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
                                            const SizedBox(height: 8),
                                            Text(
                                              "₹ ${pricePerItem.toStringAsFixed(2)} x ${cartItem.quantity} = ₹ ${specificPrice.toStringAsFixed(2)}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const OrderAddress(),
                        ],
                      ),
                    ),
                    // Step 2: Payment method selection
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
                            description: "Pay when you receive your product",
                            price: "₹${widget.totalAmount}",
                            selected: _selectedMethod == PaymentEnum.cash.label,
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
                            price: "₹${widget.totalAmount}",
                            selected:
                                _selectedMethod == PaymentEnum.online.label,
                            onTap: () {
                              setState(() {
                                _selectedMethod = PaymentEnum.online.label;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              Consumer(
                                builder: (context, listenRef, child) {
                                  final value = listenRef.watch(
                                    orderAcceptTerms,
                                  );
                                  return CustomCheckBox(
                                    value: value,
                                    onChanged: (newValue) {
                                      listenRef
                                              .read(orderAcceptTerms.notifier)
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
                                onPressed: () => navigateTo(
                                  context: context,
                                  screen: const TermsOfUsePage(),
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
            ],
          ),
        ],
      ),
    );
  }
}
