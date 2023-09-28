library fortunica;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:fortunica/analytics/analytics_fortunica_impl.dart';
import 'package:fortunica/data/cache/fortunica_caching_manager.dart';
import 'package:fortunica/data/models/enums/fortunica_user_status.dart';
import 'package:fortunica/data/models/user_info/user_status.dart';
import 'package:fortunica/infrastructure/di/app_initializer.dart';
import 'package:fortunica/infrastructure/di/inject_config.dart';
import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';

class FortunicaBrand implements BaseBrand {
  static const alias = 'fortunica';
  static const _name = 'fortunica';

  static final FortunicaBrand _instance = FortunicaBrand._internal();

  factory FortunicaBrand() => _instance;

  FortunicaBrand._internal();

  final bool _isActive = true;
  bool _isCurrent = false;
  BuildContext? _context;

  final AnalyticsFortunicaImpl _analytics = AnalyticsFortunicaImpl();

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
    await _analytics.init();
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
  bool get isCurrent => _isCurrent;

  @override
  set isCurrent(bool isCurrent) {
    _isCurrent = isCurrent;
  }

  @override
  String get url => '';

  @override
  PageRouteInfo get initRoute => const Fortunica();

  @override
  Analytics get analytics => _analytics;

  @override
  Color userStatusNameColor(BuildContext context) {
    final UserStatus? userStatus =
        fortunicaGetIt.get<FortunicaCachingManager>().getUserStatus();

    final FortunicaUserStatus fortunicaUserStatus =
        userStatus?.status ?? FortunicaUserStatus.offline;

    return fortunicaUserStatus.statusNameColor(context);
  }

  @override
  Color userStatusBadgeColor(BuildContext context) {
    final UserStatus? userStatus =
        fortunicaGetIt.get<FortunicaCachingManager>().getUserStatus();

    final FortunicaUserStatus fortunicaUserStatus =
        userStatus?.status ?? FortunicaUserStatus.offline;

    return fortunicaUserStatus.statusBadgeColor(context);
  }

  @override
  void goToSupport() {
    _context?.push(route: const FortunicaSupport());
  }

  @override
  List<String> freshChatCategories(String languageCode) {
    List<String> categories = [
      'general_foen_advisor',
      'payments_foen_advisor',
      'offers_foen_advisor',
      'tips_foen_advisor',
      'techhelp_foen_advisor',
      'performance_foen_advisor',
      'webtool_foen_advisor',
    ];
    switch (languageCode) {
      case 'de':
        categories = [
          'general_fode_advisor',
          'payments_fode_advisor',
          'offers_fode_advisor',
          'tips_fode_advisor',
          'techhelp_fode_advisor',
          'performance_fode_advisor',
        ];
        break;

      case 'es':
        categories = [
          'general_foes_advisor',
          'payments_foes_advisor',
          'webtool_foes_advisor',
          'tips_foes_advisor',
          'performance_foes_advisor',
          'specialcases_foes_advisor',
        ];
        break;
      case 'pt':
        categories = [
          'general_fopt_advisor',
          'payments_fopt_advisor',
          'offers_fopt_advisor',
          'tips_fopt_advisor',
          'techhelp_fopt_advisor',
        ];
        break;
      case 'en':
      default:
    }
    return categories;
  }

  @override
  List<String> freshChatTags(String languageCode) {
    List<String> tags = [
      'foen',
    ];
    switch (languageCode) {
      case 'de':
        tags = [
          'fode',
        ];
        break;

      case 'es':
        tags = [
          'foes',
        ];
        break;
      case 'pt':
        tags = [
          'fopt',
        ];
        break;
      case 'en':
      default:
    }
    return tags;
  }
}
