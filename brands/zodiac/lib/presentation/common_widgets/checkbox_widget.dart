import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/utils/utils.dart';

class CheckboxWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  const CheckboxWidget({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(!value);
      },
      child: value
          ? Utils.isDarkMode(context)
              ? Assets.zodiac.vectors.filledCheckboxDark.svg(
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                )
              : Assets.zodiac.vectors.filledCheckbox.svg(
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                )
          : Utils.isDarkMode(context)
              ? Assets.zodiac.vectors.emptyCheckboxDark.svg(
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                )
              : Assets.zodiac.vectors.emptyCheckbox.svg(
                  height: AppConstants.iconSize,
                  width: AppConstants.iconSize,
                ),
    );
  }
}
