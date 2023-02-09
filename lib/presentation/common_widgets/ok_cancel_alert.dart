import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

Future<bool?> showOkCancelAlert({
  required BuildContext context,
  required String title,
  required String okText,
  required VoidCallback actionOnOK,
  required bool allowBarrierClick,
  required bool isCancelEnabled,
  String? description,
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
                        S.of(context).cancel,
                      ),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: actionOnOK,
                    child: Text(
                      okText,
                    ),
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
                                child: Text(S.of(context).cancel.toUpperCase(),
                                    style:
                                        theme.textTheme.displayLarge?.copyWith(
                                      fontSize: 14.0,
                                      color: theme.errorColor,
                                    )),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            TextButton(
                              onPressed: actionOnOK,
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
