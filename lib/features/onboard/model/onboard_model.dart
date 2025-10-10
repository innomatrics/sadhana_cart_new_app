import 'package:sadhana_cart/core/constants/app_images.dart';

class OnboardModel {
  final String title;
  final String subtitle;
  final String imagePath;
  OnboardModel({
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

final List<OnboardModel> onboardData = [
  OnboardModel(
    title: "Discover Something New",
    subtitle: "Special New Arrival",
    imagePath: AppImages.onboard1,
  ),
  OnboardModel(
    title: "Update Your Style",
    subtitle: "Favorite Collection",
    imagePath: AppImages.onboard2,
  ),
  OnboardModel(
    title: "Explore Something New",
    subtitle: "Relax and let us bring you something new",
    imagePath: AppImages.onboard3,
  ),
];
