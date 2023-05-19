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

const String _tokensMapKey = 'tokensMapKey';
const String _brandKey = 'brandKey';
const String _localeKey = 'localeKey';
const String _firstPermissionStatusesKey = 'firstPermissionStatusesKey';

@Singleton(as: GlobalCachingManager)
class GlobalCachingManagerImpl implements GlobalCachingManager {
  GlobalCachingManagerImpl() {
    openBoxes();
  }

  static Future<void> openBoxes() async {
    await Hive.openBox(_brandsBoxKey);
    await Hive.openBox(_localeBoxKey);
    await Hive.openBox(_permissionBoxKey);
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
}
