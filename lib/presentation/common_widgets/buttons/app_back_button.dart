import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () {
        Get.back();
      },
      child: Container(
        height: 32.0,
        width: 32.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: Get.theme.scaffoldBackgroundColor,
        ),
        child: Center(
            child: SvgPicture.asset(
          AppIcons.back,
          color: Get.theme.primaryColor,
          height: 10.0,
          width: 6.0,
        )),
      ),
    );
  }
}
