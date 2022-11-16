import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

Future<bool?> showDeleteAlert(
  BuildContext context,
  String title,
) {
  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 52.0),
      child: Center(
        child: CupertinoActionSheet(
          title: Text(
            title,
            style: Get.textTheme.displayLarge?.copyWith(
              color: Get.theme.hoverColor,
              fontSize: 17.0,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Delete',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Get.theme.errorColor,
                    fontSize: 17.0,
                  )),
            ),
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                S.of(context).cancel,
                style: Get.textTheme.displayLarge?.copyWith(
                  color: Get.theme.primaryColor,
                  fontSize: 17.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
