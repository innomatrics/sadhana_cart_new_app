import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/skeletonizer/product_grid_loader.dart';
import 'package:sadhana_cart/features/home%20screen/model/custom_home_page_drawer.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/all_products_tile.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/banner_list_mobile.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/categories_list_mobile.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/featured_product_tile.dart';
import 'package:sadhana_cart/features/home%20screen/widgets/recommanded_product_tile.dart';
import 'package:sadhana_cart/features/notification/view%20model/notification_notifier.dart';
import 'package:sadhana_cart/features/notification/view/notification_page_mobile.dart';
import 'package:sadhana_cart/core/common%20repo/product/all_products_notifier.dart';

class HomePageMobile extends ConsumerStatefulWidget {
  const HomePageMobile({super.key});

  @override
  ConsumerState<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends ConsumerState<HomePageMobile> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final notifier = ref.read(allProductsProvider.notifier);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !notifier.isLoading &&
          notifier.hasMore) {
        notifier.fetchNextProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);
    final notifier = ref.read(allProductsProvider.notifier);
    final notification = ref.watch(notificationProvider);
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      drawer: const CustomHomePageDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.pureWhite,
        centerTitle: true,
        title: const Text(
          "Sadhana Cart",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          notification.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: GestureDetector(
                    onTap: () {
                      navigateTo(
                        context: context,
                        screen: const NotificationPageMobile(),
                      );
                    },
                    child: const Icon(Icons.notifications),
                  ),
                )
              : Badge.count(
                  count: notification.length,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: GestureDetector(
                      onTap: () {
                        navigateTo(
                          context: context,
                          screen: const NotificationPageMobile(),
                        );
                      },
                      child: const Icon(Icons.notifications),
                    ),
                  ),
                ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Padding at the top
            const SliverToBoxAdapter(child: SizedBox(height: 30)),

            // Categories
            const SliverToBoxAdapter(child: CategoriesListMobile()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Banner
            const SliverToBoxAdapter(child: BannerListMobile()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Featured Products
            const SliverToBoxAdapter(
              child: Text(
                "Featured Products",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: FeaturedProductTile()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Recommended Products
            const SliverToBoxAdapter(
              child: Text(
                "Recommended Products",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: RecommandedProductTile()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // All Products
            const SliverToBoxAdapter(
              child: Text(
                "All Products",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Products Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    return AllProductsTile(product: product);
                  } else {
                    return const ProductGridLoader();
                  }
                }, childCount: products.length + (notifier.hasMore ? 1 : 0)),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 2,
                  childAspectRatio: 0.65,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
