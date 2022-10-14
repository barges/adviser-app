import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_market.dart';
import 'package:shared_advisor_interface/data/models/reports_endpoint/reports_statistics.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/balance_and_transactions_cubit.dart';
import 'package:shared_advisor_interface/presentation/screens/balance_and_transactions/widgets/reports_market_widget.dart';

class ListOfMarketsByMonth extends StatelessWidget {
  final ReportsStatistics reportsStatistics;

  const ListOfMarketsByMonth({Key? key, required this.reportsStatistics})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ReportsMarket> markets = reportsStatistics.markets ?? [];

    final BalanceAndTransactionsCubit balanceAndTransactionsCubit =
        context.read<BalanceAndTransactionsCubit>();

    final String currencySymbol = balanceAndTransactionsCubit
        .currencySymbolByName(reportsStatistics.meta?.currency ?? '');
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(
        AppConstants.horizontalScreenPadding,
      ),
      decoration: BoxDecoration(
        color: Get.theme.canvasColor,
        borderRadius: BorderRadius.circular(
          AppConstants.buttonRadius,
        ),
      ),
      child: Column(
        children: [
          Column(
            children: markets.mapIndexed((element, index) {
              return ReportsMarketWidget(
                reportsMarket: element,
                currencySymbol: currencySymbol,
                rates: reportsStatistics.meta?.rates ?? {},
                isNotFirst: index > 0,
              );
            }).toList(),
          ),
          Container(
            height: 28.0,
            margin: const EdgeInsets.only(top: 24.0),
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${S.of(context).totalMarkets}:',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    color: Get.theme.primaryColor,
                  ),
                ),
                Container(
                  height: 28.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Get.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.buttonRadius,
                    ),
                  ),
                  child: Text(
                    '~ $currencySymbol '
                    '${reportsStatistics.total?.marketTotal?.amount?.toStringAsFixed(2) ?? 0.0}',
                    style: Get.textTheme.headlineMedium?.copyWith(
                      color: Get.theme.primaryColor,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
