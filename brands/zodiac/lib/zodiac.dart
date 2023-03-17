// library zodiac;
//
// import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_advisor_interface/infrastructure/brands/base_brand.dart';
// import 'package:injectable/injectable.dart';
// import 'package:zodiac/data/cache/zodiac_caching_manager.dart';
//
// @injectable
// class FortunicaBrand implements BaseBrand {
//   static const alias = 'zodiac';
//   static const _name = 'Zodiac';
//
//   final ZodiacCachingManager _cachingManager;
//
//   final bool _isActive = true;
//   BuildContext? _context;
//
//   FortunicaBrand(this._cachingManager);
//
//   @override
//   String get brandAlias => alias;
//
//   @override
//   String get iconPath => Assets.vectors.fortunica.path;
//
//   @override
//   String get title => _name;
//
//   @override
//   bool get isActive => _isActive;
//
//   @override
//   bool get isAuth => _cachingManager.getUserToken() != null;
//
//   @override
//   BuildContext? get context => _context;
//
//   @override
//   set context(BuildContext? context) {
//     _context = _context;
//   }
// }