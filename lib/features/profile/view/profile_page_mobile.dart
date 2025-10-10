import 'package:flutter/material.dart';
import 'package:sadhana_cart/features/profile/widget/additional_info_card.dart';
import 'package:sadhana_cart/features/profile/widget/profile_card.dart';

class ProfilePageMobile extends StatelessWidget {
  const ProfilePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 50),
            ProfileCard(),
            SizedBox(height: 50),
            AdditionalInfoCard(),
          ],
        ),
      ),
    );
  }
}
