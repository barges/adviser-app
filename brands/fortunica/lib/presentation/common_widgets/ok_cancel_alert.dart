import 'dart:io';

import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';

Future<bool?> showOkCancelAlert({
  required BuildContext context,
  required String title,
  required String okText,
  VoidCallback? actionOnOK,
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
                        SFortunica.of(context).cancelFortunica,
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
                                child: Text(
                                    SFortunica.of(context)
                                        .cancelFortunica
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
