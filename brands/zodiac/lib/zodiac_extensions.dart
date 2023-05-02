import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zodiac/generated/l10n.dart';

const String datePattern1 = 'dd MMM, h:mm a';
const String datePattern2 = 'dd MMM yy, h:mm a';
const String datePattern3 = 'h:mm a';
const String datePattern4 = 'MMM dd';
const String datePattern5 = 'MMM dd, yyyy';
const String datePattern6 = 'MMM d, yyyy';
const String datePattern7 = 'MMMM, yyyy';
const String datePattern8 = 'MMM. d, yyyy';
const String datePattern9 = 'h:mm a MMM d yyyy';

extension DateTimeExt on DateTime {
  String sessionsListTime(BuildContext context) {
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
      return SZodiac.of(context).yesterdayZodiac;
    }
    if (localTime.year != now.year) {
      return DateFormat(datePattern5).format(localTime);
    }
    return DateFormat(datePattern4).format(localTime);
  }

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
      return DateFormat(datePattern2).format(localTime);
    }
    return DateFormat(datePattern1).format(localTime);
  }
}

extension DoubleExt on double {
  String toCurrencyFormat(String currency, int fractionDigits) {
    final String value = abs().toStringAsFixed(fractionDigits);
    return isNegative ? '-$currency$value' : '$currency$value';
  }
}
