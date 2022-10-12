import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

const String dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
const String datePattern1 = 'MMM d, yyyy';
const String datePattern2 = 'MMM. d, yyyy';

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
        return 'German';
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'pt':
        return 'Portuguese';
      default:
        return 'Unknown language';
    }
  }

  String get parseDateTimePattern1 {
    final DateTime inputDate =
        DateTime.parse(DateFormat(dateFormat).parse(this).toString());

    return DateFormat(datePattern1).format(inputDate);
  }

  String get parseDateTimePattern2 {
    final DateTime inputDate =
        DateTime.parse(DateFormat(dateFormat).parse(this).toString());

    return DateFormat(datePattern2).format(inputDate);
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
