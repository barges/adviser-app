import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class FiltersWidget extends StatelessWidget {
  final List<Widget> filters;
  final ValueChanged<int> onTap;
  final int currentFilterIndex;
  final EdgeInsets? itemPadding;

  const FiltersWidget(
      {Key? key,
      required this.currentFilterIndex,
      required this.filters,
      required this.onTap,
      this.itemPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.iconButtonSize,
      color: Get.theme.canvasColor,
      alignment: Alignment.center,
      child: ListView.separated(
          padding:
              const EdgeInsets.only(left: AppConstants.horizontalScreenPadding),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => FilterWidget(
                title: filters[index],
                isSelected: index == currentFilterIndex,
                onTap: () {
                  onTap(index);
                },
                itemPadding: itemPadding,
              ),
          separatorBuilder: (_, __) => const SizedBox(width: 8.0),
          itemCount: filters.length),
    );
  }
}

class FilterWidget extends StatelessWidget {
  final Widget title;
  final bool isSelected;
  final VoidCallback? onTap;
  final EdgeInsets? itemPadding;

  const FilterWidget(
      {Key? key,
      required this.title,
      required this.isSelected,
      this.itemPadding,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      child: Material(
        textStyle: Get.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Get.theme.primaryColor : Get.theme.hoverColor),
        child: Container(
            padding: itemPadding,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isSelected
                    ? Get.theme.primaryColor.withOpacity(0.4)
                    : Get.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [title],
            )),
      ),
    );
  }
}
