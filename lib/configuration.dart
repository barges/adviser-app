import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/infrastructure/di/app_initializer.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:fortunica/infrastructure/di/modules/api_module.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/infrastructure/di/app_initializer.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';

class Configuration {
  static const List<Brand> brands = [
    Brand.fortunica,
    Brand.zodiac,
  ];

  static BuildContext? globalContext;
  static BuildContext? fortunicaContext;
  static BuildContext? zodiacContext;

  static List<Brand> authorizedBrands(Brand currentBrand) {
    final List<Brand> authBrands = [];
    for (Brand b in brands) {
      if (b.isAuth) {
        authBrands.add(b);
      }
    }
    if (authBrands.contains(currentBrand)) {
      authBrands.removeWhere((element) => element == currentBrand);
      authBrands.add(currentBrand);
    }

    return authBrands;
  }

  static List<Brand> unauthorizedBrands() {
    final List<Brand> unAuthBrands = [];
    for (Brand brand in brands) {
      if (!brand.isAuth) {
        unAuthBrands.add(brand);
      }
    }
    return unAuthBrands;
  }

  static void setBrandsLocales(String languageCode) {
    for (Brand brand in brands) {
      if (brand.isEnabled) {
        brand.setLanguageCode(languageCode);
      }
    }
  }

  static List<Brand> getBrandsWithFirstCurrent(Brand currentBrand) {
    final List<Brand> allBrands = [];
    for (Brand brand in brands) {
      allBrands.add(brand);
    }
    if (allBrands.firstOrNull != currentBrand) {
      allBrands.removeWhere((element) => element == currentBrand);
      allBrands.add(currentBrand);
      return allBrands.reversed.toList();
    } else {
      return allBrands;
    }
  }
}

enum Brand {
  fortunica,
  zodiac;

  static const String zodiacAlias = 'zodiac';
  static const String fortunicaAlias = 'fortunica';

  Future<void> init(Flavor flavor, AppRouter navigationService) async {
    switch (this) {
      case Brand.fortunica:
        return await FortunicaAppInitializer.setupPrerequisites(
            flavor, navigationService);
      case Brand.zodiac:
        return await ZodiacAppInitializer.setupPrerequisites(
            flavor, navigationService);
    }
  }

  bool get isAuth {
    switch (this) {
      case Brand.fortunica:
        return fortunicaGetIt.get<FortunicaCachingManager>().getUserToken() !=
            null;
      case Brand.zodiac:
        return zodiacGetIt.get<ZodiacCachingManager>().getUserToken() != null;
    }
  }

  String? get languageCode {
    switch (this) {
      case Brand.fortunica:
        return fortunicaGetIt.get<FortunicaCachingManager>().getLanguageCode();
      case Brand.zodiac:
        return zodiacGetIt.get<ZodiacCachingManager>().getLanguageCode();
    }
  }

  setLanguageCode(String code) {
    switch (this) {
      case Brand.fortunica:
        fortunicaGetIt.get<FortunicaCachingManager>().saveLanguageCode(code);
        fortunicaGetIt.get<Dio>().addLocaleToHeader(code);
        break;
      case Brand.zodiac:
        zodiacGetIt.get<ZodiacCachingManager>().saveLanguageCode(code);
        break;
    }
  }

  // Future<void> logout() async {
  //   switch (this) {
  //     case Brand.fortunica:
  //       fortunicaGetIt.get<FortunicaCachingManager>().logout();
  //       break;
  //     case Brand.zodiac:
  //       //zodiacGetIt.get<ZodiacCachingManager>().logout();
  //       break;
  //   }
  // }

  static Brand brandFromString(String? s) {
    switch (s) {
      case 'Brand.fortunica':
        return Brand.fortunica;
      case 'Brand.zodiac':
        return Brand.zodiac;
      default:
        return Brand.fortunica;
    }
  }

  static Brand brandFromName(String? name) {
    switch (name) {
      case 'fortunica':
        return Brand.fortunica;
      case 'zodiac':
        return Brand.zodiac;
      default:
        return Brand.fortunica;
    }
  }

  String get alias {
    switch (this) {
      case Brand.fortunica:
        return fortunicaAlias;
      case Brand.zodiac:
        return zodiacAlias;
      default:
        return fortunicaAlias;
    }
  }

  static Brand brandFromAlias(String? s) {
    switch (s) {
      case fortunicaAlias:
        return Brand.fortunica;
      case zodiacAlias:
        return Brand.zodiac;
      default:
        return Brand.fortunica;
    }
  }

  // RootStackRouter get getRouter {
  //   switch (this) {
  //     case Brand.fortunica:
  //       return FortunicaAppRouter();
  //     case Brand.zodiac:
  //       return ZodiacAppRouter();
  //   }
  // }

  String get title {
    switch (this) {
      case Brand.fortunica:
        return 'Fortunica';
      case Brand.zodiac:
        return 'Zodiac Psychics';
    }
  }

  String get url {
    switch (this) {
      case Brand.fortunica:
        return '';
      case Brand.zodiac:
        return 'www.zodiacpsychics.com';
    }
  }

  String get icon {
    switch (this) {
      case Brand.fortunica:
        return Assets.vectors.fortunica.path;
      case Brand.zodiac:
        return Assets.vectors.zodiacTouch.path;
    }
  }

  bool get isEnabled {
    switch (this) {
      case Brand.fortunica:
        return true;
      case Brand.zodiac:
        return true;
    }
  }

  static List<String> allBrands = [
    Assets.images.brands.bitWine.path,
    Assets.images.brands.purpleGarden.path,
    Assets.images.brands.purpleTides.path,
    Assets.images.brands.purpleOcean.path,
    Assets.images.brands.zodiacPsychics.path,
    Assets.images.brands.theraPeer.path,
    Assets.images.brands.fortunica.path,
  ];
}
