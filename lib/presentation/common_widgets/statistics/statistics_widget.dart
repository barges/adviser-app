import 'package:flutter/material.dart';

import '../../../app_constants.dart';
import '../../../data/models/reports_endpoint/reports_month.dart';
import '../../../data/models/reports_endpoint/reports_statistics.dart';
import '../../screens/balance_and_transactions/widgets/list_of_markets_by_month.dart';
import '../../screens/balance_and_transactions/widgets/month_header_widget.dart';

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
