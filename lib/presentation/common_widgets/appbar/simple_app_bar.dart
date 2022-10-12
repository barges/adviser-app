import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/main_cubit.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SimpleAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      elevation: 1.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppIconButton(
            icon: Assets.vectors.arrowLeft.path,
            onTap: () {
              Get.find<MainCubit>().clearErrorMessage();
              Get.back();
            },
          ),
          Text(
            title,
            style: Get.textTheme.headlineMedium?.copyWith(
              fontSize: 17.0,
            ),
          ),
          const SizedBox(
            width: AppConstants.iconButtonSize,
          )
        ],
      ),
      backgroundColor: Get.theme.canvasColor,
    );
  }
}
