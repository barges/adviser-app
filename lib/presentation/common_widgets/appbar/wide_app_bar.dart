import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class WideAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget bottomWidget;
  final Widget? topRightWidget;

  const WideAppBar({
    Key? key,
    required this.bottomWidget,
    this.topRightWidget,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(96.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 96.0,
        elevation: 0.5,
        shadowColor: Get.theme.hintColor,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIconButton(
                      icon: Assets.vectors.arrowLeft.path,
                      onTap: Get.back,
                    ),
                    topRightWidget ?? const SizedBox.shrink()
                  ],
                ),
                bottomWidget,
              ],
            ),
          ),
        ));
  }
}
