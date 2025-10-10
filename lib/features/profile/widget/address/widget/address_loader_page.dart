import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressLoaderPage extends StatelessWidget {
  const AddressLoaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Skeletonizer(
        child: ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              height: size.height * 0.15,
              width: size.width * 1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.home, size: 40),
                    title: Text("This is for address"),
                    subtitle: Text("This is for city"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "address.streetName",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
