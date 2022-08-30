import 'package:shared_advisor_interface/configuration.dart';

abstract class CacheManager {
  Future<void> saveToken(String? token);

  Future<void> saveLocaleIndex(int? index);

  String? getToken();

  Future<void> saveCurrentBrand(Brand currentBrand);

  Brand? getCurrentBrand();

  int? getLocaleIndex();

  Future<bool?> clear();

  bool? isLoggedIn();
}
