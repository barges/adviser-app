import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/presentation/screens/gallery/gallery_pictures_screen.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? imageFile;
  final double diameter;
  final Color? badgeColor;
  final bool withBorder;
  final bool withError;
  final bool withCameraBadge;
  final bool isZodiac;
  final bool canOpenInFullScreen;
  final VoidCallback? onTap;
  final double badgeDiameter;
  final double badgeBorderWidth;

  const UserAvatar({
    Key? key,
    this.avatarUrl,
    this.imageFile,
    this.badgeColor,
    this.onTap,
    this.diameter = 86.0,
    this.withBorder = false,
    this.withError = false,
    this.withCameraBadge = false,
    this.isZodiac = false,
    this.canOpenInFullScreen = false,
    this.badgeDiameter = 18.0,
    this.badgeBorderWidth = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: diameter,
          width: diameter,
          decoration: BoxDecoration(
            color: isZodiac && avatarUrl != null
                ? null
                : Theme.of(context).hintColor,
            shape: BoxShape.circle,
            border: withBorder
                ? Border.all(
                    width: 2.0,
                    color: withError
                        ? Theme.of(context).errorColor
                        : Theme.of(context).scaffoldBackgroundColor)
                : null,
          ),
          child: imageFile == null
              ? avatarUrl == null || avatarUrl!.isEmpty
                  ? Container(
                      child: Assets.vectors.placeholderProfileImage
                          .svg(color: Theme.of(context).canvasColor),
                    )
                  : isZodiac
                      ? SvgPicture.asset(
                          avatarUrl!,
                          height: diameter,
                          width: diameter,
                        )
                      : GestureDetector(
                          onTap: canOpenInFullScreen
                              ? () => context.push(
                                    route: ZodiacGalleryPictures(
                                      galleryPicturesScreenArguments:
                                          GalleryPicturesScreenArguments(
                                        pictures: [avatarUrl!],
                                      ),
                                    ),
                                  )
                              : null,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                  avatarUrl!,
                                  maxHeight: diameter.toInt() * 2,
                                  maxWidth: diameter.toInt() * 2,
                                ),
                              ),
                            ),
                          ),
                        )
              : GestureDetector(
                  onTap: canOpenInFullScreen
                      ? () => context.push(
                            route: ZodiacGalleryPictures(
                              galleryPicturesScreenArguments:
                                  GalleryPicturesScreenArguments(
                                pictures: [imageFile!.path],
                              ),
                            ),
                          )
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(imageFile!),
                      ),
                    ),
                  ),
                ),
        ),
        if (badgeColor != null)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: badgeDiameter,
                width: badgeDiameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: badgeColor,
                  border: Border.all(
                    width: badgeBorderWidth,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ),
          ),
        // if (withError)
        //   Positioned.fill(
        //       bottom: withCameraBadge ? AppConstants.iconButtonSize : 0.0,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //         child: Align(
        //             alignment: withCameraBadge
        //                 ? Alignment.bottomLeft
        //                 : Alignment.centerLeft,
        //             child: AutoSizeText(
        //               SFortunica.of(context).photoIsRequiredFortunica,
        //               textAlign: TextAlign.center,
        //               maxLines: 2,
        //               minFontSize: 10.0,
        //               style: Theme.of(context).textTheme.bodySmall?.copyWith(
        //                   fontSize: 12.0, color: Theme.of(context).errorColor),
        //             )),
        //       )),
      ],
    );
  }
}
