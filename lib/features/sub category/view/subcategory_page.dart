import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/product/category_products_notifier.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/helper/cache_manager_helper.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/helper/storage_key.dart';
import 'package:sadhana_cart/core/skeletonizer/image_loader.dart';
import 'package:sadhana_cart/core/skeletonizer/product_grid_loader.dart';
import 'package:sadhana_cart/core/widgets/custom_search_field.dart';
import 'package:sadhana_cart/core/common%20model/product/product_model.dart';

class SubcategoryPage extends ConsumerStatefulWidget {
  final String categoryName;
  const SubcategoryPage({super.key, required this.categoryName});

  @override
  ConsumerState<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends ConsumerState<SubcategoryPage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        ref
            .read(categoryProductProvider(widget.categoryName).notifier)
            .fetchProducts();
      }
    });

    searchController.addListener(() {
      ref
          .read(categoryProductProvider(widget.categoryName).notifier)
          .filter(query: searchController.text.trim());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(categoryProductProvider(widget.categoryName));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSearchBar(
              controller: searchController,
              backgroundColor: Colors.white,
              hintText: "Search...",
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (products.isLoading && products.products.isEmpty) {
                    // loading
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return const ProductGridLoader();
                      },
                    );
                  }

                  if (!products.isLoading && products.products.isEmpty) {
                    // No products
                    return const Center(
                      child: Text(
                        "No products found",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  //Products
                  return GridView.builder(
                    key: PageStorageKey(
                      "${StorageKey.productsByCategoryKey}${widget.categoryName}",
                    ),
                    controller: scrollController,
                    itemCount:
                        products.products.length + (products.isLoading ? 1 : 0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                    itemBuilder: (context, index) {
                      if (index == products.products.length) {
                        return const ProductGridLoader();
                      }
                      final ProductModel product = products.products[index];
                      return buildProductCard(product, size);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(ProductModel product, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                log(product.category ?? "No Category");
                log(product.productid!);
                navigateToProductDesignBasedOnCategory(
                  context: context,
                  categoryName: product.category?.toLowerCase() ?? "",
                  product: product,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: CachedNetworkImage(
                        imageUrl: product.images?.isNotEmpty == true
                            ? product.images![0]
                            : "",
                        errorWidget: (context, _, _) => const ImageLoader(),
                        placeholder: (context, _) => const ImageLoader(),
                        height: size.height * 0.20,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        cacheManager: CustomCacheManager.cacheManager,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                product.name ?? "No Name",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    "${Constants.indianCurrency} ${product.offerprice ?? 0}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "₹ ${product.price ?? 0}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
