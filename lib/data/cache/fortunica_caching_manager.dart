import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/check_permission_service.dart';
import '../models/enums/fortunica_user_status.dart';
import '../models/user_info/user_info.dart';
import '../models/user_info/user_profile.dart';
import '../models/user_info/user_status.dart';

abstract class FortunicaCachingManager {
  bool get pushTokenIsSent;

  set pushTokenIsSent(bool value);

  Future<void> saveUserToken(String userToken);

  String? getUserToken();

  Future<void> saveLanguageCode(String? languageCode);

  String? getLanguageCode();

  Future<void> saveUserProfile(UserProfile? userProfile);

  Future<void> updateUserProfileImage(List<String>? profilePictures);

  Future<void> updateUserProfileCoverPictures(List<String>? coverPictures);

  UserProfile? getUserProfile();

  Future<void> saveUserStatus(UserStatus? userStatus);

  UserStatus? getUserStatus();

  Future<void> saveUserInfo(UserInfo? userInfo);

  UserInfo? getUserInfo();

  Future<void> updateUserStatusByStatus(FortunicaUserStatus status);

  Future<void> saveUserId(String? userId);

  String? getUserId();

  Future<void> logout();

  bool get isAuth;

  StreamSubscription listenCurrentUserStatusStream(
      ValueChanged<UserStatus> callback);

  StreamSubscription listenUserIdStream(ValueChanged<String?> callback);

  StreamSubscription listenUserProfileStream(
      ValueChanged<UserProfile> callback);

  Map<String, dynamic> getFirstPermissionStatusesRequestsMap();

  Future<void> saveFirstPermissionStatusesRequestsMap(
      PermissionType permissionType);

  Future<void> saveStartTimeInactiveResendCode(DateTime? startTime);

  DateTime? getStartTimeInactiveResendCode();

  StreamSubscription listenLanguageCodeStream(ValueChanged<String> callback);
}
