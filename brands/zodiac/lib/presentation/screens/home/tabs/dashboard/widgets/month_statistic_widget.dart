import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/dashboard_cubit.dart';
import 'package:zodiac/presentation/screens/home/tabs/dashboard/widgets/chart_widget.dart';

class MonthStatisticWidget extends StatelessWidget {
  const MonthStatisticWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final double monthAmount =
          context.select((DashboardCubit cubit) => cubit.state.monthAmount);
      final String currencySymbol =
          context.select((DashboardCubit cubit) => cubit.state.currencySymbol);
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        child: Padding(
            padding: const EdgeInsets.only(
                left: AppConstants.horizontalScreenPadding,
                right: AppConstants.horizontalScreenPadding,
                top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text(
                //   SZodiac.of(context).thisMonthZodiac,
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: Theme.of(context)
                //       .textTheme
                //       .headlineMedium
                //       ?.copyWith(fontSize: 17.0),
                // ),
                // const Divider(
                //   height: 33,
                // ),
                // Text(
                //     '$currencySymbol ${monthAmount.parseValueToCurrencyFormat}',
                //     style: Theme.of(context).textTheme.labelLarge),
                // const SizedBox(
                //   height: 8.0,
                // ),
                // Row(
                //   children: [
                //     CategoryWithCounterWidget(
                //       count: 0,
                //       category: SZodiac.of(context).newCustomersZodiac,
                //     ),
                //     const SizedBox(
                //       width: 8.0,
                //     ),
                //     CategoryWithCounterWidget(
                //       count: 0,
                //       category: SZodiac.of(context).salesZodiac,
                //     ),
                //   ],
                // ),
                // const Divider(
                //   height: 33,
                // ),
                const ChartWidget()
              ],
            )),
      );
    });
  }
}

class CategoryWithCounterWidget extends StatelessWidget {
  final int count;
  final String category;

  const CategoryWithCounterWidget({
    Key? key,
    required this.count,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 28.0,
      padding: const EdgeInsets.fromLTRB(4.0, 4.0, 6.0, 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppConstants.buttonRadius,
        ),
        color: theme.scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: theme.primaryColor,
            ),
            child: Center(
              child: Text(
                count.toString(),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 13.0,
                  color: theme.backgroundColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            category,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 13.0,
            ),
          ),
        ],
      ),
    );
  }
}
