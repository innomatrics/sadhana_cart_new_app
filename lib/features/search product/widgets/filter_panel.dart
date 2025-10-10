import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/common%20repo/category/category_notifier.dart';
import 'package:sadhana_cart/core/disposable/disposable.dart';
import 'package:sadhana_cart/core/widgets/custom_drop_down.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/features/search%20product/model/product_filter.dart';
import 'package:sadhana_cart/features/search%20product/view%20model/filter_product_notifier.dart';

class FilterPanel extends ConsumerStatefulWidget {
  const FilterPanel({super.key});

  @override
  ConsumerState<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends ConsumerState<FilterPanel> {
  var _currentRange = const RangeValues(0, 5000);
  final _minPrice = 0.0;
  final _maxPrice = 5000.0;

  @override
  Widget build(BuildContext context) {
    final toggle = ref.watch(filterPanelProvider);
    final categorySearch = ref.watch(filterCategoryProvider);
    final categorySync = ref.watch(categoryAsync);
    final Size size = MediaQuery.of(context).size;
    final loader = ref.watch(loadingProvider);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: 0,
      bottom: 0,
      right: toggle ? 0 : -size.width * 0.7,
      width: size.width * 0.7,
      child: Material(
        elevation: 16,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300, width: 2),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Filters",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          ref.read(filterPanelProvider.notifier).state = false,
                    ),
                  ],
                ),

                // Price Range Slider
                const Text(
                  "Price",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 2),
                  child: RangeSlider(
                    values: _currentRange,
                    min: _minPrice,
                    max: _maxPrice,
                    divisions: 100,
                    activeColor: Colors.black,
                    labels: RangeLabels(
                      "₹${_currentRange.start.round()}",
                      "₹${_currentRange.end.round()}",
                    ),
                    onChanged: (values) {
                      //used setstate because it's simple and disposable
                      setState(() {
                        _currentRange = values;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${_currentRange.start.round()}"),
                    Text("₹${_currentRange.end.round()}"),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: size.height * 0.1,
                  child: categorySync.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const Center(child: Text("No categories found"));
                      }
                      return CustomDropDown<String?>(
                        items: data
                            .map(
                              (e) => DropdownMenuItem<String?>(
                                value: e.name,
                                child: Text(e.name),
                              ),
                            )
                            .toSet()
                            .toList(),
                        onChanged: (value) {
                          ref.read(filterCategoryProvider.notifier).state =
                              value;
                        },
                        value: categorySearch,
                        labelText: "Category",
                        showBorder: true,
                      );
                    },
                    error: (e, s) => Center(child: Text(e.toString())),
                    loading: () => const CircularProgressIndicator.adaptive(),
                  ),
                ),
                const SizedBox(height: 20),

                CustomElevatedButton(
                  onPressed: () {
                    final filter = ProductFilter(
                      category: categorySearch,
                      minPrice: _currentRange.start,
                      maxPrice: _currentRange.end,
                    );

                    ref.read(productFilterProvider.notifier).state = filter;

                    ref
                        .read(filterProductsProvider.notifier)
                        .loadProducts(filter, reset: true);

                    ref.read(isFilterAppliedProvider.notifier).state = true;
                    ref.read(filterPanelProvider.notifier).state = false;
                  },
                  child: loader
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Apply Filters",
                          style: customElevatedButtonTextStyle,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
