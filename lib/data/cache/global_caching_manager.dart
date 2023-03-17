import 'dart:async';

import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/services/check_permission_service.dart';
import 'package:flutter/material.dart';

abstract class GlobalCachingManager {

  Future<void> saveCurrentBrand(Brand currentBrand);

  Brand getCurrentBrand();

  Future<void> saveLanguageCode(String? languageCode);

  String? getLanguageCode();

  Map<String, dynamic> getFirstPermissionStatusesRequestsMap();

  Future<void> saveFirstPermissionStatusesRequestsMap(
      PermissionType permissionType);

  StreamSubscription listenCurrentBrandStream(ValueChanged<Brand> callback);

  StreamSubscription listenLanguageCodeStream(ValueChanged<String> callback);

}
