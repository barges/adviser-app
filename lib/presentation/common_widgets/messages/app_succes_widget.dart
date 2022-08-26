import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';
import 'package:shared_advisor_interface/presentation/themes/app_colors.dart';

class AppSuccessWidget extends StatelessWidget {
  final String message;
  final VoidCallback close;
  final bool showEmailButton;

  const AppSuccessWidget(
      {Key? key,
      required this.message,
      required this.close,
      this.showEmailButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Get.theme.primaryColorLight,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppConstants.buttonRadius),
            bottomRight: Radius.circular(AppConstants.buttonRadius),
          )),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Get.theme.primaryColor,
                    ),
                  ),
                  if (showEmailButton)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: _OpenEmailButton(),
                    )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: GestureDetector(
                onTap: close,
                child: Icon(
                  Icons.close,
                  color: Get.theme.primaryColor,
                  size: 18.0,
                )),
          )
        ],
      ),
    );
  }
}

class _OpenEmailButton extends StatelessWidget {
  const _OpenEmailButton({Key? key}) : super(key: key);

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
              mailApps: result.options,
            );
          },
        );
      },
    );
  }
}
