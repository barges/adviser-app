import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_info.dart';

abstract class CacheManager {
  Future<void> saveUserInfo(UserInfo userInfo);

  UserInfo? getUserInfo();

  Future<void> saveTokenForBrand(Brand brand, String token);

  Future<void> saveLocaleIndex(int? index);

  String? getTokenByBrand(Brand brand);

  List<Brand> getAuthorizedBrands();

  List<Brand> getUnauthorizedBrands();

  Future<void> saveCurrentBrand(Brand currentBrand);

  Brand? getCurrentBrand();

  int? getLocaleIndex();

  Future<bool> clearTokenForBrand(Brand brand);

  bool? isLoggedIn();

  void listenCurrentBrand(ValueChanged<Brand> callback);
}
