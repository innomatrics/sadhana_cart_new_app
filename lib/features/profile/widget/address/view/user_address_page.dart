import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/features/profile/widget/address/widget/add_address_page.dart';
import 'package:sadhana_cart/features/profile/widget/address/widget/user_address_data.dart';

class UserAddressPage extends StatelessWidget {
  const UserAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Saved Addresses",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0.0,
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          navigateTo(context: context, screen: const AddAddressPage());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: const UserAddressData(),
    );
  }
}
