import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SimpleAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleTextStyle: Get.textTheme.titleMedium,
      leading: Navigator.canPop(context)
          ? InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(AppIcons.iosBackButton,
                        color: Get.theme.primaryColor, size: 16.0),
                    Text(
                      S.of(context).back,
                      style: Get.textTheme.labelMedium?.copyWith(
                        color: Get.theme.primaryColor,
                      ),
                    )
                  ],
                ),
              ))
          : const SizedBox(),
      leadingWidth: 70,
      elevation: 0.0,
      title: Text(title),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
