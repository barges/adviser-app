import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

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
        if (onChanged != null) {
          onChanged!(!value);
        }
      },
      child: value
          ? Assets.zodiac.vectors.filledCheckbox.svg(
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
