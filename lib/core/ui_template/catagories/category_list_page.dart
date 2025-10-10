import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class CategoryListPage extends StatelessWidget {
  final String title;
  final List<ProductModel> products;

  const CategoryListPage({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      // body: products.isEmpty
      //     ? const Center(
      //         child: Text("No products found", style: TextStyle(fontSize: 16)),
      //       )
      //     : ListView.separated(
      //         padding: const EdgeInsets.all(8),
      //         itemCount: products.length,
      //         separatorBuilder: (context, index) =>
      //             const Divider(height: 1, color: Colors.grey),
      //         itemBuilder: (context, index) {
      //           final product = products[index];
      //           return GestureDetector(
      //             onTap: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) =>
      //                       ProductDetailPage(product: product),
      //                 ),
      //               );
      //             },
      //             child: Container(
      //               padding: const EdgeInsets.symmetric(
      //                 horizontal: 12,
      //                 vertical: 10,
      //               ),
      //               color: Colors.white,
      //               child: Row(
      //                 children: [
      //                   // Product Image
      //                   ClipRRect(
      //                     borderRadius: BorderRadius.circular(8),
      //                     child: Image.network(
      //                       product.images.first,
      //                       width: 90,
      //                       height: 90,
      //                       fit: BoxFit.cover,
      //                     ),
      //                   ),
      //                   const SizedBox(width: 12),

      //                   // Product Info
      //                   Expanded(
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           product.name,
      //                           maxLines: 2,
      //                           overflow: TextOverflow.ellipsis,
      //                           style: const TextStyle(
      //                             fontSize: 16,
      //                             fontWeight: FontWeight.w600,
      //                             color: Colors.black87,
      //                           ),
      //                         ),
      //                         const SizedBox(height: 6),
      //                         Text(
      //                           "₹ ${product.price}",
      //                           style: const TextStyle(
      //                             fontSize: 16,
      //                             fontWeight: FontWeight.bold,
      //                             color: Colors.green,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),

      //                   // Arrow Icon
      //                   const Icon(
      //                     Icons.arrow_forward_ios,
      //                     size: 18,
      //                     color: Colors.grey,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       ),
    );
  }
}
