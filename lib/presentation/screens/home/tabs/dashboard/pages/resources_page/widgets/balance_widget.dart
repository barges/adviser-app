import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_icon_button.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/resources/app_routes.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final UserProfile? userProfile =
          context.select((DashboardCubit cubit) => cubit.state.userProfile);
      return Container(
        padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircularPercentIndicator(
                      radius: 34.0,
                      lineWidth: 5.0,
                      percent: 0.6,
                      animation: true,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      center: UserAvatar(
                          diameter: 60.0,
                          withBorder: false,
                          avatarUrl: userProfile?.profilePictures?.firstOrNull),
                      progressColor: AppColors.promotion,
                    ),
                    /**
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(
                                      width: 1.0, color: Theme.of(context).canvasColor)),
                              child: Text('45',
                                  style: Theme.of(context).textTheme.displaySmall
                                      ?.copyWith(color: Theme.of(context).backgroundColor)),
                            ),
                          ),
                        )
                      */
                  ],
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile?.profileName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      /**
                          Text(
                            '${S.of(context).betterThan} 48% ${S.of(context).advisors}',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).shadowColor),
                          ),
                          Row(
                            children: [
                              Assets.vectors.upRating.svg(width: 18.0),
                              const SizedBox(width: 6.0),
                              Text(
                                '3 ${S.of(context).placesUpFromLastMonth}',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.online),
                              )
                            ],
                          )
                        */
                    ],
                  ),
                ),
                AppIconButton(
                  icon: Assets.vectors.arrowRight.path,
                  onTap: () => Get.toNamed(AppRoutes.editProfile),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(height: 1.0),
            ),
            /**
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${S.of(context).personalBalance}:',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).shadowColor),
                      ),
                      Text(
                        '\$ ${(12282.20).parseValueToCurrencyFormat}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                )
              */
          ],
        ),
      );
    });
  }
}
