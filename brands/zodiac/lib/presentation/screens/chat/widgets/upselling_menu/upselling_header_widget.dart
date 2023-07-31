import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

class UpsellingHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onCrossTap;

  const UpsellingHeaderWidget({
    Key? key,
    required this.title,
    this.onCrossTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        const SizedBox(
          width: 32.0,
        ),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 17.0),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        GestureDetector(
          onTap: onCrossTap,
          child: Assets.zodiac.vectors.crossSmall.svg(
            height: AppConstants.iconSize,
            width: AppConstants.iconSize,
            colorFilter: ColorFilter.mode(
              theme.shadowColor,
              BlendMode.srcIn,
            ),
          ),
        )
      ],
    );
  }
}
