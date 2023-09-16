import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';

Future<bool?> showOkCancelAlert({
  required BuildContext context,
  required String title,
  required String okText,
  Color? okTextColor,
  VoidCallback? actionOnOK,
  required bool allowBarrierClick,
  required bool isCancelEnabled,
  String? description,
  String? cancelText,
}) async {
  ThemeData theme = Theme.of(context);
  return await showDialog(
    barrierDismissible: allowBarrierClick,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () => Future.value(allowBarrierClick),
        child: Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                ),
                content: description != null
                    ? Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 13.0,
                        ),
                      )
                    : null,
                actions: [
                  if (isCancelEnabled)
                    CupertinoDialogAction(
                      child: Text(
                        cancelText ?? S.of(context).cancel,
                      ),
                      onPressed: () {
                        context.popForced(false);
                      },
                    ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      context.popForced(true);
                      if (actionOnOK != null) {
                        actionOnOK();
                      }
                    },
                    child: Text(okText,
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: okTextColor ?? theme.primaryColor,
                        )),
                  )
                ],
              )
            : Dialog(
                backgroundColor: Theme.of(context).canvasColor,
                elevation: 0.0,
                shape: const ContinuousRectangleBorder(),
                insetPadding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.horizontalScreenPadding),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontSize: 17.0),
                        ),
                        if (description != null)
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12.0,
                            ),
                            child: Text(
                              description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 24.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isCancelEnabled)
                              TextButton(
                                child: Text(
                                    (cancelText ?? S.of(context).cancel)
                                        .toUpperCase(),
                                    style:
                                        theme.textTheme.displayLarge?.copyWith(
                                      fontSize: 14.0,
                                      color: theme.errorColor,
                                    )),
                                onPressed: () => context.popForced(false),
                              ),
                            TextButton(
                              onPressed: () {
                                context.popForced(true);
                                if (actionOnOK != null) {
                                  actionOnOK();
                                }
                              },
                              child: Text(okText.toUpperCase(),
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontSize: 14.0,
                                    color: theme.primaryColor,
                                  )),
                            )
                          ],
                        )
                      ]),
                ),
              ),
      );
    },
  );
}
