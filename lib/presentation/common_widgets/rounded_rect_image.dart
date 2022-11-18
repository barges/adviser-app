import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedRectImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  const RoundedRectImage(
    this.url, {
    this.width,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(url),
        ),
      ),
    );
  }
}
