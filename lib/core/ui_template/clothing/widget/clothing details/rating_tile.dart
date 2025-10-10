import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:sadhana_cart/core/colors/app_color.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';

class RatingTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final String review;
  const RatingTile({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.14,
      width: size.width * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: imageUrl.startsWith("http")
                  ? CachedNetworkImageProvider(imageUrl)
                  : const AssetImage(AppImages.noProfile),
            ),
            title: Text(
              name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: StarRating(
              mainAxisAlignment: MainAxisAlignment.start,
              color: AppColor.ratingColor,
              size: 20,
              rating: rating,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Text(
              review,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
