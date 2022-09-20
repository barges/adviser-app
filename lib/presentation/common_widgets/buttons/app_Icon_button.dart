import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const AppIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => onTap(),
      child: Container(
        height: 32.0,
        width: 32.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Get.theme.scaffoldBackgroundColor,
        ),
        child: Center(
            child: SvgPicture.asset(
          icon,
          color: Get.theme.primaryColor,
          height: AppConstants.iconsSize,
          width: AppConstants.iconsSize,
        )),
      ),
    );
  }
}
