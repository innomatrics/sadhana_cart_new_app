import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "About Us",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Welcome to Sadhana Cart",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _infoCard(
              title: "Our Mission",
              icon: Icons.flag,
              content:
                  "To empower small businesses and independent sellers by providing them with the tools and exposure they need to grow online.",
            ),
            const SizedBox(height: 16),

            _infoCard(
              title: "Our Vision",
              icon: Icons.visibility,
              content:
                  "To become the most trusted and user-friendly platform for small business owners and independent sellers to sell their products online.",
            ),
            const SizedBox(height: 16),

            _infoCard(
              title: "Our Values",
              icon: Icons.favorite,
              content:
                  "Integrity, reliability, and customer-first approach in every step we take. We value small businesses and their growth.",
            ),
            const SizedBox(height: 24),

            const Center(
              child: Text(
                "Join us today and start your journey!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColor.dartPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: AppColor.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
