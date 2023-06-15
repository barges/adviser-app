import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/user_avatar.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_cubit.dart';

class PersonalInformationWidget extends StatelessWidget {
  const PersonalInformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final ThemeData theme = Theme.of(context);

      final UserProfile? userProfile =
          context.select((DashboardV1Cubit cubit) => cubit.state.userProfile);
      final double monthAmount =
          context.select((DashboardV1Cubit cubit) => cubit.state.monthAmount);
      final String currencySymbol = context
          .select((DashboardV1Cubit cubit) => cubit.state.currencySymbol);
      return Container(
          padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: theme.canvasColor,
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
          child: Column(
            children: [
              UserAvatar(
                  diameter: 60.0,
                  withBorder: false,
                  avatarUrl: userProfile?.profilePictures?.firstOrNull),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                userProfile?.profileName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
              ),
              const Divider(
                height: 17.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).earnedThisMonth,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 14.0,
                      color: theme.shadowColor,
                    ),
                  ),
                  Text(
                    '$currencySymbol ${monthAmount.parseValueToCurrencyFormat}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 17.0,
                      color: theme.primaryColor,
                    ),
                  )
                ],
              )
            ],
          ));
    });
  }
}
