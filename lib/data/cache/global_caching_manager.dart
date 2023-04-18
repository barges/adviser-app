import 'dart:async';

import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:flutter/material.dart';

abstract class GlobalCachingManager {
  Future<void> saveCurrentBrand(BaseBrand currentBrand);

  BaseBrand getCurrentBrand();

  Future<void> saveLanguageCode(String? languageCode);

  String? getLanguageCode();

  Map<String, dynamic> getFirstPermissionStatusesRequestsMap();

  Future<void> saveFirstPermissionStatusesRequestsMap(
      PermissionType permissionType);

  StreamSubscription listenCurrentBrandStream(ValueChanged<BaseBrand> callback);

  StreamSubscription listenLanguageCodeStream(ValueChanged<String> callback);

  Future<void> saveAuthorizedBrandsAliases(
      List<String> authorizedBrandsAliases);

  List<String>? getAuthorizedBrandsAliases();
}
