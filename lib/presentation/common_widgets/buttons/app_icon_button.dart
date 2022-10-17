import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback? onTap;
  final bool needColor;

  const AppIconButton({
    Key? key,
    required this.icon,
    this.onTap,
    this.needColor = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppConstants.iconButtonSize,
        width: AppConstants.iconButtonSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Get.theme.scaffoldBackgroundColor,
        ),
        child: Center(
            child: SvgPicture.asset(
          icon,
          color: needColor ? Get.theme.primaryColor : null,
          height: AppConstants.iconSize,
          width: AppConstants.iconSize,
        )),
      ),
    );
  }
}
