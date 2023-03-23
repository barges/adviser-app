library zodiac;

import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/infrastructure/di/app_initializer.dart';
import 'package:zodiac/zodiac_constants.dart';


class ZodiacBrand implements BaseBrand {
  static const alias = 'zodiac';
  static const _name = 'Zodiac Touch';

  static final ZodiacBrand _instance = ZodiacBrand._internal();

  factory ZodiacBrand() {
    return _instance;
  }

  ZodiacBrand._internal();

  final bool _isActive = true;
  BuildContext? _context;

  ZodiacBrand._();

  @override
  String get brandAlias => alias;

  @override
  String get iconPath => Assets.vectors.fortunica.path;

  @override
  String get name => _name;

  @override
  bool get isActive => _isActive;

  @override
  bool get isAuth =>
      zodiacGetIt.get<ZodiacCachingManager>().getUserToken() != null;

  @override
  init(Flavor flavor) async {
    await ZodiacAppInitializer.setupPrerequisites(Flavor.production);
  }

  @override
  BuildContext? get context => _context;

  @override
  set context(BuildContext? context) {
    _context = context;
  }

  @override
  String? get languageCode =>
      zodiacGetIt.get<ZodiacCachingManager>().getLanguageCode();

  @override
  set languageCode(String? languageCode) {
    zodiacGetIt.get<ZodiacCachingManager>().saveLanguageCode(languageCode);
  }

  @override
  String get url => ZodiacConstants.sideMenuUrl;
}
