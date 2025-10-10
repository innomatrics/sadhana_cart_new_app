import 'package:animate_do/animate_do.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20repo/auth/onboard_notifier.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/oboard_button.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_bar_mobile.dart';
import 'package:sadhana_cart/features/onboard/model/onboard_model.dart';
import 'package:sadhana_cart/features/onboard/view%20model/onboard_view_model.dart';

class OnboardPageModel extends ConsumerStatefulWidget {
  const OnboardPageModel({super.key});

  @override
  ConsumerState<OnboardPageModel> createState() => _OnboardPageModelState();
}

class _OnboardPageModelState extends ConsumerState<OnboardPageModel> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentIndex = ref.watch(onboardDotController);

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.white),
          Positioned(
            top: size.height * 0.50,
            child: Container(
              height: size.height * 0.50,
              width: size.width,
              color: AppColor.primaryColor,
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: onboardData.length,
            onPageChanged: (index) {
              ref.read(onboardDotController.notifier).state = index;
            },
            itemBuilder: (context, index) {
              final item = onboardData[index];
              return Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    SlideInRight(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideInRight(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      height: size.height * 0.5,
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: AppColor.onboardGreyColor,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(item.imagePath),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 180,
            child: DotsIndicator(
              dotsCount: onboardData.length,
              position: currentIndex.toDouble(),
              decorator: const DotsDecorator(
                activeColor: Colors.white,
                color: Colors.grey,
              ),
              onTap: (index) {
                ref.read(onboardDotController.notifier).state = index;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Positioned(
            bottom: 100,
            child: OboardButton(
              text: currentIndex == onboardData.length - 1
                  ? "Start Shopping"
                  : "Next",
              onPressed: () async {
                final currentIndex = ref.read(onboardDotController);
                if (currentIndex < onboardData.length - 1) {
                  ref.read(onboardDotController.notifier).state++;
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  if (context.mounted) {
                    ref.read(onboardProvider.notifier).setSeen();
                    navigateToReplacement(
                      context: context,
                      screen: const BottomNavBarMobile(),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

final List<Widget> onboardPages = [
  const OnboardPageModel(),
  const OnboardPageModel(),
  const OnboardPageModel(),
];
