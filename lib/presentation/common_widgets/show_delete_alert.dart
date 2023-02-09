import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

Future<bool?> showDeleteAlert(
  BuildContext context,
  String title,
) {
  final ThemeData theme = Theme.of(context);
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
                child: Text(S.of(context).delete,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.errorColor,
                      fontSize: 17.0,
                    )),
              ),
              const SizedBox.shrink(),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => Navigator.pop(context, false),
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
                                color: theme.primaryColor,
                              )),
                          onPressed: () => Navigator.pop(context, false),
                        ),
                        TextButton(
                          child: Text(S.of(context).delete.toUpperCase(),
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 14.0,
                                color: theme.errorColor,
                              )),
                          onPressed: () => Navigator.pop(context, true),
                        )
                      ],
                    )
                  ]),
            ),
          ),
  );
}
