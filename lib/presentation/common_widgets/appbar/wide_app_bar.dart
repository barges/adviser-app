import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

import '../buttons/app_icon_button.dart';

class WideAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? topRightWidget;

  const WideAppBar({Key? key, required this.title, this.topRightWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      elevation: 1.0,
      toolbarHeight: 92.0,
      title: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [AppIconButton(
                icon: Assets.vectors.arrowLeft.path,
                onTap: Get.back,
              ),
                topRightWidget ?? const SizedBox()
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                title,
                style: Get.textTheme.headlineMedium,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(92.0);
}
