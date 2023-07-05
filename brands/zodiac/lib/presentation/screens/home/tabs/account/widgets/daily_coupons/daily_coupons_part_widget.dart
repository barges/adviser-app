import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:zodiac/data/models/user_info/daily_coupon_info.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/widgets/daily_coupons/daily_coupons_widget.dart';
import 'package:zodiac/presentation/screens/home/tabs/account/zodiac_account_cubit.dart';

class DailyCouponsPartWidget extends StatelessWidget {
  const DailyCouponsPartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ZodiacAccountCubit accountCubit = context.read<ZodiacAccountCubit>();

    final List<DailyCouponInfo>? dailyCoupons =
        context.select((ZodiacAccountCubit cubit) => cubit.state.dailyCoupons);

    if (dailyCoupons != null) {
      return Builder(builder: (context) {
        final int dailyCouponsLimit = context.select(
            (ZodiacAccountCubit cubit) => cubit.state.dailyCouponsLimit);

        int selectedCount = 0;
        for (DailyCouponInfo element in dailyCoupons) {
          selectedCount += element.count ?? 0;
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            color: theme.canvasColor,
          ),
          child: Column(
            children: [
              Builder(builder: (context) {
                final bool disableDailyCouponsEnabling = context.select(
                    (ZodiacAccountCubit cubit) =>
                        cubit.state.disableDailyCouponsEnabling);

                return Opacity(
                  opacity: disableDailyCouponsEnabling ? 0.6 : 1.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              SZodiac.of(context).showDailyCouponsZodiac,
                              style: theme.textTheme.headlineMedium
                                  ?.copyWith(fontSize: 17.0),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: theme.primaryColor,
                              ),
                              child: Text(
                                '$selectedCount/$dailyCouponsLimit',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontSize: 13.0,
                                  color: theme.canvasColor,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Builder(builder: (context) {
                              final bool dailyCouponsEnabled = context.select(
                                  (ZodiacAccountCubit cubit) =>
                                      cubit.state.dailyCouponsEnabled);
                              return CupertinoSwitch(
                                value: dailyCouponsEnabled,
                                onChanged: disableDailyCouponsEnabling
                                    ? null
                                    : accountCubit.updateDailyCouponsEnabled,
                                activeColor: Theme.of(context).primaryColor,
                                trackColor: Theme.of(context).hintColor,
                              );
                            }),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          SZodiac.of(context)
                              .theNumberOfAvailableCouponsDependsOnTheAmountOfSessionsZodiac,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.shadowColor),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              DailyCouponsWidget(
                dailyCoupons: dailyCoupons,
                limitReached: selectedCount == dailyCouponsLimit,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Builder(builder: (context) {
                final bool countIsZero = selectedCount == 0;

                final bool couponsSetEqualPrevious = context.select(
                    (ZodiacAccountCubit cubit) =>
                        cubit.state.couponsSetEqualPrevious);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Opacity(
                      opacity:
                          couponsSetEqualPrevious || countIsZero ? 0.6 : 1.0,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                theme.primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          onPressed: couponsSetEqualPrevious || countIsZero
                              ? null
                              : accountCubit.saveDailyCouponsSet,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 13.0,
                              horizontal: 16.0,
                            ),
                            child: Text(
                              countIsZero
                                  ? SZodiac.of(context)
                                      .selectAtLeast1CouponZodiac
                                  : SZodiac.of(context).saveCouponsSetZodiac,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontSize: 17.0,
                                color: theme.canvasColor,
                              ),
                            ),
                          )),
                    ),
                  ),
                );
              }),
              Builder(builder: (context) {
                final bool disableDailyRenewalEnabling = context.select(
                    (ZodiacAccountCubit cubit) =>
                        cubit.state.disableDailyRenewalEnabling);
                return Opacity(
                  opacity: disableDailyRenewalEnabling ? 0.6 : 1.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.horizontalScreenPadding),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              SZodiac.of(context).dailyRenewalZodiac,
                              style: theme.textTheme.headlineMedium
                                  ?.copyWith(fontSize: 17.0),
                            ),
                            Builder(builder: (context) {
                              final bool dailyRenewalEnabled = context.select(
                                  (ZodiacAccountCubit cubit) =>
                                      cubit.state.dailyRenewalEnabled);
                              return CupertinoSwitch(
                                value: dailyRenewalEnabled,
                                onChanged: disableDailyRenewalEnabling
                                    ? null
                                    : accountCubit
                                        .updateDailyCouponsRenewalEnabled,
                                activeColor: Theme.of(context).primaryColor,
                                trackColor: Theme.of(context).hintColor,
                              );
                            }),
                          ],
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          SZodiac.of(context)
                              .selectedCouponsWillBeRenewedAutomaticallyZodiac,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.shadowColor),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      });
    } else {
      return const SizedBox.shrink();
    }
  }
}
