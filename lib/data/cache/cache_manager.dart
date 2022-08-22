abstract class CacheManager {
  Future<void> saveToken(String? token);

  Future<void> saveLocaleIndex(int? index);

  String? getToken();

  int? getLocaleIndex();

  Future<bool?> clear();

  bool? isLoggedIn();
}
