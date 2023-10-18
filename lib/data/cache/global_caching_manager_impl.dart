/*import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../services/check_permission_service.dart';
import 'global_caching_manager.dart';

const String _localeBoxKey = 'localeBoxKey';
const String _permissionBoxKey = 'permissionBoxKey';
const String _phoneBoxKey = 'phoneBoxKey';

const String _localeKey = 'localeKey';
const String _firstPermissionStatusesKey = 'firstPermissionStatusesKey';
const String _startTimeInactiveResendCodeKey = 'startTimeInactiveResendCodeKey';

@Singleton(as: GlobalCachingManager)
class GlobalCachingManagerImpl implements GlobalCachingManager {
  GlobalCachingManagerImpl() {
    openBoxes();
  }

  static Future<void> openBoxes() async {
    await Hive.openBox(_localeBoxKey);
    await Hive.openBox(_permissionBoxKey);
    await Hive.openBox(_phoneBoxKey);
  }

  @override
  Map<String, dynamic> getFirstPermissionStatusesRequestsMap() {
    return Map<String, dynamic>.from(Hive.box(_permissionBoxKey)
        .get(_firstPermissionStatusesKey, defaultValue: {}) as Map);
  }

  @override
  String? getLanguageCode() {
    return Hive.box(_localeBoxKey).get(_localeKey);
  }

  @override
  Future<void> saveLanguageCode(String? languageCode) async {
    await Hive.box(_localeBoxKey).put(_localeKey, languageCode);
  }

  @override
  DateTime? getStartTimeInactiveResendCode() {
    return Hive.box(_phoneBoxKey).get(_startTimeInactiveResendCodeKey);
  }

  @override
  StreamSubscription listenLanguageCodeStream(ValueChanged<String> callback) {
    return Hive.box(_localeBoxKey).watch(key: _localeKey).listen((event) {
      callback(event.value);
    });
  }

  @override
  Future<void> saveFirstPermissionStatusesRequestsMap(
      PermissionType permissionType) async {
    Map<String, dynamic> firstPermissionStatusesRequestsMap =
        getFirstPermissionStatusesRequestsMap();

    firstPermissionStatusesRequestsMap[permissionType.name] = true;

    await Hive.box(_permissionBoxKey)
        .put(_firstPermissionStatusesKey, firstPermissionStatusesRequestsMap);
  }

  @override
  Future<void> saveStartTimeInactiveResendCode(DateTime? startTime) async {
    await Hive.box(_phoneBoxKey)
        .put(_startTimeInactiveResendCodeKey, startTime);
  }
}*/
