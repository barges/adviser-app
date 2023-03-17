// library fortunica;
//
// import 'package:shared_advisor_interface/infrastructure/brands/base_router.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
// import 'package:shared_advisor_interface/infrastructure/flavor/flavor_config.dart';
// import 'package:flutter/cupertino.dart';
//
// import './infrastructure/routing/app_router.gr.dart';
// import './infrastructure/di/app_initializer.dart';
//
// class FortunicaBrand with ChangeNotifier implements BaseBrand {
//   static const alias = 'fortunica';
//   static const _name = 'Fortunica';
//   static FortunicaBrand? _instance;
//   static FortunicaBrand get instance {
//     if (_instance != null) {
//       return _instance!;
//     } else {
//       _instance = FortunicaBrand._();
//       return _instance!;
//     }
//   }
//
//   bool _isAuth = false;
//   int _countBadge = 0;
//   bool _isActive = true;
//
//   FortunicaBrand._();
//
//   @override
//   String get brandAlias => alias;
//
//   @override
//   String get iconPath => Assets.vectors.fortunica.path;
//
//   @override
//   String get name => _name;
//
//   @override
//   int get countBadge => _countBadge;
//
//   @override
//   bool get isActive => _isActive;
//
//   @override
//   bool get isAuth => _isAuth;
//
//   @override
//   set isAuth(bool auth) {
//     _isAuth = auth;
//     notifyListeners();
//   }
//
//   @override
//   set isActive(bool active) {
//     _isActive = active;
//     notifyListeners();
//   }
//
//   @override
//   set countBadge(int count) {
//     _countBadge = count;
//     notifyListeners();
//   }
//
//   @override
//   init(IBrandRouterService navigationService) async {
//     await FortunicaAppInitializer.setupPrerequisites(
//         Flavor.production, navigationService
//     );
//   }
//
//   @override
//   RootStackRouter getRouter() {
//     return FortunicaAppRouter();
//   }
// }