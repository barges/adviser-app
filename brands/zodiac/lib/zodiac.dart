library zodiac;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/infrastructure/di/app_initializer.dart';
import 'package:zodiac/infrastructure/di/inject_config.dart';
import 'package:zodiac/zodiac_constants.dart';

class ZodiacBrand implements BaseBrand {
  static const alias = 'zodiac';
  static const _name = 'Zodiac Psychics';

  static final ZodiacBrand _instance = ZodiacBrand._internal();

  factory ZodiacBrand() {
    return _instance;
  }

  ZodiacBrand._internal();

  final bool _isActive = true;
  bool _isCurrent = false;
  BuildContext? _context;

  @override
  String get brandAlias => alias;

  @override
  String get iconPath => Assets.vectors.zodiacTouch.path;

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

  @override
  bool get isCurrent => _isCurrent;

  @override
  set isCurrent(bool isCurrent) {
    _isCurrent = isCurrent;
  }

  @override
  PageRouteInfo get initRoute => const Zodiac();

  @override
  Color userStatusNameColor(BuildContext context) {
    final ZodiacUserStatus userStatus =
        zodiacGetIt.get<ZodiacCachingManager>().getUserStatus() ??
            ZodiacUserStatus.offline;

    return userStatus.statusNameColor(context);
  }

  @override
  Color userStatusBadgeColor(BuildContext context) {
    final ZodiacUserStatus userStatus =
        zodiacGetIt.get<ZodiacCachingManager>().getUserStatus() ??
            ZodiacUserStatus.offline;

    return userStatus.statusBadgeColor(context);
  }

  @override
  void goToSupport(){
    _context?.push(route: const ZodiacSupport());
  }

  @override
  List<String> freshChatCategories(String languageCode){
    List<String> categories = [
      'general_zd_advisor',
      'payments_zd_advisor',
      'offers_zd_advisor',
      'tips_zd_advisor',
      'techhelp_zd_advisor',
    ];
    switch (languageCode) {
      case 'es':
        categories = [
          'general_ps_advisor',
          'payments_ps_advisor',
          'offers_ps_advisor',
          'tips_ps_advisor',
          'techhelp_ps_advisor',
        ];
        break;
      case 'pt':
        categories = [
          'general_pspt_advisor',
          'payments_pspt_advisor',
          'offers_pspt_advisor',
          'tips_pspt_advisor',
          'techhelp_pspt_advisor',
        ];
        break;
      case 'en':
      default:
    }
    return categories;
  }

  @override
  List<String> freshChatTags(String languageCode){
    List<String> tags = [
      'support',
    ];
    switch (languageCode) {
      case 'es':
        tags = [
          'soporte',
        ];
        break;
      case 'pt':
        tags = [
          'psiquicospt',
        ];
        break;
      case 'en':
      default:
    }
    return tags;
  }
}
