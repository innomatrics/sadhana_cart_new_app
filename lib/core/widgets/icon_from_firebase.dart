import 'package:flutter/material.dart';

class IconFromFirebase extends StatelessWidget {
  final int iconCode;

  const IconFromFirebase({super.key, required this.iconCode});

  @override
  Widget build(BuildContext context) {
    IconData iconData = IconData(iconCode, fontFamily: 'MaterialIcons');

    return Icon(iconData, size: 30, color: Colors.black);
  }
}
