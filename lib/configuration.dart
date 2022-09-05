import 'package:get/get.dart';
import 'package:shared_advisor_interface/presentation/resources/app_icons.dart';

class Configuration {
  static const List<Brand> brands = [
    Brand.fortunica,
    Brand.zodiacTouch,
  ];
}

enum Brand { fortunica, zodiacTouch }

extension BrandExtension on Brand {

  static Brand? brandFromString(String? s) {
    switch (s) {
      case 'Brand.fortunica':
        return Brand.fortunica;
      case 'Brand.zodiacTouch':
        return Brand.zodiacTouch;
      default:
        return null;
    }
  }

  String get name {
    switch (this) {
      case Brand.fortunica:
        return 'Fortunica';
      case Brand.zodiacTouch:
        return 'Zodiac Touch';
    }
  }

  String get url {
    switch (this) {
      case Brand.fortunica:
        return '';
      case Brand.zodiacTouch:
        return 'www.zodiacpsychics.com';
    }
  }

  String get icon {
    switch (this) {
      case Brand.fortunica:
        return AppIcons.fortunica;
      case Brand.zodiacTouch:
        return AppIcons.zodiacTouch;
    }
  }

  bool get isEnabled {
    switch (this) {
      case Brand.fortunica:
        return true;
      case Brand.zodiacTouch:
        return false;
    }
  }
}

class BrandService extends GetxService{

}
