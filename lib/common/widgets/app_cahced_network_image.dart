import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCahcedNetworkImage extends StatelessWidget {
  const AppCahcedNetworkImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: 'url',
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      // cacheManager: CacheManager,
    );
  }
}
