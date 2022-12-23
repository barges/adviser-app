import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';
import 'package:shared_advisor_interface/presentation/resources/app_constants.dart';

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
const String datePattern10 = 'MM/dd';
const String datePattern11 = 'MM/dd/yy';
const String datePattern12 = 'MMM. dd, yyyy HH:mm';

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

  String languageNameByCode(BuildContext context) {
    final String languageCode = substring(0, 2);
    switch (languageCode) {
      case 'de':
        return AppConstants.deBrandName;
      case 'en':
        return AppConstants.enBrandName;
      case 'es':
        return AppConstants.esBrandName;
      case 'pt':
        return AppConstants.ptBrandName;
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

  String get parseDateTimePattern11 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern11).format(inputData);
  }

  String get parseDateTimePattern12 {
    final DateTime inputData = DateTime.parse(
        DateFormat(dateFormat).parse(this, true).toLocal().toString());
    return DateFormat(datePattern12).format(inputData);
  }

  String get removeSpacesAndNewLines {
    return trim().replaceAll(RegExp(r'(\n){3,}'), "\n\n");
  }

  String get currencySymbolByName {
    final NumberFormat format = NumberFormat.simpleCurrency(name: this);
    return format.currencySymbol;
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
      return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern7;
    }
    if (timeDifference < -365) {
      return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern9;
    }
    return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern8;
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
    if (timeDifference < -365) {
      return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern11;
    }
    return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern10;
  }

  String get historyCardQuestionTime {
    DateTime now = DateTime.now();
    DateTime localTime = toLocal();
    int timeDifference =
        DateTime(localTime.year, localTime.month, localTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (timeDifference < -365) {
      return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern11;
    }
    return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern10;
  }

  String get historyCardAnswerTime {
    return DateFormat(dateFormat).format(toLocal()).parseDateTimePattern7;
  }
}

extension FileExt on File {
  double get sizeInMb => lengthSync() / (1024 * 1024);
}

extension DurationExt on Duration {
  String get formatMMSS {
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    return "${minutes < 10 ? '0$minutes' : '$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}";
  }
}
