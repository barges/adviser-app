import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class TransparentAppBar extends StatelessWidget {
  const TransparentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96.0,
      width: Get.width,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.mirror,
          colors: [
            Get.theme.hoverColor.withOpacity(.5),
            Get.theme.hoverColor.withOpacity(.21),
            Get.theme.hoverColor.withOpacity(.0)
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: AppIconButton(
          icon: Assets.vectors.arrowLeft.path,
          onTap: Get.back,
        ),
      ),
    );
  }
}
