import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/reports_endpoint/reports_market.dart';
import '../../../../app_constants.dart';
import '../../../../extensions.dart';
import '../../../../data/models/enums/sessions_types.dart';
import '../../../../data/models/reports_endpoint/reports_unit.dart';
import '../../../../generated/l10n.dart';
import 'reports_unit_widget.dart';

class ReportsMarketWidget extends StatelessWidget {
  final ReportsMarket reportsMarket;
  final String currencySymbol;
  final Map<SessionsTypes, double> rates;
  final bool isNotFirst;

  const ReportsMarketWidget({
    Key? key,
    required this.reportsMarket,
    required this.currencySymbol,
    required this.rates,
    required this.isNotFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ReportsUnit> units = reportsMarket.units ?? [];
    return units.isNotEmpty
        ? Column(
            children: [
              if (isNotFirst)
                const SizedBox(
                  height: 32.0,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 22.0,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius),
                    ),
                    child: Text(
                      reportsMarket.iso?.languageNameByCode(context) ?? '',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              Column(
                children: units.mapIndexed((index, element) {
                  return ReportsUnitWidget(
                    reportsUnit: element,
                    currencySymbol: currencySymbol,
                    rate: rates[element.type] ?? 0.0,
                    previousIsCanceled: index != 0 &&
                        units[index - 1].numberCancelled != null &&
                        units[index - 1].amountCancelled != null,
                    isLastElement: index == units.length - 1,
                  );
                }).toList(),
              ),
              SizedBox(
                height: kToolbarHeight,
                child: Column(
                  children: [
                    const Divider(
                      height: 1.0,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${SFortunica.of(context).totalFortunica}:',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontSize: 16.0,
                                ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 24.0,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(
                                AppConstants.buttonRadius,
                              ),
                            ),
                            child: Text(
                              '~ $currencySymbol '
                              '${reportsMarket.marketTotal?.amount?.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1.0,
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
