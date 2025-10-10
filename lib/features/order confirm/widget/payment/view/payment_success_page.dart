import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_bar_mobile.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomElevatedButton(
            child: const Text(
              "Go to Home",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () {
              navigateToReplacement(
                context: context,
                screen: const BottomNavBarMobile(),
              );
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    width: size.width * 0.6,
                    child: Lottie.asset(AppImages.successLottie),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Your order is on the way!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Thank you for shopping with us. Your order has been placed successfully.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
