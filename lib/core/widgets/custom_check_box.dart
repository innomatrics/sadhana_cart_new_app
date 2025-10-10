import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  const CustomCheckBox({super.key, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      activeColor: Colors.black,
      value: value,
      onChanged: onChanged,
    );
  }
}
