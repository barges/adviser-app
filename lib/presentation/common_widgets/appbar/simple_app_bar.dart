import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? backButtonText;

  const SimpleAppBar({Key? key, required this.title, this.backButtonText}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleTextStyle: Get.textTheme.titleMedium,
      leading: AppBackButton(
        text: backButtonText,
      ),
      leadingWidth: 70,
      elevation: 0.0,
      title: Text(title),
      backgroundColor: Get.theme.canvasColor,
    );
  }
}
