import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';

const countryPhoneCodesJsonPath = 'assets/country_phone_codes.json';

class PhoneCountryCodes {
  late final Future<bool> _initPhoneCountryCodes;
  static final PhoneCountryCodes _instance = PhoneCountryCodes._internal();
  static final List<PhoneCountryCode> _phoneCountryCodes = [];

  PhoneCountryCodes._internal() {
    _initPhoneCountryCodes = Future<bool>(() async {
      await _init();
      return true;
    });
  }

  static Future<bool> init() {
    return PhoneCountryCodes()._initPhoneCountryCodes;
  }

  factory PhoneCountryCodes() {
    return _instance;
  }

  Future<void> _init() async {
    if (_phoneCountryCodes.isEmpty) {
      final List<dynamic> jsonData = await _loadCountryPhoneCodesJson();
      final whitespaceRegExp = RegExp(r'\s+');
      for (final json in jsonData) {
        final phoneCountryCode = PhoneCountryCode.fromJson(json);
        _phoneCountryCodes.add(phoneCountryCode.copyWith(
            code: phoneCountryCode.code
                ?.replaceAll(whitespaceRegExp, '')
                .replaceFirst('+', '')));
      }
    }
  }

  Future<List<dynamic>> _loadCountryPhoneCodesJson() async {
    final String response =
        await rootBundle.loadString(countryPhoneCodesJsonPath);
    return await jsonDecode(response);
  }

  static List<PhoneCountryCode> searchPhoneCountryCodes(String text) {
    final whitespaceRegExp = RegExp(r'\s+');
    String searchText = text.trim().toLowerCase();
    if (searchText.startsWith('+')) {
      searchText = searchText.replaceFirst('+', '');
    }
    return _phoneCountryCodes.where((item) {
      if (item.name != null &&
          item.name!.toLowerCase().startsWith(searchText)) {
        return true;
      }

      String searchTextWirhoutWhitespace =
          searchText.replaceAll(whitespaceRegExp, '');
      if (item.code != null &&
          item.code!.startsWith(searchTextWirhoutWhitespace)) {
        return true;
      }
      return false;
    }).toList();
  }

  static String? getCountryNameByCode(int code) {
    return _phoneCountryCodes
        .firstWhereOrNull((item) => item.toCodeInt() == code)
        ?.name;
  }
}
