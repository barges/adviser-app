import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'generated/l10n.dart';

const String datePattern1 = 'MMM d, yyyy';
const String datePattern4 = 'MMM dd';
const String datePattern5 = 'MMM dd, yyyy';

const String currencyPattern = '#,##0.00';

// TODO ?
const String timeFormat = 'h:mm a';

extension DateTimeExt on DateTime {
  String get chatListTime {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference == 0) {
      return DateFormat(timeFormat).format(localTime);
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

  String get noteTime {
    return DateFormat(
      'MMM. dd, yyyy, $timeFormat',
    ).format(toLocal());
  }

  String get oldNoteTime {
    return DateFormat(
      'MMM. dd, yyyy $timeFormat',
    ).format(toLocal());
  }
}

extension DoubleExt on double {
  String get parseValueToCurrencyFormat {
    final currencyFormatter = NumberFormat(currencyPattern, 'ID');
    return currencyFormatter.format(this).replaceAll('.', ' ');
  }
}
