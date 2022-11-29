import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/picker_modal_pop_up.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';

class MarketFilterWidget extends StatelessWidget {
  final ValueChanged<int> changeIndex;
  final int currentMarketIndex;

  const MarketFilterWidget({
    Key? key,
    required this.changeIndex,
    required this.currentMarketIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MarketsType> userMarkets =
        context.select((SessionsCubit cubit) => cubit.state.userMarkets);

    return userMarkets.length > 2
        ? Container(
            height: AppConstants.appBarHeight,
            color: Theme.of(context).canvasColor,
            child: GestureDetector(
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
                      Text(element.languageName),
                    ],
                  );
                }).toList(),
              ),
              child: Builder(builder: (context) {
                final MarketsType currentMarket =
                    userMarkets[currentMarketIndex];
                final bool isNotAllTypeMarket =
                    currentMarket != MarketsType.all;
                return Container(
                  height: AppConstants.iconButtonSize,
                  margin: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: AppConstants.horizontalScreenPadding,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: AppConstants.horizontalScreenPadding),
                  decoration: BoxDecoration(
                      color: isNotAllTypeMarket
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius)),
                  child: Row(
                    mainAxisSize:MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${S.of(context).market} ${currentMarket.languageName}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isNotAllTypeMarket
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                            ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Assets.vectors.arrowDown.svg(
                        color: isNotAllTypeMarket
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).hoverColor,
                      )
                    ],
                  ),
                );
              }),
            ),
          )
        : const SizedBox.shrink();
  }
}
