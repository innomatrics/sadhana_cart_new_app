import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/widgets/custom_check_box.dart';
import 'package:sadhana_cart/core/widgets/custom_text_button.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/controller/payment_controller.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/widget/checkout_total_amount_container.dart';
import 'package:sadhana_cart/features/order%20confirm/widget/payment/widget/custom_payment_method.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/address/model/address_model.dart';
import 'package:sadhana_cart/features/profile/widget/address/view%20model/address_notifier.dart';
import 'package:sadhana_cart/features/profile/widget/payment/view%20model/list_wallet_page.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentProvider);
    final paymentController = ref.read(paymentProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Step 2 of 3",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  "Payment",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Payment methods row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(paymentMethodTitle.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      ref.read(orderStepperPageProvider.notifier).state = index;
                    },
                    child: CustomPaymentMethod(
                      image: paymentMethodImage[index],
                      index: index,
                      title: paymentMethodTitle[index],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Wallet list or conditional UI
              Consumer(
                builder: (context, ref, child) {
                  final index = ref.watch(orderStepperPageProvider);
                  if (index == 0) {
                    return const SizedBox.shrink();
                  } else if (index == 1) {
                    return const ListWalletPage();
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              const SizedBox(height: 20),

              // Checkout total
              const CheckoutTotalAmountContainer(),

              const SizedBox(height: 20),

              // Terms & conditions checkbox
              Row(
                children: [
                  const SizedBox(width: 20),
                  Consumer(
                    builder: (context, ref, child) {
                      final value = ref.watch(orderAcceptTerms);
                      return CustomCheckBox(
                        value: value,
                        onChanged: (newValue) {
                          ref.read(orderAcceptTerms.notifier).state = newValue!;
                        },
                      );
                    },
                  ),
                  const Text("I agree to", style: TextStyle(fontSize: 16)),
                  CustomTextButton(
                    text: "Terms and Conditions",
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Payment button & state handling
              Center(
                child: paymentState.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (ref.read(orderAcceptTerms)) {
                            // Get current user
                            final user = ref.read(userProvider);
                            final addressState = ref.read(addressprovider);
                            final AddressModel? address =
                                addressState.addresses.isNotEmpty
                                ? addressState.addresses.last
                                : null;

                            if (user == null || address == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("User or address not found"),
                                ),
                              );
                              return;
                            }

                            // Start payment with required params
                            paymentController.startPayment(
                              amount: 1, // Replace with actual amount in paise
                              contact: address.phoneNumber.toString(),
                              email: user.email ?? "demo@example.com",
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please accept Terms & Conditions",
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text("Pay Now"),
                      ),
              ),

              // Show success or error message
              if (paymentState.success)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Payment Success! ID: ${paymentState.paymentId}",
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (paymentState.error != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Payment Failed: ${paymentState.error}",
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
