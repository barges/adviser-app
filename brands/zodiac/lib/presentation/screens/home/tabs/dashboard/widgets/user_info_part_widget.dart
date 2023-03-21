import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/user_info/user_balance.dart';
import 'package:zodiac/data/models/user_info/user_details.dart';
import 'package:zodiac/presentation/common_widgets/user_avatar.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';

class DashboardUserInfoPartWidget extends StatelessWidget {
  const DashboardUserInfoPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserDetails? userPersonalInfo =
        context.select((DashboardCubit cubit) => cubit.state.userPersonalInfo);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
        color: Theme.of(context).canvasColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.horizontalScreenPadding),
        child: Column(
          children: [
            UserAvatar(avatarUrl: userPersonalInfo?.avatar),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              userPersonalInfo?.name != null ? userPersonalInfo!.name! : '',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 17.0),
            ),
            const Divider(
              height: 17.0,
            ),
            Builder(builder: (context) {
              final UserBalance? userBalance = context
                  .select((DashboardCubit cubit) => cubit.state.userBalance);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ///TODO: need change
                    'Personal Balance:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14.0,
                          color: Theme.of(context).shadowColor,
                        ),
                  ),
                  if (userBalance != null)
                    Text(
                      '${userBalance.currency ?? '\$'} ${NumberFormat('###,###,##0.00').format(userBalance.balance ?? 0.0).replaceAll(',', ' ').replaceAll('.', ',')}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontSize: 17.0,
                                color: Theme.of(context).primaryColor,
                              ),
                    )
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
