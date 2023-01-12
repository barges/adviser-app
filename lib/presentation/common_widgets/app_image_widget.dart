import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/main.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';

class AppImageWidget extends StatelessWidget {
  final Uri uri;
  final double? width;
  final double? height;
  final double? radius;
  final bool canBeOpenedInFullScreen;

  const AppImageWidget({
    required this.uri,
    this.width,
    this.height,
    this.radius,
    this.canBeOpenedInFullScreen = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canBeOpenedInFullScreen
          ? () {
              Get.toNamed(
                AppRoutes.galleryPictures,
                arguments: GalleryPicturesScreenArguments(
                  pictures: [uri.toString()],
                ),
              );
            }
          : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: radius != null ? BorderRadius.circular(radius!) : null,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: uri.hasScheme
                ? CachedNetworkImageProvider(uri.toString(),
                        cacheManager: getIt.get<BaseCacheManager>())
                    as ImageProvider<Object>
                : FileImage(
                    File(uri.toFilePath()),
                  ),
          ),
        ),
      ),
    );
  }
}
