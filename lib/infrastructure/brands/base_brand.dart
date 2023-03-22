import 'package:flutter/cupertino.dart';

export 'base_router.dart';

abstract class BaseBrand with ChangeNotifier {
  BuildContext get context;

  set context(BuildContext context);

  String get languageCode;

  set languageCode(String languageCode);

  String get brandAlias;

  String get name;

  String get iconPath;

  bool get isActive;

  bool get isAuth;
}
