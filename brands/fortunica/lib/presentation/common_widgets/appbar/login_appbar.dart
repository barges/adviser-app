import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:fortunica/presentation/common_widgets/buttons/change_locale_button.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({Key? key}) : super(key: key);

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
          if (Navigator.of(context).canPop())
            Row(
              children: [
                AppIconButton(
                  icon: Assets.vectors.arrowLeft.path,
                  onTap: () => fortunicaGetIt.get<AppRouter>().pop(context),
                ),
                const SizedBox(
                  width: 12.0,
                ),
              ],
            ),
          Expanded(
            child: Text(
              S.of(context).chooseBrand,
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
