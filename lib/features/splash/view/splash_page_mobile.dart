import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/features/onboard/view/onboard_page_mobile.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_option.dart';
import 'package:sadhana_cart/core/common%20repo/auth/onboard_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';

class SplashPageMobile extends ConsumerStatefulWidget {
  const SplashPageMobile({super.key});

  @override
  ConsumerState<SplashPageMobile> createState() => _SplashPageMobileState();
}

class _SplashPageMobileState extends ConsumerState<SplashPageMobile> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    log("Splash: Starting splash init...");

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      log(" Splash: Not mounted, exit.");
      return;
    }

    try {
      final hasSeenOnboard = await ref.read(onboardProvider.future);
      log("onboarding data: hasSeenOnboard = $hasSeenOnboard");

      if (!mounted) {
        log("not mounted after onboarding data");
        return;
      }

      if (!hasSeenOnboard) {
        log("navigating to OnboardPage");
        navigateToReplacement(
          context: context,
          screen: const OnboardPageMobile(),
        );
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      log("Firebase user: $user");

      if (user != null) {
        ref.read(authNotifierProvider.notifier).login();
        log("Set auth logged in true");
      } else {
        ref.read(authNotifierProvider.notifier).logout();
        log("Set auth logged in false");
      }

      log("navigating to BottomNavOption");
      navigateToReplacement(context: context, screen: const BottomNavOption());
    } catch (e) {
      log("onboarding error: $e");
      if (!mounted) return;
      navigateToReplacement(
        context: context,
        screen: const OnboardPageMobile(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.appLogo, height: size.height * 0.15),
            const SizedBox(height: 20),
            const Loader(),
          ],
        ),
      ),
    );
  }
}
