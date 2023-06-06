import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/themes/app_colors.dart';
import 'package:zodiac/generated/l10n.dart';

class ResendMessageWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onTryAgain;

  const ResendMessageWidget({
    Key? key,
    required this.onCancel,
    required this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _ResendButtonWidget(
        text: SZodiac.of(context).cancelSendingZodiac,
        iconPath: Assets.vectors.cross.path,
        color: AppColors.error,
        onTap: onCancel,
      ),
      const SizedBox(
        width: 8.0,
      ),
      _ResendButtonWidget(
        text: SZodiac.of(context).tryAgainZodiac,
        iconPath: Assets.zodiac.vectors.refreshIcon.path,
        color: Theme.of(context).primaryColor,
        onTap: onTryAgain,
      )
    ]);
  }
}

class _ResendButtonWidget extends StatelessWidget {
  final String text;
  final String iconPath;
  final Color color;
  final VoidCallback? onTap;

  const _ResendButtonWidget({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12.0,
                color: color,
              ),
            ),
            const SizedBox(
              width: 4.0,
            ),
            SvgPicture.asset(
              iconPath,
              height: 16.0,
              width: 16.0,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
