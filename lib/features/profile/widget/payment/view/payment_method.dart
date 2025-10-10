import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_text_button.dart';
import 'package:sadhana_cart/features/profile/widget/payment/view%20model/list_wallet_page.dart';
import 'package:sadhana_cart/features/profile/widget/payment/widget/add_payment_method.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Payment Method",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Card Management",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CustomTextButton(
                text: "Add New +",
                onPressed: () => navigateTo(
                  context: context,
                  screen: const AddPaymentMethod(),
                ),
                color: Colors.red,
              ),
            ],
          ),
          const ListWalletPage(),
        ],
      ),
    );
  }
}
