import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Terms of Use',
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
            const SizedBox(height: 32),

            // Section for User Accounts
            _infoCard(
              title: "1. User Accounts",
              icon: Icons.account_circle,
              content:
                  "• You must register an account to make purchases or sell products\n"
                  "• You are responsible for maintaining the confidentiality of your account\n"
                  "• You must provide accurate and complete information",
            ),
            const SizedBox(height: 24),

            // Section for Vendor Responsibilities
            _infoCard(
              title: "2. Vendor Responsibilities",
              icon: Icons.business,
              content:
                  "• Vendors must ensure their products are legal, genuine, and as described\n"
                  "• Vendors are responsible for order fulfillment, returns, and refunds\n"
                  "• Vendors must comply with all applicable laws and regulations",
            ),
            const SizedBox(height: 24),

            // Section for Purchases and Payments
            _infoCard(
              title: "3. Purchases and Payments",
              icon: Icons.payment,
              content:
                  "• All purchases made through the app are subject to availability\n"
                  "• We use secure third-party payment gateways for processing\n"
                  "• Prices are subject to change without notice",
            ),
            const SizedBox(height: 24),

            // Section for Prohibited Activities
            _infoCard(
              title: "4. Prohibited Activities",
              icon: Icons.block,
              content:
                  "• Posting or selling counterfeit or restricted items\n"
                  "• Attempting to hack or disrupt the platform\n"
                  "• Using automated tools to access data or manipulate listings",
            ),
            const SizedBox(height: 24),

            // Section for Intellectual Property
            _infoCard(
              title: "5. Intellectual Property",
              icon: Icons.lock_outline,
              content:
                  "• All content, logos, and trademarks are owned by us or our partners\n"
                  "• Users may not copy or reproduce app content without permission\n"
                  "• Vendors retain ownership of their product listings and images",
            ),
            const SizedBox(height: 24),

            // Section for Termination
            _infoCard(
              title: "6. Termination",
              icon: Icons.exit_to_app,
              content:
                  "• We reserve the right to suspend or terminate accounts for violations\n"
                  "• Terminated users may lose access to their data or listings\n"
                  "• Users may appeal termination decisions through our support system",
            ),
            const SizedBox(height: 24),

            // Section for Limitation of Liability
            _infoCard(
              title: "7. Limitation of Liability",
              icon: Icons.warning,
              content:
                  "• We are not liable for any damages arising from use of the app\n"
                  "• All transactions are between vendors and customers directly\n"
                  "• We provide the platform but do not guarantee product quality or delivery",
            ),
            const SizedBox(height: 32),

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
            blurRadius: 6,
            offset: const Offset(0, 4),
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
