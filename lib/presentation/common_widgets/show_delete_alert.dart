import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Theme.of(context).hoverColor,
                  fontSize: 17.0,
                ),
          ),
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(S.of(context).delete,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).errorColor,
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
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
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
