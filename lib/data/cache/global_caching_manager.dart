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

  Future<void> saveStartTimeVerificationAttempt(DateTime startTime);

  DateTime? getStartTimeVerificationAttempt();

  Future<void> saveVerificationCodeAttempts(int attempts);

  int? getVerificationCodeAttempts();

  Future<void> saveAttemptsToEnterRightCode(int attempts);

  int? getAttemptsToEnterRightCode();

  Future<void> saveStartTimeInactiveResendCode(DateTime? startTime);

  DateTime? getStartTimeInactiveResendCode();

  StreamSubscription listenCurrentBrandStream(ValueChanged<BaseBrand> callback);

  StreamSubscription listenLanguageCodeStream(ValueChanged<String> callback);
}
