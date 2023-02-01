import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_arguments.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdateScreen extends StatefulWidget {
  const ForceUpdateScreen({Key? key}) : super(key: key);

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
  final ForceUpdateScreenArguments? _arguments = Get.arguments;

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
                            _arguments?.title ??
                                S.of(context).pleaseUpdateTheApp,
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            _arguments?.description ??
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
                    onPressed: _goToStore,
                  ),
                  SizedBox(
                    height: _arguments?.moreLink == null ? 24.0 : 16.0,
                  ),
                  if (_arguments?.moreLink != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextButton(
                          onPressed: _openLearnMoreLink,
                          style: TextButton.styleFrom(
                            // minimumSize: Size.zero,
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            S.of(context).learnMore,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.primaryColor,
                            ),
                          )),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _goToStore() async {
    late Uri uri;

    if (Platform.isIOS) {
      uri = Uri.parse(_arguments?.updateLink ??
          'https://apps.apple.com/app/id${AppConstants.fortunicaIosAppId}');
    } else {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      uri = Uri.parse(_arguments?.updateLink ??
          'market://details?id=${packageInfo.packageName}');
    }

    _openUrl(uri);
  }

  Future<void> _openLearnMoreLink() async {
    final Uri uri = Uri.parse(_arguments?.moreLink ?? '');
    _openUrl(uri);
  }

  Future<void> _openUrl(Uri uri) async {
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 2),
        message: 'Could not launch $uri',
      ));
    }
  }
}
