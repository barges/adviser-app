import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class OpenEmailButton extends StatelessWidget {
  const OpenEmailButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
          gradient: const LinearGradient(
              colors: [AppColors.ctaGradient1, AppColors.ctaGradient2]),
        ),
        child: Text(
          S.of(context).openEmailApp,
          style: Get.textTheme.labelMedium
              ?.copyWith(color: Get.theme.backgroundColor),
        ),
      ),
      onTap: () async {
        var result = await OpenMailApp.openMailApp();
        showDialog(
          context: context,
          builder: (_) {
            return MailAppPickerDialog(
              title: S.of(context).chooseEmailApp,
              mailApps: result.options,
            );
          },
        );
      },
    );
  }
}
