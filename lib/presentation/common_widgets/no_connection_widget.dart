import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Utils.isDarkMode(context)
                  ? Assets.images.logos.noConnectionLogoDark.image(
                      height: AppConstants.logoSize,
                      width: AppConstants.logoSize,
                    )
                  : Assets.images.logos.noConnectionLogo.image(
                      height: AppConstants.logoSize,
                      width: AppConstants.logoSize,
                    ),
              const SizedBox(
                height: 24.0,
              ),
              Text(
                S.of(context).noInternetConnection,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    S.of(context).uhohNoNetworkNcheckYourInternetConnection,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16.0,
                          color: Theme.of(context).shadowColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
