import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class PaymentOptionTile extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final bool selected;
  final VoidCallback onTap;
  const PaymentOptionTile({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColor.dartPrimaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColor.dartPrimaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.dartPrimaryColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
