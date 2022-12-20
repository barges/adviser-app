import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/data/models/enums/markets_type.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/market_filter_widget.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ListOfFiltersWidget extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<int?> onTapToFilter;
  final List<MarketsType> userMarkets;
  final int? currentFilterIndex;
  final int currentMarketIndex;
  final ValueChanged<int> onTapToMarket;
  final bool withMarketFilter;

  const ListOfFiltersWidget(
      {Key? key,
      required this.currentFilterIndex,
      required this.filters,
      required this.onTapToFilter,
      required this.userMarkets,
      required this.currentMarketIndex,
      required this.onTapToMarket,
      this.withMarketFilter = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: AppConstants.appBarHeight,
        color: Theme.of(context).canvasColor,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScreenPadding,
            ),
            child: Row(
              children: filters
                  .map<Widget>(
                    (element) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _FilterWidget(
                        title: element,
                        isSelected:
                            filters.indexOf(element) == currentFilterIndex,
                        onTap: onTapToFilter,
                        filterIndex: filters.indexOf(element),
                      ),
                    ),
                  )
                  .toList()
                ..add(
                  MarketFilterWidget(
                      userMarkets: userMarkets,
                      currentMarketIndex: currentMarketIndex,
                      changeIndex: onTapToMarket),
                ),
            ),
          ),
        )

        // ListView.separated(
        //   shrinkWrap: true,
        //   scrollDirection: Axis.horizontal,
        //   padding: withMarketFilter
        //       ? const EdgeInsets.only(
        //           left: AppConstants.horizontalScreenPadding,
        //           right: 8.0,
        //         )
        //       : const EdgeInsets.symmetric(
        //           horizontal: AppConstants.horizontalScreenPadding,
        //         ),
        //   itemBuilder: (_, index) => _FilterWidget(
        //     title: filters[index],
        //     isSelected: index == currentFilterIndex,
        //     onTap: () => onTapToFilter(index),
        //   ),
        //   separatorBuilder: (_, __) => const SizedBox(width: 8.0),
        //   itemCount: filters.length,
        // ),
        );
  }
}

class _FilterWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final int filterIndex;
  final ValueChanged<int?> onTap;

  const _FilterWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.filterIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelected ? onTap(null) : onTap(filterIndex);
      },
      child: Container(
        height: AppConstants.iconButtonSize,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScreenPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: isSelected
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
        ),
      ),
    );
  }
}
