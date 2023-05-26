import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fortunica/fortunica.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_advisor_interface/data/cache/global_caching_manager.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:zodiac/zodiac.dart';

@singleton
class BrandManager {
  static final List<BaseBrand> brands = [
    FortunicaBrand(),
    ZodiacBrand(),
  ];

  static String timeFormat = 'h:mm a';

  static final BaseBrand defaultBrand = brands.first;

  final GlobalCachingManager _cachingManager;

  BrandManager(this._cachingManager);

  initDi(Flavor flavor) async {
    for (BaseBrand brand in brands) {
      await brand.init(flavor);
    }
  }

  static BaseBrand brandFromAlias(String? alias) {
    switch (alias) {
      case FortunicaBrand.alias:
        return FortunicaBrand();
      case ZodiacBrand.alias:
        return ZodiacBrand();
      default:
        return FortunicaBrand();
    }
  }

   List<BaseBrand> authorizedBrands() {
    final List<String> authBrandsAliases = [];
    for (BaseBrand b in brands) {
      if (b.isAuth) {
        authBrandsAliases.add(b.brandAlias);
      }
    }
    final BaseBrand currentBrand = getCurrentBrand();
    if (authBrandsAliases.contains(currentBrand.brandAlias)) {
      authBrandsAliases
          .removeWhere((element) => element == currentBrand.brandAlias);
      authBrandsAliases.add(currentBrand.brandAlias);
    }

    final List<BaseBrand> authBrands = [];
    for (String alias in authBrandsAliases) {
      authBrands.add(brandFromAlias(alias));
    }

    return authBrands;
  }

  static List<BaseBrand> unauthorizedBrands() {
    final List<String> unAuthBrandsAliases = [];
    for (BaseBrand b in brands) {
      if (!b.isAuth) {
        unAuthBrandsAliases.add(b.brandAlias);
      }
    }

    final List<BaseBrand> unAuthBrands = [];
    for (String alias in unAuthBrandsAliases) {
      unAuthBrands.add(brandFromAlias(alias));
    }

    return unAuthBrands;
  }

  static void setIsCurrentForBrands(BaseBrand brand) {
    for (BaseBrand b in brands) {
      if (brand.brandAlias == b.brandAlias) {
        b.isCurrent = true;
      } else {
        b.isCurrent = false;
      }
    }
  }

  static void setBrandsLocales(String languageCode) {
    for (BaseBrand brand in brands) {
      if (brand.isActive) {
        brand.languageCode = languageCode;
      }
    }
  }

  static List<BaseBrand> getActiveBrandsWithFirstCurrent(
      BaseBrand currentBrand) {
    final List<String> allBrandsAliases = [];
    for (BaseBrand brand in brands) {
      if (brand.isActive) {
        allBrandsAliases.add(brand.brandAlias);
      }
    }

    if (allBrandsAliases.firstOrNull != currentBrand.brandAlias) {
      allBrandsAliases.remove(currentBrand.brandAlias);
      allBrandsAliases.insert(0, currentBrand.brandAlias);
    }

    final List<BaseBrand> allBrands = [];
    for (String alias in allBrandsAliases) {
      allBrands.add(brandFromAlias(alias));
    }
    return allBrands;
  }

  BaseBrand getCurrentBrand() {
    return _cachingManager.getCurrentBrand();
  }

  Future<void> setCurrentBrand(BaseBrand brand) async {
   await _cachingManager.saveCurrentBrand(brand);
  }

  StreamSubscription listenCurrentBrandStream(
      ValueChanged<BaseBrand> callback) {
    return _cachingManager.listenCurrentBrandStream(callback);
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
