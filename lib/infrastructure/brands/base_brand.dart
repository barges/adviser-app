import 'package:flutter/cupertino.dart';
import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';

export 'base_router.dart';

abstract class BaseBrand {

  Future init(Flavor flavor);

  BuildContext? get context;

  set context(BuildContext? context);

  String? get languageCode;

  set languageCode(String? languageCode);

  String get brandAlias;

  String get name;

  String get iconPath;

  bool get isActive;

  bool get isAuth;

  String get url;
}
