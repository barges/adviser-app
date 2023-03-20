import 'dart:async';


abstract class ZodiacCachingManager {

  Future<void> saveUserToken(String userToken);

  String? getUserToken();

  Future<void> logout();

  Future<void> saveLanguageCode(String? languageCode);

  String? getLanguageCode();

}
