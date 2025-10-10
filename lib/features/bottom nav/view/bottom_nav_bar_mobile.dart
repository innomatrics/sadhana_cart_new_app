import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/features/bottom%20nav/model/bottom_nav_model.dart';
import 'package:sadhana_cart/features/bottom%20nav/view%20model/bottom_view_model.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class BottomNavBarMobile extends ConsumerWidget {
  const BottomNavBarMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavigationBarIndex);
    return Scaffold(
      bottomNavigationBar: StylishBottomBar(
        borderRadius: BorderRadius.circular(20),
        backgroundColor: const Color(0xffFFFFFF),
        currentIndex: currentIndex,
        items: bottomBarItems,
        option: AnimatedBarOptions(iconStyle: IconStyle.animated),
        onTap: (int index) {
          ref.read(bottomNavigationBarIndex.notifier).state = index;
        },
      ),
      body: bottomPages[currentIndex],
    );
  }
}
