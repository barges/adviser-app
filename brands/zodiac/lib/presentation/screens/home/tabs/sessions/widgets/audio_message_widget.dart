import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:zodiac/generated/l10n.dart';

class AudioMessageWidget extends StatelessWidget {
  const AudioMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Container(
          height: AppConstants.iconSize,
          width: AppConstants.iconSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.primaryColorLight,
          ),
          child: Assets.vectors.play.svg(
            height: AppConstants.iconSize,
            width: AppConstants.iconSize,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          SZodiac.of(context).audioMessageZodiac,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 14.0,
            color: theme.shadowColor,
          ),
        )
      ],
    );
  }
}
