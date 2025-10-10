import 'package:flutter/material.dart';
import 'package:sadhana_cart/features/favorites/widgets/favorite_product_tile.dart';

class FavoritePageMobile extends StatelessWidget {
  const FavoritePageMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Wishlist",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [Expanded(child: FavoriteProductTile())]),
      ),
    );
  }
}
