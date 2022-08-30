import 'package:get_storage/get_storage.dart';
import 'package:shared_advisor_interface/configuration.dart';

import 'cache_manager.dart';

const String _tokenKey = 'tokenKey';
const String _brandKey = 'brandKey';
const String _loggedInBrandsKey = 'loggedInBrandsKey';
const String _localeIndexKey = 'localeIndexKey';

class DataCacheManager implements CacheManager {
  final GetStorage _userBox = GetStorage();
  final GetStorage _localeBox = GetStorage();

  @override
  Future<bool> clear() async {
    await _userBox.erase();
    return true;
  }

  @override
  String? getToken() {
    return _userBox.read(_tokenKey);
  }

  @override
  int? getLocaleIndex() {
    return _localeBox.read(_localeIndexKey);
  }

  @override
  Future<void> saveToken(String? token) async {
    await _userBox.write(_tokenKey, token);
  }

  @override
  Future<void> saveLocaleIndex(int? index) async {
    await _localeBox.write(_localeIndexKey, index);
  }

  @override
  bool? isLoggedIn() {
    return _userBox.hasData(_tokenKey);
  }

  @override
  Future<void> saveCurrentBrand(Brand currentBrand) async {
    await _userBox.write(_brandKey, currentBrand.toString());
  }

  @override
  Brand? getCurrentBrand() {
    return BrandExtension.brandFromString(_userBox.read(_brandKey));
  }
}
