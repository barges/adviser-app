// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:system_date_time_format/system_date_time_format.dart';
import 'package:zodiac/generated/l10n.dart';

Future<void> showTimePickerDialog(
    BuildContext context, ValueSetter<String> setTime) async {
  final ThemeData theme = Theme.of(context);

  final format = SystemDateTimeFormat();

  final String? timePattern = await format.getTimePattern();

  final bool use24hFormat = timePattern?.contains('a') == false;

  String returnedTime = DateFormat(timePattern).format(DateTime.now());

  return await showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return Container(
        height: 232.0,
        color: theme.canvasColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: context.pop,
                    child: Text(
                      SZodiac.of(context).cancelZodiac,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: theme.primaryColor, height: 1.33),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setTime(returnedTime);
                      context.pop();
                    },
                    child: Text(
                      SZodiac.of(context).doneZodiac,
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: theme.primaryColor,
                        fontSize: 15.0,
                        height: 1.33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  onDateTimeChanged: (date) {
                    returnedTime = DateFormat(timePattern).format(date);
                  },
                  use24hFormat: use24hFormat,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
