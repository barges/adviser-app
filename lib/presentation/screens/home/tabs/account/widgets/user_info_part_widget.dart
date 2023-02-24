import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/error_badge.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/home_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/account_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/change_status_comment_bottom_sheet.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/account/widgets/timer_widget.dart';
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
        color: Theme.of(context).canvasColor,
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
              onTap: currentStatus.status != FortunicaUserStatus.legalBlock
                  ? accountCubit.goToEditProfile
                  : null,
              child: Row(
                children: [
                  UserAvatar(
                    avatarUrl: userProfile?.profilePictures?.firstOrNull,
                    diameter: 72.0,
                    badgeColor:
                        currentStatus.status?.statusColorForBadge(context),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfile?.profileName != null &&
                                  userProfile!.profileName!.isNotEmpty
                              ? userProfile.profileName!
                              : S.of(context).yourUsername,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (userProfile?.rituals?.isNotEmpty == true)
                          Text(
                              userProfile!.rituals!
                                  .map((e) => e.sessionName(context))
                                  .toList()
                                  .reduce(
                                      (value, element) => '$value, $element'),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Theme.of(context).shadowColor)),
                        Text(
                          currentStatus.status?.statusName(context) ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    currentStatus.status?.statusColor(context),
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
                        Opacity(
                          opacity: currentStatus.status !=
                                  FortunicaUserStatus.legalBlock
                              ? 1.0
                              : 0.4,
                          child: Assets.vectors.arrowRight.svg(
                            color: Theme.of(context).primaryColor,
                          ),
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
                final int secondsForTimer = context.select(
                    (AccountCubit cubit) => cubit.state.secondsForTimer);

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
                        accountCubit: accountCubit,
                      );
                    }
                  },
                  isDisable: currentStatus.status != FortunicaUserStatus.live &&
                      currentStatus.status != FortunicaUserStatus.offline,
                  initSwitcherValue:
                      currentStatus.status == FortunicaUserStatus.live,
                  timerWidget: secondsForTimer > 0
                      ? TimerWidget(
                          secondsForTimer: secondsForTimer,
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
                  onChanged: (value) =>
                      accountCubit.updateEnableNotificationsValue(value),
                );
              },
            ),
            const Divider(
              height: 1.0,
            ),
            TileWidget(
              isDisable: currentStatus.status != FortunicaUserStatus.live &&
                  currentStatus.status != FortunicaUserStatus.offline,
              iconSVGPath: Assets.vectors.eye.path,
              title: S.of(context).previewAccount,
              onTap: accountCubit.goToAdvisorPreview,
            )
          ]),
        )
      ]),
    );
  }
}
