import 'package:flutter/material.dart';
import 'package:sadhana_cart/features/auth/view/forgot%20password/view/forgot_password_mobile.dart';
import 'package:sadhana_cart/features/auth/view/sign%20up/view/sign_in_mobile.dart';
import 'package:sadhana_cart/features/auth/view/sign%20up/view/sign_up_mobile.dart';
import 'package:sadhana_cart/features/bottom%20nav/view/bottom_nav_bar_mobile.dart';
import 'package:sadhana_cart/features/cart/view/cart_page_mobile.dart';
import 'package:sadhana_cart/features/favorites/view/favorite_page_mobile.dart';
import 'package:sadhana_cart/features/home%20screen/view/home_page_mobile.dart';
import 'package:sadhana_cart/features/notification/view/notification_page_mobile.dart';
import 'package:sadhana_cart/features/order/widgets/my%20orders/view/my_orders_page.dart';
import 'package:sadhana_cart/features/search%20product/view/search_product_mobile.dart';
import 'package:sadhana_cart/features/splash/view/splash_page_mobile.dart';

class AppRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    '/sign-in': (_) => const SignInMobile(),
    '/sign-up': (_) => const SignUpMobile(),
    '/forgot-password': (_) => const ForgotPasswordMobile(),
    '/bottom-nav': (_) => const BottomNavBarMobile(),
    '/cart': (_) => const CartPageMobile(),
    '/favourites': (_) => const FavoritePageMobile(),
    'notifications': (_) => const NotificationPageMobile(),
    '/search': (_) => const SearchProductMobile(),
    '/homepage': (_) => const HomePageMobile(),
    '/order': (_) => const MyOrdersPage(),
    '/splash': (_) => const SplashPageMobile(),
    '/signup': (_) => const SignUpMobile(),
  };
}
