import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';

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
const String datePattern10 = 'MMM. dd, yyyy HH:mm';

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

  String? get capitalize {
    if (length > 1) {
      return this[0].toUpperCase() + substring(1).toLowerCase();
    } else if (length == 1) {
      return this[0].toUpperCase();
    } else {
      return null;
    }
  }

  String languageNameByCode(BuildContext context) {
    final String languageCode = substring(0, 2);
    switch (languageCode) {
      case 'de':
        return AppConstants.deLanguageName;
      case 'en':
        return AppConstants.enLanguageName;
      case 'es':
        return AppConstants.esLanguageName;
      case 'pt':
        return AppConstants.ptLanguageName;
      default:
        return S.of(context).other;
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

  String get parseDateTimePattern10 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern10).format(inputData);
  }

  String get removeSpacesAndNewLines {
    return trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");
  }

  String get currencySymbolByName {
    final NumberFormat format = NumberFormat.simpleCurrency(name: this);
    return format.currencySymbol;
  }

  bool get isHtml {
    return RegExp(r'<([A-Za-z][A-Za-z0-9]*)\b[^>]*>(.*?)</\1>').hasMatch(this);
  }
}

extension DoubleExt on double {
  String get parseValueToCurrencyFormat {
    final currencyFormatter = NumberFormat(currencyPattern, 'ID');
    return currencyFormatter.format(this).replaceAll('.', ' ');
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
    if (localTime.year != now.year) {
      return DateFormat(dateFormat).format(this).parseDateTimePattern9;
    }
    return DateFormat(dateFormat).format(this).parseDateTimePattern8;
  }

  String historyListTime(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference == 0) {
      return S.of(context).today;
    }
    if (localTime.year != now.year) {
      return DateFormat(dateFormat).format(this).parseDateTimePattern9;
    }
    return DateFormat(dateFormat).format(this).parseDateTimePattern8;
  }
}

extension FileExt on File {
  int get sizeInBytes => lengthSync();

  double get sizeInMb => sizeInBytes / (1024 * 1024);
}

extension DurationExt on Duration {
  String get formatMMSS {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return "${minutes < 10 ? '0$minutes' : '$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}";
  }
}

extension IntExt on int {
  String get formatMSS {
    final minutes = this ~/ 60;
    final seconds = remainder(60);
    return "${'$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}";
  }
}
