import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final File? imageFile;
  final double diameter;

  const UserAvatar({
    Key? key,
    this.avatarUrl,
    this.imageFile,
    this.diameter = 86.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: imageFile == null
              ? avatarUrl == null || avatarUrl!.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          color: Get.theme.canvasColor, shape: BoxShape.circle),
                      child: Assets.vectors.placeholderProfileImage.svg(
                        color: Get.theme.hintColor,
                        height: diameter,
                        width: diameter,
                      ),
                    )
                  : Container(
                      height: diameter,
                      width: diameter,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(avatarUrl!),
                        ),
                      ),
                    )
              : Container(
                  height: diameter,
                  width: diameter,
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
      ],
    );
  }
}
