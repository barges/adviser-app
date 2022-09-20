import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_Icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(72.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle: Get.textTheme.headlineMedium,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      elevation: 1.0,
      toolbarHeight: 72.0,
      title: Row(
        children: [
          if (Navigator.of(context).canPop())
            Row(
              children: [
                AppIconButton(
                  icon: Assets.vectors.back.path,
                  onTap: Get.back,
                ),
               const SizedBox(
                  width: 12.0,
                ),
              ],
            ),
          Expanded(
            child: Text(
              S.of(context).chooseBrandToLogIn,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ),
          const ChangeLocaleButton(),
        ],
      ),
      backgroundColor: Get.theme.canvasColor,
    );
  }
}
