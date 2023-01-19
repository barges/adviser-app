import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding,
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            S
                                .of(context)
                                .thisVersionOfTheAppIsNoLongerSupported,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 16.0,
                              color: theme.shadowColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppElevatedButton(
                    title: S.of(context).update,
                    onPressed: goToStore,
                  ),
                  const SizedBox(
                    height: 58.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> goToStore() async {
    String appId = '1164888500';
    if (Platform.isAndroid) {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appId = packageInfo.packageName;
    }

    final Uri url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
