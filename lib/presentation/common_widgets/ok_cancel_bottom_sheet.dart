import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

Future<void> showOkCancelBottomSheet({
  required BuildContext context,
  required VoidCallback okOnTap,
  String okButtonText = 'Ok',
  VoidCallback? cancelOnTap,
}) async {
  if (Platform.isAndroid) {
    Get.bottomSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: okOnTap,
            child: Container(
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              width: Get.width,
              child: Center(
                  child: Text(
                okButtonText,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
              if (cancelOnTap != null) {
                cancelOnTap();
              }
            },
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Center(
                child: Text(S.of(context).cancel,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Get.theme.primaryColor,
                    )),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Get.theme.canvasColor,
    );
  } else {
    await showCupertinoModalPopup(
        context: context,
        builder: (_) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: okOnTap,
                child: Text(
                  okButtonText,
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Get.back();
                if (cancelOnTap != null) {
                  cancelOnTap();
                }
              },
              child: Text(
                S.of(context).cancel,
              ),
            ),
          );
        });
  }
}
