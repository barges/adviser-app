import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

Future<bool?> showReturnInQueueAlert(
  BuildContext context,
) {
  final theme = Theme.of(context);
  final s = S.of(context);

  return showCupertinoDialog<bool>(
    context: context,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Center(
        child: CupertinoAlertDialog(
          title: Text(
            s.youRefuseToAnswerThisQuestion,
            style: theme.textTheme.displayLarge?.copyWith(
              color: theme.hoverColor,
              fontSize: 17.0,
            ),
          ),
          content: Text(
            s.itWillGoBackIntoTheGeneralQueueAndYouWillNotBeAbleToTakeItAgain,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.hoverColor,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                    fontSize: 17.0,
                  )),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                s.return_,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: theme.primaryColor,
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
