import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/common_widgets/buttons/open_email_button.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppSuccessWidget extends StatelessWidget {
  final String message;
  final VoidCallback close;

  const AppSuccessWidget({
    Key? key,
    required this.message,
    required this.close,
  }) : super(key: key);

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: OpenEmailButton(),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            child: GestureDetector(
              onTap: close,
              child: Assets.vectors.close.svg(
                color: Get.theme.primaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
