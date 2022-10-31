import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/sessions_type.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/error_badge.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/change_status_comment_bottom_sheet.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/count_down_timer.dart';
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
            child: GestureDetector(
              onTap: accountCubit.goToEditProfile,
              child: Row(
                children: [
                  UserAvatar(
                    avatarUrl: userProfile?.profilePictures?.firstOrNull,
                    diameter: 72.0,
                    badgeColor: currentStatus.status?.statusColorForBadge,
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
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
                            userProfile?.rituals
                                    ?.map((e) => e.sessionName)
                                    .toList()
                                    .reduce((value, element) =>
                                        '$value, $element') ??
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
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 36.0,
                    ),
                    child: Stack(
                      children: [
                        Assets.vectors.arrowRight.svg(
                          color: Get.theme.primaryColor,
                        ),
                        if (currentStatus.status ==
                            FortunicaUserStatus.incomplete)
                          const Positioned(
                            right: 0.0,
                            child: ErrorBadge(),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
        Padding(
          padding:
              const EdgeInsets.only(left: AppConstants.horizontalScreenPadding),
          child: Column(children: [
            const Divider(
              height: 1.0,
            ),
            Builder(
              builder: (context) {
                final int seconds =
                    context.select((AccountCubit cubit) => cubit.state.seconds);
                return TileWidget(
                  title: S.of(context).imAvailableNow,
                  iconSVGPath: Assets.vectors.availability.path,
                  onChanged: (newValue) {
                    if (newValue) {
                      accountCubit.updateUserStatus(
                        status: FortunicaUserStatus.live,
                      );
                    } else {
                      changeStatusCommentBottomSheet(
                        context: context,
                        commentController: accountCubit.commentController,
                        okOnTap: () {
                          accountCubit.updateUserStatus(
                            status: FortunicaUserStatus.offline,
                          );
                        },
                      );
                    }
                  },
                  isDisable: currentStatus.status !=
                          FortunicaUserStatus.live &&
                      currentStatus.status != FortunicaUserStatus.offline,
                  initSwitcherValue:
                      currentStatus.status == FortunicaUserStatus.live,
                  timerWidget: seconds > 0
                      ? CountDownTimer(
                          seconds: seconds,
                          onEnd: accountCubit.hideTimer,
                        )
                      : null,
                );
              },
            ),
            const Divider(
              height: 1.0,
            ),
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
            const Divider(
              height: 1.0,
            ),
            TileWidget(
              isDisable: currentStatus.status != FortunicaUserStatus.live,
              iconSVGPath: Assets.vectors.eye.path,
              title: S.of(context).previewAccount,
              onTap: () {
                Get.toNamed(AppRoutes.advisorPreview);
              },
            )
          ]),
        )
      ]),
    );
  }
}
