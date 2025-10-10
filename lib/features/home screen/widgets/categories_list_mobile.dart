import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20repo/category/category_notifier.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';
import 'package:sadhana_cart/core/helper/navigation_helper.dart';
import 'package:sadhana_cart/features/sub%20category/view/subcategory_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesListMobile extends ConsumerWidget {
  const CategoriesListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(categoryAsync);
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.1,
      width: size.width * 1,
      child: category.when(
        data: (data) {
          final category = data;
          return ListView.builder(
            itemCount: category.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              final cat = category[index];
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: size.height * 0.06,
                    width: size.width * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColor.primaryColor,
                        width: 0.9,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          navigateTo(
                            context: context,
                            screen: SubcategoryPage(categoryName: cat.name),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          height: size.height * 0.06,
                          width: size.width * 0.12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                cat.image,
                                cacheKey: cat.id,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      cat.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.onboardButtonColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => Skeletonizer(
          ignoreContainers: true,
          child: ListView.builder(
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return const Skeletonizer(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(AppImages.onboard),
                    radius: 30,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
