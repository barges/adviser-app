import 'package:flutter/material.dart';
import 'package:zodiac/presentation/common_widgets/checkbox_widget.dart';

class MethodItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const MethodItem({
    Key? key,
    required this.title,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 5.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: isSelected
              ? theme.primaryColorLight
              : theme.scaffoldBackgroundColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: isSelected
                  ? theme.textTheme.labelMedium?.copyWith(
                      fontSize: 15.0,
                      color: theme.primaryColor,
                    )
                  : theme.textTheme.bodyMedium,
            ),
            CheckboxWidget(value: isSelected),
          ],
        ));
  }
}
