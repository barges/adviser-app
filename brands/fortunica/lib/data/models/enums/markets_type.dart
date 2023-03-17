import 'package:shared_advisor_interface/app_constants.dart';
import 'package:shared_advisor_interface/generated/assets/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:fortunica/generated/l10n.dart';

enum MarketsType {
  de,
  en,
  es,
  pt,
  all;

  String get flagImagePath {
    switch (this) {
      case MarketsType.de:
        return Assets.images.flags.german.path;
      case MarketsType.en:
        return Assets.images.flags.english.path;
      case MarketsType.es:
        return Assets.images.flags.spanish.path;
      case MarketsType.pt:
        return Assets.images.flags.portugues.path;
      case MarketsType.all:
        return '';
    }
  }

  String languageName(BuildContext context) {
    switch (this) {
      case MarketsType.de:
        return AppConstants.deBrandName;
      case MarketsType.en:
        return AppConstants.enBrandName;
      case MarketsType.es:
        return AppConstants.esBrandName;
      case MarketsType.pt:
        return AppConstants.ptBrandName;
      case MarketsType.all:
        return SFortunica.of(context).allMarketsFortunica;
    }
  }

 static const List<String> actualMarkets = [
    'en',
    'es',
    'de',
    'pt',
  ];

  static MarketsType typeFromString(String? market) {
    switch (market) {
      case 'en':
        return MarketsType.en;
      case 'es':
        return MarketsType.es;
      case 'pt':
        return MarketsType.pt;
      case 'de':
        return MarketsType.de;
      default:
        return MarketsType.all;
    }
  }
}
