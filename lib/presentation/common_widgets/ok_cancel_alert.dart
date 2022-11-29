import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

Future showOkCancelAlert({
  required BuildContext context,
  required String title,
  required String okText,
  required VoidCallback actionOnOK,
  required bool allowBarrierClock,
  required bool isCancelEnabled,
}) async {
  ThemeData theme = Theme.of(context);
  await showDialog(
      barrierDismissible: allowBarrierClock,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () => Future.value(allowBarrierClock),
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text(title,
                      style:
                          theme.textTheme.bodyText2?.copyWith(fontSize: 19.0)),
                  actions: [
                    if (isCancelEnabled)
                      CupertinoDialogAction(
                        child: Text(S.of(context).cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: actionOnOK,
                      child: Text(okText),
                    )
                  ],
                )
              : Dialog(
                  backgroundColor: Theme.of(context).canvasColor,
                  insetPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalScreenPadding),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      left: 16.0,
                      right: 16.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontSize: 17.0,
                              )),
                          const SizedBox(
                            height: 24.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isCancelEnabled)
                                TextButton(
                                  child: Text(S.of(context).cancel,
                                      style: theme.textTheme.displayLarge
                                          ?.copyWith(
                                        fontSize: 14.0,
                                        color: theme.errorColor,
                                      )),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              TextButton(
                                onPressed: actionOnOK,
                                child: Text(okText,
                                    style:
                                        theme.textTheme.displayLarge?.copyWith(
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
      });
}
