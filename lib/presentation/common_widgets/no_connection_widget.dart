import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.horizontalScreenPadding,
      ),
      child: Column(
        children: [
          Get.isDarkMode
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
            S.of(context).youDontHaveAnInternetConnection,
            style: Get.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
