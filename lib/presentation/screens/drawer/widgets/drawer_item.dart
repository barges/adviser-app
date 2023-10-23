import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';

import '../../../../app_constants.dart';
import '../../../../data/cache/caching_manager.dart';
import '../../../../data/models/enums/fortunica_user_status.dart';
import '../../../../data/models/user_info/user_status.dart';
import '../../../../generated/assets/assets.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../global.dart';
import '../../../../main_cubit.dart';
import '../../../../utils/utils.dart';
import '../../../common_widgets/ok_cancel_bottom_sheet.dart';
import '../drawer_cubit.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final UserStatus? userStatus =
          globalGetIt.get<CachingManager>().getUserStatus();
      final FortunicaUserStatus fortunicaUserStatus =
          userStatus?.status ?? FortunicaUserStatus.offline;
      final ThemeData theme = Theme.of(context);

      return Container(
        height: 64.0,
        padding: const EdgeInsets.fromLTRB(4.0, 4.0, 12.0, 4.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        ),
        child: Row(
          children: [
            Builder(builder: (context) {
              return Stack(alignment: Alignment.bottomRight, children: [
                Container(
                  height: 56.0,
                  width: 56.0,
                  padding: const EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    color: theme.canvasColor,
                    border: Border.all(
                      color: theme.hintColor,
                    ),
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.vectors.fortunica.path,
                      color: Utils.isDarkMode(context)
                          ? theme.backgroundColor
                          : null,
                    ),
                  ),
                ),
                Container(
                  height: 12.0,
                  width: 12.0,
                  decoration: BoxDecoration(
                    color: fortunicaUserStatus.statusBadgeColor(context),
                    shape: BoxShape.circle,
                    border: Border.all(width: 2.0, color: theme.canvasColor),
                  ),
                )
              ]);
            }),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstants.fortunicaName,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showOkCancelBottomSheet(
                  context: context,
                  okButtonText: SFortunica.of(context).logOut,
                  okOnTap: () async {
                    await context.read<DrawerCubit>().logout(context);
                    if (context.mounted) {
                      context.pop();
                      context
                          .read<MainCubit>()
                          .scaffoldKey
                          .currentState
                          ?.closeDrawer();
                    }
                  },
                );
              },
              child: SvgPicture.asset(
                Assets.vectors.moreHorizontal.path,
                height: AppConstants.iconSize,
                width: AppConstants.iconSize,
                color: theme.iconTheme.color,
              ),
            ),
          ],
        ),
      );
    });
  }
}
