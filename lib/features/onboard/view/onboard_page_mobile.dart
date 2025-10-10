import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/features/onboard/model/onboard_page_model.dart';
import 'package:sadhana_cart/features/onboard/view%20model/onboard_view_model.dart';

class OnboardPageMobile extends ConsumerStatefulWidget {
  const OnboardPageMobile({super.key});

  @override
  ConsumerState<OnboardPageMobile> createState() => _OnboardPageMobileState();
}

class _OnboardPageMobileState extends ConsumerState<OnboardPageMobile> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final currentIndex = ref.read(onboardDotController);
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void didUpdateWidget(covariant OnboardPageMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentIndex = ref.read(onboardDotController);
    _pageController.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: onboardPages,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
