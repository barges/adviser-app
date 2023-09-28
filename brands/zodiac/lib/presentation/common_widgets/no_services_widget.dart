import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';

class NoServicesWidget extends StatelessWidget {
  const NoServicesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
      ),
      child: Column(
        children: [
          Utils.isDarkMode(context)
              ? Assets.zodiac.vectors.serviceEmptyStateDark.svg()
              : Assets.zodiac.vectors.serviceEmptyStateLight.svg(),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            SZodiac.of(context).letsCreateYourFirstServiceZodiac,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            SZodiac.of(context).firstYouNeedFillInformationAboutServiceZodiac,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).shadowColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
