import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScreenPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Utils.isDarkMode(context)
                      ? Assets.images.logos.forceUpdateLogoDark.image(
                          height: AppConstants.logoSize,
                          width: AppConstants.logoSize,
                        )
                      : Assets.images.logos.forceUpdateLogo.image(
                          height: AppConstants.logoSize,
                          width: AppConstants.logoSize,
                        ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    S.of(context).pleaseUpdateTheApp,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    S.of(context).thisVersionOfTheAppIsNoLongerSupported,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16.0,
                      color: theme.shadowColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 68.0,
                  ),
                  AppElevatedButton(
                    title: S.of(context).update,
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: 22.0,
                  ),
                  GestureDetector(
                    onTap: null,
                    child: Text(
                      S.of(context).learnMore,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 17.0,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 34.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
