import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppBackButton extends StatelessWidget {
  final String? icon;
  final double width;
  final EdgeInsets? padding;

  const AppBackButton({Key? key, this.icon, this.width = 32.0, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Get.back();
      },
      child: Container(
        height: width,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Get.theme.scaffoldBackgroundColor,
        ),
        child: Center(
            child: SvgPicture.asset(
          icon ?? Assets.vectors.back.path,
          color: Get.theme.primaryColor,
          height: AppConstants.iconsSize,
          width: AppConstants.iconsSize,
        )),
      ),
    );
  }
}
