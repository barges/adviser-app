library fortunica;

import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:flutter/cupertino.dart';

import 'package:fortunica/infrastructure/di/app_initializer.dart';

class FortunicaBrand implements BaseBrand {
  static const alias = 'fortunica';
  static const _name = 'Fortunica';

  static final FortunicaBrand _instance = FortunicaBrand._internal();

  factory FortunicaBrand() => _instance;

  FortunicaBrand._internal();

  final bool _isActive = true;
  BuildContext? _context;

  FortunicaBrand._();

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
      fortunicaGetIt.get<FortunicaCachingManager>().getUserToken() != null;

  @override
  init(Flavor flavor) async {
    await FortunicaAppInitializer.setupPrerequisites(Flavor.production);
  }

  @override
  BuildContext? get context => _context;

  @override
  set context(BuildContext? context) {
    _context = context;
  }

  @override
  String? get languageCode =>
      fortunicaGetIt.get<FortunicaCachingManager>().getLanguageCode();

  @override
  set languageCode(String? languageCode) {
    fortunicaGetIt
        .get<FortunicaCachingManager>()
        .saveLanguageCode(languageCode);
  }

  @override
  String get url => '';
}
