import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:zodiac/generated/l10n.dart';

extension DateTimeExt on DateTime {
  String listTime(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference == 0) {
      return SZodiac.of(context).todayZodiac;
    }
    if (timeDifference == -1) {
      ///TODO: need change
      return 'Yesterday';
    }
    if (localTime.year != now.year) {
      return DateFormat(dateFormat).format(this).parseDateTimePattern9;
    }
    return DateFormat(dateFormat).format(this).parseDateTimePattern8;
  }
}
