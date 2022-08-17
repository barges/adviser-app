abstract class CacheManager {
  Future<void> saveToken(String? token);

  String? getToken();

  Future<bool?> clear();

  bool? isLoggedIn();
}
