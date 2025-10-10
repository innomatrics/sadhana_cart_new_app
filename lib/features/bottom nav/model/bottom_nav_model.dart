import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/features/cart/view/cart_page_mobile.dart';
import 'package:sadhana_cart/features/home%20screen/view/home_page_mobile.dart';
import 'package:sadhana_cart/features/profile/view/profile_page_mobile.dart';
import 'package:sadhana_cart/features/search%20product/view/search_product_mobile.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

List<BottomBarItem> bottomBarItems = [
  BottomBarItem(
    icon: const Icon(Icons.home),
    title: const Text("Home"),
    selectedColor: AppColor.primaryColor,
    selectedIcon: const Icon(Icons.home),
  ),
  BottomBarItem(
    icon: const Icon(Icons.search),
    title: const Text("Search"),
    selectedColor: AppColor.primaryColor,
    selectedIcon: const Icon(Icons.search),
  ),
  BottomBarItem(
    icon: const Icon(Icons.shopping_bag),
    title: const Text("Cart"),
    selectedColor: AppColor.primaryColor,
    selectedIcon: const Icon(Icons.shopping_bag),
  ),
  BottomBarItem(
    icon: const Icon(Icons.person),
    title: const Text("Profile"),
    selectedColor: AppColor.primaryColor,
    selectedIcon: const Icon(Icons.person),
  ),
];

final List<Widget> bottomPages = [
  const HomePageMobile(),
  SearchProductMobile(
    appBar: AppBar(
      backgroundColor: AppColor.pureWhite,
      centerTitle: true,
      title: const Text(
        "Discover Something New",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  CartPageMobile(
    appBar: AppBar(
      backgroundColor: AppColor.pureWhite,
      centerTitle: true,
      title: const Text(
        "Your Cart",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  const ProfilePageMobile(),
];
