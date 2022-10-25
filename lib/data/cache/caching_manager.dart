import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/user_info/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';

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

  Future<void> updateUserStatusByStatus(FortunicaUserStatusEnum status);

  Future<void> saveUserId(String? userId);

  String? getUserId();

  Future<void> saveTokenForBrand(Brand brand, String token);

  Future<void> saveLocaleIndex(int? index);

  String? getTokenByBrand(Brand brand);

  List<Brand> getAuthorizedBrands();

  List<Brand> getUnauthorizedBrands();

  Future<void> saveCurrentBrand(Brand currentBrand);

  Brand? getCurrentBrand();

  int? getLocaleIndex();

  Future<void> logout(Brand brand);

  Future<bool> clearTokenForBrand(Brand brand);

  bool? isLoggedIn();

  VoidCallback listenCurrentBrand(ValueChanged<Brand> callback);

  VoidCallback listenCurrentUserStatus(ValueChanged<UserStatus> callback);
}
