import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/routing/app_router.dart';
import '../../generated/l10n.dart';

Future<void> showOkCancelBottomSheet({
  required BuildContext context,
  required VoidCallback okOnTap,
  VoidCallback? cancelOnTap,
  String okButtonText = 'Ok',
}) async {
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
              context.pop();
              if (cancelOnTap != null) {
                cancelOnTap();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
              child: Center(
                child: Text(SFortunica.of(context).cancel,
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
                context.pop();
                if (cancelOnTap != null) {
                  cancelOnTap();
                }
              },
              child: Text(
                SFortunica.of(context).cancel,
              ),
            ),
          );
        });
  }
}
