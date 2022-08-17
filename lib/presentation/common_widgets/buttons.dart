import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

import '../resources/app_icons.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  const AppElevatedButton({Key? key, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 14.0)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ))),
        child: Text(text ?? ''),
      ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  final String? text;

  const AppBackButton({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator.canPop(context)
        ? InkResponse(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(AppIcons.iosBackButton,
                      color: Get.theme.primaryColor, size: 16.0),
                  Text(
                    text ?? S.of(context).back,
                    style: Get.textTheme.labelMedium?.copyWith(
                      color: Get.theme.primaryColor,
                    ),
                  )
                ],
              ),
            ))
        : const SizedBox();
  }
}
