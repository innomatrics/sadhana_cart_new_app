import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/common%20repo/subcategory/subcategory_notifier.dart';

final subCategorySelected = StateProvider<int>((ref) => 0);

class SubcategoryTile extends ConsumerWidget {
  const SubcategoryTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final subcategory = ref.watch(subcategoryProvider);
    final subIndex = ref.watch(subCategorySelected);
    return SizedBox(
      height: size.height * 0.05,
      width: size.width * 1,
      child: ListView.builder(
        itemCount: subcategory.subcategory.length,
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final sub = subcategory.subcategory[index];
          final isSelected = index == subIndex;
          return GestureDetector(
            onTap: () {
              ref.read(subCategorySelected.notifier).state = index;
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: size.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                  right: Radius.circular(12),
                ),
                color: isSelected
                    ? AppColor.primaryColor
                    : Colors.grey.shade200,
              ),
              child: Center(
                child: Text(
                  sub.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
