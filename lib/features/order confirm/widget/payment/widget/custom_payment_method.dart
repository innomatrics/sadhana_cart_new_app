import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';

class CustomPaymentMethod extends ConsumerWidget {
  final String image;
  final String title;
  final int? index;
  const CustomPaymentMethod({
    super.key,
    required this.image,
    required this.title,
    this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(orderStepperPageProvider);
    final isSelected = index == currentIndex;
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.1,
      width: size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
          color: isSelected ? Colors.black : Colors.transparent,
          width: isSelected ? 1.4 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          SizedBox(
            height: 50,
            width: 100,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

List<String> paymentMethodTitle = ["Cash", "Card"];

List<String> paymentMethodImage = [AppImages.money, AppImages.creditCard];
