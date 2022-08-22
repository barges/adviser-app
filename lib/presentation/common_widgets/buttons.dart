import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

import '../resources/app_icons.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AppElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Get.theme.primaryColorLight, Get.theme.primaryColorDark]),
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ),
        child: Text(text),
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
