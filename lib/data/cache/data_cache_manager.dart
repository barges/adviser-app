import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_advisor_interface/configuration.dart';

import 'cache_manager.dart';

const String _tokensMapKey = 'tokensMapKey';
const String _brandKey = 'brandKey';
const String _localeIndexKey = 'localeIndexKey';

class DataCacheManager implements CacheManager {
  final GetStorage _userBox = GetStorage();
  final GetStorage _localeBox = GetStorage();

  @override
  Future<bool> clearTokenForBrand(Brand brand) async {
    Map<String, dynamic>? tokensMap = _userBox.read(_tokensMapKey);
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
    final Map<String, dynamic>? tokensMap = _userBox.read(_tokensMapKey);
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
    Map<String, String>? tokensMap = _userBox.read(_tokensMapKey);
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
    return _userBox.hasData(_tokensMapKey);
  }

  @override
  Future<void> saveCurrentBrand(Brand currentBrand) async {
    await _userBox.write(_brandKey, currentBrand.toString());
  }

  @override
  Brand? getCurrentBrand() {
    return BrandExtension.brandFromString(_userBox.read(_brandKey));
  }

  @override
  void listenCurrentBrand(ValueChanged<Brand> callback) {
    _userBox.listenKey(_brandKey, (value) {
      callback(BrandExtension.brandFromString(value));
    });
  }

  @override
  List<Brand> getAuthorizedBrands() {
    Map<String, dynamic>? tokensMap = _userBox.read(_tokensMapKey);
    if (tokensMap != null) {
      List<Brand> authorizedBrands = [];
      for (Brand element in Configuration.brands) {
        if (tokensMap[element.toString()]?.isNotEmpty == true) {
          authorizedBrands.add(element);
        }
      }
      return authorizedBrands;
    } else {
      return [];
    }
  }

  @override
  List<Brand> getUnauthorizedBrands() {
    List<Brand> allBrands = Configuration.brands;
    Map<String, dynamic>? tokensMap = _userBox.read(_tokensMapKey);
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
    await _userBox.remove(_tokensMapKey);
  }

  Future<void> _saveTokensMap(Map<String, dynamic> tokensMap) async {
    await _userBox.write(_tokensMapKey, tokensMap);
  }
}
