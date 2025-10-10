import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class CustomProgressIndicator extends StatelessWidget {
  final List<Map<String, dynamic>> ratingData;

  const CustomProgressIndicator({super.key, required this.ratingData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ratingData.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final rating = ratingData[index];
        final ratingStars = rating['stars'];
        final percentage = rating['percentage'] / 100.0;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(
                "$ratingStars",
                style: const TextStyle(
                  color: AppColor.onboardButtonColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.star, color: AppColor.ratingColor),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColor.switchTileColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColor.ratingColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // Percentage text
              Text(
                "${(percentage * 100).toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: AppColor.ratingColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
