import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';

class CategoryMenuItemWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryMenuItemWidget({
    Key? key,
    required this.title,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 9.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          color: isSelected
              ? theme.primaryColorLight
              : theme.scaffoldBackgroundColor,
        ),
        child: Text(
          title,
          style: isSelected
              ? theme.textTheme.labelMedium
                  ?.copyWith(color: theme.primaryColor, fontSize: 15.0)
              : theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
