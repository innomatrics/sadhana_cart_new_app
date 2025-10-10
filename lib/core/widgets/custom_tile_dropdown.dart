import 'package:flutter/material.dart';

class CustomTileDropdown extends StatelessWidget {
  final String title;
  final Widget value;
  const CustomTileDropdown({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(side: BorderSide.none),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [Padding(padding: const EdgeInsets.all(10.0), child: value)],
    );
  }
}
