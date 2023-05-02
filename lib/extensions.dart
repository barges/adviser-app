import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/l10n.dart';




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
