import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/auth%20service/auth_service.dart';
import 'package:sadhana_cart/core/common%20repo/auth/auth_notifier.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/favorites/view/favorite_page_mobile.dart';
import 'package:sadhana_cart/features/onboard/view/onboard_page_mobile.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/view/my_orders_page.dart';
import 'package:sadhana_cart/features/profile/widget/address/view/user_address_page.dart';

class AdditionalInfoCard extends ConsumerWidget {
  const AdditionalInfoCard({super.key});

  void _handleProtectedRoute({
    required WidgetRef ref,
    required BuildContext context,
    required Widget screen,
  }) {
    final isLoggedIn = ref.read(authNotifierProvider);
    if (!isLoggedIn) {
      showCustomSnackbar(
        context: context,
        message: "Please login first",
        type: ToastType.info,
      );
      return;
    }
    navigateTo(context: context, screen: screen);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _customTile(
            icon: const Icon(Icons.location_on),
            text: "Address",
            onTap: () => _handleProtectedRoute(
              ref: ref,
              context: context,
              screen: const UserAddressPage(),
            ),
          ),
          Divider(color: Colors.grey.shade300),
          _customTile(
            icon: const Icon(Icons.history),
            text: "My Orders",
            onTap: () => _handleProtectedRoute(
              ref: ref,
              context: context,
              screen: const MyOrdersPage(),
            ),
          ),
          Divider(color: Colors.grey.shade300),
          _customTile(
            icon: const Icon(Icons.favorite),
            text: "Wishlist",
            onTap: () => _handleProtectedRoute(
              ref: ref,
              context: context,
              screen: const FavoritePageMobile(),
            ),
          ),
          Divider(color: Colors.grey.shade300),
          _customTile(
            icon: const Icon(Icons.logout),
            text: "Logout",
            onTap: () async {
              await AuthService.signOut(ref: ref, context: context);
              if (context.mounted) {
                ref.read(authNotifierProvider.notifier).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardPageMobile(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _customTile({
    required Icon icon,
    required String text,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: icon,
      onTap: onTap,
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: trailing,
    );
  }
}
