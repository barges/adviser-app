import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class UserProfileImageWidget extends StatelessWidget {
  final double radius;
  final String networkImagePath;

  const UserProfileImageWidget(
      {Key? key, this.networkImagePath = '', this.radius = 43.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: Get.theme.hintColor,
        child: ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: (_, __) => Assets.vectors.placeholderProfileImage
                .svg(color: Get.theme.canvasColor),
            imageUrl: networkImagePath,
            errorWidget: (_, __, ___) => Assets.vectors.placeholderProfileImage
                .svg(color: Get.theme.canvasColor),
          ),
        ));
  }
}
