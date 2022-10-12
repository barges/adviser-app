import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/change_locale_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class SimpleAppBarWithChangeLanguageWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String iconPath;
  final double iconWidth;


  const SimpleAppBarWithChangeLanguageWidget(
      {Key? key, required this.title, required this.iconPath,this.iconWidth = 24.0,})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding, vertical: 14.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Ink(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Get.theme.scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius)),
                  child: SvgPicture.asset(iconPath, width: iconWidth),
                ),
                const SizedBox(width: 8.0),
                Text(title, style: Get.textTheme.headlineMedium),
              ],
            ),
            const ChangeLocaleButton()
          ]),
        ),
      ),
    );
  }
}
