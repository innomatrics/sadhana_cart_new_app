import 'package:flutter/material.dart';

class WidgetTemplate {
  static const Color textColor = Color(0xff87898D);
  static Widget productDetailsRowTemplate({
    required String title,
    required String value,
    required bool isGiveSpaceAtlast,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Text(
              value,
              style: const TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          isGiveSpaceAtlast
              ? const SizedBox(width: 40)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
