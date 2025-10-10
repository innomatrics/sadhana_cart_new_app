import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressTileLoader extends StatelessWidget {
  const AddressTileLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Skeletonizer(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        height: size.height * 0.15,
        width: size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.add_reaction),
              title: Text("This is address placeholder"),
              subtitle: Text("This is address placeholder"),
            ),
          ],
        ),
      ),
    );
  }
}
