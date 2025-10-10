import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sadhana_cart/core/constants/app_images.dart';

class ExtensionHelper {
  static ImageProvider getImageProvider(String? url) {
    if (url == null || url.isEmpty || !url.startsWith('http')) {
      return const AssetImage(AppImages.noProfile);
    } else {
      return CachedNetworkImageProvider(url);
    }
  }
}
