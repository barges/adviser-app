import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? backIcon;
  final String? backButtonText;
  final VoidCallback? openDrawer;

  const SimpleAppBar({
    Key? key,
    required this.title,
    this.backButtonText,
    this.openDrawer,
    this.backIcon,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      titleTextStyle: Get.textTheme.headlineMedium,
      actions: [
        if (openDrawer != null)
          IconButton(
              onPressed: openDrawer,
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ))
      ],
      elevation: 0.0,
      title: Row(
        children: [
          AppIconButton(
            icon: backIcon ?? Assets.vectors.arrowLeft.path,
            onTap: Get.back,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Text(title),
        ],
      ),
      backgroundColor: Get.theme.canvasColor,
    );
  }
}
