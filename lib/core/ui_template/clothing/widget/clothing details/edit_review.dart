import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/widgets/custom_elevated_button.dart';
import 'package:sadhana_cart/core/widgets/custom_outline_button.dart';
import 'package:sadhana_cart/core/widgets/snack_bar.dart';
import 'package:sadhana_cart/features/rating/view%20model/rating_notifier.dart';

Future<void> showEditRatingDialoge({
  required BuildContext context,
  required WidgetRef ref,
  required String productId,
  required String ratingId,
}) {
  double userRating = 0.0;
  final TextEditingController reviewController = TextEditingController();
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Consumer(
            builder: (context, ref, child) {
              final ratingNotifier = ref.watch(ratingProvider.notifier);
              return StatefulBuilder(
                builder: (context, setState) {
                  bool isLoading = false;

                  Future<void> handleSubmit() async {
                    final review = reviewController.text.trim();
                    if (userRating > 0 && review.isNotEmpty) {
                      setState(() => isLoading = true);
                      final bool success = await ratingNotifier.updaterating(
                        productId: productId,
                        comment: review,
                        rating: userRating,
                        ratingId: ratingId,
                      );
                      setState(() => isLoading = false);

                      if (success) {
                        ref.invalidate(specificProductrating(productId));
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      if (context.mounted) {
                        showCustomSnackbar(
                          context: context,
                          message: success
                              ? 'Thanks for your feedback!'
                              : 'Failed to submit rating',
                          type: success ? ToastType.success : ToastType.error,
                        );
                      }
                    } else {
                      showCustomSnackbar(
                        context: context,
                        message: 'Please fill all fields',
                        type: ToastType.error,
                      );
                    }
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Rate this Product',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      StarRating(
                        rating: userRating,
                        size: 36,
                        color: AppColor.ratingColor,
                        starCount: 5,
                        allowHalfRating: true,
                        onRatingChanged: (rating) {
                          setState(() {
                            userRating = rating;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: reviewController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Write your review...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomOutlineButton(
                            onPressed: () async {
                              final bool isSuccess = await ratingNotifier
                                  .deleteRating(
                                    ratingId: ratingId,
                                    productId: productId,
                                  );
                              if (isSuccess && context.mounted) {
                                ref.invalidate(
                                  specificProductrating(productId),
                                );
                                showCustomSnackbar(
                                  context: context,
                                  message: "Rating deleted",
                                  type: ToastType.success,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 40,
                            width: 100,
                            child: CustomElevatedButton(
                              onPressed: () {
                                isLoading ? null : handleSubmit();
                              },
                              child: isLoading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'Submit',
                                      style: customElevatedButtonTextStyle,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
    },
  );
}
