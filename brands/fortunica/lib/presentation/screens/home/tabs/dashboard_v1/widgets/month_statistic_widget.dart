// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/dashboard_v1_cubit.dart';
import 'package:fortunica/presentation/screens/home/tabs/dashboard_v1/widgets/chart_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';

const String _currencyPattern = '#,##0.00';

class MonthStatisticWidget extends StatelessWidget {
  const MonthStatisticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final double monthAmount =
          context.select((DashboardV1Cubit cubit) => cubit.state.monthAmount);
      final String currencySymbol = context
          .select((DashboardV1Cubit cubit) => cubit.state.currencySymbol);
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
                Text(
                  SFortunica.of(context).thisMonthFortunica,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 17.0),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstants.horizontalScreenPadding),
                    child: Divider(
                      height: 2,
                    )),
                Text(
                    '$currencySymbol ${_parseValueToCurrencyFormat(monthAmount)}',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(
                  height: 8.0,
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstants.horizontalScreenPadding),
                    child: Divider(
                      height: 1,
                    )),
                const ChartWidget()
              ],
            )),
      );
    });
  }

  String _parseValueToCurrencyFormat(double amount) {
    final currencyFormatter = NumberFormat(_currencyPattern, 'ID');
    return currencyFormatter.format(amount).replaceAll('.', ' ');
  }
}

class _PerformancePropertyInfo extends StatelessWidget {
  final String title;
  final int info;

  const _PerformancePropertyInfo(
      {Key? key, required this.title, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minWidth: 20.0, minHeight: 20.0),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8.0)),
          child: Text(
            info.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).backgroundColor),
          ),
        ),
        const SizedBox(width: 4.0),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w500),
        )
      ]),
    );
  }
}
