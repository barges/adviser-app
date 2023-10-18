import 'package:flutter/material.dart';

import '../../app_constants.dart';
import '../../data/models/enums/markets_type.dart';
import '../../generated/assets/assets.gen.dart';
import '../../generated/l10n.dart';
import 'picker_modal_pop_up.dart';

class MarketFilterWidget extends StatelessWidget {
  final List<MarketsType> userMarkets;
  final int currentMarketIndex;
  final ValueChanged<int> changeIndex;
  final bool isExpanded;

  const MarketFilterWidget({
    Key? key,
    required this.userMarkets,
    required this.currentMarketIndex,
    required this.changeIndex,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return userMarkets.length > 2
        ? GestureDetector(
            onTap: () => showPickerModalPopUp(
              context: context,
              setIndex: changeIndex,
              currentIndex: currentMarketIndex,
              elements: userMarkets.map((element) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (element.flagImagePath.isNotEmpty)
                      Image.asset(element.flagImagePath),
                    Text(element.languageName(context)),
                  ],
                );
              }).toList(),
            ),
            child: Builder(builder: (context) {
              final MarketsType currentMarket = userMarkets[currentMarketIndex];
              return Container(
                height: AppConstants.iconButtonSize,
                margin: isExpanded
                    ? const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: AppConstants.horizontalScreenPadding)
                    : null,
                padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: AppConstants.horizontalScreenPadding),
                decoration: BoxDecoration(
                    color: currentMarket != MarketsType.all
                        ? theme.primaryColorLight
                        : theme.scaffoldBackgroundColor,
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius)),
                child: Row(
                  mainAxisSize:
                      isExpanded ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${SFortunica.of(context).marketFortunica} ${currentMarket.languageName(context)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: currentMarket != MarketsType.all
                            ? theme.primaryColor
                            : theme.hoverColor,
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Assets.vectors.arrowDown.svg(
                      color: currentMarket != MarketsType.all
                          ? theme.primaryColor
                          : theme.hoverColor,
                    )
                  ],
                ),
              );
            }),
          )
        : const SizedBox.shrink();
  }
}
