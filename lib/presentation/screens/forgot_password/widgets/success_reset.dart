import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/app_elevated_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/utils/utils.dart';

class SuccessResetWidget extends StatelessWidget {
  const SuccessResetWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalScreenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Utils.isDarkMode(context)
              ? Assets.images.logos.successResetPasswordLogoDark.image(
                  height: AppConstants.logoSize,
                  width: AppConstants.logoSize,
                )
              : Assets.images.logos.successResetPasswordLogo.image(
                  height: AppConstants.logoSize,
                  width: AppConstants.logoSize,
                ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            S.of(context).nowYouCanLoginWithANewPassword,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 24.0,
          ),
          AppElevatedButton(
            title: S.of(context).login,
            onPressed: () => Get.back(),
          )
        ],
      ),
    );
  }
}
