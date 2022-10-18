import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';

const String dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
const String datePattern1 = 'MMM d, yyyy';
const String datePattern2 = 'MMM. d, yyyy';
const String datePattern3 = 'dd/MM/yyyy';

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

  String get getFlagImageByLanguageCode {
    switch (this) {
      case 'de':
        return Assets.images.flags.german.path;
      case 'en':
        return Assets.images.flags.english.path;
      case 'es':
        return Assets.images.flags.spanish.path;
      case 'pt':
        return Assets.images.flags.portugues.path;

      default:
        return '';
    }
  }

  String get getZodiacProfileImage {
    switch (this) {
      case 'aquarius':
        return Assets.vectors.zodiac.aquarius.path;
      case 'aries':
        return Assets.vectors.zodiac.aries.path;
      case 'cancer':
        return Assets.vectors.zodiac.cancer.path;
      case 'capricorn':
        return Assets.vectors.zodiac.capricorn.path;
      case 'gemini':
        return Assets.vectors.zodiac.gemini.path;
      case 'leo':
        return Assets.vectors.zodiac.leo.path;
      case 'libra':
        return Assets.vectors.zodiac.libra.path;
      case 'pisces':
        return Assets.vectors.zodiac.pisces.path;
      case 'sagittarius':
        return Assets.vectors.zodiac.sagittarius.path;
      case 'scorpio':
        return Assets.vectors.zodiac.scorpio.path;
      case 'taurus':
        return Assets.vectors.zodiac.taurus.path;
      case 'virgo':
        return Assets.vectors.zodiac.virgo.path;

      default:
        return '';
    }
  }

  String get getHoroscopeByZodiacName {
    switch (this) {
      case 'aquarius':
        return Assets.vectors.horoscopes.aquarius.path;
      case 'aries':
        return Assets.vectors.horoscopes.aries.path;
      case 'cancer':
        return Assets.vectors.horoscopes.cancer.path;
      case 'capricorn':
        return Assets.vectors.horoscopes.capricorn.path;
      case 'gemini':
        return Assets.vectors.horoscopes.gemini.path;
      case 'leo':
        return Assets.vectors.horoscopes.leo.path;
      case 'libra':
        return Assets.vectors.horoscopes.libra.path;
      case 'pisces':
        return Assets.vectors.horoscopes.pisces.path;
      case 'sagittarius':
        return Assets.vectors.horoscopes.sagittarius.path;
      case 'scorpio':
        return Assets.vectors.horoscopes.scorpio.path;
      case 'taurus':
        return Assets.vectors.horoscopes.taurus.path;
      case 'virgo':
        return Assets.vectors.horoscopes.virgo.path;

      default:
        return '';
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

  String get parseDateTimePattern3 {
    final DateTime inputDate =
        DateTime.parse(DateFormat(dateFormat).parse(this).toString());
    return DateFormat(datePattern3).format(inputDate);
  }

  String get removeSpacesAndNewLines{
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
