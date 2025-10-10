import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductLoader extends StatelessWidget {
  final bool isGrid;
  const ProductLoader({super.key, this.isGrid = false});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Skeletonizer(
          child: SizedBox(
            height: size.height * 0.9,
            width: size.width,
            child: isGrid
                ? GridView.builder(
                    itemCount: 8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Skeletonizer(
                          child: Container(
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.height * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Container(
                                    height: 16,
                                    width: size.width * 0.3,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 6),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Container(
                                    height: 14,
                                    width: size.width * 0.2,
                                    color: Colors.grey[350],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Skeletonizer(
                          child: Container(
                            height: size.height * 0.3,
                            width: size.width * 0.45,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: size.height * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Container(
                                    height: 16,
                                    width: size.width * 0.3,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                const SizedBox(height: 6),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: Container(
                                    height: 14,
                                    width: size.width * 0.2,
                                    color: Colors.grey[350],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
