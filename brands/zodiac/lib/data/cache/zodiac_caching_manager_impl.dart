import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/models/user_info/my_details.dart';

const String _zodiacUserBoxKey = 'zodiacUserBoxKey';
const String _zodiacSettingsBoxKey = 'zodiacSettingsBoxKey';

const String _userTokenKey = 'userTokenKey';
const String _userStatusKey = 'userStatusKey';
const String _localeKey = 'localeKey';
const String _allLocalesKey = 'allLocalesKey';
const String _allCategoriesKey = 'allCategoriesKey';
const String _userInfoKey = 'userInfoKey';
const String _userIdKey = 'userIdKey';
const String _detailedUserInfoKey = 'detailedUserInfoKey';

@Injectable(as: ZodiacCachingManager)
class ZodiacCachingManagerImpl implements ZodiacCachingManager {
  static Future<void> openBoxes() async {
    await Hive.openBox(_zodiacUserBoxKey);
    await Hive.openBox(_zodiacSettingsBoxKey);
  }

  bool _pushTokenIsSent = false;

  @override
  bool get haveLocales =>
      Hive.box(_zodiacSettingsBoxKey).containsKey(_allLocalesKey);

  @override
  bool get haveCategories =>
      Hive.box(_zodiacSettingsBoxKey).containsKey(_allCategoriesKey);

  @override
  bool get pushTokenIsSent => _pushTokenIsSent;

  @override
  set pushTokenIsSent(bool value) {
    _pushTokenIsSent = value;
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
    _pushTokenIsSent = false;
  }

  @override
  List<LocaleModel>? getAllLocales() {
    List<LocaleModel>? locales;
    if (Hive.box(_zodiacSettingsBoxKey).containsKey(_allLocalesKey)) {
      final List<dynamic> localesList =
          json.decode(Hive.box(_zodiacSettingsBoxKey).get(_allLocalesKey));
      locales = localesList.map((e) => LocaleModel.fromJson(e)).toList();
    }
    return locales;
  }

  @override
  Future<void> saveAllLocales(List<LocaleModel>? locales) async {
    await Hive.box(_zodiacSettingsBoxKey)
        .put(_allLocalesKey, json.encode(locales));
  }

  @override
  List<CategoryInfo>? getAllCategories() {
    List<CategoryInfo>? categories;
    if (Hive.box(_zodiacSettingsBoxKey).containsKey(_allCategoriesKey)) {
      final List<dynamic> categoriesList =
          json.decode(Hive.box(_zodiacSettingsBoxKey).get(_allCategoriesKey));
      categories = categoriesList.map((e) => CategoryInfo.fromJson(e)).toList();
    }
    return categories;
  }

  @override
  Future<void> saveAllCategories(List<CategoryInfo>? categories) async {
    await Hive.box(_zodiacSettingsBoxKey)
        .put(_allCategoriesKey, json.encode(categories));
  }

  @override
  String? getLanguageCode() {
    return Hive.box(_zodiacSettingsBoxKey).get(_localeKey);
  }

  @override
  Future<void> saveLanguageCode(String? languageCode) async {
    await Hive.box(_zodiacSettingsBoxKey).put(_localeKey, languageCode);
  }

  @override
  MyDetails? getUserInfo() {
    MyDetails? myDetails;
    if (Hive.box(_zodiacUserBoxKey).containsKey(_userInfoKey)) {
      myDetails = MyDetails.fromJson(
          json.decode(Hive.box(_zodiacUserBoxKey).get(_userInfoKey)));
    }
    return myDetails;
  }

  @override
  Future<void> saveUserInfo(MyDetails? myDetails) async {
    await Hive.box(_zodiacUserBoxKey)
        .put(_userInfoKey, json.encode(myDetails?.toJson()));
  }

  @override
  int? getUid() {
    return Hive.box(_zodiacUserBoxKey).get(_userIdKey);
  }

  @override
  Future<void> saveUid(int uid) async {
    await Hive.box(_zodiacUserBoxKey).put(_userIdKey, uid);
  }

  @override
  StreamSubscription listenUserInfo(ValueChanged<MyDetails> callback) {
    return Hive.box(_zodiacUserBoxKey).watch(key: _userInfoKey).listen((event) {
      callback(MyDetails.fromJson(json.decode(event.value)));
    });
  }

  @override
  DetailedUserInfo? getDetailedUserInfo() {
    DetailedUserInfo? detailedUserInfo;
    if (Hive.box(_zodiacUserBoxKey).containsKey(_detailedUserInfoKey)) {
      detailedUserInfo = DetailedUserInfo.fromJson(
          json.decode(Hive.box(_zodiacUserBoxKey).get(_detailedUserInfoKey)));
    }
    return detailedUserInfo;
  }

  @override
  StreamSubscription listenDetailedUserInfo(
      ValueChanged<DetailedUserInfo> callback) {
    return Hive.box(_zodiacUserBoxKey)
        .watch(key: _detailedUserInfoKey)
        .listen((event) {
      if (event.value != null) {
        callback(DetailedUserInfo.fromJson(json.decode(event.value)));
      }
    });
  }

  @override
  Future<void> saveDetailedUserInfo(DetailedUserInfo? userInfo) async {
    if (userInfo != null) {
      await Hive.box(_zodiacUserBoxKey)
          .put(_detailedUserInfoKey, json.encode(userInfo.toJson()));
    }
  }

  @override
  ZodiacUserStatus? getUserStatus() {
    ZodiacUserStatus? userStatus;
    if (Hive.box(_zodiacUserBoxKey).containsKey(_userStatusKey)) {
      userStatus = ZodiacUserStatus.statusFromString(
          Hive.box(_zodiacUserBoxKey).get(_userStatusKey));
    }
    return userStatus;
  }

  @override
  Future<void> saveUserStatus(ZodiacUserStatus? userStatus) async {
    if (userStatus != null) {
      await Hive.box(_zodiacUserBoxKey)
          .put(_userStatusKey, userStatus.toString());

      final DetailedUserInfo? detailedUserInfo = getDetailedUserInfo();
      if (detailedUserInfo != null) {
        await saveDetailedUserInfo(detailedUserInfo.copyWith(
            details: detailedUserInfo.details?.copyWith(
          status: userStatus,
        )));
      }
    }
  }

  @override
  StreamSubscription listenCurrentUserStatusStream(
      ValueChanged<ZodiacUserStatus> callback) {
    return Hive.box(_zodiacUserBoxKey)
        .watch(key: _userStatusKey)
        .listen((event) {
      if (event.value != null) {
        callback(ZodiacUserStatus.statusFromString(event.value));
      }
    });
  }
}
