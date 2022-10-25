import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ListOfFiltersWidget extends StatelessWidget {
  final List<String> filters;
  final ValueChanged<int> onTap;
  final int currentFilterIndex;

  const ListOfFiltersWidget(
      {Key? key,
      required this.currentFilterIndex,
      required this.filters,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.0,
      color: Get.theme.canvasColor,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScreenPadding,
          ),
          itemBuilder: (_, index) => _FilterWidget(
                title: filters[index],
                isSelected: index == currentFilterIndex,
                onTap: () => onTap(index),
              ),
          separatorBuilder: (_, __) => const SizedBox(width: 8.0),
          itemCount: filters.length),
    );
  }
}

class _FilterWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterWidget(
      {Key? key, required this.title, required this.isSelected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        isSelected ? Get.theme.primaryColor : Get.theme.hoverColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 6.0, horizontal: AppConstants.horizontalScreenPadding),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected
                ? Get.theme.primaryColor.withOpacity(0.4)
                : Get.theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius)),
        child: Text(title,
            style: Get.textTheme.bodyMedium?.copyWith(color: textColor)),
      ),
    );
  }
}
