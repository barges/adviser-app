import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';
import 'package:shared_advisor_interface/presentation/services/check_permission_service.dart';

abstract class CachingManager {
  Future<void> saveUserProfile(UserProfile? userProfile);

  VoidCallback listenUserProfile(ValueChanged<UserProfile> callback);

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

  Future<void> saveTokenForBrand(Brand brand, String token);

  String? getTokenByBrand(Brand brand);

  List<Brand> getAuthorizedBrands();

  List<Brand> getUnauthorizedBrands();

  Future<void> saveCurrentBrand(Brand currentBrand);

  Brand? getCurrentBrand();

  Future<void> saveLanguageCode(String? languageCode);

  String? getLanguageCode();

  VoidCallback listenLanguageCode(ValueChanged<String> callback);

  Future<bool> logout(Brand brand);

  Future<bool> clearTokenForBrand(Brand brand);

  bool? isLoggedIn();

  VoidCallback listenCurrentBrand(ValueChanged<Brand> callback);

  VoidCallback listenCurrentUserStatus(ValueChanged<UserStatus> callback);

  VoidCallback listenUserId(ValueChanged<String?> callback);

  bool? getFirstPushNotificationSet();

  void saveFirstPushNotificationSet();

  Map<PermissionType, bool> getFirstPermissionStatusesRequestsMap();

  Future<void> saveFirstPermissionStatusesRequestsMap(
      PermissionType permissionType);
}
