import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_advisor_interface/analytics/analytics.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';

abstract class BaseBrand {

  Future init(Flavor flavor);

  BuildContext? get context;

  set context(BuildContext? context);

  PageRouteInfo get initRoute;

  bool get isCurrent;

  set isCurrent(bool isCurrent);

  String? get languageCode;

  set languageCode(String? languageCode);

  String get brandAlias;

  String get name;

  String get iconPath;

  bool get isActive;

  bool get isAuth;

  String get url;

  Analytics get analytics;

  Color userStatusNameColor(BuildContext context);

  Color userStatusBadgeColor(BuildContext context);

  List<String> freshChatCategories(String languageCode);

  List<String> freshChatTags(String languageCode);

  void goToSupport();
}
