import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20services/chat_support/chat_service.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/settings/view/chat_support_page.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/settings/view/privacy_policy_page.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/settings/view/terms_of_use_page.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/settings/widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> openChatSupport(BuildContext context) async {
    log("openChatSupport: Start");

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: Loader()),
    );
    log("openChatSupport: Loading indicator shown");

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      // support is your admin id (adjust as needed)
      const supportId = "support";

      // Get or create conversation between user and support
      log("openChatSupport: Attempting to get or create conversation for user");
      final chatId = await ChatService.getOrCreateConversation(supportId);
      log("openChatSupport: Conversation obtained with ID: $chatId");

      // Close loading indicator
      if (context.mounted) {
        navigateBack(context: context);
      }
      log("openChatSupport: Loading indicator dismissed");

      // Navigate to chat page
      log("openChatSupport: Navigating to ChatSupportPage");
      if (context.mounted) {
        navigateTo(
          context: context,
          screen: ChatSupportPage(chatId: chatId),
        );
      }
      log("openChatSupport: Navigation complete");
    } catch (e, stackTrace) {
      if (context.mounted) {
        navigateBack(context: context);
      }
      log("openChatSupport: Failed to open chat - $e", stackTrace: stackTrace);
      if (context.mounted) {
        showCustomSnackbar(
          context: context,
          message: e.toString(),
          type: ToastType.error,
        );
      }
    }

    log("openChatSupport: End");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // SettingsTile(
            //   icon: Icons.notifications,
            //   text: "Notifications",
            //   onTap: () => navigateTo(
            //     context: context,
            //     screen: const NotificationPage(),
            //   ),
            // ),
            SettingsTile(
              icon: Icons.policy,
              text: "Terms of Use",
              onTap: () =>
                  navigateTo(context: context, screen: const TermsOfUsePage()),
            ),
            SettingsTile(
              icon: Icons.privacy_tip_outlined,
              text: "Privacy Policy",
              onTap: () => navigateTo(
                context: context,
                screen: const PrivacyPolicyPage(),
              ),
            ),
            SettingsTile(
              icon: Icons.chat,
              text: "Chat Support",
              onTap: () => openChatSupport(context),
            ),
          ],
        ),
      ),
    );
  }
}
