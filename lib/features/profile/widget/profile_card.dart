import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/loader.dart';
import 'package:sadhana_cart/features/auth/view/sign%20up/view/sign_in_mobile.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final userAsync = ref.watch(getCurrentUserProfile);
    return Skeletonizer(
      enabled: userAsync.isLoading,
      child: Container(
        height: size.height * 0.15,
        width: size.width,
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
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Profile Image
            Container(
              height: size.height * 0.1,
              width: size.width * 0.2,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: userAsync.when(
                loading: () => const SizedBox(),
                error: (e, _) =>
                    Image.asset(AppImages.noProfile, fit: BoxFit.cover),
                data: (data) {
                  final imageUrl = data?.profileImage;
                  if (imageUrl != null && imageUrl.isNotEmpty) {
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Loader(),
                      errorWidget: (context, url, error) =>
                          Image.asset(AppImages.noProfile, fit: BoxFit.cover),
                    );
                  } else {
                    return Image.asset(AppImages.noProfile, fit: BoxFit.cover);
                  }
                },
              ),
            ),

            const SizedBox(width: 16),

            // Profile Info
            Expanded(
              child: userAsync.when(
                loading: () => const ListTile(
                  title: Text("John Doe"),
                  subtitle: Text("john@example.com"),
                  trailing: Icon(Icons.settings),
                ),
                error: (error, stackTrace) =>
                    const Center(child: Text("Failed to load profile")),
                data: (data) {
                  if (data == null) {
                    return ListTile(
                      title: const Text("Not logged in"),
                      subtitle: const Text("Please sign in"),
                      trailing: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => navigateTo(
                          context: context,
                          screen: const SignInMobile(),
                        ),
                      ),
                    );
                  }

                  final name = data.name ?? "Unknown";
                  final email = data.email ?? "Not available";
                  // final contact = data?.contactNo;
                  // final profileImage = data?.profileImage;
                  // final gender = data?.gender;
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(email),
                    // trailing: IconButton(
                    //   icon: const Icon(Icons.settings),
                    //   onPressed: () {
                    //     navigateTo(
                    //       context: context,
                    //       screen: EditProfileSettings(
                    //         name: name,
                    //         contactNo: contact ?? 0,
                    //         profileImage: profileImage ?? "",
                    //         gender: gender ?? GenderEnum.none.label,
                    //       ),
                    //     );
                    //   },
                    // ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
