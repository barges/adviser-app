import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';

class WideAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget bottomWidget;
  final Widget? topRightWidget;

  const WideAppBar({
    Key? key,
    required this.bottomWidget,
    this.topRightWidget,
  }) : super(key: key);

  @override
  Size get preferredSize =>
      const Size.fromHeight(AppConstants.appBarHeight * 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.5,
        shadowColor: Theme.of(context).hintColor,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIconButton(
                      icon: Assets.vectors.arrowLeft.path,
                      onTap: context.pop,
                    ),
                    topRightWidget ?? const SizedBox.shrink()
                  ],
                ),
                bottomWidget,
              ],
            ),
          ),
        ));
  }
}
