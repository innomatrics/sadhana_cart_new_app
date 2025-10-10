import 'package:flutter/material.dart';

enum CardColorsEnum {
  black,
  platinum,
  gold,
  silver,
  blue,
  green,
  red,
  purple,
  titanium,
  roseGold,
  bronze,
  transparent,
  metal,
  gray,
  yellow,
  orange,
  teal,
  navy,
}

extension CardColorExtension on CardColorsEnum {
  Color get color {
    switch (this) {
      case CardColorsEnum.black:
        return const Color(0xFF000000);
      case CardColorsEnum.platinum:
        return const Color(0xFFE5E4E2);
      case CardColorsEnum.gold:
        return const Color(0xFFFFD700);
      case CardColorsEnum.silver:
        return const Color(0xFFC0C0C0);
      case CardColorsEnum.blue:
        return const Color(0xFF2196F3);
      case CardColorsEnum.green:
        return const Color(0xFF4CAF50);
      case CardColorsEnum.red:
        return const Color(0xFFF44336);
      case CardColorsEnum.purple:
        return const Color(0xFF9C27B0);
      case CardColorsEnum.titanium:
        return const Color(0xFF8D918D);
      case CardColorsEnum.roseGold:
        return const Color(0xFFB76E79);
      case CardColorsEnum.bronze:
        return const Color(0xFFCD7F32);
      case CardColorsEnum.transparent:
        return const Color(0x00000000);
      case CardColorsEnum.metal:
        return const Color(0xFFB0B0B0);
      case CardColorsEnum.gray:
        return const Color(0xFF9E9E9E);
      case CardColorsEnum.yellow:
        return const Color(0xFFFFEB3B);
      case CardColorsEnum.orange:
        return const Color(0xFFFF9800);
      case CardColorsEnum.teal:
        return const Color(0xFF009688);
      case CardColorsEnum.navy:
        return const Color(0xFF000080);
    }
  }
}

extension CardColorsEnumExtension on CardColorsEnum {
  String get label {
    switch (this) {
      case CardColorsEnum.black:
        return "Black";
      case CardColorsEnum.platinum:
        return "Platinum";
      case CardColorsEnum.gold:
        return "Gold";
      case CardColorsEnum.silver:
        return "Silver";
      case CardColorsEnum.blue:
        return "Blue";
      case CardColorsEnum.green:
        return "Green";
      case CardColorsEnum.red:
        return "Red";
      case CardColorsEnum.purple:
        return "Purple";
      case CardColorsEnum.titanium:
        return "Titanium";
      case CardColorsEnum.roseGold:
        return "Rose Gold";
      case CardColorsEnum.bronze:
        return "Bronze";
      case CardColorsEnum.transparent:
        return "Transparent";
      case CardColorsEnum.metal:
        return "Metal";
      case CardColorsEnum.gray:
        return "Gray";
      case CardColorsEnum.yellow:
        return "Yellow";
      case CardColorsEnum.orange:
        return "Orange";
      case CardColorsEnum.teal:
        return "Teal";
      case CardColorsEnum.navy:
        return "Navy";
    }
  }
}
