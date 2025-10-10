import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SubcategoryLoader extends StatelessWidget {
  const SubcategoryLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Subcategory",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Subcategory",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Subcategory',
                            style: TextStyle(fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
