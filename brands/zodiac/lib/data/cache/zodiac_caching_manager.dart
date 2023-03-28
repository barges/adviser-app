import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/user_info.dart';

abstract class ZodiacCachingManager {
  bool get pushTokenIsSent;

  set pushTokenIsSent(bool value);

  Future<void> saveUserToken(String userToken);

  String? getUserToken();

  Future<void> logout();

  Future<void> saveLanguageCode(String? languageCode);

  String? getLanguageCode();


  ///TODO: Do we need this method?
  Future<void> saveUserInfo(UserInfo? userInfo);
  ///TODO: Do we need this method?
  UserInfo? getUserInfo();

  Future<void> saveUid(int uid);

  int? getUid();

  StreamSubscription listenUserInfo(ValueChanged<UserInfo> callback);

  Future<void> saveDetailedUserInfo(DetailedUserInfo? userInfo);

  DetailedUserInfo? getDetailedUserInfo();

  StreamSubscription listenDetailedUserInfo(
      ValueChanged<DetailedUserInfo> callback);

  Future<void> saveUserStatus(ZodiacUserStatus? userStatus);

  ZodiacUserStatus? getUserStatus();

  StreamSubscription listenCurrentUserStatusStream(
      ValueChanged<ZodiacUserStatus> callback);
}
