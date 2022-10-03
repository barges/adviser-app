import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/tile_widget.dart';

class UserInfoPartWidget extends StatelessWidget {
  const UserInfoPartWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccountCubit accountCubit = context.read<AccountCubit>();
    final UserStatus currentStatus =
        context.select((HomeCubit cubit) => cubit.state.userStatus);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppConstants.buttonRadius,
        ),
        color: Get.theme.canvasColor,
      ),
      child: Column(children: [
        Builder(builder: (context) {
          final UserProfile? userProfile = context.select(
            (AccountCubit cubit) => cubit.state.userProfile,
          );
          return Padding(
            padding: const EdgeInsets.all(
              AppConstants.horizontalScreenPadding,
            ),
            child: Row(
              children: [
                UserAvatar(
                  avatarUrl: userProfile?.profilePictures?.firstOrNull,
                  diameter: 72.0,
                  badgeColor: currentStatus.status?.statusColorForBadge,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile?.profileName ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Get.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                          userProfile?.rituals?.reduce((value, element) =>
                                  '${value.capitalize}, ${element.capitalize}') ??
                              '',
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Get.theme.shadowColor)),
                      Text(
                        currentStatus.status?.statusName ?? '',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: currentStatus.status?.statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.editProfile);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 36.0,
                    ),
                    child: Assets.vectors.arrowRight.svg(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          );
        }),
        Padding(
          padding:
              const EdgeInsets.only(left: AppConstants.horizontalScreenPadding),
          child: Column(children: [
            const SizedBox(height: 2.0, child: Divider()),
            Builder(
              builder: (context) {
                return TileWidget(
                  isDisable:
                      currentStatus.status != FortunicaUserStatusEnum.live,
                  initSwitcherValue:
                      currentStatus.status == FortunicaUserStatusEnum.live,
                  title: S.of(context).imAvailableNow,
                  iconSVGPath: Assets.vectors.availability.path,
                  onChanged: accountCubit.updateUserStatus,
                );
              },
            ),
            const SizedBox(height: 2, child: Divider()),
            Builder(
              builder: (context) {
                final bool enableNotifications = context.select(
                    (AccountCubit cubit) => cubit.state.enableNotifications);
                return TileWidget(
                  initSwitcherValue: enableNotifications,
                  title: S.of(context).notifications,
                  iconSVGPath: Assets.vectors.notification.path,
                  onChanged: accountCubit.updateEnableNotificationsValue,
                );
              },
            ),
            const SizedBox(height: 2, child: Divider()),
            TileWidget(
              isDisable: currentStatus.status != FortunicaUserStatusEnum.live,
              iconSVGPath: Assets.vectors.eye.path,
              title: S.of(context).previewAccount,
              onTap: () {},
            )
          ]),
        )
      ]),
    );
  }
}
