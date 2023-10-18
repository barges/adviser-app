import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_constants.dart';
import '../../../generated/assets/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/buttons/app_elevated_button.dart';

class ForceUpdateScreen extends StatefulWidget {
  final ForceUpdateScreenArguments forceUpdateScreenArguments;

  const ForceUpdateScreen({
    Key? key,
    required this.forceUpdateScreenArguments,
  }) : super(key: key);

  @override
  State<ForceUpdateScreen> createState() => _ForceUpdateScreenState();
}

class _ForceUpdateScreenState extends State<ForceUpdateScreen> {
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
                            widget.forceUpdateScreenArguments.title ??
                                SFortunica.of(context).pleaseUpdateTheApp,
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            widget.forceUpdateScreenArguments.description ??
                                SFortunica.of(context)
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
                    title: SFortunica.of(context).update,
                    onPressed: _goToStore,
                  ),
                  SizedBox(
                    height: widget.forceUpdateScreenArguments.moreLink == null
                        ? 24.0
                        : 16.0,
                  ),
                  if (widget.forceUpdateScreenArguments.moreLink != null)
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
                            SFortunica.of(context).learnMore,
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
      uri = Uri.parse(widget.forceUpdateScreenArguments.updateLink ??
          'https://apps.apple.com/app/id${AppConstants.fortunicaIosAppId}');
    } else {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      uri = Uri.parse(widget.forceUpdateScreenArguments.updateLink ??
          'market://details?id=${packageInfo.packageName}');
    }

    _openUrl(uri);
  }

  Future<void> _openLearnMoreLink() async {
    final Uri uri = Uri.parse(widget.forceUpdateScreenArguments.moreLink ?? '');
    _openUrl(uri);
  }

  Future<void> _openUrl(Uri uri) async {
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $uri'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

class ForceUpdateScreenArguments {
  final String? title;
  final String? description;
  final String? updateLink;
  final String? moreLink;

  ForceUpdateScreenArguments({
    this.title,
    this.description,
    this.updateLink,
    this.moreLink,
  });
}
