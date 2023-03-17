import 'dart:async';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';


const String _zodiacUserBoxKey = 'zodiacUserBoxKey';
const String _zodiacLocaleBoxKey = 'zodiacLocaleBoxKey';

const String _userTokenKey = 'userTokenKey';
const String _localeKey = 'localeKey';

@Injectable(as: ZodiacCachingManager)
class ZodiacCachingManagerImpl implements ZodiacCachingManager {
  static Future<void> openBoxes() async {
    await Hive.openBox(_zodiacUserBoxKey);
    await Hive.openBox(_zodiacLocaleBoxKey);
  }

  @override
  String? getUserToken() {
    return Hive.box(_zodiacUserBoxKey).get(_userTokenKey);
  }

  @override
  Future<void> saveUserToken(String userToken) async {
    await Hive.box(_zodiacUserBoxKey).put(_userTokenKey, userToken);
  }

  @override
  Future<void> logout() async {
    await Hive.box(_zodiacUserBoxKey).clear();
  }

  @override
  String? getLanguageCode() {
    return Hive.box(_zodiacLocaleBoxKey).get(_localeKey);
  }

  @override
  Future<void> saveLanguageCode(String? languageCode) async {
    await Hive.box(_zodiacLocaleBoxKey).put(_localeKey, languageCode);
  }
}
