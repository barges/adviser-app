import 'package:get_storage/get_storage.dart';

import 'cache_manager.dart';


const String tokenKey = 'tokenKey';
const String localeIndexKey = 'localeIndexKey';

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
    return _userBox.read(tokenKey);
  }

  @override
  int? getLocaleIndex() {
    return _localeBox.read(localeIndexKey);
  }

  @override
  Future<void> saveToken(String? token) async {
   await _userBox.write(tokenKey, token);
  }

  @override
  Future<void> saveLocaleIndex(int? index) async {
   await _localeBox.write(localeIndexKey, index);
  }

  @override
  bool? isLoggedIn() {
   return _userBox.hasData(tokenKey);
  }
}
