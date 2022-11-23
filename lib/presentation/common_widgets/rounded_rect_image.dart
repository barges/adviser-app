import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RoundedRectImage extends StatelessWidget {
  final Uri uri;
  final double? width;
  final double? height;
  const RoundedRectImage({
    required this.uri,
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
