import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/extensions.dart';
import 'package:zodiac/generated/l10n.dart';

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
      return DateFormat(dateFormat).format(this).parseDateTimePattern9;
    }
    return DateFormat(dateFormat).format(this).parseDateTimePattern8;
  }

  String get chatListTime {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference == 0) {
      return DateFormat(dateFormat).format(this).parseDateTimePattern7;
    }
    if (localTime.year != now.year) {
      return DateFormat(dateFormat).format(this).parseDateTimePattern9;
    }
    return DateFormat(dateFormat).format(this).parseDateTimePattern8;
  }
}

extension DurationExt on Duration {
  String formatDHMS(BuildContext context) {
    final days = inDays;
    final hours = inHours.remainder(24);
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return "${days > 0 ? '$days ${SZodiac.of(context).daysZodiac} ' : ''}${hours > 0 ? '$hours ${SZodiac.of(context).hoursZodiac} ' : ''}${minutes > 0 ? '$minutes ${SZodiac.of(context).minutesZodiac} ' : ''}${seconds > 0 ? '$seconds ${SZodiac.of(context).secondsZodiac}' : ''}";
  }
}
