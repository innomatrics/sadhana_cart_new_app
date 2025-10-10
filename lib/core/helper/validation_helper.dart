import 'package:flutter/material.dart';

class ValidationHelper {
  static FormFieldValidator<String> validateTextField({required String text}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return "$text is required";
      }
      return null;
    };
  }

  static String? Function(String?)? emailValidate() {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter an email';
      } else if (!emailRegex.hasMatch(value.trim())) {
        return 'Please enter a valid email';
      }
      return null;
    };
  }

  static String? Function(String?)? passwordValidate({required int number}) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter a password';
      } else if (value.length < 8) {
        return 'Please enter a valid password';
      }
      return null;
    };
  }

  static String? Function(String?)? validateMobileNumber({
    required int number,
  }) {
    if (number < 10) {
      return (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a mobile number';
        } else if (value.length != 10) {
          return 'Please enter a valid mobile number';
        }
        return null;
      };
    }
    return null;
  }
}
