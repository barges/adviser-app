import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../generated/l10n.dart';
import '../buttons/change_locale_button.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback openDrawer;

  const LoginAppBar({
    Key? key,
    required this.openDrawer,
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
      toolbarHeight: 72.0,
      title: Row(
        children: [
          Expanded(
            child: Text(
              SFortunica.of(context).chooseBrandFortunica,
              style: Theme.of(context).textTheme.headlineMedium,
              maxLines: 2,
              textAlign: TextAlign.left,
            ),
          ),
          const ChangeLocaleButton(),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
    );
  }
}
