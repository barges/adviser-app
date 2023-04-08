import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/category_info.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
import 'package:zodiac/data/models/user_info/locale_model.dart';
import 'package:zodiac/data/models/user_info/my_details.dart';

abstract class ZodiacCachingManager {
  bool get haveLocales;
  bool get haveCategories;

  bool get pushTokenIsSent;

  set pushTokenIsSent(bool value);

  Future<void> saveUserToken(String userToken);

  String? getUserToken();

  Future<void> logout();

  Future<void> saveAllLocales(List<LocaleModel>? locales);

  List<LocaleModel>? getAllLocales();

  Future<void> saveAllCategories(List<CategoryInfo>? categories);

  List<CategoryInfo>? getAllCategories();

  Future<void> saveLanguageCode(String? languageCode);

  String? getLanguageCode();

  Future<void> saveUserInfo(MyDetails? userInfo);

  MyDetails? getUserInfo();

  Future<void> saveUid(int uid);

  int? getUid();

  StreamSubscription listenUserInfo(ValueChanged<MyDetails> callback);

  Future<void> saveDetailedUserInfo(DetailedUserInfo? userInfo);

  DetailedUserInfo? getDetailedUserInfo();

  StreamSubscription listenDetailedUserInfo(
      ValueChanged<DetailedUserInfo> callback);

  Future<void> saveUserStatus(ZodiacUserStatus? userStatus);

  ZodiacUserStatus? getUserStatus();

  StreamSubscription listenCurrentUserStatusStream(
      ValueChanged<ZodiacUserStatus> callback);
}
