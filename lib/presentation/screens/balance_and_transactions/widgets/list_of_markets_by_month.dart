import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../extensions.dart';
import '../../../../app_constants.dart';
import '../../../../data/models/reports_endpoint/reports_market.dart';
import '../../../../data/models/reports_endpoint/reports_statistics.dart';
import '../../../../generated/l10n.dart';
import '../../../common_widgets/empty_list_widget.dart';
import 'reports_market_widget.dart';

class ListOfMarketsByMonth extends StatelessWidget {
  final ReportsStatistics reportsStatistics;

  const ListOfMarketsByMonth({Key? key, required this.reportsStatistics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ReportsMarket> markets = reportsStatistics.markets ?? [];
    final String currencySymbol =
        reportsStatistics.meta?.currency?.currencySymbolByName ?? '';
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(
        AppConstants.horizontalScreenPadding,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(
          AppConstants.buttonRadius,
        ),
      ),
      child: Column(
        children: [
          if (markets.isNotEmpty)
            Column(
              children: markets.mapIndexed((index, element) {
                return ReportsMarketWidget(
                  reportsMarket: element,
                  currencySymbol: currencySymbol,
                  rates: reportsStatistics.meta?.rates ?? {},
                  isNotFirst: index > 0,
                );
              }).toList(),
            )
          else
            EmptyListWidget(
              title: SFortunica.of(context)
                  .youHaveNotYetCompletedThisMonthsSessionsFortunica,
            ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (markets.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Divider(
                    height: 1.0,
                  ),
                ),
              Container(
                margin: EdgeInsets.only(
                  top: markets.isNotEmpty ? 24.0 : 16.0,
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${SFortunica.of(context).totalMarketsFortunica}:',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                    Container(
                      height: 28.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.buttonRadius,
                        ),
                      ),
                      child: Text(
                        '~ $currencySymbol '
                        '${reportsStatistics.total?.marketTotal?.amount?.toStringAsFixed(2) ?? 0.0}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
