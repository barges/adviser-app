import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/app_back_button.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? backButtonText;

  const SimpleAppBar({Key? key, required this.title, this.backButtonText})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleTextStyle: Get.textTheme.titleMedium,
      leading: const AppBackButton(),
      leadingWidth: 70,
      elevation: 0.0,
      title: Text(title),
      backgroundColor: Get.theme.canvasColor,
    );
  }
}
