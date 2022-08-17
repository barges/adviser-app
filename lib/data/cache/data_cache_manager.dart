import 'package:get_storage/get_storage.dart';

import 'cache_manager.dart';


const String tokenKey = 'tokenKey';

class DataCacheManager implements CacheManager {

 final GetStorage _box = GetStorage();

  @override
  Future<bool> clear() async {
    await _box.erase();
    return true;
  }

  @override
  String? getToken() {
    return _box.read(tokenKey);
  }

  @override
  Future<void> saveToken(String? token) async {
   await _box.write(tokenKey, token);
  }

  @override
  bool? isLoggedIn() {
   return _box.hasData(tokenKey);
  }
}
