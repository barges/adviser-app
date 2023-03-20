import 'dart:io';

import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zodiac/generated/l10n.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';

Future<void> showOkCancelBottomSheet({
  required BuildContext context,
  required VoidCallback okOnTap,
  String okButtonText = 'Ok',
  VoidCallback? cancelOnTap,
}) async {
  final route = zodiacGetIt.get<AppRouter>();

  if (Platform.isAndroid) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: okOnTap,
            child: Container(
              padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                okButtonText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).errorColor,
                    ),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {
              route.pop(context);
              if (cancelOnTap != null) {
                cancelOnTap();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Center(
                child: Text(SZodiac.of(context).cancelZodiac,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        )),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).canvasColor,
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
                route.pop(context);
                if (cancelOnTap != null) {
                  cancelOnTap();
                }
              },
              child: Text(
                SZodiac.of(context).cancelZodiac,
              ),
            ),
          );
        });
  }
}
