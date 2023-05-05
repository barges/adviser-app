import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/common_widgets/buttons/app_icon_button.dart';

class PhoneNumberAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onTap;
  const PhoneNumberAppBar({
    super.key,
    this.onTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.5,
      toolbarHeight: AppConstants.appBarHeight,
      leading: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 8.0),
        child: AppIconButton(
          icon: Assets.vectors.arrowLeft.path,
          onTap: onTap ?? () => context.pop(),
        ),
      ),
      title: Text(
        SZodiac.of(context).phoneNumberZodiac,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 17.0,
            ),
      ),
    );
  }
}
