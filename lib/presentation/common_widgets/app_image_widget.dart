import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImageWidget extends StatelessWidget {
  final Uri uri;
  final double? width;
  final double? height;
  final double? radius;

  const AppImageWidget({
    required this.uri,
    this.width,
    this.height,
    this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: uri.hasScheme
              ? CachedNetworkImageProvider(uri.toString())
                  as ImageProvider<Object>
              : FileImage(
                  File(uri.toFilePath()),
                ),
        ),
      ),
    );
  }
}
