import 'package:flutter/material.dart';

enum AddressIconType {
  home,
  office,
  hospital,
  school,
  grocery,
  apartment,
  cafe,
  library,
}

extension AddressIconTypeExtension on AddressIconType {
  IconData get icon {
    switch (this) {
      case AddressIconType.home:
        return Icons.home;
      case AddressIconType.office:
        return Icons.business_center;
      case AddressIconType.hospital:
        return Icons.local_hospital;
      case AddressIconType.school:
        return Icons.school;
      case AddressIconType.grocery:
        return Icons.local_grocery_store;
      case AddressIconType.apartment:
        return Icons.apartment;
      case AddressIconType.cafe:
        return Icons.local_cafe;
      case AddressIconType.library:
        return Icons.local_library;
    }
  }

  String get label {
    switch (this) {
      case AddressIconType.home:
        return "Home";
      case AddressIconType.office:
        return "Office";
      case AddressIconType.hospital:
        return "Hospital";
      case AddressIconType.school:
        return "School";
      case AddressIconType.grocery:
        return "Grocery Store";
      case AddressIconType.apartment:
        return "Apartment";
      case AddressIconType.cafe:
        return "Cafe";
      case AddressIconType.library:
        return "Library";
    }
  }
}
