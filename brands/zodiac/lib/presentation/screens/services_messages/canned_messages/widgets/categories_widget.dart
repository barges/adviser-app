import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/data/models/canned_messages/canned_category.dart';

class CategoriesWidget extends StatelessWidget {
  final ValueChanged<int> onTap;
  final List<CannedCategory> categories;
  final int initialSelectedIndex;
  final String? title;
  late final ValueNotifier<int> indexNotifier =
      ValueNotifier(initialSelectedIndex);

  CategoriesWidget({
    super.key,
    required this.onTap,
    required this.categories,
    this.title,
    this.initialSelectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              title!,
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
            ),
          ),
        Column(
            children: categories.mapIndexed<Widget>(
          (index, element) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index != categories.length - 1 ? 12.0 : 0.0),
              child: ValueListenableBuilder(
                valueListenable: indexNotifier,
                builder: (_, int value, __) {
                  return _RadioButton(
                    title: element.name ?? '',
                    isSelected: value == index,
                    onTap: () {
                      if (value != index) {
                        onTap(index);
                      }
                      indexNotifier.value = index;
                    },
                  );
                },
              ),
            );
          },
        ).toList()),
      ],
    );
  }
}

class _RadioButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioButton({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: isSelected
              ? theme.primaryColorLight
              : theme.scaffoldBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? theme.primaryColor : theme.hoverColor,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400),
            ),
            isSelected
                ? Assets.zodiac.vectors.radioButtonOn.svg()
                : Assets.zodiac.vectors.radioButtonOff.svg()
          ],
        ),
      ),
    );
  }
}