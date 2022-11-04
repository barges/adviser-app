import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/picker_modal_pop_up.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

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
                    Text(element.languageName),
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
                        color: Get.theme.primaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    Assets.vectors.arrowDown.svg()
                  ],
                ),
              );
            }),
          )
        : const SizedBox.shrink();
  }
}
