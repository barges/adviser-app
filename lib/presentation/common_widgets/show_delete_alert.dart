import 'dart:io';

import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showDeleteAlert(
  BuildContext context,
  String title, {
  String? deleteText,
  bool swapButtonColorsForAndroid = false,
}) {
  final ThemeData theme = Theme.of(context);
  final String showDeleteText = deleteText ?? S.of(context).delete;

  return showDialog<bool>(
    context: context,
    builder: (context) => Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(
              title,
              style: theme.textTheme.displayLarge?.copyWith(
                color: theme.hoverColor,
                fontSize: 17.0,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context, true),
                child: Text(showDeleteText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.errorColor,
                      fontSize: 17.0,
                    )),
              ),
              const SizedBox.shrink(),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => context.popForced(false),
                child: Text(
                  S.of(context).cancel,
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: theme.primaryColor,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ],
          )
        : Dialog(
            backgroundColor: theme.canvasColor,
            elevation: 0.0,
            shape: const ContinuousRectangleBorder(),
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
                    Text(
                      title,
                      style:
                          theme.textTheme.labelLarge?.copyWith(fontSize: 17.0),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text(S.of(context).cancel.toUpperCase(),
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 14.0,
                                color: swapButtonColorsForAndroid
                                    ? theme.errorColor
                                    : theme.primaryColor,
                              )),
                          onPressed: () => context.popForced(false),
                        ),
                        TextButton(
                          child: Text(showDeleteText.toUpperCase(),
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 14.0,
                                color: swapButtonColorsForAndroid
                                    ? theme.primaryColor
                                    : theme.errorColor,
                              )),
                          onPressed: () => context.popForced(true),
                        )
                      ],
                    )
                  ]),
            ),
          ),
  );
}
