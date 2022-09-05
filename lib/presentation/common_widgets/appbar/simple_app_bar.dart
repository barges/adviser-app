import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_back_button.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? backButtonText;
  final VoidCallback? openDrawer;

  const SimpleAppBar(
      {Key? key, required this.title, this.backButtonText, this.openDrawer})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleTextStyle: Get.textTheme.titleMedium,
      leading: const AppBackButton(),
      actions: [
        IconButton(
            onPressed: openDrawer,
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ))
      ],
      leadingWidth: 70,
      elevation: 0.0,
      title: Text(title),
      backgroundColor: Get.theme.canvasColor,
    );
  }
}
