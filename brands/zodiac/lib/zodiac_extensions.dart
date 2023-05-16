import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:zodiac/generated/l10n.dart';

const String datePattern4 = 'MMM dd';
const String datePattern5 = 'MMM dd, yyyy';
const String datePattern6 = 'MMM d, yyyy';
const String datePattern7 = 'MMMM, yyyy';
const String datePattern8 = 'MMM. d, yyyy';

extension DateTimeExt on DateTime {
  String get sessionsListTime {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference == 0) {
      return DateFormat(
        BrandManager.timeFormat,
      ).format(localTime);
    }
    if (localTime.year != now.year) {
      return DateFormat(datePattern5).format(localTime);
    }
    return DateFormat(datePattern4).format(localTime);
  }

  String transactionsListTime(BuildContext context) {
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
      return DateFormat(
        BrandManager.timeFormat,
      ).format(localTime);
    }
    if (localTime.year != now.year) {
      return DateFormat(
        'dd MMM yy, ${BrandManager.timeFormat}',
      ).format(localTime);
    }
    return DateFormat(
      'dd MMM, ${BrandManager.timeFormat}',
    ).format(localTime);
  }

  String get reviewCardTime {
    return DateFormat(
      '${BrandManager.timeFormat} MMM d yyyy',
    ).format(toLocal());
  }
}

extension DoubleExt on double {
  String toCurrencyFormat(String currency, int fractionDigits) {
    final String value = abs().toStringAsFixed(fractionDigits);
    return isNegative ? '-$currency$value' : '$currency$value';
  }
}

extension DurationExt on Duration {
  String get timerFormat {
    return DateFormat.Hms().format(
        DateTime.fromMillisecondsSinceEpoch(inMilliseconds, isUtc: true));
  }
}
