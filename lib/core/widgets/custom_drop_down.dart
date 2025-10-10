import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final T value;
  final String labelText;
  final bool showBorder;
  const CustomDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
    required this.labelText,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: items,
      initialValue: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        border: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
        focusedBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
        enabledBorder: showBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
      ),
    );
  }
}
