import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class ListOfFiltersWidget extends StatelessWidget {
  final List<String> filters;
  final List<VoidCallback> onTaps;
  final int currentFilterIndex;

  const ListOfFiltersWidget(
      {Key? key,
      required this.currentFilterIndex,
      required this.filters,
      required this.onTaps})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52.0,
          color: Get.theme.canvasColor,
          padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: AppConstants.horizontalScreenPadding),
          alignment: Alignment.center,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, index) => FilterWidget(
                    title: filters[index],
                    isSelected: index == currentFilterIndex,
                    onTap: onTaps[index],
                  ),
              separatorBuilder: (_, __) => const SizedBox(width: 8.0),
              itemCount: filters.length),
        ),
        SizedBox(
            height: 1.0,
            child: Divider(color: Get.theme.hintColor, thickness: 1))
      ],
    );
  }
}

class FilterWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const FilterWidget(
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: Get.textTheme.bodyMedium?.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
