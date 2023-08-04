import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:zodiac/generated/l10n.dart';

class SomethingWentWrongWidget extends StatelessWidget {
  const SomethingWentWrongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Utils.isDarkMode(context)
              ? Assets.images.logos.somethingWentWrongLogoDark.image(
                  height: AppConstants.logoSize,
                  width: AppConstants.logoSize,
                )
              : Assets.images.logos.somethingWentWrongLogo.image(
                  height: AppConstants.logoSize,
                  width: AppConstants.logoSize,
                ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            SZodiac.of(context).somethingWentWrongZodiac,
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            SZodiac.of(context).swipeDownToReloadZodiac,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.0,
              color: theme.shadowColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 24.0,
          ),
          Assets.vectors.arrowDown.svg(
            height: AppConstants.iconSize,
            width: AppConstants.iconSize,
            colorFilter: ColorFilter.mode(
              theme.shadowColor,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
