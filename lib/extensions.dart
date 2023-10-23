import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_constants.dart';
import 'generated/l10n.dart';

const String datePattern1 = 'MMM d, yyyy';
const String datePattern4 = 'MMM dd';
const String datePattern5 = 'MMM dd, yyyy';

const String currencyPattern = '#,##0.00';

const String timeFormat = 'h:mm a';

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
        return SFortunica.of(context).other;
    }
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

extension FileExt on File {
  int get sizeInBytes => lengthSync();

  double get sizeInMb => sizeInBytes / (1024 * 1024);
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
