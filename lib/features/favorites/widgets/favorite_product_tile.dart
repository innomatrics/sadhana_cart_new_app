import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/favorite/fav_model_notifier.dart';
import 'package:sadhana_cart/core/common%20repo/favorite/favorite_notifier.dart';
import 'package:sadhana_cart/core/common%20services/favorite/favorite_service.dart';
import 'package:sadhana_cart/core/constants/constants.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:collection/collection.dart';

class FavoriteProductTile extends ConsumerWidget {
  const FavoriteProductTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final favList = ref.watch(favoriteProvider).toList();

    if (favList.isEmpty) {
      return const Center(child: Text("No Favorites"));
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: favList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final favorite = favList[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  navigateToProductDesignBasedOnCategory(
                    context: context,
                    categoryName: favorite.category ?? "",
                    product: favorite,
                  );
                },
                child: Container(
                  height: size.height * 0.22,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        favorite.images!.first,
                        cacheKey: favorite.productid,
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final favSet = ref.watch(favoriteModelProvider);
                        final model = favSet.firstWhereOrNull(
                          (e) => e.productid == favorite.productid,
                        );

                        final favoriteId = model?.favoriteId;

                        return IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () async {
                            if (favoriteId == null) return;

                            final bool isSuccess =
                                await FavoriteService.deleteFavorite(
                                  favoriteId: favoriteId,
                                  product: favorite,
                                  ref: ref,
                                );

                            if (isSuccess && context.mounted) {
                              showCustomSnackbar(
                                type: ToastType.success,
                                message: "Removed from favorites",
                                context: context,
                              );
                            }
                          },
                          icon: const Icon(Icons.favorite, color: Colors.red),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                favorite.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${Constants.indianCurrency} ${favorite.offerprice}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
