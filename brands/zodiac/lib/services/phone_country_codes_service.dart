import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:zodiac/data/models/settings/phone_country_code.dart';

const countryPhoneCodesJsonPath = 'assets/country_phone_codes.json';

@lazySingleton
class PhoneCountryCodesService {
  static final List<PhoneCountryCode> _phoneCountryCodes = [];

  static Future<bool> init() async {
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
    return true;
  }

  static Future<List<dynamic>> _loadCountryPhoneCodesJson() async {
    final String response =
        await rootBundle.loadString(countryPhoneCodesJsonPath);
    return await jsonDecode(response);
  }

  List<PhoneCountryCode> searchPhoneCountryCodes(String text) {
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

      String searchTextWithoutWhitespace =
          searchText.replaceAll(whitespaceRegExp, '');
      if (item.code != null &&
          item.code!.startsWith(searchTextWithoutWhitespace)) {
        return true;
      }
      return false;
    }).toList();
  }

  String? getCountryNameByCode(int code) {
    return _phoneCountryCodes
        .firstWhereOrNull((item) => item.toCodeInt() == code)
        ?.name;
  }
}
