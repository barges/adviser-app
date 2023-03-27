import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/user_info.dart';

const String _zodiacUserBoxKey = 'zodiacUserBoxKey';
const String _zodiacLocaleBoxKey = 'zodiacLocaleBoxKey';

const String _userTokenKey = 'userTokenKey';
const String _userStatusKey = 'userStatusKey';
const String _localeKey = 'localeKey';
const String _userInfoKey = 'userInfoKey';
const String _userIdKey = 'userIdKey';
const String _detailedUserInfoKey = 'detailedUserInfoKey';

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

  @override
  UserInfo? getUserInfo() {
    UserInfo? userInfo;
    if (Hive.box(_zodiacUserBoxKey).containsKey(_userInfoKey)) {
      userInfo = UserInfo.fromJson(
          json.decode(Hive.box(_zodiacUserBoxKey).get(_userInfoKey)));
    }
    return userInfo;
  }

  @override
  Future<void> saveUserInfo(UserInfo? userInfo) async {
    await Hive.box(_zodiacUserBoxKey)
        .put(_userInfoKey, json.encode(userInfo?.toJson()));
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
  StreamSubscription listenUserInfo(ValueChanged<UserInfo> callback) {
    return Hive.box(_zodiacUserBoxKey).watch(key: _userInfoKey).listen((event) {
      callback(UserInfo.fromJson(json.decode(event.value)));
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
      if(detailedUserInfo != null) {
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
      callback(ZodiacUserStatus.statusFromString(event.value));
    });
  }
}
