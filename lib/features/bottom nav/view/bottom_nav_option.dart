import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/responsive/responsive_screen.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_bar_mobile.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_tablet.dart';

class BottomNavOption extends StatelessWidget {
  const BottomNavOption({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveScreen(
      mobileScreen: BottomNavBarMobile(),
      tabletScreen: BottomNavTablet(),
    );
  }
}
