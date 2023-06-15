import 'package:flutter/material.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_month.dart';
import 'package:fortunica/data/models/reports_endpoint/reports_statistics.dart';
import 'package:fortunica/presentation/screens/balance_and_transactions/widgets/list_of_markets_by_month.dart';
import 'package:fortunica/presentation/screens/balance_and_transactions/widgets/month_header_widget.dart';
import 'package:shared_advisor_interface/app_constants.dart';

class StatisticsWidget extends StatelessWidget {
  final List<ReportsMonth> months;

  final ReportsStatistics? statistics;

  final int currentMonthIndex;

  final ValueSetter<int> setIndex;

  const StatisticsWidget({
    Key? key,
    required this.months,
    required this.currentMonthIndex,
    required this.setIndex,
    this.statistics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(
          AppConstants.horizontalScreenPadding,
        ),
        child: Column(
          children: [
            MonthHeaderWidget(
              months: months,
              currentMonthIndex: currentMonthIndex,
              setIndex: setIndex,
            ),
            const SizedBox(
              height: 16.0,
            ),
            if (statistics != null)
              ListOfMarketsByMonth(
                reportsStatistics: statistics!,
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
