import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? imageFile;
  final double diameter;
  final bool isOnline;

  const UserAvatar(
      {Key? key,
      this.avatarUrl,
      this.imageFile,
      this.diameter = 86.0,
      this.isOnline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: diameter,
          width: diameter,
          decoration: BoxDecoration(
              color: Get.theme.canvasColor,
              shape: BoxShape.circle,
              border: Border.all(width: 2.0, color: Get.theme.canvasColor)),
          child: imageFile == null
              ? avatarUrl == null || avatarUrl!.isEmpty
                  ? Container(
                      child: Assets.vectors.placeholderProfileImage
                          .svg(color: Get.theme.hintColor),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(avatarUrl!),
                        ),
                      ),
                    )
              : Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.0,
                      color: Get.theme.scaffoldBackgroundColor,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(imageFile!),
                    ),
                  ),
                ),
        ),
        if (isOnline)
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.online,
                    border:
                        Border.all(width: 4.0, color: Get.theme.canvasColor)),
              ),
            ),
          )
      ],
    );
  }
}
