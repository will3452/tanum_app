import 'package:flutter/material.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String imageUrl;
  final ImageLoadingBuilder loadingBuilder;
  final ImageErrorWidgetBuilder fallback;
  final double? width;
  final double? height;

  const NetworkImageWithFallback({
    Key? key,
    required this.imageUrl,
    required this.fallback,
    required this.loadingBuilder,
    this.width = 75,
    this.height = 75,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      loadingBuilder: loadingBuilder,
      errorBuilder: fallback,
      width: width,
      height: height,
    );
  }
}
