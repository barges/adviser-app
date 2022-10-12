import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class FiltersListWidget extends StatelessWidget {
  final List<Widget> filters;
  final ValueChanged<int> onTap;
  final int currentFilterIndex;

  const FiltersListWidget(
      {Key? key,
      required this.currentFilterIndex,
      required this.filters,
      required this.onTap})
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
        itemBuilder: (_, index) => _FilterWidget(
          title: filters[index],
          isSelected: index == currentFilterIndex,
          onTap: () {
            onTap(index);
          },
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 8.0),
        itemCount: filters.length,
      ),
    );
  }
}

class _FilterWidget extends StatelessWidget {
  final Widget title;
  final bool isSelected;
  final VoidCallback? onTap;

  const _FilterWidget(
      {Key? key, required this.title, required this.isSelected, this.onTap})
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
            padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: AppConstants.horizontalScreenPadding),
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
