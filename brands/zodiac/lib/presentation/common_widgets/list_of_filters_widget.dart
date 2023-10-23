import 'package:collection/collection.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:flutter/material.dart';

class ListOfFiltersWidget extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<int> onTapToFilter;
  final int? currentFilterIndex;
  final double? itemWidth;
  final double padding;

  const ListOfFiltersWidget({
    Key? key,
    required this.filters,
    required this.onTapToFilter,
    required this.currentFilterIndex,
    this.itemWidth,
    this.padding = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: filters.mapIndexed<Widget>(
        (index, element) {
          final bool isSelected = index == currentFilterIndex;
          return Padding(
            padding: index != filters.length - 1
                ? const EdgeInsets.only(right: 8.0)
                : EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? padding : 0.0,
                  right: index == filters.length - 1 ? padding : 0.0),
              child: _FilterWidget(
                title: element,
                isSelected: isSelected,
                onTap: () => onTapToFilter(
                  index,
                ),
                width: itemWidth,
              ),
            ),
          );
        },
      ).toList()),
    );
  }
}

class _FilterWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;

  const _FilterWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 38.0,
        padding:
            width == null ? const EdgeInsets.symmetric(horizontal: 24.0) : null,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: isSelected
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).canvasColor,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).hoverColor,
              ),
        ),
      ),
    );
  }
}
