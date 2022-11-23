import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

const String dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
const String datePattern1 = 'MMM d, yyyy';
const String datePattern2 = 'MMM. d, yyyy';
const String datePattern3 = 'dd/MM/yyyy';
const String datePattern4 = 'HH:mm MMM d yyyy';
const String datePattern5 = 'H:mm';
const String datePattern6 = 'MMM. dd, yyyy, HH:mm';
const String datePattern7 = 'HH:mm';
const String datePattern8 = 'MMM dd';
const String datePattern9 = 'MMM dd, yyyy';

const String currencyPattern = '#,##0.00';

extension ObjectExt<T> on T {
  R let<R>(R Function(T that) op) => op(this);
}

extension StringExt on String {
  String get to256 {
    final bytes = utf8.encode(this);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  String get languageNameByCode {
    switch (this) {
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Portuguese';
      default:
        return 'Unknown language';
    }
  }

  String get parseDateTimePattern1 {
    final DateTime inputDate = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());

    return DateFormat(datePattern1).format(inputDate);
  }

  String get parseDateTimePattern2 {
    final DateTime inputDate = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());

    return DateFormat(datePattern2).format(inputDate);
  }

  String get parseDateTimePattern3 {
    final DateTime inputDate = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern3).format(inputDate);
  }

  String get parseDateTimePattern4 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern4).format(inputData);
  }

  String get parseDateTimeChat {
    final datetime = DateTime.tryParse(this);
    if (datetime == null) {
      return DateFormat(datePattern5).format(DateTime.now());
    }

    return DateFormat(datePattern5).format(datetime);
  }

  String get parseDateTimePattern6 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern6).format(inputData);
  }

  String get parseDateTimePattern7 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern7).format(inputData);
  }

  String get parseDateTimePattern8 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern8).format(inputData);
  }

  String get parseDateTimePattern9 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern9).format(inputData);
  }

  String get removeSpacesAndNewLines {
    return trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");
  }
}

extension DoubleExt on double {
  String get parseValueToCurrencyFormat {
    final currencyFormatter = NumberFormat(currencyPattern, 'ID');
    return currencyFormatter.format(this).replaceAll('.', ' ');
  }
}

extension IterableExtention<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E element, int index) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndexed(void Function(E element, int index) f) {
    var i = 0;
    for (var e in this) {
      f(e, i++);
    }
  }

  E? get firstOrNull {
    return isEmpty ? null : first;
  }

  E? get lastOrNull {
    return isEmpty ? null : last;
  }
}

extension DateTimeExt on DateTime {
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
    if (timeDifference < -365) {
      return DateFormat(dateFormat).format(this).parseDateTimePattern9;
    }
    return DateFormat(dateFormat).format(this).parseDateTimePattern8;
  }
}
