import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/picker_modal_pop_up.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/screens/home/tabs/sessions/sessions_cubit.dart';

class MarketFilterWidget extends StatelessWidget {
  final ValueChanged<int> changeIndex;
  final bool isExpanded;

  const MarketFilterWidget({
    Key? key,
    required this.changeIndex,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MarketsType> userMarkets =
        context.select((SessionsCubit cubit) => cubit.state.userMarkets);

    final int currentMarketIndex = context.select(
        (SessionsCubit cubit) => cubit.state.currentMarketIndexForPrivate);
    return userMarkets.length > 2
        ? Container(
            height: AppConstants.appBarHeight,
            color: Get.theme.canvasColor,
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
                  margin: isExpanded
                      ? const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: AppConstants.horizontalScreenPadding,
                        )
                      : const EdgeInsets.only(
                          top: 10.0,
                          bottom: 10.0,
                          right: AppConstants.horizontalScreenPadding,
                        ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: AppConstants.horizontalScreenPadding),
                  decoration: BoxDecoration(
                      color: isNotAllTypeMarket
                          ? Get.theme.primaryColorLight
                          : Get.theme.scaffoldBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(AppConstants.buttonRadius)),
                  child: Row(
                    mainAxisSize:
                        isExpanded ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${S.of(context).market} ${currentMarket.languageName}',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          color: isNotAllTypeMarket
                              ? Get.theme.primaryColor
                              : Get.textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      Assets.vectors.arrowDown.svg(
                       color: isNotAllTypeMarket
                            ? Get.theme.primaryColor
                            : Get.theme.hoverColor,
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
