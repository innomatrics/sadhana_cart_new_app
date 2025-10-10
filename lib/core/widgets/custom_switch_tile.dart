import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class CustomSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool)? onChanged;
  const CustomSwitchTile({
    super.key,
    required this.value,
    this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColor.switchTileColor,
      thumbColor: WidgetStateProperty.all<Color>(Colors.white),
      inactiveTrackColor: const Color(0xffCBCDD8),
      title: Text(
        title,
        style: const TextStyle(color: AppColor.dartPrimaryColor),
      ),
    );
  }
}
