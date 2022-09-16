import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

class AppErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback close;

  const AppErrorWidget(
      {Key? key, required this.errorMessage, required this.close})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
          color: Get.theme.errorColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppConstants.buttonRadius),
            bottomRight: Radius.circular(AppConstants.buttonRadius),
          )),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
              child: Text(
                errorMessage,
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Get.theme.backgroundColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: GestureDetector(
              onTap: close,
              child: Assets.vectors.close.svg(
                color: Get.theme.backgroundColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
