import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_advisor_interface/configuration.dart';
import 'package:shared_advisor_interface/data/models/enums/fortunica_user_status.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_profile.dart';
import 'package:shared_advisor_interface/data/models/user_info/user_status.dart';

import 'cache_manager.dart';

const String _tokensMapKey = 'tokensMapKey';
const String _brandKey = 'brandKey';
const String _userProfileKey = 'userProfileKey';
const String _userStatusKey = 'userStatusKey';
const String _userIdKey = 'userIdKey';
const String _localeIndexKey = 'localeIndexKey';

class DataCacheManager implements CacheManager {
  final GetStorage _userBox = GetStorage();
  final GetStorage _brandsBox = GetStorage();
  final GetStorage _localeBox = GetStorage();

  @override
  Future<bool> clearTokenForBrand(Brand brand) async {
    Map<String, dynamic>? tokensMap = _brandsBox.read(_tokensMapKey);
    bool isOk = tokensMap != null;
    if (isOk) {
      if (tokensMap.length > 1) {
        tokensMap.removeWhere((key, value) => key == brand.toString());
        await _saveTokensMap(tokensMap);
      } else {
        await _clearTokensMap();
      }
    }
    return isOk;
  }

  @override
  Future<void> saveTokenForBrand(Brand brand, String token) async {
    final Map<String, dynamic>? tokensMap = _brandsBox.read(_tokensMapKey);
    if (tokensMap != null) {
      tokensMap[brand.toString()] = token;
      _saveTokensMap(tokensMap);
    } else {
      _saveTokensMap({
        brand.toString(): token,
      });
    }
  }

  @override
  String? getTokenByBrand(Brand brand) {
    Map<String, dynamic>? tokensMap = _brandsBox.read(_tokensMapKey);
    return tokensMap?[brand.toString()];
  }

  @override
  int? getLocaleIndex() {
    return _localeBox.read(_localeIndexKey);
  }

  @override
  Future<void> saveLocaleIndex(int? index) async {
    await _localeBox.write(_localeIndexKey, index);
  }

  @override
  bool? isLoggedIn() {
    return _brandsBox.hasData(_tokensMapKey);
  }

  @override
  Future<void> saveCurrentBrand(Brand currentBrand) async {
    await _brandsBox.write(_brandKey, currentBrand.toString());
  }

  @override
  Brand? getCurrentBrand() {
    return BrandExtension.brandFromString(_brandsBox.read(_brandKey));
  }

  @override
  VoidCallback listenCurrentBrand(ValueChanged<Brand> callback) {
    return _brandsBox.listenKey(_brandKey, (value) {
      callback(BrandExtension.brandFromString(value));
    });
  }

  @override
  List<Brand> getAuthorizedBrands() {
    final Brand? currentBrand = getCurrentBrand();

    Map<String, dynamic>? tokensMap = _brandsBox.read(_tokensMapKey);
    if (tokensMap != null && currentBrand != null) {
      List<Brand> authorizedBrands = [];
      for (Brand element in Configuration.brands) {
        if (tokensMap[element.toString()]?.isNotEmpty == true) {
          authorizedBrands.add(element);
        }
      }
      return authorizedBrands
        ..removeWhere((element) => element == currentBrand)
        ..add(currentBrand);
    } else {
      return [];
    }
  }

  @override
  List<Brand> getUnauthorizedBrands() {
    List<Brand> allBrands = Configuration.brands;
    Map<String, dynamic>? tokensMap = _brandsBox.read(_tokensMapKey);
    if (tokensMap != null) {
      List<Brand> unauthorizedBrands = [];
      for (Brand element in allBrands) {
        if (tokensMap[element.toString()]?.isNotEmpty != true) {
          unauthorizedBrands.add(element);
        }
      }
      return unauthorizedBrands;
    } else {
      return allBrands;
    }
  }

  Future<void> _clearTokensMap() async {
    await _brandsBox.remove(_tokensMapKey);
  }

  Future<void> _saveTokensMap(Map<String, dynamic> tokensMap) async {
    await _brandsBox.write(_tokensMapKey, tokensMap);
  }

  @override
  UserProfile? getUserProfile() {
    UserProfile userProfile = _userBox.read(_userProfileKey);
    return userProfile;
  }

  @override
  Future<void> saveUserProfile(UserProfile? userProfile) async {
    await _userBox.write(_userProfileKey, userProfile);
  }

  @override
  VoidCallback listenUserProfile(ValueChanged<UserProfile> callback) {
    return _userBox.listenKey(_userProfileKey, (value) {
      callback(value);
    });
  }

  @override
  Future<void> updateUserProfileImage(List<String>? profilePictures) async {
    UserProfile? profile = getUserProfile();

    await _userBox.write(
      _userProfileKey,
      profile?.copyWith(
        profilePictures: profilePictures,
      ),
    );
  }

  @override
  Future<void> updateUserProfileCoverPictures(
      List<String>? coverPictures) async {
    UserProfile? profile = getUserProfile();

    await _userBox.write(
      _userProfileKey,
      profile?.copyWith(
        coverPictures: coverPictures,
      ),
    );
  }

  @override
  UserStatus? getUserStatus() {
    if (_userBox.hasData(_userStatusKey)) {
      UserStatus userStatus =
          UserStatus.fromJson(_userBox.read(_userStatusKey));
      return userStatus;
    }
    return null;
  }

  @override
  Future<void> saveUserStatus(UserStatus? userStatus) async {
    await _userBox.write(_userStatusKey, userStatus?.toJson());
  }

  @override
  Future<void> updateUserStatusByStatus(FortunicaUserStatusEnum status) async {
    UserStatus? userStatus = getUserStatus();
    await _userBox.write(
      _userStatusKey,
      userStatus?.copyWith(
        status: status,
      ),
    );
  }

  @override
  VoidCallback listenCurrentUserStatus(ValueChanged<UserStatus> callback) {
    return _userBox.listenKey(_userStatusKey, (value) {
      callback(UserStatus.fromJson(value));
    });
  }

  @override
  String? getUserId() {
    return _userBox.read(_userIdKey);
  }

  @override
  Future<void> saveUserId(String? userId) async {
    await _userBox.write(_userIdKey, userId);
  }
}
