import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final Color iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final bool showBorder;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Search',
    this.onChanged,
    this.onTap,
    this.controller,
    this.backgroundColor,
    this.iconColor = Colors.grey,
    this.borderRadius = 30.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.elevation = 2,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(borderRadius),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: iconColor),
          prefixIcon: Icon(Icons.search, color: iconColor),
          filled: true,
          fillColor: backgroundColor,
          contentPadding: padding,
          border: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                    color: AppColor.onboardButtonColor,
                    width: 1.2,
                  ),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
          focusedBorder: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                    color: AppColor.onboardButtonColor,
                    width: 1.2,
                  ),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),

          enabledBorder: showBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(
                    color: AppColor.onboardButtonColor,
                    width: 1.2,
                  ),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: BorderSide.none,
                ),
        ),
      ),
    );
  }
}
