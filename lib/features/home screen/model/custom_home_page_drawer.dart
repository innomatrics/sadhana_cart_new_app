import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20model/customer/customer_model.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/drawer_content.dart';
import 'package:sadhana_cart/features/profile/view%20model/user_notifier.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomHomePageDrawer extends ConsumerWidget {
  const CustomHomePageDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(getCurrentUserProfile);

    return Drawer(
      backgroundColor: Colors.white,
      child: userAsync.when(
        loading: () =>
            const Skeletonizer(enabled: true, child: DrawerContent()),

        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Failed to load user profile: $error'),
          ),
        ),

        data: (user) {
          final isLoggedIn = ref.read(authNotifierProvider);
          if (!isLoggedIn) {
            return const Center(child: Text("No User Logged In"));
          }

          if (user is CustomerModel) {
            return DrawerContent(user: user);
          } else {
            return const Center(child: Text("No User Logged In"));
          }
        },
      ),
    );
  }
}
