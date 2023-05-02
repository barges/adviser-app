import 'package:flutter/material.dart';
import 'package:fortunica/generated/l10n.dart';
import 'package:intl/intl.dart';

const String datePattern1 = 'MMM d, yyyy';
const String datePattern2 = 'MMM. dd, yyyy, HH:mm';
const String datePattern3 = 'HH:mm';
const String datePattern4 = 'MMM dd';
const String datePattern5 = 'MMM dd, yyyy';
const String datePattern6 = 'MMM. dd, yyyy HH:mm';

extension DateTimeExt on DateTime {
  String get chatListTime {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference == 0) {
      return DateFormat(datePattern3).format(localTime);
    }
    if (localTime.year != now.year) {
      return DateFormat(datePattern5).format(localTime);
    }
    return DateFormat(datePattern4).format(localTime);
  }

  String historyListTime(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference == 0) {
      return SFortunica.of(context).todayFortunica;
    }
    if (localTime.year != now.year) {
      return DateFormat(datePattern5).format(this);
    }
    return DateFormat(datePattern4).format(localTime);
  }
}
