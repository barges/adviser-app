import 'package:flutter/material.dart';

class RadioButtonWidget extends StatelessWidget {
  final bool isSelected;
  const RadioButtonWidget({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: 22.0,
      width: 22.0,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.scaffoldBackgroundColor,
        border: Border.all(
          color: isSelected ? theme.primaryColor : theme.shadowColor,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor,
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
