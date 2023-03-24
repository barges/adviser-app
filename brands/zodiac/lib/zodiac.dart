library zodiac;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
import 'package:shared_advisor_interface/infrastructure/routing/app_router.gr.dart';
import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
import 'package:zodiac/data/models/enums/zodiac_user_status.dart';
import 'package:zodiac/data/models/user_info/detailed_user_info.dart';
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
    final DetailedUserInfo? detailedUserInfo =
        zodiacGetIt.get<ZodiacCachingManager>().getDetailedUserInfo();
    final ZodiacUserStatus userStatus =
        detailedUserInfo?.details?.status ?? ZodiacUserStatus.offline;

    return userStatus.statusNameColor(context);
  }

  @override
  Color userStatusBadgeColor(BuildContext context) {
    final DetailedUserInfo? detailedUserInfo =
        zodiacGetIt.get<ZodiacCachingManager>().getDetailedUserInfo();
    final ZodiacUserStatus userStatus =
        detailedUserInfo?.details?.status ?? ZodiacUserStatus.offline;

    return userStatus.statusBadgeColor(context);
  }
}
