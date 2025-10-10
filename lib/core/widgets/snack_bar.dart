import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

TextStyle _snackbarTextStyle = const TextStyle(
  color: Colors.black87,
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

void showCustomSnackbar({
  required BuildContext context,
  required String message,
  String? subtitle,
  required ToastType type,
  bool displayIcon = true,
  Text? action,
}) {
  CherryToast toast;

  final titleWidget = Text(message, style: _snackbarTextStyle);
  final subtitleWidget = subtitle != null
      ? Text(
          subtitle,
          style: _snackbarTextStyle.copyWith(
            fontSize: 13,
            color: Colors.black54,
          ),
        )
      : null;

  switch (type) {
    case ToastType.success:
      toast = CherryToast.success(
        title: titleWidget,
        description: subtitleWidget,
        action: action,
        displayIcon: displayIcon,
        animationType: AnimationType.fromTop,
        animationDuration: const Duration(milliseconds: 400),
      );
      break;

    case ToastType.error:
      toast = CherryToast.error(
        title: titleWidget,
        description: subtitleWidget,
        action: action,
        displayIcon: displayIcon,
        animationType: AnimationType.fromTop,
        animationDuration: const Duration(milliseconds: 400),
      );
      break;

    case ToastType.info:
      toast = CherryToast.info(
        title: titleWidget,
        description: subtitleWidget,
        action: action,
        displayIcon: displayIcon,
        animationType: AnimationType.fromTop,
        animationDuration: const Duration(milliseconds: 400),
      );
      break;
  }

  toast.show(context);
}

enum ToastType { success, error, info }
