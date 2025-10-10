import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/product/all_products_notifier.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/skeletonizer/product_grid_loader.dart';
import 'package:sadhana_cart/core/widgets/custom_search_field.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/all_products_tile.dart';
import 'package:sadhana_cart/features/search%20product/view%20model/filter_product_notifier.dart';
import 'package:sadhana_cart/features/search%20product/view%20model/search_products_notifier.dart';
import 'package:sadhana_cart/features/search%20product/widgets/filter_panel.dart';

class SearchProductMobile extends ConsumerStatefulWidget {
  final PreferredSizeWidget? appBar;
  const SearchProductMobile({super.key, this.appBar});

  @override
  ConsumerState<SearchProductMobile> createState() =>
      _SearchProductMobileState();
}

class _SearchProductMobileState extends ConsumerState<SearchProductMobile> {
  final searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  String query = "";

  void _onSearchChanged() {
    setState(() {
      query = searchController.text.trim().toLowerCase();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchController.addListener(_onSearchChanged);

      scrollController.addListener(() {
        if (query.isNotEmpty) {
          // search pagination
          final searchNotifier = ref.read(
            searchProductsProvider(query).notifier,
          );
          if (scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent - 200 &&
              searchNotifier.hasMore &&
              !searchNotifier.isLoadingMore) {
            searchNotifier.loadMore();
          }
        } else {
          // filter pagination
          final notifier = ref.read(filterProductsProvider.notifier);
          final filter = ref.read(productFilterProvider);
          if (scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent - 200 &&
              notifier.hasMore &&
              !notifier.isLoadingMore) {
            notifier.loadProducts(filter);
          }
        }
      });

      final filter = ref.read(productFilterProvider);
      ref
          .read(filterProductsProvider.notifier)
          .loadProducts(filter, reset: true);
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toggle = ref.watch(filterPanelProvider);
    final isFilterApplied = ref.watch(isFilterAppliedProvider);
    final filteredProducts = ref.watch(filterProductsProvider);
    final allProducts = ref.watch(allProductsProvider);

    final searchResults = ref.watch(searchProductsProvider(query));
    final searchNotifier = ref.read(searchProductsProvider(query).notifier);
    final filterNotifier = ref.watch(filterProductsProvider.notifier);

    return Scaffold(
      appBar: widget.appBar,
      drawer: const Drawer(),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomSearchBar(
                        controller: searchController,
                        backgroundColor: Colors.white,
                        hintText: "Search...",
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        ref.read(filterPanelProvider.notifier).state = !toggle;
                      },
                      icon: const Icon(Icons.filter_list),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: query.isNotEmpty
                      ? searchResults.when(
                          data: (products) {
                            if (products.isEmpty) {
                              return const Center(
                                child: Text("No products found."),
                              );
                            }
                            return GridView.builder(
                              controller: scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 2,
                                    childAspectRatio: 0.65,
                                  ),
                              itemCount: products.length + 1,
                              itemBuilder: (context, index) {
                                if (index == products.length) {
                                  return searchNotifier.hasMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Center(
                                            child: ProductGridLoader(),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                }
                                final product = products[index];
                                return AllProductsTile(product: product);
                              },
                            );
                          },
                          loading: () {
                            return Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 2,
                                      childAspectRatio: 0.65,
                                    ),
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return const ProductGridLoader();
                                },
                              ),
                            );
                          },
                          error: (error, stack) {
                            log("Error in search: $error");
                            return Center(child: Text("Error: $error"));
                          },
                        )
                      : isFilterApplied
                      ? filteredProducts.when(
                          data: (products) {
                            if (products.isEmpty) {
                              return const Center(
                                child: Text("No products found."),
                              );
                            }
                            return GridView.builder(
                              controller: scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 2,
                                    childAspectRatio: 0.65,
                                  ),
                              itemCount: products.length + 1,
                              itemBuilder: (context, index) {
                                if (index == products.length) {
                                  return filterNotifier.hasMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: ProductGridLoader(),
                                        )
                                      : const SizedBox.shrink();
                                }
                                final product = products[index];
                                return AllProductsTile(product: product);
                              },
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stack) {
                            log("Error in filteredProducts: $error");
                            return Center(child: Text("Error: $error"));
                          },
                        )
                      : GridView.builder(
                          controller: scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 2,
                                childAspectRatio: 0.65,
                              ),
                          itemCount: allProducts.length,
                          itemBuilder: (context, index) {
                            final product = allProducts[index];
                            return AllProductsTile(product: product);
                          },
                        ),
                ),
              ],
            ),
          ),
          const FilterPanel(),
        ],
      ),
    );
  }
}
