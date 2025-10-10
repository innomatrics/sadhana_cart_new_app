import 'package:flutter/material.dart';

class ResponsiveScreen extends StatelessWidget {
  final Widget mobileScreen;
  final Widget tabletScreen;
  const ResponsiveScreen({
    super.key,
    required this.mobileScreen,
    required this.tabletScreen,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return tabletScreen;
        } else {
          return mobileScreen;
        }
      },
    );
  }
}
