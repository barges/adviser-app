import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../app_constants.dart';

class ListOfFiltersWidget extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<int?> onTapToFilter;
  final int? currentFilterIndex;
  final bool withMarketFilter;

  const ListOfFiltersWidget(
      {Key? key,
      required this.currentFilterIndex,
      required this.filters,
      required this.onTapToFilter,
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
              padding: withMarketFilter
                  ? const EdgeInsets.only(
                      left: AppConstants.horizontalScreenPadding,
                      right: 8.0,
                    )
                  : const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding,
                    ),
              child: Row(
                  children: filters.mapIndexed<Widget>(
                (index, element) {
                  final bool isSelected = index == currentFilterIndex;
                  return Padding(
                    padding: index != filters.length - 1
                        ? const EdgeInsets.only(right: 8.0)
                        : EdgeInsets.zero,
                    child: _FilterWidget(
                      title: element,
                      isSelected: isSelected,
                      onTap: () => onTapToFilter(
                        isSelected ? null : index,
                      ),
                    ),
                  );
                },
              ).toList()),
            )));
  }
}

class _FilterWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
