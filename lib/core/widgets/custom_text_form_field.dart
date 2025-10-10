import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String labelText;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final int? maxLength;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool isShowBorder;
  final int maxLine;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;
  final Iterable<String>? autofillHints;
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.validator,
    required this.labelText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.suffixIcon,
    this.obscureText = false,
    this.isShowBorder = false,
    this.maxLine = 1,
    this.contentPadding = const EdgeInsets.all(0),
    this.hintText,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLine,
      obscureText: obscureText,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        contentPadding: contentPadding,
        counterText: "",
        prefixIcon: prefixIcon,
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        border: isShowBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
        focusedBorder: isShowBorder
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
        enabledBorder: isShowBorder
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
