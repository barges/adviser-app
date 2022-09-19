import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/configuration.dart';

abstract class CacheManager {
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

