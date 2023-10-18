import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../infrastructure/routing/app_router.dart';
import '../../app_constants.dart';
import '../../generated/assets/assets.gen.dart';
import '../../infrastructure/routing/app_router.gr.dart';
import '../screens/gallery/gallery_pictures_screen.dart';

class AppImageWidget extends StatelessWidget {
  final Uri uri;
  final bool canBeOpenedInFullScreen;
  final BoxFit fit;
  final double? radius;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? loadingIndicatorHeight;
  final int? memCacheHeight;

  const AppImageWidget({
    required this.uri,
    this.width,
    this.height,
    this.radius,
    this.memCacheHeight,
    this.backgroundColor,
    this.loadingIndicatorHeight,
    this.canBeOpenedInFullScreen = false,
    this.fit = BoxFit.cover,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double widgetHeight = height ?? MediaQuery.of(context).size.height;
    double widgetWidth = width ?? MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: canBeOpenedInFullScreen
          ? () {
              context.push(
                route: FortunicaGalleryPictures(
                  galleryPicturesScreenArguments:
                      GalleryPicturesScreenArguments(
                    pictures: [uri.toString()],
                  ),
                ),
              );
            }
          : null,
      child: ClipRRect(
        borderRadius:
            radius != null ? BorderRadius.circular(radius!) : BorderRadius.zero,
        child: uri.hasScheme
            ? CachedNetworkImage(
                memCacheHeight:
                    memCacheHeight != null ? memCacheHeight! * 2 : null,
                imageUrl: uri.toString(),
                width: widgetWidth,
                height: widgetHeight,
                fit: fit,
                placeholder: (context, url) => Container(
                  width: widgetWidth,
                  height: widgetHeight,
                  color: backgroundColor,
                  child: Center(
                    child: SizedBox(
                      height: loadingIndicatorHeight ?? AppConstants.iconSize,
                      width: loadingIndicatorHeight ?? AppConstants.iconSize,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [
                          Theme.of(context).iconTheme.color ?? Colors.grey,
                        ],
                      ),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    width: widgetWidth,
                    height: widgetHeight,
                    color: backgroundColor,
                    child: Center(
                      child: Assets.vectors.imageError.svg(
                        width: AppConstants.iconSize,
                        height: AppConstants.iconSize,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  );
                },
              )
            : Image.file(
                File(uri.toFilePath()),
                fit: fit,
                width: widgetWidth,
                height: widgetHeight,
              ),
      ),
    );
  }
}
