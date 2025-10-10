import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';

class CustomRatioButton<T> extends StatelessWidget {
  final T groupValue;
  final T value;
  final void Function(T?)? onChanged;
  const CustomRatioButton({
    super.key,
    required this.value,
    this.onChanged,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return Radio.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: AppColor.primaryColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      groupValue: groupValue,
      focusColor: AppColor.primaryColor,
      hoverColor: AppColor.primaryColor,
      splashRadius: 0.0,
    );
  }
}
