import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/generated/l10n.dart';

class ResendMessageWidget extends StatelessWidget {
  const ResendMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [_CancelSendingWidget()]);
  }
}

class _CancelSendingWidget extends StatelessWidget {
  const _CancelSendingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Text(
            SZodiac.of(context).cancelSendingZodiac,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 12.0,
              color: AppColors.error,
            ),
          ),
          const SizedBox(
            width: 4.0,
          ),
          Assets.vectors.cross.svg(
            height: 16.0,
            width: 16.0,
            color: AppColors.error,
          )
        ],
      ),
    );
  }
}
