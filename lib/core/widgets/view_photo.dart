import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhoto extends StatelessWidget {
  final String imageUrl;
  const ViewPhoto({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return PhotoView(imageProvider: CachedNetworkImageProvider(imageUrl));
  }
}
