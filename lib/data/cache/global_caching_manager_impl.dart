import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/di/brand_manager.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';

import 'global_caching_manager.dart';

const String _brandsBoxKey = 'brandsBoxKey';
const String _localeBoxKey = 'localeBoxKey';
const String _permissionBoxKey = 'permissionBoxKey';
const String _phoneBoxKey = 'phoneBoxKey';

const String _tokensMapKey = 'tokensMapKey';
const String _brandKey = 'brandKey';
const String _localeKey = 'localeKey';
const String _firstPermissionStatusesKey = 'firstPermissionStatusesKey';
const String _startTimeVerificationAttemptKey =
    'startTimeVerificationAttemptKey';
const String _verificationCodeAttemptsKey = 'verificationCodeAttemptsKey';
const String _attemptsToEnterRightCodeKey = 'attemptsToEnterRightCodeKey';
const String _startTimeInactiveResendCodeKey = 'startTimeInactiveResendCodeKey';

@Injectable(as: GlobalCachingManager)
class GlobalCachingManagerImpl implements GlobalCachingManager {
  GlobalCachingManagerImpl() {
    openBoxes();
  }

  static Future<void> openBoxes() async {
    await Hive.openBox(_brandsBoxKey);
    await Hive.openBox(_localeBoxKey);
    await Hive.openBox(_permissionBoxKey);
    await Hive.openBox(_phoneBoxKey);
  }

  @override
  BaseBrand getCurrentBrand() {
    return BrandManager.brandFromAlias(Hive.box(_brandsBoxKey).get(_brandKey));
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
  DateTime? getStartTimeVerificationAttempt() {
    return Hive.box(_phoneBoxKey).get(_startTimeVerificationAttemptKey);
  }

  @override
  int? getVerificationCodeAttempts() {
    return Hive.box(_phoneBoxKey).get(_verificationCodeAttemptsKey);
  }

  @override
  int? getAttemptsToEnterRightCode() {
    return Hive.box(_phoneBoxKey).get(_attemptsToEnterRightCodeKey);
  }

  @override
  DateTime? getStartTimeInactiveResendCode() {
    return Hive.box(_phoneBoxKey).get(_startTimeInactiveResendCodeKey);
  }

  @override
  StreamSubscription listenCurrentBrandStream(
      ValueChanged<BaseBrand> callback) {
    return Hive.box(_brandsBoxKey).watch(key: _brandKey).listen((event) {
      callback(BrandManager.brandFromAlias(event.value));
    });
  }

  @override
  StreamSubscription listenLanguageCodeStream(ValueChanged<String> callback) {
    return Hive.box(_localeBoxKey).watch(key: _localeKey).listen((event) {
      callback(event.value);
    });
  }

  @override
  Future<void> saveCurrentBrand(BaseBrand currentBrand) async {
    await Hive.box(_brandsBoxKey).put(_brandKey, currentBrand.brandAlias);
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
  Future<void> saveLanguageCode(String? languageCode) async {
    await Hive.box(_localeBoxKey).put(_localeKey, languageCode);
  }

  @override
  Future<void> saveStartTimeVerificationAttempt(DateTime startTime) async {
    await Hive.box(_phoneBoxKey)
        .put(_startTimeVerificationAttemptKey, startTime);
  }

  @override
  Future<void> saveVerificationCodeAttempts(int attempts) async {
    await Hive.box(_phoneBoxKey).put(_verificationCodeAttemptsKey, attempts);
  }

  @override
  Future<void> saveAttemptsToEnterRightCode(int attempts) async {
    await Hive.box(_phoneBoxKey).put(_attemptsToEnterRightCodeKey, attempts);
  }

  @override
  Future<void> saveStartTimeInactiveResendCode(DateTime? startTime) async {
    await Hive.box(_phoneBoxKey)
        .put(_startTimeInactiveResendCodeKey, startTime);
  }
}
