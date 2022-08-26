import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_back_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback changeLocale;

  const LoginAppBar({Key? key, required this.changeLocale}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(72.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleTextStyle: Get.textTheme.headlineMedium,
      automaticallyImplyLeading: false,
      centerTitle: false,
      titleSpacing: AppConstants.horizontalScreenPadding,
      elevation: 2,
      toolbarHeight: 72.0,
      title: Row(
        children: [
          if (Navigator.of(context).canPop())
            Row(
              children: const [
                AppBackButton(),
                SizedBox(
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
          ChangeLocaleButton(
            changeLocale: changeLocale,
          ),
        ],
      ),
      backgroundColor: Get.theme.canvasColor,
    );
  }
}

class ChangeLocaleButton extends StatelessWidget {
  final VoidCallback changeLocale;

  const ChangeLocaleButton({Key? key, required this.changeLocale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: InkResponse(
        onTap: changeLocale,
        child: Container(
          height: 32.0,
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Row(
            children: [
              SvgPicture.asset(
                AppIcons.languages,
                color: Get.theme.primaryColor,
                width: 20.0,
                height: 20.0,
              ),
              const SizedBox(
                width: 6.0,
              ),
              Text(
                Intl.getCurrentLocale().capitalize ?? '',
                style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: Get.theme.primaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
