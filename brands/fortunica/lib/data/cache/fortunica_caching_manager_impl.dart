import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/data/models/user_info/user_info.dart';
import 'package:fortunica/data/models/user_info/user_profile.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/global.dart';

import 'fortunica_caching_manager.dart';

const String _fortunicaUserBoxKey = 'fortunicaUserBoxKey';
const String _fortunicaLocaleBoxKey = 'fortunicaLocaleBoxKey';

const String _userProfileKey = 'userProfileKey';
const String _userInfoKey = 'userInfoKey';
const String _userStatusKey = 'userStatusKey';
const String _userIdKey = 'userIdKey';
const String _userTokenKey = 'userTokenKey';
const String _localeKey = 'localeKey';

@Injectable(as: FortunicaCachingManager)
class FortunicaCachingManagerImpl implements FortunicaCachingManager {
  static Future<void> openBoxes() async {
    await Hive.openBox(_fortunicaUserBoxKey);
    await Hive.openBox(_fortunicaLocaleBoxKey);
  }

  bool _pushTokenIsSent = false;

  @override
  bool get pushTokenIsSent => _pushTokenIsSent;

  @override
  set pushTokenIsSent(bool value) {
    _pushTokenIsSent = value;
  }

  @override
  String? getUserId() {
    return Hive.box(_fortunicaUserBoxKey).get(_userIdKey);
  }

  @override
  UserInfo? getUserInfo() {
    UserInfo? userInfo;
    if (Hive.box(_fortunicaUserBoxKey).containsKey(_userInfoKey)) {
      userInfo = UserInfo.fromJson(
          json.decode(Hive.box(_fortunicaUserBoxKey).get(_userInfoKey)));
    }
    return userInfo;
  }

  @override
  UserProfile? getUserProfile() {
    UserProfile? userProfile;
    if (Hive.box(_fortunicaUserBoxKey).containsKey(_userProfileKey)) {
      Map<String, dynamic>? userProfileMap =
          json.decode(Hive.box(_fortunicaUserBoxKey).get(_userProfileKey));
      if(userProfileMap != null) {
        userProfile = UserProfile.fromJson(userProfileMap);
      }
    }

    return userProfile;
  }

  @override
  UserStatus? getUserStatus() {
    if (Hive.box(_fortunicaUserBoxKey).containsKey(_userStatusKey)) {
      UserStatus userStatus = UserStatus.fromJson(
          json.decode((Hive.box(_fortunicaUserBoxKey).get(_userStatusKey))));
      return userStatus;
    }
    return null;
  }

  @override
  Future<void> saveUserStatus(UserStatus? userStatus) async {
    await Hive.box(_fortunicaUserBoxKey)
        .put(_userStatusKey, json.encode(userStatus?.toJson()));
  }

  @override
  StreamSubscription listenCurrentUserStatusStream(
      ValueChanged<UserStatus> callback) {
    return Hive.box(_fortunicaUserBoxKey)
        .watch(key: _userStatusKey)
        .listen((event) {
      if (event.value != null) {
        callback(UserStatus.fromJson(json.decode(event.value)));
      }
    });
  }

  @override
  StreamSubscription listenUserIdStream(ValueChanged<String?> callback) {
    return Hive.box(_fortunicaUserBoxKey)
        .watch(key: _userIdKey)
        .listen((event) {
      callback(event.value);
    });
  }

  @override
  StreamSubscription listenUserProfileStream(
      ValueChanged<UserProfile> callback) {
    return Hive.box(_fortunicaUserBoxKey)
        .watch(key: _userProfileKey)
        .listen((event) {
      logger.d('event value ${event.value != null}');
      if (event.value != null) {
        logger.d('event value ${event.value}');
        logger.d('event value ${event.value != null}');
        callback(UserProfile.fromJson(json.decode(event.value) ?? '{}'));
      }
    });
  }

  @override
  Future<void> logout() async {
    await Hive.box(_fortunicaUserBoxKey).clear();
    _pushTokenIsSent = false;
  }

  @override
  Future<void> saveUserId(String? userId) async {
    await Hive.box(_fortunicaUserBoxKey).put(_userIdKey, userId);
  }

  @override
  Future<void> saveUserInfo(UserInfo? userInfo) async {
    await Hive.box(_fortunicaUserBoxKey)
        .put(_userInfoKey, json.encode(userInfo?.toJson()));
  }

  @override
  Future<void> saveUserProfile(UserProfile? userProfile) async {
    await Hive.box(_fortunicaUserBoxKey)
        .put(_userProfileKey, json.encode(userProfile?.toJson()));
  }


  @override
  Future<void> updateUserProfileCoverPictures(
      List<String>? coverPictures) async {
    UserProfile? profile = getUserProfile();

    await saveUserProfile(
      profile?.copyWith(
        coverPictures: coverPictures,
      ),
    );
  }

  @override
  Future<void> updateUserProfileImage(List<String>? profilePictures) async {
    UserProfile? profile = getUserProfile();

    await saveUserProfile(
      profile?.copyWith(
        profilePictures: profilePictures,
      ),
    );
  }

  @override
  Future<void> updateUserStatusByStatus(FortunicaUserStatus status) async {
    UserStatus? userStatus = getUserStatus();

    await Hive.box(_fortunicaUserBoxKey).put(
      _userStatusKey,
      userStatus?.copyWith(
        status: status,
      ),
    );
  }

  @override
  String? getUserToken() {
    return Hive.box(_fortunicaUserBoxKey).get(_userTokenKey);
  }

  @override
  Future<void> saveUserToken(String userToken) async {
    await Hive.box(_fortunicaUserBoxKey).put(_userTokenKey, userToken);
  }

  @override
  String? getLanguageCode() {
    return Hive.box(_fortunicaLocaleBoxKey).get(_localeKey);
  }

  @override
  Future<void> saveLanguageCode(String? languageCode) async {
    await Hive.box(_fortunicaLocaleBoxKey).put(_localeKey, languageCode);
  }
}
