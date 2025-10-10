//if they give proper color section you can you this code's there 
//this code will provide color selection... also used color enums to get colors

//  const Divider(color: AppColor.lightGrey, thickness: 1.2),
                  // Consumer(
                  //   builder: (context, ref, child) {
                  //     final selecIndex = ref.watch(clothingColorProvider);
                  //     return Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 20),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const Text(
                  //             "Color :",
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           const SizedBox(width: 20),
                  //           Expanded(
                  //             child: Wrap(
                  //               spacing: 8,
                  //               runSpacing: 8,
                  //               children: List.generate(
                  //                 product.sizeVariants?.length ?? 0,
                  //                 (index) {
                  //                   final isSelected = index == selecIndex;
                  //                   final colorName =
                  //                       product.sizeVariants?[index].color;
                  //                   final color = getColorFromDatabase(
                  //                     colorName ?? "black",
                  //                   );
                  //                   final isWhite =
                  //                       color == AppColors.white.color;

                  //                   return GestureDetector(
                  //                     onTap: () {
                  //                       ref
                  //                               .read(
                  //                                 clothingColorProvider
                  //                                     .notifier,
                  //                               )
                  //                               .state =
                  //                           index;
                  //                     },
                  //                     child: Container(
                  //                       height: 50,
                  //                       width: 50,
                  //                       decoration: BoxDecoration(
                  //                         shape: BoxShape.circle,
                  //                         color: Colors.transparent,
                  //                         border: isSelected
                  //                             ? Border.all(
                  //                                 color: AppColor.primaryColor,
                  //                                 width: 2,
                  //                               )
                  //                             : null,
                  //                       ),
                  //                       child: Container(
                  //                         height: 40,
                  //                         width: 40,
                  //                         margin: const EdgeInsets.all(5),
                  //                         decoration: BoxDecoration(
                  //                           shape: BoxShape.circle,
                  //                           color: color,
                  //                           boxShadow: [
                  //                             BoxShadow(
                  //                               color: Colors.grey.shade300,
                  //                               blurRadius: 5,
                  //                               offset: const Offset(0, 2),
                  //                             ),
                  //                           ],
                  //                           border: isWhite
                  //                               ? Border.all(color: Colors.grey)
                  //                               : null,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),